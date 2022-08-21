#!/bin/bash

baseUrlDockerHub="https://hub.docker.com/"
endpointUsuarios="v2/users/"

userDockerHub=$1
passwordDockerHub=$2
imageName=${3:-"bootcamp_nginx"}
containerName=${4:-"bootcamp_container"}
hostPort=${5:-"8080"}

<< 'Comment'
   Realiza una peticion a docker hub para validar existencia de usuario
Comment
existsUser(){
    echo $(curl -s -I "$baseUrlDockerHub$endpointUsuarios$1" | head -n 1 | awk '{print $2}')
}

<< 'Comment'
   Validamos existencia de contenedor con el nombre
Comment
existsContainer(){
    echo $(docker ps -a | grep -w  $1)
}

<< 'Comment'
   Validamos que el puerto no este en uso en el host
Comment
portNotAvailable(){
    echo $(docker ps -q -f publish=$1)
}

<< 'Comment'
   Crea el volumen del reto y se crea la imagen a partir del Dockerfile
Comment
imageCreator(){
    echo "creando volumen..."
    docker volume create static_content >reto3.log
    echo "creando imagen..."
    docker build --no-cache -t $1 . >reto3.log    
}

<< 'Comment'
   Crea un contenedor
Comment
containerCreator(){
    echo "creando contendor..."
    docker run -d --name $1 -v static_content:/usr/share/nginx/html -p $3:80 $2 >reto3.log
}

<< 'Comment'
   ELiminaun contenedor
Comment
deleteContainer(){
    docker stop $1 2> reto3_error.log 1> reto3.log 
    docker rm $1 2> reto3_error.log 1> reto3.log
}

<< 'Comment'
   Autentica en dockerhub
Comment
authDockerHub(){
    echo $(docker login -u $1 -p $2 2> reto3_error.log) 
}

<< 'Comment'
   Sube la imagen en dockerhub
Comment
uploadDockerHub(){
    echo "subiendo imagen $userDockerHub/$imageName ..."
    docker tag "$imageName" "$userDockerHub/$imageName" > reto3.log
    docker push "$userDockerHub/$imageName" > reto3.log
}

if [[ -z "$userDockerHub" ]]; then
    echo "No ingreso un usuario de dockerHub, el trabajo termino."
    exit
fi

if [[ -z "$passwordDockerHub" ]]; then
    echo "No ingreso su password de dockerHub, el trabajo termino."
    exit
fi

#PROCESO
echo "Validando usuario de dockerHub..."
exists=$(existsUser $userDockerHub)
if [[ "$exists" != "200" ]]; then
    echo "El usuario $userDockerHub no existe en dockerhub, el trabajo termino."
    exit
fi

echo "Validando nombre de contenedor..."
existsConta=$(existsContainer $containerName);            
if [[ -n "$existsConta" ]]; then
    echo "Ya existe un contenedor con el nombre *$containerName*, el trabajo termino."
    exit
fi

echo "Validando disponibilidad puerto del host..."
portNot=$(portNotAvailable $hostPort);
if [[ -n "$portNot" ]]; then
    echo "El puerto especificado *$hostPort* esta en uso por el contenedor con ID *$portNot*, el trabajo termino."
    exit
fi

echo "Autenticando en dockerhub..."
auth=$(authDockerHub "$userDockerHub" "$passwordDockerHub")
if [[ "$auth" != "Login Succeeded" ]]; then
    echo "Credencial incorrecta, el trabajo termino"                            
    deleteContainer "$containerName"
    exit;
fi

imageCreator "$imageName"
containerCreator "$containerName" "$imageName" "$hostPort"
uploadDockerHub "$userDockerHub" "$containerName"
echo "El contenedor se encuentra *UP* y la imagen fue subida a su cuenta de docker hub"