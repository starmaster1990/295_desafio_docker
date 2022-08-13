# RETO 2 - DOCKER
Si ejecutamos el comando tal cual lo copiamos, se presentara lo siguiente

![](images/1_comando_reto.png)

Adjuntamos backslash \  al final de cada linea a excepcion de la ultima

![](images/2_modificacion_comando.png)

Termina de levantar el contenedor y visualizamos el estado del contenedor

Nos percatamos que el puerto en el que trabaja el contenedor no fue mapeado a alguno del host

![](images/3_puerto_host_no_mapedo.png)

Lo terminamos de verificar con el inspect y navicat

![](images/4_inspet_1.png)

![](images/5_verificacion_navicat.png)

Modificamos el comando para mapear a un puerto del host
```bash
docker run --name bbdd  --env MARIADB_ROOT_PASSWORD=root  --env MARIADB_DATABASE=prueba  --env MARIADB_USER=invitado --env MARIADB_PASSWORD=invitado -p 3306:3306 mariadb
```
![](images/6_mapeando_puerto_al_host.png)

Verificamos el puerto del host

![](images/7_verificando_puerto_host.png)

Verificamos la conexion con Navicat

![](images/8_conexion_mariadb.png)

Visualizamos la base de datos que se creó **prueba**

![](images/9_base_datos.png)

Se intenta eliminar la imagen sin éxito

![](images/10_intento_eliminar_contenedor.png)

*Si le pasamos **-f** al eliminar la imagen si lo hace, ya que lo forzamos*

![](images/11_eliminado_forzado.png)