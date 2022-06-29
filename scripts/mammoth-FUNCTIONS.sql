-- Function: get_subtotal
-- **********************
DROP function IF EXISTS `get_subtotal`;
DELIMITER $$
CREATE FUNCTION `get_subtotal`(p_price DECIMAL(11,2), p_discount TINYINT, p_quantity SMALLINT)
RETURNS decimal(11,2)
NO SQL
DETERMINISTIC
BEGIN
	DECLARE v_subtotal DECIMAL(11,2);
    SET v_subtotal = (p_price * (1 - p_discount/100)) * p_quantity;
	RETURN v_subtotal;
END$$
DELIMITER ;

-- Function: get_order_amount
-- **************************
DROP function IF EXISTS `get_order_amount`;
DELIMITER $$
CREATE FUNCTION `get_order_amount`(p_id_order INT)
RETURNS decimal(11,2)
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE v_order_amount DECIMAL(11,2);
    
    SELECT SUM(get_subtotal(unit_price, discount, quantity)) INTO v_order_amount
    FROM order_detail
    WHERE id_order=p_id_order;
    
	RETURN v_order_amount;
END$$
DELIMITER ;

-- Function: next_invoice_n
-- ************************
DROP function IF EXISTS `next_invoice_n`;
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

