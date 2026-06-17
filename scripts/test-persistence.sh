#!/usr/bin/env bash

# Proyecto Integrador - Administración de Sistemas Avanzada
# Alumno: Lucas Aponte
# Este script crea un archivo dentro del volumen persistente,
# elimina el Pod y comprueba que el dato continúa disponible.

set -euo pipefail

NAMESPACE="proyecto-adsa"
DEPLOYMENT="nginx-adsa"
ARCHIVO="/usr/share/nginx/html/persistencia.txt"
CONTENIDO="Dato persistente del Proyecto Integrador AdSA"

echo "=== Prueba automatizada de persistencia ==="

echo
echo "1. Creando archivo dentro del volumen..."
kubectl exec \
  --namespace="$NAMESPACE" \
  deployment/"$DEPLOYMENT" \
  -- sh -c "echo '$CONTENIDO' > '$ARCHIVO'"

echo
echo "2. Verificando el contenido inicial:"
kubectl exec \
  --namespace="$NAMESPACE" \
  deployment/"$DEPLOYMENT" \
  -- cat "$ARCHIVO"

POD_ACTUAL=$(
  kubectl get pods \
    --namespace="$NAMESPACE" \
    --selector=app=nginx-adsa \
    --output=jsonpath='{.items[0].metadata.name}'
)

echo
echo "3. Eliminando el Pod: $POD_ACTUAL"
kubectl delete pod "$POD_ACTUAL" --namespace="$NAMESPACE"

echo
echo "4. Esperando que Kubernetes recree el Pod..."
kubectl rollout status deployment/"$DEPLOYMENT" \
  --namespace="$NAMESPACE" \
  --timeout=120s

echo
echo "5. Comprobando el contenido después de la recreación:"
CONTENIDO_RECUPERADO=$(
  kubectl exec \
    --namespace="$NAMESPACE" \
    deployment/"$DEPLOYMENT" \
    -- cat "$ARCHIVO"
)

if [[ "$CONTENIDO_RECUPERADO" == "$CONTENIDO" ]]; then
  echo "PRUEBA EXITOSA: el archivo persistió después de recrear el Pod."
else
  echo "PRUEBA FALLIDA: el contenido no coincide."
  exit 1
fi
