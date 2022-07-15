/*************************************************
			   CREACIÓN DE FUNCIONES
 *************************************************/
 
-- Function: get_subtotal
-- Objetivo: obtener el subtotal de un ítem determinado del detalle de un pedido, en base a su precio unitario, % de descuento y cantidad comprada
DROP FUNCTION IF EXISTS `get_subtotal`;
DELIMITER $$
CREATE FUNCTION `get_subtotal`(p_price DECIMAL(11,2), p_discount TINYINT, p_quantity SMALLINT)
RETURNS DECIMAL(11,2)
CONTAINS SQL
DETERMINISTIC
BEGIN
	DECLARE v_subtotal DECIMAL(11,2);
    SET v_subtotal = (p_price * (1 - p_discount/100)) * p_quantity;
	RETURN v_subtotal;
END$$
DELIMITER ;

#SELECT get_subtotal(1200, 20, 3);

-- Function: get_order_amount
-- Objetivo: obtener el importe total de un determinado pedido a partir de su detalle de compra
DROP FUNCTION IF EXISTS `get_order_amount`;
DELIMITER $$
CREATE FUNCTION `get_order_amount`(p_id_order INT)
RETURNS DECIMAL(11,2)
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE v_order_amount DECIMAL(11,2);
    
    SELECT SUM(GET_SUBTOTAL(unit_price, discount, quantity)) INTO v_order_amount
    FROM order_detail
    WHERE id_order=p_id_order;
    
	RETURN v_order_amount;
END$$
DELIMITER ;

#SELECT get_order_amount(3);

-- Function: invoice_type
-- Objetivo: obtener el tipo de factura a emitir en base al tipo de usuario de la orden asociada
DROP FUNCTION IF EXISTS `invoice_type`;
DELIMITER $$
CREATE FUNCTION `invoice_type`(p_id_order INT)
RETURNS ENUM("A","B")
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE v_id_iva_category INT;
	
    SELECT u.id_iva INTO v_id_iva_category
	FROM `order` o JOIN user u
    ON o.id_user=u.id_user
    WHERE o.id_order=p_id_order;
    
    IF v_id_iva_category IS NULL THEN
		RETURN NULL;
	END IF;
    
	IF v_id_iva_category IN (1, 4, 9, 11) THEN
		RETURN "A";
	ELSE
		RETURN "B";
	END IF;
END$$
DELIMITER ;

#SELECT invoice_type(3);

-- Function: next_invoice_n
-- Objetivo: obtener el string representativo del tipo y número de factura siguiente a emitir en base al tipo de factura que elegido
DROP FUNCTION IF EXISTS `next_invoice_n`;
DELIMITER $$
CREATE FUNCTION `next_invoice_n`(p_type ENUM("A","B"))
RETURNS CHAR(15)
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE v_invoice_n CHAR(15);
    DECLARE v_invoice_count INT;
    
    SELECT COUNT(id_invoice) INTO v_invoice_count
	FROM invoice
    WHERE type = p_type;

	SET v_invoice_n = LPAD(v_invoice_count + 1, 8, 0);
        
	IF p_type = "A" THEN
		RETURN CONCAT("A-0001-", v_invoice_n);
	ELSE
		RETURN CONCAT("B-0001-", v_invoice_n);
	END IF;
END$$
DELIMITER ;

#SELECT next_invoice_n("B");