/*************************************************
	     CREACIÓN DE USUARIOS Y PERMISOS
 *************************************************/

# USER: reader
# ************

# Creo el usuario reader con su contraseña
CREATE USER IF NOT EXISTS reader@localhost IDENTIFIED BY 'Reader2022';

# verifico su correcta creación en la tabla users de la BD mysql
-- SELECT * FROM mysql.user;

# Le doy permisos sólo de lectura al usuario reader sobre todas las tablas y vistas de la base de datos mammoth
GRANT SELECT ON mammoth.* TO reader@localhost;

# verifico los permisos del usuario reader
-- SHOW GRANTS FOR reader@localhost;

# USER: writer
# ************

# Creo el usuario writer con su contraseña
CREATE USER IF NOT EXISTS writer@localhost IDENTIFIED BY 'Writer2022';

# verifico su correcta creación en la tabla users de la BD mysql
-- SELECT * FROM mysql.user;

# Le doy permisos de lectura, inserción y actualización al usuario writer sobre todas las tablas y vistas de la base de datos mammoth
GRANT SELECT, INSERT, UPDATE ON mammoth.* TO writer@localhost;

# verifico los permisos del usuario writer
-- SHOW GRANTS FOR writer@localhost;