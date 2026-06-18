```bash
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
        echo "ERROR: no se encontró el comando '${comando}'."
        exit 1
    fi
}

echo "========================================"
echo " Proyecto Integrador AdSA — Run All"
echo "========================================"
echo

comprobar_comando kind
comprobar_comando kubectl

if [[ ! -f "${CLUSTER_CONFIG}" ]]; then
    echo "ERROR: no se encontró ${CLUSTER_CONFIG}"
    exit 1
fi

if [[ "${1:-}" == "--fresh" ]]; then
    if kind get clusters 2>/dev/null | grep -Fxq "${CLUSTER_NAME}"; then
        echo "Eliminando el clúster existente ${CLUSTER_NAME}..."
        kind delete cluster --name "${CLUSTER_NAME}"
    fi
elif [[ -n "${1:-}" ]]; then
    echo "Uso: $0 [--fresh]"
    exit 1
fi

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
echo "1. Desplegando recursos..."
bash scripts/deploy.sh

echo
echo "2. Validando el despliegue..."
bash scripts/validate.sh

echo
echo "3. Ejecutando la prueba de persistencia..."
bash scripts/test-persistence.sh

echo
echo "========================================"
echo " Ejecución completa finalizada"
echo "========================================"
echo
echo "Para abrir la aplicación:"
echo
echo "kubectl port-forward -n proyecto-adsa svc/nginx-service 8085:80"
echo
echo "Luego ingresar en: http://localhost:8085"
```
