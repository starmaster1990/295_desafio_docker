#!/bin/bash

baseUrlDockerHub="https://hub.docker.com/"
endpointUsuarios="v2/users/"

lines(){
    echo "=========================================="
}

read -p "Ingresa tu usuario de docker hub: " userDockerHub

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

imageCreator(){
    lines
    echo "================ Creando el volumen ================"bootcamp_container
    lines
    docker volume create static_content >reto3.log
    lines
    echo "================ Creando imagen ================"
    lines
    docker build --no-cache -t $1 . >reto3.log    
}

containerCreator(){
    lines
    echo "================ Creando contenedor ================"
    lines
    docker run -d --name $1 -v static_content:/usr/share/nginx/html -p $3:80 $2 >reto3.log
}

deleteContainer(){
    docker stop $1 2> reto3_error.log 1> reto3.log 
    docker rm $1 2> reto3_error.log 1> reto3.log
}

authDockerHub(){
    echo $(docker login -u $1 -p $2 2> reto3_error.log) 
}

uploadDockerHub(){
    docker tag "$imageName" "$userDockerHub/$imageName" > reto3.log
    docker push "$userDockerHub/$imageName" > reto3.log
}

 if [[ -z "$userDockerHub" ]]; then
        echo "No ingreso un usuario de docker hub, el trabajo termino."
    else        
        exists=$(existsUser $userDockerHub)
        if [[ "$exists" == "200" ]]; then
            read -p "Ingresa un nombre para la imagen, esto es opcional(por defecto es *bootcamp_nginx*): " imageName
            if [[ -z "$imageName" ]]; then
                imageName="bootcamp_nginx"
            fi

            read -p "Ingresa un nombre para el contenedor, esto es opcional(por defecto es *bootcamp_container*): " containerName            
            if [[ -z "$containerName" ]]; then
                containerName="bootcamp_container"
            fi

            existsConta=$(existsContainer $containerName);
            
            if [[ -z "$existsConta" ]]; then
                imageCreator "$imageName"
                
                read -p "Ingresa un puerto del host, esto es opcional(por defecto es *8080*): " hostPort
                if [[ -z "$hostPort" ]]; then
                    hostPort="8080"
                fi
                portNot=$(portNotAvailable $hostPort);

                if [[ -z "$portNot" ]]; then
                    containerCreator "$containerName" "$imageName" "$hostPort"
                    echo "A continuacion necesitamos tu password de docker hub, para subir la imagen"
                    read -p "Ingresa tu password de Dockerhub: " passwordDockerHub
                    if [[ -z "$passwordDockerHub" ]]; then
                        echo "No ingreso un password, el trabajo termino"
                        deleteContainer "$containerName"
                    else 
                        auth=$(authDockerHub "$userDockerHub" "$passwordDockerHub")
                        if [[ "$auth" == "Login Succeeded" ]]; then
                            uploadDockerHub "$userDockerHub" "$containerName"
                            echo "El contenedor se encuentra *UP* y la imagen fue subida a su cuenta de docker hub"
                        else
                            echo "Credencial incorrecta, el trabajo termino"                            
                            deleteContainer "$containerName"
                        fi
                    fi
                else
                    echo "El puerto especificado *$hostPort* esta en uso por el contenedor con ID *$portNot*, el trabajo termino."
                fi

            else
                echo "Ya existe un contenedor con el nombre *$containerName*, el trabajo termino."
            fi
        else
            echo "El usuario ingresado no existe, el trabajo termino."
        fi

fi 