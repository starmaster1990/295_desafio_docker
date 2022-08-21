#!/bin/bash
source ../global.sh

userDockerHub=$1
passwordDockerHub=$2

#variables
imageNameMongo="mi_imagen_mongo"
imageNameNginx=4:"mi_imagen_nginx"
containerNameMongo="mi_container_mongo"
containerNameNginx="mi_container_nginx"
hostPortContainerNginx="9999"

MONGO_DB_NAME="Library"
MONGO_DB_COLLECTION="Books"
MONGO_USER_ROOT="administrador"
MONGO_PASSWORD_ROOT="12345"

if [[ -z "$userDockerHub" ]]; then
    echo "${error}ERROR${reset}: No ingreso un usuario de dockerHub, el trabajo termino."
    exit
fi

if [[ -z "$passwordDockerHub" ]]; then
    echo "${error}ERROR${reset}: No ingreso su password de dockerHub, el trabajo termino."
    exit
fi

echo "${info}INFO${reset}: Validando usuario de dockerHub..."
exists=$(existsUser $userDockerHub)
if [[ "$exists" != "200" ]]; then
    echo "${error}ERROR${reset}: El usuario $userDockerHub no existe en dockerhub, el trabajo termino."
    exit
fi

auth=$(authDockerHub "$userDockerHub" "$passwordDockerHub")
if [[ "$auth" != "Login Succeeded" ]]; then
    echo "${error}ERROR${reset}: Credencial de usuario $userDockerHub incorrecta, el trabajo termino"                            
    exit;
fi

echo "************************** EJERCICIO 1 - MONGO **************************"
echo "${info}INFO${reset}: Iniciando el trabajo... "

echo "${info}INFO${reset}: Levantando el contenedor... "
docker run -d -p 27017:27017 --name $containerNameMongo -e MONGO_INITDB_ROOT_USERNAME="$MONGO_USER_ROOT" -e MONGO_INITDB_ROOT_PASSWORD="$MONGO_PASSWORD_ROOT"  mongo:5.0 &>/dev/null
sleep 5

echo "${info}INFO${reset}: Creando la base de datos y la coleccion ${bold}Books${reset}... "
json="$(cat books.json)"
docker exec -i "$containerNameMongo" mongo --quiet -u "$MONGO_USER_ROOT" -p "$MONGO_PASSWORD_ROOT" &>/dev/null <<EOF
 use $MONGO_DB_NAME
 db.$MONGO_DB_COLLECTION.insert($json);
 exit
EOF

echo "${info}INFO${reset}: Creando la imagen... "
containerID=$(existsContainer $containerNameMongo);            
if [[ -z "$containerID" ]]; then
    echo "${error}ERROR${reset}: No se encontro contenedor para crear la imagen"
    exit
fi
docker commit "$containerID" "$imageNameMongo"

echo "${info}INFO${reset}: Subiendo imagen a dockerHub..."
uploadDockerHub "$userDockerHub" "$imageNameMongo"

echo "${info}INFO${reset}: El contenedor se encuentra ${bold}UP${reset} y la imagen fue subida a su cuenta de docker hub"


echo "************************** EJERCICIO 2- NGINX **************************"

echo "${info}INFO${reset}: Iniciando el trabajo... "


echo "${info}INFO${reset}: Validando nombre de contenedor..."
containerID=$(existsContainer $containerNameNginx);            
if [[ -n "$containerID" ]]; then
    echo "${error}ERROR${reset}: Ya existe un contenedor con el nombre ${bold}$containerNameNginx${reset}, el trabajo termino."
    exit
fi

echo "${info}INFO${reset}: Validando disponibilidad puerto del host..."
portNot=$(portNotAvailable $hostPortContainerNginx);
if [[ -n "$portNot" ]]; then
    echo "${error}ERROR${reset}: El puerto especificado ${bold}$hostPortContainerNginx${reset} esta en uso por el contenedor con ID ${bold}$portNot${reset}, el trabajo termino."
    exit
fi

imageCreator "$imageNameNginx"
containerCreator "$imageNameNginx" "$containerNameNginx" "$hostPortContainerNginx" "80"
echo "${info}INFO${reset}: Subiendo imagen a dockerHub..."
uploadDockerHub "$userDockerHub" "$imageNameNginx"
echo "${info}INFO${reset}: El contenedor se encuentra ${bold}UP${reset} y la imagen fue subida a su cuenta de docker hub"

echo "************************** EJERCICIO 3 - ELIMINAR CONTENEDORES **************************"
# echo "${info}INFO${reset}: Eliminando..."
# docker stop $(docker ps -q) && docker rm -f $(docker ps -a -q) &>/dev/null
# echo "${info}INFO${reset}: todos los contenedores de sus sistema han sido eliminados"









