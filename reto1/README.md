# RETO 1 - DOCKER
## Creando contendor
Verificamos las imagenes de nginx que tiene nuestro registro local
```bash
docker images | grep nginx
```
![](images/1_listar_imagenes_nginx.png)


Creamos el contendor a partir de la imagen de nginx
```bash
docker run -d --name servidor_web -p 8181:80 nginx
```
![](images/2_crea_contenedor.png)

## Copiando pagina
Copiamos nuestro index.html
```bash
docker cp index.html servidor_web:/usr/share/nginx/html
```

## Pruebas
Realizamos un curl
```bash
curl localhost:8181
```
![](images/4_curl_contenedor.png)


Tambien verificamos ingresando por el navegador

![](images/5_pagina_navegador.png)

## Eliminando contendor
Eliminamos el contenedor con el siguiente comando
```bash
docker stop servidor_web && docker rm servidor_web
```
Y listamos los contenedores para verficar
```bash
docker ps -a
```
![](images/6_eliminar_lista_contenedores.png)

Como pueden apreciar ya no existe el contenedor