#!/bin/bash

<< 'Comment'
    Seguimos las instrucciones del reto 1, en el bash solo colocar 
    los comandos para crear el contendor
Comment

<< 'Comment'
    Creamos contenedor, en esta ocasion pasamos la opcion "--rm" para
    que al parar el contendor este se elimine automaticamente
Comment
docker run --rm -d --name servidor_web -p 8181:80 nginx

#cambiamos el contenido del index por default
docker cp index.html servidor_web:/usr/share/nginx/html

# curl para ver el contenido
curl localhost:8181