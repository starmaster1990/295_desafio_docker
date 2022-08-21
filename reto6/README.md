# RETO 3 - DOCKER
Este reto se compone de 3 partes
- El ejercicio mongo
- El ejercicio nginx
- Elminar los contenedores del sistema

Este reto se automatizo con las todas las partes por lo que al finalizar el script no tendra ningun contenedor<br>
Nota: si desea dejar los contenedores activos comente la ultima seccion<br>
La automatizacion usa el archivo del **script.sh** del reto y el **glogal.sh**
En este ejerciocio **global.sh** contiene constantes y funciones para diferentes tareas.<br> 
Ej: subir la imagen a dockerhub, validar usuario de dockerhub, etc.
## AUTOMATIZACIÓN
### PARAMETROS
Este script debe recibir 2 parametros obligatorios. <br>
A continuación se detalla los parametros<br><br>
![](images/0_parametros.png)
1. Usuario de Dockerhub
2. Password de su usuario de Dockerhub
### DETALLE 
El script realiza lo siguiente:
- Valida que los parametros de usuario y password se hayan pasado al script
- Valida la existencia del usuario en DockerHub
- Valida las credenciales de DockerHub
- Seccion MONGO
    - Crea contenedor
    - Crea BD e inserta informacion en coleccion
    - Crea la imagen desde el contenedor(uso de docker commit)
    - Tagea y sube la imagen a dockerhub
- Seccion MONGO
    - Se valida nombre de contenedor no exista en el host
    - Se valida que el puerto no este en uso por otro contenedor
    - Se crea imagen
    - Se crea contenedor
    - Tagea y sube la imagen a dockerhub
- Se eliminan los contenedores del sistema(parte final del reto)
### EXPLICACIÓN 
**VARIABLES Y PARAMETROS SCRIPT**<br>
A la derecha tenemos las variables **baseUrlDockerHub** **endpointUsuarios** que forman el endpoint<br>
de dockerHub que permite validar la existencia del usuario<br>
A la izquierda tenemos los parametros de entrada del script junto con las variables usadas en el script<br>
Nombre de imageners, contenedores, etc.<br>

![](images/1_variables_y_global.png)

**VALIDACION CREDENCIALES DOCKERHUB**<br>
**A la izquierda:**
- Se valida que el script reciba el nombre y passwor de un usuario de dockerhub
- Se valida la existencia del  usuario de dockerhub
- Se valida las credenciales de dockerhub y se inicia sesion

**A la derecha**
Las funciones en **global.sh** que se utilizan 
- existsUser
- authDockerHub
<br>
![](images/2_validacion_usuario.png)

**EJERCICIO - MONGO** 

![](images/3_mongo.png)

**EJERCICIO - NGINX** 

![](images/4_web.png)

**EJERCICIO - ELIMINA CONTENEDORES** 

![](images/5_elimina_contenedores.png)

## RESULTADO
![](images/final_mongo.png)<br>
![](images/final_web.png)<br>
![](images/final.png)<br>


**NOTA** En la ejecucion de ciertos comandos en el script se envia la salida de ejecución a archivos .log <br>
Esto es para no ensuciar la salida que vera el usuario al ejecutar el script