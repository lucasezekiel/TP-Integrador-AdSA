# TP-Integrador-AdSA
El proyecto propuesto consiste en desarrollar un laboratorio reproducible y automatizado para el despliegue de una aplicación web en Kubernetes, utilizando manifiestos YAML, scripts Bash y documentación técnica versionada en GitHub.

La aplicación estará basada en Nginx y será desplegada sobre un clúster local Kind. El objetivo principal será demostrar cómo Kubernetes permite administrar aplicaciones contenerizadas mediante configuración declarativa, almacenamiento persistente y automatización de tareas básicas de administración de sistemas.

El proyecto incluirá la creación de recursos Kubernetes como Persistent Volume, Persistent Volume Claim, ConfigMap, Secret y un Pod o Deployment de Nginx. A través del uso de PV y PVC se buscará demostrar la persistencia de datos aun cuando el Pod sea eliminado y recreado. Mediante ConfigMaps se modificará la página principal del servidor web sin alterar la imagen del contenedor, y mediante Secrets se incorporará una variable sensible dentro del entorno del contenedor de forma controlada.

Además, se desarrollarán scripts Bash que permitan automatizar el despliegue completo, verificar el estado final de los recursos creados y realizar pruebas básicas de funcionamiento. Entre esas pruebas se incluirá la validación del acceso al servicio web, la persistencia de los datos y la lectura de variables inyectadas desde Secrets.

El repositorio estará organizado con una estructura clara, incluyendo una carpeta de manifiestos YAML, una carpeta de scripts, documentación en README.md y capturas de validación. El README describirá el objetivo del proyecto, los requisitos, los pasos de instalación, la ejecución del despliegue, la validación de resultados y los comandos utilizados.

Este proyecto se relaciona con los contenidos de Administración de Sistemas Avanzada, especialmente con contenedores, Kubernetes, almacenamiento persistente, configuración declarativa, automatización con scripts y buenas prácticas de documentación en entornos de software libre. Su finalidad es construir una solución simple, reproducible y verificable que demuestre competencias prácticas en administración de infraestructura cloud-native.
