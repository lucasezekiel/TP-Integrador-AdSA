# Proyecto Integrador — Administración de Sistemas Avanzada

## Automatización de una aplicación web persistente en Kubernetes

**Alumno:** Lucas Aponte

**Carrera:** Tecnicatura Superior en Administración de Sistemas y Software Libre

**Asignatura:** Administración de Sistemas Avanzada

**Universidad Nacional del Comahue — Complejo Regional Zona Atlántica y Sur**

---

## 1. Descripción

Este proyecto implementa un laboratorio reproducible y automatizado para desplegar una aplicación web basada en Nginx sobre un clúster local de Kubernetes creado con Kind.

La solución utiliza manifiestos YAML para definir los recursos del clúster y scripts Bash para automatizar el despliegue, la validación, la prueba de persistencia y la limpieza del entorno.

El proyecto integra almacenamiento persistente mediante Persistent Volume y Persistent Volume Claim, configuración dinámica mediante ConfigMap y gestión de una variable sensible ficticia mediante Secret.

El repositorio permite desplegar la infraestructura de forma ordenada, reproducible y verificable, aplicando conceptos de administración de sistemas en entornos cloud-native.

---

## 2. Objetivo general

Desarrollar un laboratorio reproducible y automatizado para desplegar una aplicación web Nginx sobre Kubernetes, integrando almacenamiento persistente, configuración declarativa, gestión de variables sensibles y scripts Bash para la administración del entorno.

---

## 3. Objetivos específicos

* Crear un clúster Kubernetes local mediante Kind.
* Definir los recursos mediante manifiestos YAML.
* Aislar los recursos dentro de un Namespace propio.
* Implementar almacenamiento persistente mediante PV y PVC.
* Personalizar la página principal de Nginx mediante un ConfigMap.
* Inyectar una variable ficticia mediante un Secret.
* Desplegar la aplicación mediante un Deployment.
* Exponer la aplicación mediante un Service.
* Automatizar el despliegue y la validación mediante scripts Bash.
* Comprobar la persistencia de datos después de eliminar y recrear un Pod.
* Documentar el funcionamiento y los resultados en GitHub.

---

## 4. Arquitectura

```text
Usuario
  │
  │ localhost:8085
  ▼
Service nginx-service
  │
  ▼
Deployment nginx-adsa
  │
  ├── ConfigMap nginx-config
  │      └── index.html personalizado
  │
  ├── Secret nginx-secret
  │      └── variable PASSWORD
  │
  └── PVC pvc-nginx-adsa
          │
          ▼
      PV pv-nginx-adsa
          │
          ▼
      hostPath del nodo Kind
```

El Service permite acceder a la aplicación. El Deployment administra el Pod de Nginx y lo recrea en caso de eliminación. El ConfigMap suministra la página web, el Secret inyecta una variable de entorno y el PVC conserva los datos independientemente del ciclo de vida del Pod.

---

## 5. Tecnologías utilizadas

* Linux
* Kubernetes
* Kind
* kubectl
* Podman
* Nginx Alpine
* YAML
* Bash
* Git
* GitHub

---

## 6. Estructura del repositorio

```text
TP-Integrador-AdSA/
├── README.md
├── LICENSE
├── kind/
│   └── cluster.yaml
├── manifests/
│   ├── 00-namespace.yaml
│   ├── 01-pv.yaml
│   ├── 02-pvc.yaml
│   ├── 03-configmap.yaml
│   ├── 04-secret.yaml
│   ├── 05-deployment.yaml
│   └── 06-service.yaml
├── scripts/
│   ├── deploy.sh
│   ├── validate.sh
│   ├── test-persistence.sh
│   └── cleanup.sh
├── web/
│   └── index.html
└── docs/
    ├── PRESENTACION.md
    └── capturas/
```

---

## 7. Recursos implementados

### Namespace

Agrupa y aísla los recursos del proyecto dentro de:

```text
proyecto-adsa
```

### Persistent Volume

Reserva almacenamiento local dentro del nodo del clúster Kind.

### Persistent Volume Claim

Solicita el espacio que utiliza la aplicación Nginx.

### ConfigMap

Contiene el archivo `index.html` personalizado que se muestra como página principal.

### Secret

Contiene una contraseña ficticia utilizada únicamente para demostrar la inyección de variables de entorno.

> El Secret incluido no contiene credenciales reales.

### Deployment

Administra el Pod de Nginx y garantiza que exista una réplica disponible.

### Service

Expone la aplicación dentro del clúster y permite acceder mediante `kubectl port-forward`.

---

## 8. Requisitos

Antes de ejecutar el proyecto se requiere:

* Linux.
* Kind.
* kubectl.
* Podman o Docker.
* Git.
* Bash.

Verificar las herramientas:

```bash
kind version
kubectl version --client
podman --version
git --version
```

---

## 9. Clonar el repositorio

```bash
git clone REPOSITORIO_DEL_PROYECTO
cd TP-Integrador-AdSA
```

---

## 10. Crear el clúster Kind

```bash
kind create cluster \
  --name adsa-integrador \
  --config kind/cluster.yaml
```

Verificar:

```bash
kubectl config current-context
kubectl get nodes
```

Resultado esperado:

```text
adsa-integrador-control-plane   Ready   control-plane
```

---

## 11. Desplegar el proyecto

El script `deploy.sh` aplica los manifiestos en el orden necesario:

```bash
./scripts/deploy.sh
```

El script realiza las siguientes acciones:

1. Crea el Namespace.
2. Crea el Persistent Volume.
3. Crea el Persistent Volume Claim.
4. Aplica el ConfigMap.
5. Aplica el Secret.
6. Crea el Deployment de Nginx.
7. Crea el Service.
8. Espera que el Deployment quede disponible.

Al finalizar, el Pod debe encontrarse en estado `Running` y el PVC en estado `Bound`.

---

## 12. Validar el despliegue

```bash
./scripts/validate.sh
```

La validación comprueba:

* estado del nodo;
* estado del Deployment;
* Pod en ejecución;
* Service creado;
* PVC enlazado al PV;
* ConfigMap disponible;
* Secret disponible;
* contenido del archivo `index.html`;
* inyección de la variable `PASSWORD`.

Salida final esperada:

```text
Validación finalizada correctamente.
```

---

## 13. Acceder a la aplicación

Ejecutar:

```bash
kubectl port-forward \
  --namespace proyecto-adsa \
  service/nginx-service \
  8085:80
```

Abrir en el navegador:

```text
http://localhost:8085
```

La página debe mostrar:

```text
Aplicación Nginx en Kubernetes
Proyecto Integrador de Administración de Sistemas Avanzada
Alumno: Lucas Aponte
Configuración cargada mediante ConfigMap.
```

El proceso de `port-forward` debe permanecer activo mientras se accede desde el navegador.

---

## 14. Prueba automatizada de persistencia

Ejecutar:

```bash
./scripts/test-persistence.sh
```

El script realiza automáticamente:

1. La creación de un archivo dentro del volumen persistente.
2. La verificación de su contenido.
3. La eliminación del Pod activo.
4. La espera mientras Kubernetes recrea el Pod.
5. La comprobación del archivo desde el nuevo Pod.

Resultado esperado:

```text
PRUEBA EXITOSA: el archivo persistió después de recrear el Pod.
```

Esta prueba demuestra que los datos se almacenan en el volumen persistente y no dependen del ciclo de vida del contenedor.

Para observar la recreación del Pod en tiempo real, se puede ejecutar en otra terminal:

```bash
kubectl get pods \
  --namespace proyecto-adsa \
  --watch
```

---

## 15. Autorrecuperación

El Deployment declara una réplica de Nginx como estado deseado. Si el Pod es eliminado, Kubernetes detecta la diferencia entre el estado real y el estado declarado, por lo que crea automáticamente un nuevo Pod.

Este comportamiento demuestra el mecanismo de autorrecuperación o *self-healing* de Kubernetes.

---

## 16. Limpieza del entorno

Para eliminar los recursos creados:

```bash
./scripts/cleanup.sh
```

Para eliminar el clúster Kind:

```bash
kind delete cluster --name adsa-integrador
```

---

## 17. Resultados obtenidos

Durante las pruebas se verificó que:

* el despliegue automatizado finaliza correctamente;
* el nodo del clúster queda en estado `Ready`;
* el Pod Nginx queda en estado `Running`;
* el PVC queda enlazado al PV en estado `Bound`;
* la página personalizada del ConfigMap se muestra en el navegador;
* el Secret se inyecta como variable de entorno;
* Kubernetes recrea automáticamente el Pod eliminado;
* el archivo almacenado en el PVC permanece disponible después de recrear el Pod.

---

## 18. Limitaciones

El proyecto utiliza `hostPath` porque está diseñado como laboratorio local sobre Kind.

Esta solución es adecuada para demostraciones y entornos de desarrollo, pero no representa un sistema de almacenamiento distribuido para producción. En un entorno real podrían utilizarse StorageClasses y soluciones como Ceph, Longhorn, OpenEBS o servicios de almacenamiento provistos por plataformas cloud.

El Secret incluido utiliza una credencial ficticia. La codificación utilizada por Kubernetes no debe interpretarse como cifrado de la información.

---

## 19. Conclusión

El proyecto permitió integrar conceptos de contenedores, Kubernetes, almacenamiento persistente, configuración declarativa y automatización.

El uso de manifiestos YAML hizo posible definir la infraestructura de manera reproducible, mientras que los scripts Bash simplificaron el despliegue, la validación y las pruebas.

La eliminación y recreación del Pod permitió comprobar que Kubernetes mantiene el estado deseado de la aplicación. A su vez, el uso de PV y PVC demostró que los datos pueden persistir más allá del ciclo de vida de los contenedores.

La solución constituye un laboratorio sencillo, verificable y reutilizable para comprender principios fundamentales de administración avanzada de sistemas en entornos cloud-native.

---

## 20. Licencia

Este proyecto se distribuye bajo la licencia **GNU General Public License v3.0**, en concordancia con los principios del software libre.



