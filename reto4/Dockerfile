FROM httpd:alpine

#argumentos pasados en el build
ARG PROJECT_MAINTAINER
ARG PROJECT_NAME

#Etiquetado
LABEL maintainer=$PROJECT_MAINTAINER
LABEL project=$PROJECT_NAME

#Como metadato, indicamos que el contenedor utiliza el puerto 80
EXPOSE 80

#Modificaciones sobre la imagen que he utilizado como base, en este caso alpine
COPY content/ /usr/local/apache2/htdocs