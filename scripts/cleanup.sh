#!/usr/bin/env bash

# Proyecto Integrador - Administración de Sistemas Avanzada
# Alumno: Lucas Aponte
# Este script elimina los recursos creados para dejar limpio el clúster.

set -euo pipefail

NAMESPACE="proyecto-adsa"

echo "=== Limpieza del proyecto ==="

if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
  echo "Eliminando recursos namespaced..."
  kubectl delete namespace "$NAMESPACE"
else
  echo "El namespace $NAMESPACE no existe."
fi

if kubectl get pv pv-nginx-adsa >/dev/null 2>&1; then
  echo "Eliminando PersistentVolume..."
  kubectl delete pv pv-nginx-adsa
else
  echo "El PersistentVolume no existe."
fi

echo "Limpieza finalizada."
