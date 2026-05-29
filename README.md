# TP-Integrador-AdSA
El proyecto propuesto consiste en desarrollar un laboratorio reproducible en GitHub para desplegar una aplicación web simple sobre Kubernetes utilizando almacenamiento persistente y configuración dinámica.

La aplicación estará basada en Nginx y será desplegada en un clúster local Kind. El objetivo principal será demostrar cómo Kubernetes permite desacoplar el ciclo de vida de los contenedores del almacenamiento mediante el uso de Persistent Volumes y Persistent Volume Claims.

Además, el proyecto incorporará un ConfigMap para personalizar la página principal del servidor web sin modificar la imagen del contenedor, y un Secret para inyectar una variable sensible dentro del Pod de forma controlada.

El repositorio incluirá manifiestos YAML organizados por etapas, scripts de despliegue y prueba, y documentación en un archivo README.md. También se incluirán capturas de pantalla que evidencien la creación de los recursos, la persistencia de datos luego de eliminar y recrear el Pod, y la correcta lectura del ConfigMap y del Secret.

Este proyecto se relaciona con los contenidos de la asignatura vinculados a contenedores, Kubernetes, almacenamiento persistente, configuración declarativa y automatización básica. Su desarrollo permitirá demostrar, de manera práctica y reproducible, conceptos fundamentales de administración avanzada de sistemas en entornos cloud-native.
