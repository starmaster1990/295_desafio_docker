#!/bin/bash

lines(){
    echo "=========================================="
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

imageCreator(){
    lines
    echo "================ Creando imagen ================"
    lines
    docker build --no-cache --build-arg PROJECT_MAINTAINER=$2 --build-arg PROJECT_NAME=$3 -t $1 . >reto4.log    
}

containerCreator(){
    lines
    echo "================ Creando contenedor ================"
    lines
    docker run -d --name $1 -p $3:80 $2 >reto4.log
}

deleteContainer(){
    docker stop $1 2> reto4_error.log 1> reto4.log 
    docker rm $1 2> reto4_error.log 1> reto4.log
}

echo "Este job crea un contenedor basado en un dockerfile con imagen base de apache"

read -p "Ingresa un nombre para la imagen, esto es opcional(por defecto es *simple-apache:new*): " imageName
read -p "Ingresa el nombre para el contenedor,esto es opcional(por defecto es *my_apache*): " containerName
read -p "Ingresa el PROJECT MAINTAINER,esto es opcional(por defecto es *ronny.tigrero.22@gmail.com*): " projectMaintainer
read -p "Ingresa el PROJECT NAME,esto es opcional(por defecto es *bootcamp*): " projectName

if [[ -z "$imageName" ]]; then
    imageName="simple-apache:new"
fi

if [[ -z "$containerName" ]]; then
    containerName="my_apache"
fi

existsConta=$(existsContainer $containerName);
if [[ -z "$existsConta" ]]; then
    imageCreator "$imageName" "$projectMaintainer" "$projectName"
    
    read -p "Ingresa el puerto del host,esto es opcional(por defecto es *5050*): " hostPort
    if [[ -z "$hostPort" ]]; then
        hostPort="5050"
    fi

    portNot=$(portNotAvailable $hostPort);    
    if [[ -z "$portNot" ]]; then        
        containerCreator "$containerName" "$imageName" "$hostPort"
        echo "se ha creado el contenedor *$containerName*"
      else
        echo "El puerto especificado *$hostPort* esta en uso por el contenedor con ID *$portNot*, el trabajo termino."
        deleteContainer "$containerName"
    fi
else
    echo "Ya existe un contenedor con el nombre *$containerName*, el trabajo termino."
fi