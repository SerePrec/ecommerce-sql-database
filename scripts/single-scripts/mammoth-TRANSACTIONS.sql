/*************************************************
	               TRANSACCIONES
 *************************************************/

-- Inicio transacción de eliminación de registros
-- **********************************************
START TRANSACTION;
	DELETE FROM favorite
    WHERE id_user = 5 AND id_product = 35; 
	DELETE FROM favorite
    WHERE id_user = 20 AND id_product = 8;
	DELETE FROM favorite
    WHERE id_user = 128 AND id_product = 25;

-- Si quiero deshacer las eliminaciones
# ROLLBACK;

-- Si quiero persistir las eliminaciones
COMMIT;   

-- Inicio transacción de inserción de registros con savepoints
-- ***********************************************************
START TRANSACTION;
SAVEPOINT defecto;
	INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('23268524','Chris','Roizin',29,'M-3582-BIB','+504-996-327-6440','croizin0@topsy.com','JQkTexqZcnQb0HUEvOU9yW4Kg1HhylNI',3,'24-23268524-8');
	INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('49658397','Demian','Haugh',61,'F-9876-BZA',NULL,'dhaugh1@livejournal.com','H4wqvW3LWO5nff9pqhHn6om08sY5J4YQ',3,'23-49658397-0');
	INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('19801835','Ricardo','MacGibbon',4,'F-1048-UUO','+86-438-437-9190','rmacgibbon2@yale.edu','3XjIkO0T3O2tyWKQ2qoJ0KjAcT4aAC3u',2,'26-19801835-7');
	INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('22800504','Tatiana','Savin',135,'S-4869-KDE',NULL,'tsavin34@google.es','9b4k5MCEMy8OX3GjHZETDfP6kWw2CLOX',4,'20-22800504-7');
SAVEPOINT pack_1; 	
    INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('29421433','Sam','Dietz',51,'R-0995-IDE','+86-228-424-1758','sdietz14@springer.com','7LuUZsScKgCDjd10xCGLUT6dqYHkJ1AY',1,'27-29421433-0');
	INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('39123289','Sofie','Coupe',76,'R-4775-TTY',NULL,'socoupe25@dyndns.org','LJgedd9Ks5QeB0xN3RCEKnsZdJhVAxUZ',2,'26-39123289-0');
	INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('11812384','Silvie','Drioli',40,'L-5227-ZMK','+993-471-983-4374','sidrioli@aboutads.info','4ZfiVjYtJ57zl3InATTT89GyFf4UnrxU',10,'20-11812384-9');
	INSERT INTO user (`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`)
    VALUES ('44556880','Fernando','Poulsen',65,'X-6557-CAS','+1-710-661-3272','fepoulsen17@mapquest.com','umoeZPgPO8aGoOuSWkSIxqu884DPWCxp',8,'27-44556880-6');
SAVEPOINT pack_2;

-- si quiero deshacer el savepoint pack_1
# RELEASE SAVEPOINT pack_1;
	