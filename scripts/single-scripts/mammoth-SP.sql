/*************************************************
	  CREACIÓN DE PROCEDIMIENTOS ALMACENADOS
 *************************************************/
 
-- Store Procedure: show_products_ordered_by_field
-- Objetivo: mostrar el listado de productos ordenados por un campo determinado (p_field) y según el criterio elegido (p_order) ascendente o descendente
DROP procedure IF EXISTS `show_products_ordered_by_field`;

DELIMITER $$
CREATE PROCEDURE `show_products_ordered_by_field`(IN p_field VARCHAR(12), IN p_order ENUM("ASC", "DESC", ""))
BEGIN
	-- declaro una variable local para almacenar el tipo de ordenamiento
	DECLARE ordered VARCHAR(30);
    
    -- declaro en una variable la sentencia básica del select de productos
    SET @sentence = "SELECT p.id_product, p.name, p.description, b.brand, a.category, ROUND((p.price/1.21),2) pl, p.discount, p.price plf, ROUND((p.price*(1-p.discount/100)),2) pvf
		FROM mammoth.product p JOIN mammoth.brand b 
        ON p.id_brand=b.id_brand 
        JOIN mammoth.category a 
        ON p.id_category=a.id_category";
	
    -- si el campo elegido es "" o NULL, seteo el tipo de ordenamiento como un string vacío
	IF p_field = "" or p_field IS NULL then
		SET ordered = "";
	-- si hay un campo elegido y el tipo de orden seleccionado es "" o NULL, se toma el ordenamiento por defecto (ASC)
	ELSEIF p_order = "" OR p_order IS NULL THEN
		SET ordered = concat(" ORDER BY ", p_field);
	-- si no,se construye el ordenamiento con el tipo elegido 
    ELSE 
		SET ordered = concat(" ORDER BY ", p_field, " ", p_order);
	END IF;
    
    -- se contruye la sentencia completa concatenando el ordenamiento
    SET @sentence= concat(@sentence, ordered);
    
    -- Se prepara, ejecuta y deshace el objeto SQL que tiene la sentencia resultante
    PREPARE runSQL FROM @sentence;
    EXECUTE runSQL;
    DEALLOCATE PREPARE runSQL;
END$$
DELIMITER ;

#CALL mammoth.show_products_ordered_by_field('brand', 'desc');

-- Store Procedure: delete_old_carts
-- Objetivo: Eliminar los carritos de compra con mayor antigüedad que la cantidad de días elegidos (p_days)
DROP procedure IF EXISTS `delete_old_carts`;

DELIMITER $$
CREATE PROCEDURE `delete_old_carts`(IN p_days SMALLINT)
BEGIN
	-- declaro una variable local para almacenar la fecha límite antes de la cual se borrarán los carritos
	DECLARE limit_date DATE;
    DECLARE initial_quantity INT DEFAULT 0;
    DECLARE final_quantity INT DEFAULT 0;

	-- seteo el modo seguro de update/delete en 0
    SET sql_safe_updates = 0;
    
    -- seteo el valor de la fecha límite en función a la fecha actual y los días seleccionados
    SET limit_date = date_sub(current_date(), INTERVAL p_days DAY);
	
    IF p_days > 0 then
		-- seteo la cantidad de carritos iniciales
		SELECT count(*) INTO initial_quantity FROM mammoth.cart;
		-- elimino los carritos cuya fecha es anterior a la límite
        DELETE FROM mammoth.cart WHERE date(last_update) < limit_date;
		-- seteo la cantidad de carritos luego del borrado
		SELECT count(*) INTO final_quantity FROM mammoth.cart;
	END IF;
	
    -- devuelvo el resultado de la cantidad de carritos borrados
	SELECT initial_quantity-final_quantity deleted_carts; 
    
    -- seteo el modo seguro de update/delete en 1
	SET sql_safe_updates = 1;
END$$
DELIMITER ;

#CALL mammoth.delete_old_carts(40);
