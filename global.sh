#!/bin/bash
#colors
bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)

baseUrlDockerHub="https://hub.docker.com/"
endpointUsuarios="v2/users/"

################################
#       METODOS GENERALES
################################
<< 'Comment'
   Validamos existencia de contenedor con el nombre
   Devuelve el id del contenedor
Comment
existsContainer(){
    echo $(docker ps -a -q -f name=$1);
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
    echo "${info}INFO${reset}: creando imagen..."
    docker build --no-cache -t $1 . >reto.log    
}

<< 'Comment'
   Crea un contenedor
   $1 nombre imagen
   $2 nombre contenedor
   $3 puerto host
   $4 puerto contenedor
Comment
containerCreator(){
    echo "${info}INFO${reset}: creando contendor..."
    docker run -d --name $2 -p $3:$4 $1 >reto.log
}

<< 'Comment'
   ELimina un contenedor
Comment
deleteContainer(){
    docker stop $1 2> reto_error.log 1> reto.log 
    docker rm $1 2> reto_error.log 1> reto.log
}

<< 'Comment'
   Realiza una peticion a docker hub para validar existencia de usuario
Comment
existsUser(){
    echo $(curl -s -I "$baseUrlDockerHub$endpointUsuarios$1" | head -n 1 | awk '{print $2}')
}

<< 'Comment'
   Autentica en dockerhub
Comment
authDockerHub(){
    echo $(docker login -u $1 -p $2 2> reto_error.log) 
}

<< 'Comment'
   Sube la imagen en dockerhub
   $1 user dockerhub
   $2 nombre imagen
Comment
uploadDockerHub(){
    echo "${info}INFO${reset}: subiendo imagen $1/$2 ..."
    docker tag "$2" "$1/$2" > reto.log
    docker push "$1/$2" > reto.log
}
