# El comando de la linea 3 indica el sistema operativo a utilizar para construir el entorno de desarrollo
# En este caso la imagen de ubuntu en su ultima version (latest)
FROM ubuntu:latest

# El comando en la linea 6 actualiza los paquetes de ubuntu (nuestro sistema operativo)
#  y tambien actualiza todos los paquetes instalados
RUN apt-get update && apt-get upgrade -y

# Con este comando se instala el servidor Web Apache y configuaramos al contenedor para que reciva solicitudes HTTP
# y devuelva archivos HTML
RUN apt-get install -y apache2

# Este comando instala el sistema de base de datos MySQL
# El contenedor tiene una base de datos lista para usarse en los sistemas que lo necesisten
RUN apt-get install -y mysql-server

# Instalamos PHP, junto con Apache y la extensión PHP para que interactue con MySQL
RUN apt-get install -y php libapache2-mod-php php-mysql

# Este comando inicia el servidor MySQL y cambia la contraseña del usuario "root"
RUN service mysql start && \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpassword';"

# Este comando habilita el modulo php8.3 en el servidor Apache, para que el servidor pueda leer y ejecutar archivos PHP
RUN a2enmod php8.3

# Este comando copia el código del sitio Web desde la carpeta src
COPY ./src /var/www/html

# Modificamos la configuración de Apache para poder usar archivos .htaccess (archivos extras para usar en el servidor Web)
RUN echo "<Directory /var/www/html/> \n\
    AllowOverride All \n\
    </Directory>" >> /etc/apache2/apache2.conf

# Este comando se usa para exponer el puerto 80 que usa Apache y el puerto 3306 para la conexiones a la base de datos MySQL
# A traves de estos puertos nos comunicamos con el mundo exterior 
EXPOSE 80 3306

# Se inicializa Apache y MySQL cuando se eejcuta o arranca el contenedor 
# tail -f /dev/null hace que el contenedor se siga ejecutando en segundo plano indefinidamente
CMD ["sh", "-c", "service apache2 start && service mysql start && tail -f /dev/null"]

