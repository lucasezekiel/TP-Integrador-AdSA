#!/usr/bin/env bash

# Ejecución completa del Proyecto Integrador AdSA.
#
# Uso:
#   ./scripts/run-all.sh
#   ./scripts/run-all.sh --fresh
#
# La opción --fresh elimina y vuelve a crear el clúster.

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLUSTER_NAME="${CLUSTER_NAME:-adsa-integrador}"
CONTEXT_NAME="kind-${CLUSTER_NAME}"
CLUSTER_CONFIG="${ROOT_DIR}/kind/cluster.yaml"

cd "${ROOT_DIR}"

comprobar_comando() {
    local comando="$1"

    if ! command -v "${comando}" >/dev/null 2>&1; then
        echo "ERROR: no se encontró el comando '${comando}'." >&2
        exit 1
    fi
}

echo "=========================================="
echo " Proyecto Integrador AdSA - Ejecución total"
echo "=========================================="
echo

comprobar_comando kind
comprobar_comando kubectl
comprobar_comando bash

if [[ ! -f "${CLUSTER_CONFIG}" ]]; then
    echo "ERROR: no se encontró ${CLUSTER_CONFIG}" >&2
    exit 1
fi

case "${1:-}" in
    "")
        ;;
    --fresh)
        if kind get clusters 2>/dev/null | grep -Fxq "${CLUSTER_NAME}"; then
            echo "Eliminando el clúster existente ${CLUSTER_NAME}..."
            kind delete cluster --name "${CLUSTER_NAME}"
        fi
        ;;
    *)
        echo "Uso: $0 [--fresh]" >&2
        exit 1
        ;;
esac

if kind get clusters 2>/dev/null | grep -Fxq "${CLUSTER_NAME}"; then
    echo "El clúster ${CLUSTER_NAME} ya existe."
else
    echo "Creando el clúster ${CLUSTER_NAME}..."

    kind create cluster \
        --name "${CLUSTER_NAME}" \
        --config "${CLUSTER_CONFIG}"
fi

echo
echo "Seleccionando el contexto ${CONTEXT_NAME}..."
kubectl config use-context "${CONTEXT_NAME}" >/dev/null

echo
echo "[1/3] Desplegando los recursos..."
bash "${ROOT_DIR}/scripts/deploy.sh"

echo
echo "[2/3] Validando el despliegue..."
bash "${ROOT_DIR}/scripts/validate.sh"

echo
echo "[3/3] Probando persistencia y autorrecuperación..."
bash "${ROOT_DIR}/scripts/test-persistence.sh"

echo
echo "=========================================="
echo " Ejecución completa finalizada correctamente"
echo "=========================================="
echo
echo "Para acceder a la aplicación:"
echo
echo "kubectl port-forward -n proyecto-adsa svc/nginx-service 8085:80"
echo
echo "Luego abrir: http://localhost:8085"
