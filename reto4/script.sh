#!/bin/bash

imageName=${1:-"simple-apache:new"}
containerName=${2:-"my_apache"}
hostPort=${3:-"5050"}
projectMaintainer=${4:-"ronny.tigrero.22@gmail.com"}
projectName=${5:-"bootcamp"}

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
   Crea la imagen a partir del Dockerfile
Comment
imageCreator(){
    docker build --no-cache --build-arg PROJECT_MAINTAINER=$2 --build-arg PROJECT_NAME=$3 -t $1 . >reto4.log
}

<< 'Comment'
   Crea un contenedor
Comment
containerCreator(){
    echo "creando contendor..."
    docker run -d --name $1 -p $3:80 $2 >reto4.log
}

<< 'Comment'
   ELimina un contenedor
Comment
deleteContainer(){
    docker stop $1 2> reto4_error.log 1> reto4.log 
    docker rm $1 2> reto4_error.log 1> reto4.log
}

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

imageCreator "$imageName" "$projectMaintainer" "$projectName"
containerCreator "$containerName" "$imageName" "$hostPort"
echo "El contenedor *$containerName* se encuentra *UP* en el puerto *$hostPort*"