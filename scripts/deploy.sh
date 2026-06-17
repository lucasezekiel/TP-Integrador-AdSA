#!/usr/bin/env bash

# Proyecto Integrador - Administración de Sistemas Avanzada
# Alumno: Lucas Aponte
# Este script aplica los manifiestos en el orden necesario
# y espera que la aplicación Nginx quede disponible.

set -euo pipefail

NAMESPACE="proyecto-adsa"
DEPLOYMENT="nginx-adsa"

echo "=== Despliegue del proyecto integrador ==="

echo "[1/7] Creando namespace..."
kubectl apply -f manifests/00-namespace.yaml

echo "[2/7] Creando PersistentVolume..."
kubectl apply -f manifests/01-pv.yaml

echo "[3/7] Creando PersistentVolumeClaim..."
kubectl apply -f manifests/02-pvc.yaml

echo "[4/7] Aplicando ConfigMap..."
kubectl apply -f manifests/03-configmap.yaml

echo "[5/7] Aplicando Secret..."
kubectl apply -f manifests/04-secret.yaml

echo "[6/7] Desplegando Nginx..."
kubectl apply -f manifests/05-deployment.yaml

echo "[7/7] Creando Service..."
kubectl apply -f manifests/06-service.yaml

echo
echo "Esperando que el Deployment quede disponible..."
kubectl rollout status deployment/"$DEPLOYMENT" \
  --namespace="$NAMESPACE" \
  --timeout=120s

echo
echo "Despliegue completado correctamente."
kubectl get pods,svc,pvc --namespace="$NAMESPACE"
