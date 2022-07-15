/*************************************************
			   CREACIÓN DE TRIGGERS
 *************************************************/
 
-- Trigger: AF_IN_user_table_manipulation_log
-- Objetivo: guardar en la tabla de "logs de operaciones DML sobre tablas" la información asociada al evento de inserción de un nuevo usuario
DROP TRIGGER IF EXISTS AF_IN_user_table_manipulation_log;

CREATE TRIGGER AF_IN_user_table_manipulation_log
AFTER INSERT ON user
FOR EACH ROW
INSERT INTO table_manipulation_log VALUES
("user", "insert", current_date(), current_time(), user());


-- Trigger: AF_UP_user_table_manipulation_log
-- Objetivo: guardar en la tabla de "logs de operaciones DML sobre tablas" la información asociada al evento de actualización de un usuario
DROP TRIGGER IF EXISTS AF_UP_user_table_manipulation_log;

CREATE TRIGGER AF_UP_user_table_manipulation_log
AFTER UPDATE ON user
FOR EACH ROW
INSERT INTO table_manipulation_log VALUES
("user", "update", current_date(), current_time(), user());


-- Trigger: AF_DE_user_table_manipulation_log
-- Objetivo: guardar en la tabla de "logs de operaciones DML sobre tablas" la información asociada al evento de eliminación de un usuario
DROP TRIGGER IF EXISTS AF_DE_user_table_manipulation_log;

CREATE TRIGGER AF_DE_user_table_manipulation_log
AFTER DELETE ON user
FOR EACH ROW
INSERT INTO table_manipulation_log VALUES
("user", "delete", current_date(), current_time(), user());


-- Trigger: BF_UP_product_product_price_update
-- Objetivo: guardar en la tabla de "actualizaciones de precios" la información asociada al cambio de precio y/o descuento sobre un producto
DROP TRIGGER IF EXISTS BF_UP_product_product_price_update;

DELIMITER $$
CREATE TRIGGER BF_UP_product_product_price_update
BEFORE UPDATE ON product
FOR EACH ROW
BEGIN
	-- Si el precio pasado para actualizar es negativo, setearlo en 0
    IF NEW.price < 0 THEN
		SET NEW.price = 0;
	END IF;
    -- Si el descuento pasado para actualizar es negativo, setearlo en 0
    IF NEW.discount < 0 THEN
		SET NEW.discount = 0;
	END IF;
    
    INSERT INTO product_price_update VALUES
    (OLD.id_product, NEW.name, OLD.price, OLD.discount, NEW.price, NEW.discount, now(), user());
END $$
DELIMITER ;
