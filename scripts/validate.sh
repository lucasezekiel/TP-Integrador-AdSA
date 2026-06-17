#!/usr/bin/env bash

# Proyecto Integrador - Administración de Sistemas Avanzada
# Alumno: Lucas Aponte
# Este script verifica los recursos principales y comprueba
# que el ConfigMap y el Secret estén disponibles en el Pod.

set -euo pipefail

NAMESPACE="proyecto-adsa"
DEPLOYMENT="nginx-adsa"

echo "=== Validación del despliegue ==="

echo
echo "1. Estado del clúster:"
kubectl get nodes

echo
echo "2. Estado de los recursos del proyecto:"
kubectl get deployment,pods,svc,pvc,configmap,secret \
  --namespace="$NAMESPACE"

echo
echo "3. Estado del PersistentVolume:"
kubectl get pv pv-nginx-adsa

echo
echo "4. Esperando disponibilidad del Deployment:"
kubectl rollout status deployment/"$DEPLOYMENT" \
  --namespace="$NAMESPACE" \
  --timeout=120s

echo
echo "5. Verificando la página proporcionada por el ConfigMap:"
kubectl exec \
  --namespace="$NAMESPACE" \
  deployment/"$DEPLOYMENT" \
  -- head -n 5 /usr/share/nginx/html/index.html

echo
echo "6. Verificando que la variable PASSWORD esté inyectada:"
kubectl exec \
  --namespace="$NAMESPACE" \
  deployment/"$DEPLOYMENT" \
  -- printenv PASSWORD

echo
echo "Validación finalizada correctamente."
