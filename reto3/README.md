# RETO 3 - DOCKER

Creamos el volumen 
```bash
docker volume create static_content
```

Creamos la imagen **bootcamp_nginx**, para eso, nos situamos al nivel del **Dockerfile** de la carpeta **reto3**
```bash
docker build -t bootcamp_nginx .
```

Iniciamos el contenedor enlazando el volumen previamente
```bash
docker run -d --name bootcamp_container -v static_content:/usr/share/nginx/html -p 8080:80 bootcamp_nginx 
```

Realizamos un curl para probar
```bash
curl localhost:8080/index.html
```