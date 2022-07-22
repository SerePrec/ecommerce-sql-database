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


-- Store Procedure: generate_order_from_cart
-- Objetivo: generar una orden de compra junto a su detalle a partir del id del carrito que da origen
-- (p_id_cart) y el tipo de envío elegido por el usuario (p_id_delivery). Finalmente borra el carrito
-- una vez terminada con éxito la transacción. Si el stock de productos no es suficiente aborta el proceso.
DROP procedure IF EXISTS `generate_order_from_cart`;

DELIMITER $$
CREATE PROCEDURE generate_order_from_cart(IN p_id_cart INT, IN p_id_delivery INT)
BEGIN
    -- Declaro las variables locales
    DECLARE v_id_user INT;
    DECLARE v_id_order INT;
    DECLARE v_if_stock INT;
    
	-- Declaro los manejadores de errores y warnings
    -- Para que ante una ocurrencia de alguna de esas situaciones, dispare un ROLLBACK
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		-- ERROR y WARNING
		ROLLBACK;
        SELECT "Error durante la transacción" Result;
	END; 
  
    -- Obtengo el id_user del usuario propietario del carrito
	SET v_id_user = (SELECT id_user
					 FROM mammoth.cart 
					 WHERE id_cart = p_id_cart);
    
    -- Obtengo el valor min del stock que quedaría al efectuar la operación                 
	SET v_if_stock = (SELECT min(s.stock - CAST(c.quantity AS SIGNED))
					  FROM mammoth.cart_detail c JOIN mammoth.stock s
					  ON c.id_product = s.id_product
					  WHERE c.id_cart = p_id_cart);
                      
	-- Si el stock < 0, devuelvo un mensaje de error, puesto que algunos de 
    -- los productos seleccionados en el carrito, no cuenta con el stock suficiente 
    -- para llevar a cabo el proceso de compra.
    -- También verifico que el carrito exista (pertenezca a un usuario)
    IF (v_id_user IS NULL) THEN
		SELECT "Error: carrito inexistente" Result;
    ELSEIF (v_if_stock < 0) THEN
		SELECT "Error: alguno de los productos no cuenta con stock suficiente" Result;
	ELSE
		-- Inicio la transacción
		START TRANSACTION;
			-- creo una nueva orden con los valores que poseo y estado inicial generada y no pagada (0)
			INSERT INTO mammoth.order VALUES (NULL, v_id_user, p_id_delivery, "generada", 0, now());
			
			-- Obtengo el id de la orden recién creada
			SET v_id_order = (SELECT MAX(id_order)
							  FROM mammoth.order);
							  
			-- Inserto los registros correspondientes del detalle que contenía el carrito asociado a esa orden
			INSERT INTO mammoth.order_detail
				(SELECT v_id_order, c.id_product, c.quantity, p.price, p.discount
				 FROM mammoth.cart_detail c JOIN mammoth.product p
				 ON c.id_product = p.id_product
				 WHERE c.id_cart = p_id_cart);
			
            -- Actualizo los stocks de los productos que pertenecen a la orden recién generada
			UPDATE mammoth.stock AS s
			SET s.stock = s.stock - (SELECT quantity
									 FROM order_detail AS o
                                     WHERE  id_order = v_id_order AND o.id_product = s.id_product) 
			WHERE s.id_product IN (SELECT id_product
								   FROM order_detail
                                   WHERE id_order = v_id_order);
				 
			-- Elimino el carrito y por su restricción ON DELETE ON CASCADE también su detalle
			DELETE FROM cart WHERE id_cart = p_id_cart; 
			
		-- Si todo ocurrió sin problemas, hago el commit de los cambios
		COMMIT;
        SELECT concat("La orden ", v_id_order, ", se generó con éxito") Result;
	END IF;
END$$
DELIMITER ;

#CALL mammoth.generate_order_from_cart(5, 2);
