/*************************************************
	               CREACIÓN DE BD
 *************************************************/
CREATE DATABASE IF NOT EXISTS mammoth;
USE mammoth;

/*************************************************
                  CREACIÓN DE TABLAS 
 *************************************************/
 
-- TABLES
-- ******

-- Table: user 
-- (Datos de los clientes)
CREATE TABLE user (
	id_user INT UNSIGNED NOT NULL AUTO_INCREMENT,
    dni CHAR(8) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    id_address INT UNSIGNED NOT NULL,
    postcode VARCHAR(20) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    id_iva INT UNSIGNED NOT NULL,
    cuit_cuil CHAR(13) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id_user),
    INDEX idx_dni (dni),
    INDEX idx_email (email)
);
  
-- Table: subscription
-- (Suscripciones de los usuarios a los distintos temas de interés)
CREATE TABLE subscription (
	id_user INT UNSIGNED NOT NULL,
    id_topic INT UNSIGNED NOT NULL,
    PRIMARY KEY(id_user, id_topic)
);

-- Table: topic
-- (Temas de suscripción)
CREATE TABLE topic (
	id_topic INT UNSIGNED NOT NULL AUTO_INCREMENT,
    topic VARCHAR(20) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_topic)
);

-- Table: favorite
-- (Productos favoritos de los usuarios)
CREATE TABLE favorite (
	id_user INT UNSIGNED NOT NULL,
    id_product INT UNSIGNED NOT NULL,
    PRIMARY KEY(id_user, id_product)
);

-- Table: iva_category
-- (Condición frente al iva)
CREATE TABLE iva_category (
	id_iva INT UNSIGNED NOT NULL AUTO_INCREMENT,
    iva_category VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_iva)
);

-- Table: address
-- (Direcciones de usuarios o proveedores)
CREATE TABLE address (
	id_address INT UNSIGNED NOT NULL AUTO_INCREMENT,
    address VARCHAR(60) NOT NULL,
    id_city INT UNSIGNED NOT NULL,
    last_update DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    PRIMARY KEY (id_address)
);

-- Table: city
-- (Listado de ciudades)
CREATE TABLE city (
	id_city INT UNSIGNED NOT NULL AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL,
    id_province INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_city)
);

-- Table: province
-- (Listado de provincias)
CREATE TABLE province (
	id_province INT UNSIGNED NOT NULL AUTO_INCREMENT,
    iso_code VARCHAR(6) NOT NULL,
    province VARCHAR(50) NOT NULL,
    id_country INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_province),
	CONSTRAINT UN_iso_code UNIQUE (iso_code)
);

-- Table: country
-- (Listado de paises)
CREATE TABLE country (
	id_country INT UNSIGNED NOT NULL AUTO_INCREMENT,
	iso_code CHAR(2) NOT NULL,
    country VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_country),
   	CONSTRAINT UN_iso_code UNIQUE (iso_code)
);

-- Table: cart
-- (Carritos de compra de los usuarios)
CREATE TABLE cart (
	id_cart INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_user INT UNSIGNED NOT NULL,
    last_update DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    PRIMARY KEY (id_cart)
);

-- Table: cart_detail
-- (Detalles del contenido de los carritos de compra por usuario)
CREATE TABLE cart_detail (
	id_cart INT UNSIGNED NOT NULL,
    id_product INT UNSIGNED NOT NULL,
    quantity SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_cart, id_product)
);

-- Table: product
-- (Detalles de los productos)
CREATE TABLE product (
	id_product INT UNSIGNED NOT NULL AUTO_INCREMENT,
    code VARCHAR(20),
    name VARCHAR(70) NOT NULL,
    description TEXT,
    id_brand INT UNSIGNED NOT NULL,
	id_country INT UNSIGNED NOT NULL,
    id_provider INT UNSIGNED NOT NULL,
    id_category INT UNSIGNED NOT NULL,
    thumbnail VARCHAR(1024),
    price DECIMAL(11,2) NOT NULL,
    discount TINYINT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    last_update DATETIME ON UPDATE NOW(),
    PRIMARY KEY (id_product),
    INDEX idx_name (name)
);

-- Table: category
-- (Listado de categorias de los productos)
CREATE TABLE category (
	id_category INT UNSIGNED NOT NULL AUTO_INCREMENT,
    category VARCHAR(20) NOT NULL,
    description VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_category)
);

-- Table: brand
-- (Listado de marcas)
CREATE TABLE brand (
	id_brand INT UNSIGNED NOT NULL AUTO_INCREMENT,
    brand VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_brand)
);

-- Table: provider
-- (Datos de los proveedores)
CREATE TABLE provider (
	id_provider INT UNSIGNED NOT NULL AUTO_INCREMENT,
    cuit CHAR(13) NOT NULL,
    name VARCHAR(50) NOT NULL,
    id_address INT UNSIGNED NOT NULL,
    postcode VARCHAR(20) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(50) NOT NULL,
    id_iva INT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id_provider),
    INDEX idx_name (name)
);

-- Table: stock
-- (Stock de los productos)
CREATE TABLE stock (
	id_product INT UNSIGNED NOT NULL,
    stock SMALLINT NOT NULL DEFAULT 0,
    last_update DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    PRIMARY KEY (id_product)
);

-- Table: order
-- (Ordenes de pedido de los usuarios)
CREATE TABLE `order` (
	id_order INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_user INT UNSIGNED NOT NULL,
    id_delivery INT UNSIGNED NOT NULL,
    status ENUM("generada","proceso","enviada","pausada","cancelada") NOT NULL, 
    paid BOOLEAN NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id_order)
);

-- Table: order_detail
-- (Detalles del contenido de los pedidos de compra por usuario)
CREATE TABLE order_detail (
	id_order INT UNSIGNED NOT NULL,
    id_product INT UNSIGNED NOT NULL,
    quantity SMALLINT NOT NULL,
    unit_price DECIMAL(11,2) NOT NULL,
	discount TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_order, id_product)
);

-- Table: delivery_type
-- (Opciones de tipos de retiro / entrega)
CREATE TABLE delivery_type (
	id_delivery INT UNSIGNED NOT NULL AUTO_INCREMENT,
    delivery_type VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_delivery)
);

-- Table: invoice
-- (Listado de las facturas de pedidos)
CREATE TABLE invoice (
	id_invoice INT UNSIGNED NOT NULL AUTO_INCREMENT,
    invoice_n CHAR(15) NOT NULL,
	type ENUM("A","B") NOT NULL, 
    id_order INT UNSIGNED NOT NULL,
    id_date INT UNSIGNED NOT NULL,
    amount DECIMAL(11,2) NOT NULL,
    id_p_method INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_invoice),
    CONSTRAINT UN_invoice_n UNIQUE (invoice_n),
    CONSTRAINT UN_id_order UNIQUE (id_order)
);

-- Table: payment_method
-- (Tipos de opciones de pago)
CREATE TABLE payment_method (
	id_p_method INT UNSIGNED NOT NULL AUTO_INCREMENT,
    payment_method VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_p_method)
);

-- Table: card_payment
-- (Listado de pagos con tarjeta)
CREATE TABLE card_payment (
	id_card_payment INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_invoice INT UNSIGNED NOT NULL,
    id_card_issuer INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_card_payment),
    CONSTRAINT UN_id_invoice UNIQUE (id_invoice)
);

-- Table: card_issuer
-- (Entidad emisora de la tarjeta)
CREATE TABLE card_issuer (
	id_card_issuer INT UNSIGNED NOT NULL AUTO_INCREMENT,
    card_issuer VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_card_issuer)
);

-- Table: date
-- (Tabla calendario)
CREATE TABLE date (
	id_date INT UNSIGNED NOT NULL AUTO_INCREMENT,
    date DATE NOT NULL,
	d_number TINYINT UNSIGNED NOT NULL,
    d_name VARCHAR(9) NOT NULL,
    m_number TINYINT UNSIGNED NOT NULL,
	m_name VARCHAR(10) NOT NULL,
    trimester TINYINT UNSIGNED NOT NULL,
    year YEAR NOT NULL,
    holiday BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (id_date),
    CONSTRAINT UN_date UNIQUE (date)
);


-- FOREIGN KEYS
-- ************

-- Reference: FK_user_address (table: user)
ALTER TABLE user ADD CONSTRAINT FK_user_address FOREIGN KEY (id_address)
    REFERENCES address (id_address);
    
-- Reference: FK_user_iva_category (table: user)
ALTER TABLE user ADD CONSTRAINT FK_user_iva_category FOREIGN KEY (id_iva)
    REFERENCES iva_category (id_iva);
    
-- Reference: FK_subscription_user (table: subscription)
ALTER TABLE subscription ADD CONSTRAINT FK_subscription_user FOREIGN KEY (id_user)
    REFERENCES user (id_user);
    
-- Reference: FK_subscription_topic (table: subscription)
ALTER TABLE subscription ADD CONSTRAINT FK_subscription_topic FOREIGN KEY (id_topic)
    REFERENCES topic (id_topic);
    
-- Reference: FK_favorite_user (table: favorite)
ALTER TABLE favorite ADD CONSTRAINT FK_favorite_user FOREIGN KEY (id_user)
    REFERENCES user (id_user);
    
-- Reference: FK_favorite_product (table: favorite)
ALTER TABLE favorite ADD CONSTRAINT FK_favorite_product FOREIGN KEY (id_product)
    REFERENCES product (id_product);

-- Reference: FK_address_city (table: address)
ALTER TABLE address ADD CONSTRAINT FK_address_city FOREIGN KEY (id_city)
    REFERENCES city (id_city);    
    
-- Reference: FK_city_province (table: city)
ALTER TABLE city ADD CONSTRAINT FK_city_province FOREIGN KEY (id_province)
    REFERENCES province (id_province);
    
-- Reference: FK_province_country (table: province)
ALTER TABLE province ADD CONSTRAINT FK_province_country FOREIGN KEY (id_country)
    REFERENCES country (id_country);

-- Reference: FK_cart_user (table: cart)
ALTER TABLE cart ADD CONSTRAINT FK_cart_user FOREIGN KEY (id_user)
    REFERENCES user (id_user);    

-- Reference: FK_cart_detail_cart (table: cart_detail)
ALTER TABLE cart_detail ADD CONSTRAINT FK_cart_detail_cart FOREIGN KEY (id_cart)
    REFERENCES cart (id_cart) ON DELETE CASCADE;      

-- Reference: FK_cart_detail_product (table: cart_detail)
ALTER TABLE cart_detail ADD CONSTRAINT FK_cart_detail_product FOREIGN KEY (id_product)
    REFERENCES product (id_product);      

-- Reference: FK_product_brand (table: product)
ALTER TABLE product ADD CONSTRAINT FK_product_brand FOREIGN KEY (id_brand)
    REFERENCES brand (id_brand);     

-- Reference: FK_product_country (table: product)
ALTER TABLE product ADD CONSTRAINT FK_product_country FOREIGN KEY (id_country)
    REFERENCES country (id_country);  
    
-- Reference: FK_product_provider (table: product)
ALTER TABLE product ADD CONSTRAINT FK_product_provider FOREIGN KEY (id_provider)
    REFERENCES provider (id_provider);  
    
-- Reference: FK_product_category (table: product)
ALTER TABLE product ADD CONSTRAINT FK_product_category FOREIGN KEY (id_category)
    REFERENCES category (id_category);    

-- Reference: FK_provider_address (table: provider)
ALTER TABLE provider ADD CONSTRAINT FK_provider_address FOREIGN KEY (id_address)
    REFERENCES address (id_address); 
    
-- Reference: FK_provider_iva (table: provider)
ALTER TABLE provider ADD CONSTRAINT FK_provider_iva FOREIGN KEY (id_iva)
    REFERENCES iva_category (id_iva);
    
-- Reference: FK_stock_product (table: stock)
ALTER TABLE stock ADD CONSTRAINT FK_stock_product FOREIGN KEY (id_product)
    REFERENCES product (id_product);
    
-- Reference: FK_order_user (table: order)
ALTER TABLE `order` ADD CONSTRAINT FK_order_user FOREIGN KEY (id_user)
    REFERENCES user (id_user); 
    
-- Reference: FK_order_delivery (table: order)
ALTER TABLE `order` ADD CONSTRAINT FK_order_delivery FOREIGN KEY (id_delivery)
    REFERENCES delivery_type (id_delivery); 
    
-- Reference: FK_order_detail_order (table: order_detail)
ALTER TABLE order_detail ADD CONSTRAINT FK_order_detail_order FOREIGN KEY (id_order)
    REFERENCES `order` (id_order); 
    
-- Reference: FK_order_detail_product (table: order_detail)
ALTER TABLE order_detail ADD CONSTRAINT FK_order_detail_product FOREIGN KEY (id_product)
    REFERENCES product (id_product); 

-- Reference: FK_invoice_order (table: invoice)
ALTER TABLE invoice ADD CONSTRAINT FK_invoice_order FOREIGN KEY (id_order)
    REFERENCES `order` (id_order);     

-- Reference: FK_invoice_date (table: invoice)
ALTER TABLE invoice ADD CONSTRAINT FK_invoice_date FOREIGN KEY (id_date)
    REFERENCES date (id_date);     

-- Reference: FK_invoice_payment_method (table: invoice)
ALTER TABLE invoice ADD CONSTRAINT FK_invoice_payment_method FOREIGN KEY (id_p_method)
    REFERENCES payment_method (id_p_method); 
    
-- Reference: FK_card_payment_invoice (table: card_payment)
ALTER TABLE card_payment ADD CONSTRAINT FK_card_payment_invoice FOREIGN KEY (id_invoice)
    REFERENCES invoice (id_invoice); 
    
-- Reference: FK_card_payment_card_issuer (table: card_payment)
ALTER TABLE card_payment ADD CONSTRAINT FK_card_payment_card_issuer FOREIGN KEY (id_card_issuer)
    REFERENCES card_issuer (id_card_issuer);


/*************************************************
				 POBLACIÓN DE TABLAS 
 *************************************************/
 
 -- Table: iva_category
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (1,'IVA Responsable Inscripto');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (2,'IVA Sujeto Exento');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (3,'Consumidor Final');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (4,'Responsable Monotributo');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (5,'Sujeto No Categorizado');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (6,'Proveedor del Exterior');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (7,'Cliente del Exterior');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (8,'IVA Liberado - Ley Nº 19.640');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (9,'Monotributista Social');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (10,'IVA No Alcanzado');
INSERT INTO iva_category (`id_iva`,`iva_category`) VALUES (11,'Monotributista Trabajador Independiente Promovido');

-- Table: country
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (1,'AD','Andorra');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (2,'AE','Emiratos Árabes Unidos');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (3,'AF','Afganistán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (4,'AG','Antigua y Barbuda');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (5,'AI','Anguila');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (6,'AL','Albania');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (7,'AM','Armenia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (8,'AN','Antillas Neerlandesas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (9,'AO','Angola');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (10,'AQ','Antártida');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (11,'AR','Argentina');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (12,'AS','Samoa Americana');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (13,'AT','Austria');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (14,'AU','Australia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (15,'AW','Aruba');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (16,'AX','Islas Áland');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (17,'AZ','Azerbaiyán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (18,'BA','Bosnia y Herzegovina');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (19,'BB','Barbados');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (20,'BD','Bangladesh');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (21,'BE','Bélgica');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (22,'BF','Burkina Faso');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (23,'BG','Bulgaria');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (24,'BH','Bahréin');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (25,'BI','Burundi');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (26,'BJ','Benin');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (27,'BL','San Bartolomé');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (28,'BM','Bermudas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (29,'BN','Brunéi');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (30,'BO','Bolivia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (31,'BR','Brasil');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (32,'BS','Bahamas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (33,'BT','Bhután');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (34,'BV','Isla Bouvet');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (35,'BW','Botsuana');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (36,'BY','Belarús');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (37,'BZ','Belice');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (38,'CA','Canadá');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (39,'CC','Islas Cocos');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (40,'CF','República Centro-Africana');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (41,'CG','Congo');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (42,'CH','Suiza');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (43,'CI','Costa de Marfil');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (44,'CK','Islas Cook');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (45,'CL','Chile');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (46,'CM','Camerún');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (47,'CN','China');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (48,'CO','Colombia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (49,'CR','Costa Rica');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (50,'CU','Cuba');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (51,'CV','Cabo Verde');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (52,'CX','Islas Christmas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (53,'CY','Chipre');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (54,'CZ','República Checa');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (55,'DE','Alemania');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (56,'DJ','Yibuti');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (57,'DK','Dinamarca');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (58,'DM','Domínica');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (59,'DO','República Dominicana');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (60,'DZ','Argel');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (61,'EC','Ecuador');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (62,'EE','Estonia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (63,'EG','Egipto');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (64,'EH','Sahara Occidental');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (65,'ER','Eritrea');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (66,'ES','España');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (67,'ET','Etiopía');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (68,'FI','Finlandia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (69,'FJ','Fiji');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (70,'FK','Islas Malvinas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (71,'FM','Micronesia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (72,'FO','Islas Faroe');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (73,'FR','Francia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (74,'GA','Gabón');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (75,'GB','Reino Unido');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (76,'GD','Granada');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (77,'GE','Georgia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (78,'GF','Guayana Francesa');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (79,'GG','Guernsey');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (80,'GH','Ghana');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (81,'GI','Gibraltar');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (82,'GL','Groenlandia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (83,'GM','Gambia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (84,'GN','Guinea');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (85,'GP','Guadalupe');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (86,'GQ','Guinea Ecuatorial');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (87,'GR','Grecia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (88,'GS','Georgia del Sur e Islas Sandwich del Sur');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (89,'GT','Guatemala');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (90,'GU','Guam');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (91,'GW','Guinea-Bissau');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (92,'GY','Guayana');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (93,'HK','Hong Kong');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (94,'HM','Islas Heard y McDonald');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (95,'HN','Honduras');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (96,'HR','Croacia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (97,'HT','Haití');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (98,'HU','Hungría');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (99,'ID','Indonesia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (100,'IE','Irlanda');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (101,'IL','Israel');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (102,'IM','Isla de Man');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (103,'IN','India');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (104,'IO','Territorio Británico del Océano Índico');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (105,'IQ','Irak');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (106,'IR','Irán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (107,'IS','Islandia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (108,'IT','Italia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (109,'JE','Jersey');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (110,'JM','Jamaica');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (111,'JO','Jordania');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (112,'JP','Japón');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (113,'KE','Kenia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (114,'KG','Kirguistán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (115,'KH','Camboya');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (116,'KI','Kiribati');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (117,'KM','Comoros');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (118,'KN','San Cristóbal y Nieves');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (119,'KP','Corea del Norte');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (120,'KR','Corea del Sur');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (121,'KW','Kuwait');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (122,'KY','Islas Caimán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (123,'KZ','Kazajstán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (124,'LA','Laos');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (125,'LB','Líbano');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (126,'LC','Santa Lucía');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (127,'LI','Liechtenstein');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (128,'LK','Sri Lanka');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (129,'LR','Liberia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (130,'LS','Lesotho');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (131,'LT','Lituania');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (132,'LU','Luxemburgo');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (133,'LV','Letonia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (134,'LY','Libia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (135,'MA','Marruecos');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (136,'MC','Mónaco');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (137,'MD','Moldova');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (138,'ME','Montenegro');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (139,'MG','Madagascar');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (140,'MH','Islas Marshall');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (141,'MK','Macedonia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (142,'ML','Mali');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (143,'MM','Myanmar');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (144,'MN','Mongolia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (145,'MO','Macao');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (146,'MQ','Martinica');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (147,'MR','Mauritania');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (148,'MS','Montserrat');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (149,'MT','Malta');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (150,'MU','Mauricio');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (151,'MV','Maldivas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (152,'MW','Malawi');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (153,'MX','México');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (154,'MY','Malasia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (155,'MZ','Mozambique');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (156,'NA','Namibia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (157,'NC','Nueva Caledonia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (158,'NE','Níger');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (159,'NF','Islas Norkfolk');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (160,'NG','Nigeria');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (161,'NI','Nicaragua');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (162,'NL','Países Bajos');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (163,'NO','Noruega');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (164,'NP','Nepal');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (165,'NR','Nauru');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (166,'NU','Niue');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (167,'NZ','Nueva Zelanda');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (168,'OM','Omán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (169,'PA','Panamá');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (170,'PE','Perú');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (171,'PF','Polinesia Francesa');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (172,'PG','Papúa Nueva Guinea');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (173,'PH','Filipinas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (174,'PK','Pakistán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (175,'PL','Polonia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (176,'PM','San Pedro y Miquelón');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (177,'PN','Islas Pitcairn');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (178,'PR','Puerto Rico');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (179,'PS','Palestina');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (180,'PT','Portugal');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (181,'PW','Islas Palaos');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (182,'PY','Paraguay');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (183,'QA','Qatar');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (184,'RE','Reunión');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (185,'RO','Rumanía');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (186,'RS','Serbia y Montenegro');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (187,'RU','Rusia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (188,'RW','Ruanda');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (189,'SA','Arabia Saudita');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (190,'SB','Islas Solomón');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (191,'SC','Seychelles');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (192,'SD','Sudán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (193,'SE','Suecia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (194,'SG','Singapur');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (195,'SH','Santa Elena');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (196,'SI','Eslovenia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (197,'SJ','Islas Svalbard y Jan Mayen');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (198,'SK','Eslovaquia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (199,'SL','Sierra Leona');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (200,'SM','San Marino');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (201,'SN','Senegal');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (202,'SO','Somalia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (203,'SR','Surinam');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (204,'ST','Santo Tomé y Príncipe');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (205,'SV','El Salvador');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (206,'SY','Siria');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (207,'SZ','Suazilandia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (208,'TC','Islas Turcas y Caicos');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (209,'TD','Chad');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (210,'TF','Territorios Australes Franceses');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (211,'TG','Togo');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (212,'TH','Tailandia');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (214,'TJ','Tayikistán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (215,'TK','Tokelau');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (216,'TL','Timor-Leste');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (217,'TM','Turkmenistán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (218,'TN','Túnez');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (219,'TO','Tonga');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (220,'TR','Turquía');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (221,'TT','Trinidad y Tobago');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (222,'TV','Tuvalu');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (223,'TW','Taiwán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (224,'UA','Ucrania');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (225,'UG','Uganda');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (226,'US','Estados Unidos de América');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (227,'UY','Uruguay');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (228,'UZ','Uzbekistán');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (229,'VA','Ciudad del Vaticano');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (230,'VC','San Vicente y las Granadinas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (231,'VE','Venezuela');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (232,'VG','Islas Vírgenes Británicas');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (233,'VI','Islas Vírgenes de los Estados Unidos de América');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (234,'VN','Vietnam');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (235,'VU','Vanuatu');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (236,'WF','Wallis y Futuna');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (237,'WS','Samoa');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (238,'YE','Yemen');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (239,'YT','Mayotte');
INSERT INTO country (`id_country`,`iso_code`,`country`) VALUES (240,'ZA','Sudáfrica');

-- Table: province
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (1,'AR-N','Misiones',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (2,'AR-D','San Luis',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (3,'AR-J','San Juan',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (4,'AR-E','Entre Ríos',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (5,'AR-Z','Santa Cruz',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (6,'AR-R','Río Negro',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (7,'AR-U','Chubut',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (8,'AR-X','Córdoba',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (9,'AR-M','Mendoza',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (10,'AR-F','La Rioja',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (11,'AR-K','Catamarca',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (12,'AR-L','La Pampa',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (13,'AR-G','Santiago del Estero',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (14,'AR-W','Corrientes',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (15,'AR-S','Santa Fe',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (16,'AR-T','Tucumán',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (17,'AR-Q','Neuquén',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (18,'AR-A','Salta',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (19,'AR-H','Chaco',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (20,'AR-P','Formosa',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (21,'AR-Y','Jujuy',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (22,'AR-C','Ciudad Autónoma de Buenos Aires',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (23,'AR-B','Buenos Aires',11);
INSERT INTO province (`id_province`,`iso_code`,`province`,`id_country`) VALUES (24,'AR-V','Tierra del Fuego',11);

-- Table: city
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (1,'1° de Mayo',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (2,'12 de Octubre',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (3,'2 de Abril',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (4,'25 de Mayo',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (5,'25 de Mayo',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (6,'25 de Mayo',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (7,'25 de Mayo',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (8,'25 de Mayo',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (9,'9 de Julio',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (10,'9 de julio',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (11,'9 de Julio',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (12,'9 de Julio',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (13,'9 de Julio',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (14,'Adolfo Alsina',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (15,'Adolfo Alsina',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (16,'Adolfo Gonzales Chaves',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (17,'Aguirre',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (18,'Albardón',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (19,'Alberdi',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (20,'Alberti',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (21,'Almirante Brown',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (22,'Almirante Brown',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (23,'Aluminé',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (24,'Ambato',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (25,'Ancasti',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (26,'Andalgalá',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (27,'Angaco',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (28,'Anta',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (29,'Antártida Argentina',24);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (30,'Antofagasta de la Sierra',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (31,'Añelo',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (32,'Apóstoles',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (33,'Arauco',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (34,'Arrecifes',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (35,'Atamisqui',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (36,'Atreucó',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (37,'Avellaneda',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (38,'Avellaneda',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (39,'Avellaneda',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (40,'Ayacucho',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (41,'Ayacucho',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (42,'Azul',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (43,'Bahía Blanca',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (44,'Balcarce',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (45,'Banda',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (46,'Baradero',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (47,'Bariloche',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (48,'Belén',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (49,'Belgrano',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (50,'Belgrano',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (51,'Belgrano',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (52,'Bella Vista',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (53,'Benito Juárez',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (54,'Berazategui',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (55,'Berisso',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (56,'Bermejo',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (57,'Bermejo',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (58,'Berón de Astrada',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (59,'Biedma',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (60,'Bolívar',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (61,'Bragado',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (62,'Brandsen',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (63,'Burruyacú',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (64,'Cachi',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (65,'Cafayate',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (66,'Cainguás',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (67,'Calamuchita',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (68,'Caleu Caleu',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (69,'Calingasta',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (70,'Campana',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (71,'Candelaria',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (72,'Cañuelas',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (73,'Capayán',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (74,'Capital',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (75,'Capital',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (76,'Capital',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (77,'Capital',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (78,'Capital',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (79,'Capital',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (80,'Capital',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (81,'Capital',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (82,'Capital',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (83,'Capital',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (84,'Capital',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (85,'Capitán Sarmiento',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (86,'Carlos Casares',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (87,'Carlos Tejedor',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (88,'Carmen de Areco',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (89,'Caseros',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (90,'Castellanos',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (91,'Castelli',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (92,'Castro Barros',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (93,'Catán Lil',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (94,'Catriló',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (95,'Caucete',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (96,'Cerrillos',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (97,'Chacabuco',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (98,'Chacabuco',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (99,'Chacabuco',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (100,'Chalileo',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (101,'Chamical',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (102,'Chapaleufú',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (103,'Chascomús',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (104,'Chical Co',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (105,'Chicligasta',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (106,'Chicoana',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (107,'Chilecito',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (108,'Chimbas',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (109,'Chivilcoy',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (110,'Chos Malal',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (111,'Choya',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (112,'Ciudad Autónoma de Buenos Aires',22);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (113,'Ciudad Libertador San Martín',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (114,'Cochinoca',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (115,'Collón Curá',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (116,'Colón',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (117,'Colón',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (118,'Colón',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (119,'Comandante Fernández',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (120,'Concepción',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (121,'Concepción',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (122,'Concordia',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (123,'Conesa',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (124,'Confluencia',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (125,'Conhelo',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (126,'Copo',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (127,'Coronel de Marina Leonardo Rosales',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (128,'Coronel Dorrego',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (129,'Coronel Felipe Varela',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (130,'Coronel Pringles',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (131,'Coronel Pringles',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (132,'Coronel Suárez',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (133,'Corpen Aike',5);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (134,'Cruz Alta',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (135,'Cruz del Eje',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (136,'Curacó',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (137,'Curuzu Cuatia',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (138,'Cushamen',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (139,'Daireaux',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (140,'Deseado',5);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (141,'Diamante',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (142,'Dolores',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (143,'Dr. Manuel Belgrano',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (144,'El Alto',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (145,'El Carmen',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (146,'El Cuy',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (147,'Eldorado',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (148,'Empedrado',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (149,'Ensenada',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (150,'Escalante',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (151,'Escobar',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (152,'Esquina',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (153,'Esteban Echeverría',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (154,'Exaltación de la Cruz',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (155,'Famaillá',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (156,'Famatina',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (157,'Federación',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (158,'Federal',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (159,'Feliciano',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (160,'Figueroa',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (161,'Florencio Varela',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (162,'Florentino Ameghino',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (163,'Florentino Ameghino',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (164,'Formosa',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (165,'Fray Justo Santa María de Oro',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (166,'Fray Mamerto Esquiú',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (167,'Futaleufú',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (168,'Gaiman',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (169,'Garay',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (170,'Gastre',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (171,'General Alvarado',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (172,'General Alvear',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (173,'General Alvear',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (174,'General Alvear',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (175,'General Ángel V. Peñaloza',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (176,'General Arenales',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (177,'General Belgrano',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (178,'General Belgrano',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (179,'General Belgrano',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (180,'General Donovan',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (181,'General Güemes',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (182,'General Güemes',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (183,'General Guido',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (184,'General José de San Martín',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (185,'General Juan F. Quiroga',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (186,'General Juan Madariaga',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (187,'General La Madrid',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (188,'General Lamadrid',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (189,'General Las Heras',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (190,'General Lavalle',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (191,'General López',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (192,'General Manuel Belgrano',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (193,'General Obligado',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (194,'General Ocampo',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (195,'General Paz',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (196,'General Paz',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (197,'General Pedernera',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (198,'General Pinto',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (199,'General Pueyrredón',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (200,'General Roca',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (201,'General Roca',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (202,'General Rodríguez',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (203,'General San Martín',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (204,'General San Martín',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (205,'General Taboada',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (206,'General Viamonte',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (207,'General Villegas',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (208,'Gobernador Dupuy',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (209,'Godoy Cruz',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (210,'Goya',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (211,'Graneros',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (212,'Guachipas',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (213,'Gualeguay',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (214,'Gualeguaychú',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (215,'Guaminí',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (216,'Guaraní',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (217,'Guasayán',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (218,'Guatraché',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (219,'Guaymallén',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (220,'Güer Aike',5);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (221,'Hipólito Yrigoyen',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (222,'Hucal',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (223,'Huiliches',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (224,'Humahuaca',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (225,'Hurlingham',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (226,'Iglesia',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (227,'Iguazú',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (228,'Independencia',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (229,'Independencia',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (230,'Iriondo',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (231,'Iruya',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (232,'Ischilín',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (233,'Islas del Atlántico Sur',24);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (234,'Islas del Ibicuy',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (235,'Itatí',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (236,'Ituzaingó',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (237,'Ituzaingó',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (238,'Jáchal',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (239,'Jiménez',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (240,'José C. Paz',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (241,'José M. Ezeiza',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (242,'Juan Bautista Alberdi',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (243,'Juan F. Ibarra',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (244,'Juan Martín de Pueyrredón',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (245,'Juárez Celman',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (246,'Junín',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (247,'Junín',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (248,'Junín',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (249,'La Caldera',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (250,'La Candelaria',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (251,'La Capital',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (252,'La Cocha',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (253,'La Costa',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (254,'La Matanza',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (255,'La Paz',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (256,'La Paz',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (257,'La Paz',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (258,'La Plata',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (259,'La Poma',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (260,'La Viña',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (261,'Lácar',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (262,'Lago Argentino',5);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (263,'Lago Buenos Aires',5);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (264,'Laishí',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (265,'Languiñeo',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (266,'Lanús',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (267,'Laprida',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (268,'Las Colonias',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (269,'Las Flores',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (270,'Las Heras',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (271,'Lavalle',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (272,'Lavalle',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (273,'Leales',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (274,'Leandro N. Alem',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (275,'Leandro N. Alem',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (276,'Ledesma',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (277,'Lezama',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (278,'Libertad',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (279,'Libertador General San Martín',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (280,'Libertador General San Martín',2);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (281,'Libertador General San Martín',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (282,'Lihuel Calel',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (283,'Limay Mahuida',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (284,'Lincoln',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (285,'Lobería',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (286,'Lobos',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (287,'Lomas de Zamora',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (288,'Loncopué',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (289,'Loreto',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (290,'Los Andes',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (291,'Los Lagos',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (292,'Loventué',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (293,'Luján',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (294,'Luján de Cuyo',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (295,'Lules',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (296,'Magallanes',5);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (297,'Magdalena',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (298,'Maipú',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (299,'Maipú',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (300,'Maipú',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (301,'Malargüe',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (302,'Malvinas Argentinas',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (303,'Mar Chiquita',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (304,'Maracó',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (305,'Marcos Juárez',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (306,'Marcos Paz',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (307,'Mártires',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (308,'Matacos',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (309,'Mayor Luis J. Fontana',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (310,'Mburucuyá',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (311,'Mercedes',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (312,'Mercedes',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (313,'Merlo',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (314,'Metán',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (315,'Minas',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (316,'Minas',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (317,'Mitre',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (318,'Molinos',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (319,'Monte',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (320,'Monte Caseros',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (321,'Monte Hermoso',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (322,'Montecarlo',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (323,'Monteros',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (324,'Moreno',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (325,'Moreno',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (326,'Morón',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (327,'Navarro',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (328,'Necochea',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (329,'Nogoyá',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (330,'Ñorquín',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (331,'Ñorquinco',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (332,'Oberá',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (333,'O\'Higgins',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (334,'Ojo de Agua',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (335,'Olavarría',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (336,'Orán',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (337,'Paclín',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (338,'Palpalá',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (339,'Paraná',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (340,'Paso de Indios',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (341,'Paso de los Libres',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (342,'Patagones',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (343,'Patiño',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (344,'Pehuajó',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (345,'Pehuenches',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (346,'Pellegrini',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (347,'Pellegrini',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (348,'Pergamino',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (349,'Pichi Mahuida',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (350,'Picún Leufú',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (351,'Picunches',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (352,'Pila',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (353,'Pilagás',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (354,'Pilar',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (355,'Pilcaniyeu',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (356,'Pilcomayo',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (357,'Pinamar',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (358,'Pirané',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (359,'Pocho',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (360,'Pocito',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (361,'Pomán',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (362,'Presidencia de la Plaza',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (363,'Presidente Perón',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (364,'Presidente Roque Sáenz Peña',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (365,'Puán',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (366,'Puelén',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (367,'Punilla',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (368,'Punta Indio',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (369,'Quebrachos',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (370,'Quemú Quemú',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (371,'Quilmes',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (372,'Quitilipi',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (373,'Ramallo',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (374,'Ramón Lista',20);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (375,'Rancul',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (376,'Rauch',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (377,'Rawson',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (378,'Rawson',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (379,'Realicó',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (380,'Rinconada',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (381,'Río Chico',5);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (382,'Río Chico',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (383,'Río Cuarto',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (384,'Río Grande',24);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (385,'Río Hondo',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (386,'Río Primero',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (387,'Río Seco',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (388,'Río Segundo',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (389,'Río Senguer',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (390,'Rivadavia',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (391,'Rivadavia',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (392,'Rivadavia',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (393,'Rivadavia',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (394,'Rivadavia',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (395,'Robles',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (396,'Rojas',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (397,'Roque Pérez',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (398,'Rosario',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (399,'Rosario de la Frontera',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (400,'Rosario de Lerma',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (401,'Rosario Vera Peñaloza',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (402,'Saavedra',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (403,'Saladas',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (404,'Saladillo',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (405,'Salavina',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (406,'Salliqueló',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (407,'Salto',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (408,'San Alberto',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (409,'San Andrés de Giles',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (410,'San Antonio',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (411,'San Antonio',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (412,'San Antonio de Areco',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (413,'San Blas de Los Sauces',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (414,'San Carlos',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (415,'San Carlos',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (416,'San Cayetano',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (417,'San Cosme',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (418,'San Cristóbal',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (419,'San Fernando',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (420,'San Fernando',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (421,'San Ignacio',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (422,'San Isidro',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (423,'San Javier',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (424,'San Javier',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (425,'San Javier',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (426,'San Jerónimo',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (427,'San Justo',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (428,'San Justo',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (429,'San Lorenzo',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (430,'San Lorenzo',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (431,'San Luis del Palmar',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (432,'San Martín',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (433,'San Martín',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (434,'San Martín',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (435,'San Martín',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (436,'San Martín',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (437,'San Miguel',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (438,'San Miguel',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (439,'San Nicolás',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (440,'San Pedro',1);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (441,'San Pedro',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (442,'San Pedro',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (443,'San Rafael',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (444,'San Roque',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (445,'San Salvador',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (446,'San Vicente',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (447,'Sanagasta',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (448,'Santa Bárbara',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (449,'Santa Catalina',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (450,'Santa Lucía',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (451,'Santa María',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (452,'Santa María',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (453,'Santa Rosa',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (454,'Santa Rosa',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (455,'Santa Victoria',18);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (456,'Santo Tomé',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (457,'Sargento Cabral',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (458,'Sarmiento',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (459,'Sarmiento',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (460,'Sarmiento',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (461,'Sauce',14);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (462,'Silípica',13);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (463,'Simoca',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (464,'Sobremonte',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (465,'Suipacha',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (466,'Susques',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (467,'Tafí del Valle',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (468,'Tafí Viejo',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (469,'Tala',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (470,'Tandil',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (471,'Tapalqué',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (472,'Tapenagá',19);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (473,'Tehuelches',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (474,'Telsen',7);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (475,'Tercero Arriba',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (476,'Tigre',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (477,'Tilcara',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (478,'Tinogasta',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (479,'Toay',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (480,'Tolhuin',24);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (481,'Tordillo',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (482,'Tornquist',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (483,'Totoral',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (484,'Trancas',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (485,'Trenel',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (486,'Trenque Lauquen',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (487,'Tres Arroyos',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (488,'Tres de Febrero',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (489,'Tres Lomas',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (490,'Tulumba',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (491,'Tumbaya',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (492,'Tunuyán',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (493,'Tupungato',9);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (494,'Ullum',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (495,'Unión',8);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (496,'Uruguay',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (497,'Ushuaia',24);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (498,'Utracán',12);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (499,'Valcheta',6);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (500,'Valle Fértil',3);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (501,'Valle Grande',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (502,'Valle Viejo',11);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (503,'Vera',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (504,'Vicente López',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (505,'Victoria',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (506,'Villa Constitución',15);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (507,'Villa Gesell',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (508,'Villaguay',4);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (509,'Villarino',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (510,'Vinchina',10);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (511,'Yaví',21);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (512,'Yerba Buena',16);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (513,'Zapala',17);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (514,'Zárate',23);
INSERT INTO city (`id_city`,`city`,`id_province`) VALUES (515,'Zonda',3);

-- Table: address
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (1,'67 Miller Terrace',2,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (2,'2947 Kennedy Court',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (3,'26342 Lighthouse Bay Drive',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (4,'62216 Lotheville Hill',10,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (5,'54803 Roth Court',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (6,'451 Marquette Point',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (7,'49112 Marquette Avenue',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (8,'23 Butterfield Center',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (9,'602 Fordem Terrace',12,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (10,'8542 Sugar Hill',10,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (11,'7669 Bay Crossing',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (12,'1810 Roxbury Way',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (13,'269 South Plaza',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (14,'9208 Steensland Circle',19,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (15,'90412 Bultman Lane',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (16,'654 Eagan Drive',7,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (17,'2397 Bunker Hill Way',10,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (18,'132 Anderson Trail',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (19,'8065 Clove Junction',14,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (20,'35 7th Road',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (21,'08360 Di Loreto Point',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (22,'3 Hallows Point',22,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (23,'05 Ridgeway Junction',12,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (24,'8 Summer Ridge Pass',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (25,'883 Kenwood Point',19,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (26,'23960 Eagle Crest Point',22,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (27,'22639 Melby Plaza',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (28,'4632 Bobwhite Plaza',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (29,'6897 Grover Street',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (30,'81915 Trailsway Alley',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (31,'0151 Calypso Crossing',14,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (32,'328 Grayhawk Park',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (33,'84254 Hansons Point',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (34,'2 Karstens Avenue',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (35,'05072 Sachtjen Park',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (36,'92 Hauk Junction',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (37,'2 Bunting Court',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (38,'8 Susan Plaza',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (39,'90908 Karstens Avenue',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (40,'7 Brickson Park Terrace',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (41,'7166 Donald Plaza',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (42,'0 Melrose Place',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (43,'91 Northridge Center',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (44,'9 Dovetail Lane',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (45,'978 2nd Lane',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (46,'318 Lukken Place',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (47,'95 Lakeland Way',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (48,'09 Grim Alley',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (49,'6 Dahle Junction',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (50,'25 Rowland Park',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (51,'2790 Chinook Terrace',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (52,'2964 Burrows Pass',14,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (53,'53 Boyd Drive',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (54,'275 Dexter Avenue',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (55,'848 Ruskin Terrace',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (56,'515 Susan Center',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (57,'2056 Westerfield Pass',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (58,'6 Dahle Circle',10,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (59,'16 Derek Road',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (60,'057 Derek Alley',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (61,'895 Carioca Street',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (62,'34129 Katie Park',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (63,'118 Messerschmidt Lane',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (64,'18 Dakota Terrace',7,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (65,'42 Mcbride Hill',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (66,'6292 Marquette Trail',12,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (67,'6 Algoma Crossing',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (68,'7203 Continental Place',2,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (69,'793 Stone Corner Drive',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (70,'2919 Havey Circle',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (71,'51086 Swallow Park',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (72,'1566 Darwin Parkway',19,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (73,'06 Logan Point',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (74,'4553 Forest Run Crossing',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (75,'85 Declaration Crossing',2,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (76,'69 Bultman Point',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (77,'2 Corben Point',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (78,'2 Talmadge Drive',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (79,'24 Charing Cross Way',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (80,'3430 Coolidge Road',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (81,'7 Russell Avenue',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (82,'278 1st Terrace',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (83,'5 Gerald Road',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (84,'97279 Banding Road',13,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (85,'2 Magdeline Park',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (86,'72 Lerdahl Junction',14,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (87,'20003 Florence Point',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (88,'71 Katie Road',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (89,'731 Center Park',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (90,'11 Susan Terrace',14,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (91,'6 Southridge Terrace',12,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (92,'9 Schiller Center',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (93,'919 Coleman Circle',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (94,'4621 Maywood Point',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (95,'475 Bartelt Park',2,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (96,'433 Gulseth Crossing',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (97,'3 Johnson Lane',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (98,'899 Pearson Junction',14,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (99,'6 Coolidge Circle',7,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (100,'81 Hudson Plaza',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (101,'7377 Kedzie Plaza',22,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (102,'545 Old Gate Park',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (103,'23152 Stephen Drive',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (104,'940 Utah Avenue',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (105,'583 Lakeland Parkway',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (106,'4919 Waubesa Center',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (107,'068 Crest Line Parkway',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (108,'0831 Fieldstone Terrace',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (109,'638 School Drive',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (110,'273 Oakridge Circle',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (111,'0 Bobwhite Alley',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (112,'9452 Steensland Court',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (113,'66446 8th Drive',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (114,'386 Lake View Drive',13,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (115,'350 Luster Place',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (116,'39213 Thackeray Avenue',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (117,'4 Carioca Park',2,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (118,'438 Ridgeview Way',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (119,'2947 Mcguire Street',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (120,'5 American Circle',19,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (121,'8 Park Meadow Way',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (122,'65 Merry Hill',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (123,'0463 Pennsylvania Place',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (124,'5349 Sauthoff Point',10,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (125,'7282 Morning Hill',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (126,'481 Utah Road',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (127,'959 Corscot Hill',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (128,'95 Maple Wood Parkway',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (129,'9880 Raven Point',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (130,'159 Warner Park',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (131,'2932 Forest Dale Circle',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (132,'339 Kensington Circle',12,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (133,'2 Hooker Court',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (134,'951 Farmco Plaza',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (135,'339 Esker Drive',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (136,'2 Bonner Lane',19,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (137,'4 Old Gate Parkway',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (138,'8658 Sutteridge Pass',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (139,'2339 Burrows Plaza',12,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (140,'53 Gateway Point',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (141,'6 Muir Avenue',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (142,'19 Monument Circle',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (143,'658 Commercial Junction',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (144,'0211 Pennsylvania Hill',2,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (145,'86 Nancy Road',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (146,'32451 Merchant Park',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (147,'8 Lake View Drive',22,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (148,'64 2nd Terrace',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (149,'1 Moulton Circle',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (150,'540 Weeping Birch Pass',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (151,'553 Haas Road',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (152,'1 Tennyson Park',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (153,'6740 Huxley Drive',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (154,'8285 Parkside Park',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (155,'3533 Bayside Place',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (156,'30344 Mockingbird Terrace',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (157,'06559 North Hill',10,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (158,'187 Kensington Trail',5,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (159,'31 7th Crossing',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (160,'1 Mallard Alley',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (161,'2 Schurz Lane',10,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (162,'8207 Boyd Parkway',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (163,'369 Leroy Road',2,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (164,'5 Dryden Place',20,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (165,'5 Dunning Way',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (166,'888 Scoville Center',19,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (167,'908 Mcbride Court',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (168,'7 Kingsford Avenue',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (169,'27698 Clemons Plaza',24,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (170,'9399 Erie Junction',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (171,'62 Dennis Center',18,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (172,'85 5th Center',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (173,'0522 Heath Center',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (174,'63934 Bluejay Parkway',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (175,'586 Prairie Rose Park',8,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (176,'5 Montana Place',1,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (177,'1832 Florence Court',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (178,'4124 Tomscot Lane',9,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (179,'19484 Clemons Circle',22,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (180,'2007 Little Fleur Center',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (181,'94 Ohio Terrace',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (182,'45493 Meadow Valley Way',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (183,'3 Talisman Point',11,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (184,'81418 Bay Drive',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (185,'8 2nd Crossing',24,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (186,'41 Burning Wood Place',6,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (187,'57 Ridgeview Road',22,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (188,'2 Farmco Pass',17,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (189,'85901 Northview Plaza',4,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (190,'0 Vermont Plaza',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (191,'700 Randy Hill',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (192,'7 Dunning Terrace',23,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (193,'81 Larry Place',3,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (194,'3158 Upham Point',13,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (195,'0627 Linden Road',16,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (196,'1 John Wall Lane',19,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (197,'5451 Division Way',24,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (198,'1433 Briar Crest Pass',21,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (199,'13 Kensington Avenue',15,'2022-06-18 00:00:00');
INSERT INTO address (`id_address`,`address`,`id_city`,`last_update`) VALUES (200,'3152 Crest Line Point',17,'2022-06-18 00:00:00');

-- Table: user
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (1,'22260584','Nissie','Roizin',29,'M-3582-BIB','+504-996-327-6440','nroizin0@topsy.com','JQkTexqZcnQb0HUEvOU9yW4Kg1HhylNI',3,'24-22260584-8','2021-08-19 19:55:57');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (2,'19638197','Leonhard','Haugh',61,'F-9876-BZA',NULL,'lhaugh1@livejournal.com','H4wqvW3LWO5nff9pqhHn6om08sY5J4YQ',3,'23-19638197-0','2021-11-06 19:21:21');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (3,'29905875','Sebastiano','MacGibbon',4,'F-1048-UUO','+86-438-437-9190','smacgibbon2@yale.edu','3XjIkO0T3O2tyWKQ2qoJ0KjAcT4aAC3u',2,'26-29905875-7','2021-06-26 19:37:53');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (4,'27896564','Trixi','Savin',135,'S-4869-KDE',NULL,'tsavin3@google.es','9b4k5MCEMy8OX3GjHZETDfP6kWw2CLOX',4,'20-27896564-7','2022-05-09 14:36:15');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (5,'19432402','Christen','Dietz',51,'R-0995-IDE','+86-228-424-1758','cdietz4@springer.com','7LuUZsScKgCDjd10xCGLUT6dqYHkJ1AY',1,'27-19432402-0','2021-10-11 19:50:41');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (6,'19178249','Shirlee','Coupe',76,'R-4775-TTY',NULL,'scoupe5@dyndns.org','LJgedd9Ks5QeB0xN3RCEKnsZdJhVAxUZ',2,'26-19178249-0','2021-12-24 22:28:51');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (7,'31842084','Susanne','Drioli',40,'L-5227-ZMK','+993-471-983-4374','sdrioli6@aboutads.info','4ZfiVjYtJ57zl3InATTT89GyFf4UnrxU',10,'20-31842084-9','2021-09-19 19:33:37');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (8,'44466380','Farrand','Poulsen',65,'X-6557-CAS','+1-710-661-3272','fpoulsen7@mapquest.com','umoeZPgPO8aGoOuSWkSIxqu884DPWCxp',8,'27-44466380-6','2021-11-16 23:49:34');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (9,'26144245','Nana','Albrighton',82,'U-1794-PWZ','+420-476-602-7159','nalbrighton8@wix.com','3SJnDuMP7vMUEat70pgONV3B15odZS9W',3,'24-26144245-6','2022-01-13 12:31:18');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (10,'22852320','Willie','Treher',32,'Z-4288-JNT','+86-686-110-0046','wtreher9@army.mil','Dwt59jKPXGyoFYAHv3mH4Lp9KC8d9z1c',10,'26-22852320-7','2021-08-28 11:37:21');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (11,'16663794','Cordey','Heisman',54,'V-1541-NFO','+220-604-306-2069','cheismana@symantec.com','LaVBlzvSlUvYZAFJz2iHUI0MU8ci77q1',3,'27-16663794-2','2021-10-14 23:28:12');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (12,'21874085','Almire','Pylkynyton',75,'Z-3822-XOP','+27-945-676-9484','apylkynytonb@who.int','EMGjXlhaAGr9EDdIahoM2qOuGTOqIpVV',10,'25-21874085-0','2021-12-24 16:37:55');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (13,'40377763','Keen','Truman',120,'I-3311-RBI','+55-250-828-6913','ktrumanc@bloomberg.com','nfRJZRPNV3xl4pfMGS4eAy6sJGpIahEt',9,'25-40377763-9','2022-03-28 08:41:52');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (14,'30699244','Leonard','Knock',41,'W-7512-QAU','+66-108-837-2117','lknockd@yale.edu','o6zV39VGeVjY7nNdtHhqC4Sgv9T7DoFe',3,'20-30699244-4','2021-09-20 03:30:22');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (15,'32379270','Wainwright','Disbrow',91,'Z-8015-RQP','+591-720-399-4181','wdisbrowe@time.com','CAWCTQvJUIVeeaAAj8glmA7JymByQ2y6',1,'25-32379270-0','2022-01-26 14:05:07');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (16,'10561594','Wandie','MacIver',85,'G-7776-YTB',NULL,'wmaciverf@whitehouse.gov','9cWjKBv0g2AGenZm5tgYSSG5JudDvslN',3,'23-10561594-4','2022-01-16 21:01:15');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (17,'25065246','Marillin','Mayman',74,'V-2623-XDE',NULL,'mmaymang@washingtonpost.com','GnXI7dm58FJFVLTpb3Qh0NEUU9Sai2Sa',11,'20-25065246-3','2021-12-20 03:09:04');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (18,'22723041','Teirtza','Darrigoe',48,'G-3049-JFO',NULL,'tdarrigoeh@themeforest.net','mPVPqV4abM2ToW8pWIE28GKybidF5Ciq',4,'26-22723041-4','2021-09-30 12:14:11');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (19,'34154111','Brandise','Gravestone',98,'I-0408-HMZ','+48-223-327-9862','bgravestonei@tamu.edu','MXiLgAvTNDOyFuJbMXv74sl2scUTnYmG',1,'23-34154111-4','2022-02-02 11:43:27');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (20,'13813960','Glynn','Mousdall',37,'E-8868-ESU','+1-419-626-1220','gmousdallj@mlb.com','rG2AP2kWv4pWqxh9M4kGNtzVsljwEizZ',10,'23-13813960-3','2021-09-07 01:42:08');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (21,'19005155','Gan','Vedntyev',94,'H-3095-XOX','+63-153-138-7367','gvedntyevk@vk.com','WQ5FY6doapmhVG2zjruP9iB2RpYCiBXt',10,'25-19005155-2','2022-01-30 04:56:35');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (22,'44424511','Allyn','Gwilt',104,'X-1790-LZA','+1-318-476-2838','agwiltl@yale.edu','sXuOZRzwfQaEh3BX1RH9RMi1CFGHYilL',9,'26-44424511-4','2022-02-21 13:11:11');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (23,'11656278','Noel','Brou',126,'K-8909-AUB','+98-111-575-4821','nbroum@hp.com','qE3Nykjwg0FwY9usFZ29omPnIAnR3k63',3,'23-11656278-0','2022-04-03 23:39:37');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (24,'34898006','Ericha','Braidwood',99,'T-4290-BSB',NULL,'ebraidwoodn@linkedin.com','2IKwXGksDz2iKwRdEaEpj2FXcuSVBEyR',11,'25-34898006-6','2022-02-06 22:51:05');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (25,'38796818','Olympia','Bulcock',46,'T-8864-XKK',NULL,'obulcocko@auda.org.au','TljUTmYFBv9WLxZm5eU13GA7dRPPqjTy',10,'25-38796818-1','2021-09-24 11:59:39');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (26,'38470792','Lizzie','Dobbson',66,'W-5621-BDG','+82-838-494-7304','ldobbsonp@youtube.com','4YZ3ld5eo95eHNeRTHng8ZepPNfBJDk9',3,'25-38470792-4','2021-11-19 11:26:55');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (27,'34898566','Joanne','Healings',2,'R-7655-SNV',NULL,'jhealingsq@apache.org','cdGKvhneWlzQsOibx73RrLMDwEFscNmS',8,'23-34898566-1','2021-06-18 20:20:30');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (28,'16638067','Darren','Gilluley',110,'F-4787-NNA',NULL,'dgilluleyr@geocities.com','20BVc2ZdIgc7bLRmsqtMOAV8VwRODdd0',10,'24-16638067-8','2022-03-03 17:36:25');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (29,'44884817','Ryan','Shmyr',59,'E-4446-BQM','+33-271-369-1954','rshmyrs@archive.org','Qdqo3jrDy1H1sX1FRWCI81J38Ij9g6mI',1,'25-44884817-3','2021-10-31 20:07:50');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (30,'27363487','Jo ann','Saines',96,'R-7708-RNZ',NULL,'jsainest@odnoklassniki.ru','LFYKcUWCZiAIoMq8GvJLDZhAv7CM4vEQ',3,'27-27363487-4','2022-01-31 21:49:50');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (31,'26467075','Sher','Enos',18,'U-8820-FPI','+86-628-153-5170','senosu@exblog.jp','59GHtKJBjPM4XCNE6fWPePxvk6wTDf4X',11,'23-26467075-8','2021-07-23 22:55:41');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (32,'18938832','Brunhilde','Rowbottom',147,'Z-0981-WIM','+7-914-296-2740','browbottomv@dyndns.org','mxak8UhEfizsIwS8CuAH0GByqF2MIajj',10,'27-18938832-3','2022-06-08 20:53:24');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (33,'34599522','Perri','Dutton',111,'M-0925-SFF','+269-267-155-6755','pduttonw@yandex.ru','Ke2sNJLbehayFedNt1BbvgSGFloS2yno',8,'26-34599522-4','2022-03-08 17:01:39');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (34,'38020532','Romola','Pallin',38,'K-0182-WNO','+591-892-102-1208','rpallinx@wordpress.com','xTufVYKjsbWeJr2gBqFSrdn2qejwc41W',11,'24-38020532-9','2021-09-09 07:23:51');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (35,'23163617','Kendra','Domenici',83,'S-7915-KSP','+381-727-837-4490','kdomeniciy@ucla.edu','AeEd2FgQg9CgqUcj67t8ZOBRBPaZdgb2',2,'24-23163617-2','2022-01-15 15:13:19');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (36,'24166727','Tamiko','Tulip',115,'N-5476-YMJ','+86-131-708-7072','ttulipz@earthlink.net','xpVGl2gtNQ21JLjrClU3F91zFri1wwdS',2,'20-24166727-5','2022-03-14 14:40:49');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (37,'40803954','Gabi','Rounsefell',77,'W-7778-QQQ','+382-160-570-2728','grounsefell10@spotify.com','MvWuGoNHclqrE41QBIw4a6mSxEQPKCMO',8,'27-40803954-5','2021-12-31 16:52:27');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (38,'43231772','Cicily','Heskey',42,'T-3202-BBY',NULL,'cheskey11@yale.edu','fZT8vZFMV4nyn9afvSfq4QfbApmR4IM7',11,'27-43231772-6','2021-09-20 23:44:10');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (39,'11045274','Elfrieda','Syplus',19,'J-2632-INC','+86-531-282-9457','esyplus12@businessweek.com','EBKlvZw2Jraz87v6Jf3dOSFxkBn7y2OY',11,'20-11045274-1','2021-07-28 22:20:53');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (40,'12646492','Shermy','Hannaway',22,'F-9841-MIN','+62-232-982-0510','shannaway13@vistaprint.com','cYv1c4Qx1EfDvLRTM40EFKMIM1Rd5UWu',11,'26-12646492-3','2021-08-09 18:01:54');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (41,'42297012','Jenelle','Tissier',69,'B-4993-IQE','+86-710-803-2950','jtissier14@oakley.com','pdKqO3rK5ibONkPnCObrECrTT6Vr50Ix',3,'24-42297012-8','2021-12-06 11:10:52');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (42,'33904316','Luz','Sholl',44,'Y-0613-PMT','+502-844-507-0431','lsholl15@shinystat.com','I19Kg6ul6FwIbPg4LEpJ7Wab0Lv47Uqn',10,'25-33904316-5','2021-09-22 02:16:29');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (43,'30806545','Cynthea','Denford',109,'K-4947-UVB','+63-727-252-1390','cdenford16@printfriendly.com','VMnke64Gu4rIKQKW8r05xZCtCkfN74wX',2,'26-30806545-7','2022-02-28 10:45:27');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (44,'31730752','Elaine','Gruczka',114,'A-9396-EQH','+30-958-814-8144','egruczka17@printfriendly.com','hL9iNkqcPWSbCLivvXDIAUrjdn0c6jE0',9,'26-31730752-9','2022-03-13 06:28:09');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (45,'36975002','Emilee','Brumbye',142,'Q-4102-WXH','+86-484-492-4647','ebrumbye18@dailymotion.com','PVE4CSW6AVbePacNzFjsd6MgdxcqzTz6',3,'25-36975002-7','2022-05-28 01:48:46');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (46,'34366682','Kass','Saladine',112,'S-3463-UZI',NULL,'ksaladine19@gov.uk','caMG1YnDObJSA0bdbU2rdlY4FfSAYAZM',3,'24-34366682-0','2022-03-11 03:18:47');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (47,'41804916','Darsie','Horley',12,'N-2602-KJC','+380-768-428-5079','dhorley1a@goo.ne.jp','xKUTJlQsA2NP2FOnP5pSubUMGGqdqbEM',9,'24-41804916-3','2021-07-11 18:51:19');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (48,'35817211','Bendicty','Damarell',21,'Y-8722-FQA',NULL,'bdamarell1b@state.tx.us','RbOXpHg5UHsLKCGxOpwM5M3oXc1X0aSX',3,'25-35817211-8','2021-08-04 20:39:19');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (49,'19314892','Elsy','Bichener',15,'C-6391-CSB',NULL,'ebichener1c@rediff.com','UMoE7iERFkeH2eprE0kfdYseQAXUg5Yq',3,'23-19314892-7','2021-07-17 07:20:10');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (50,'39315799','Kiele','Yarrall',3,'S-1414-OCH','+57-600-772-6811','kyarrall1d@list-manage.com','4BO7KZm8nRXUX0uwh3LyNTTs4f0HMsQ0',1,'27-39315799-5','2021-06-19 06:59:39');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (51,'38005633','Prince','Landy',150,'L-9683-QNV','+86-447-937-3323','plandy1e@example.com','mzUFiQgjYhIMh9qE7UBh5wM6hoAeCrZH',8,'25-38005633-5','2022-06-16 17:17:39');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (52,'15342184','Ken','Baford',34,'E-9390-OUM',NULL,'kbaford1f@gmpg.org','obo75mRb9lSyeEXgVLrPdhpmcsmF2B7J',9,'25-15342184-3','2021-08-29 07:56:26');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (53,'37669089','Nicolle','Benjafield',11,'H-8451-LNO','+7-574-776-5835','nbenjafield1g@wufoo.com','eaCVxNFwkbukDvsn28W1TinTje2LH1Eu',3,'23-37669089-4','2021-07-10 20:35:27');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (54,'42294915','Alexis','Howarth',132,'S-4683-GJG',NULL,'ahowarth1h@yelp.com','aNPFrpSoYnDthxn4RigoQBYx5P7KdhR1',11,'24-42294915-5','2022-04-28 00:51:08');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (55,'34092082','Ulrica','Gamage',95,'D-7045-HUI',NULL,'ugamage1i@senate.gov','Rc0FGR0p43kjxLlE4IFrfGGyg1hOm4KS',3,'23-34092082-1','2022-01-31 09:36:34');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (56,'20579501','Terrence','Byneth',36,'L-5804-AHY','+7-958-846-2410','tbyneth1j@reddit.com','IqJSJVh4xk7WvgieBMgaWLya4pYUE7MB',1,'23-20579501-1','2021-09-05 16:05:00');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (57,'33248382','Culley','Audrey',24,'A-0565-OIH','+62-886-987-6566','caudrey1k@imageshack.us','CkGPBJTrZjFu4lICZreFfqhzeV1rkP7a',3,'24-33248382-0','2021-08-13 10:07:29');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (58,'39586130','Seumas','Greenway',144,'L-9850-LTA','+256-849-614-2386','sgreenway1l@army.mil','LaN7EPptvgje0kt9IbCxX96IKasTXcnP',9,'25-39586130-4','2022-06-03 21:28:07');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (59,'18649719','Mozes','Duggan',116,'A-5378-NHE','+86-252-537-1414','mduggan1m@pagesperso-orange.fr','rjkIBoutwRVL1bAyWGdJd6TVCTNyxaaZ',2,'24-18649719-2','2022-03-18 00:08:21');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (60,'29506151','Jsandye','Marsters',78,'L-4276-JNR','+380-715-255-0073','jmarsters1n@cnbc.com','GAj6p507ZQO61AOhWfQo2o7fDCC7Q5uz',9,'27-29506151-2','2022-01-02 02:12:38');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (61,'25342166','Martha','Venn',64,'U-1420-WYS','+7-369-264-5139','mvenn1o@facebook.com','MnDZb1rUiBTBkhUEYRK6dRdhxx1ImGNQ',3,'24-25342166-2','2021-11-13 03:40:36');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (62,'11439149','Hilde','Surmeir',92,'N-9821-BJZ','+81-807-253-2149','hsurmeir1p@pagesperso-orange.fr','9JaooD1BQIYuNQVvDBzhP7Z8IgYzohFA',1,'26-11439149-1','2022-01-30 01:47:24');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (63,'25952832','Garwin','Ferns',93,'I-6043-GHQ','+84-254-326-2545','gferns1q@paginegialle.it','rwFsj0Llwq2Z4SkYoA0Zm7mcqrxRb9Nz',11,'26-25952832-8','2022-01-30 02:03:21');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (64,'15269744','Carolee','Hilling',108,'K-3113-BWI','+86-504-414-4987','chilling1r@reverbnation.com','cyAaOgHmEa9w7ZpatzhLwMR8lcmEzetU',8,'27-15269744-5','2022-02-27 20:48:40');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (65,'23315190','Abrahan','Goldsworthy',141,'X-8214-UNX','+66-956-830-5820','agoldsworthy1s@yelp.com','ljUKJoOZ5MqdmxkaKDggsnr43IzKCGID',11,'27-23315190-1','2022-05-27 19:20:23');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (66,'18304274','Evey','Vinter',79,'X-8550-FNL',NULL,'evinter1t@plala.or.jp','1lKcmUSN0QC6WMhJH1EThoICNLX5lvjA',3,'27-18304274-8','2022-01-05 23:05:18');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (67,'14059631','Phil','Flintoft',6,'H-5487-SKN','+52-520-895-8491','pflintoft1u@hexun.com','kYMz47DYAlB2KMHXcQplVEOQ6lR8fOca',8,'20-14059631-2','2021-06-30 01:54:20');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (68,'16140930','Dyna','Casaletto',128,'D-4023-RPM','+7-257-979-3456','dcasaletto1v@nps.gov','bpxAjeD8s0IAxJ39XAkqZbj4ceWPwdEL',3,'23-16140930-7','2022-04-08 09:18:06');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (69,'13551696','Natalina','Arents',122,'H-1019-SCX','+27-164-155-0990','narents1w@yelp.com','hbLtp0DURDcTOTGi4q8LIqcP9GZ59JOR',3,'27-13551696-9','2022-03-31 16:23:48');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (70,'39202435','Mellie','Lightbourne',137,'H-2355-UGD','+55-405-961-6686','mlightbourne1x@cyberchimps.com','IeUb1Sqa9MLCMFdtgduQVjpH51HwAuth',3,'23-39202435-5','2022-05-15 11:33:56');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (71,'27042084','Orazio','Folli',106,'L-0875-YMH','+1-282-860-7867','ofolli1y@microsoft.com','fuXt9DnEkPjLCDi6VX6YT5Fx7zKe0oGN',11,'25-27042084-7','2022-02-25 22:54:38');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (72,'12459557','Ker','Patient',14,'M-6232-CPV','+86-768-294-2982','kpatient1z@purevolume.com','PtAR8lVqE52FxrNVy6zpLUXwNEmrxZ7q',3,'23-12459557-0','2021-07-17 00:37:53');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (73,'30073591','Josey','Sproat',89,'S-0913-POZ','+46-154-188-2709','jsproat20@google.ca','QMXsafEH1BFVK9xrXWu2HGypz4DlSLLE',3,'27-30073591-1','2022-01-22 19:13:16');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (74,'22105966','Darb','Clem',134,'Q-9914-HAY','+976-187-267-8012','dclem21@squarespace.com','2MRWiQV9jliVZAZeHwN1nRyI16BseUPo',3,'23-22105966-8','2022-05-07 21:09:39');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (75,'42359034','Chiquita','Merigon',118,'E-0845-ONW','+62-488-686-1932','cmerigon22@globo.com','VIAldeA6KkInDmnb5IaPJnrZpQIyzOtj',1,'23-42359034-4','2022-03-25 08:44:33');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (76,'35351105','Tanner','Schutter',149,'J-7212-TYN','+355-670-732-9886','tschutter23@list-manage.com','PvojITOS9806X0SK8Y5R5dSxBqinoM4M',9,'26-35351105-7','2022-06-14 21:47:12');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (77,'31662327','Junia','Cussins',20,'O-8912-HQK',NULL,'jcussins24@about.me','Ru46sO9Wt7ptxZn0SgsebJT0FiLtVrSK',3,'24-31662327-9','2021-07-29 08:27:26');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (78,'40172716','Gwyn','Dwine',143,'U-9274-SYH','+976-240-457-9336','gdwine25@macromedia.com','rAeThU7Gy58GLjHVBaeCQ4JtsRdJaZxw',3,'24-40172716-2','2022-06-02 17:55:00');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (79,'13929598','Garrik','O\'Hickey',101,'X-0395-IWC',NULL,'gohickey26@sogou.com','Q4SrxuCk3JHe1aKAIAT4kkjHnUn9R7tH',3,'27-13929598-0','2022-02-10 03:03:39');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (80,'29654820','Nealy','Magor',33,'K-6282-QRF',NULL,'nmagor27@acquirethisname.com','UB5AC0XUaHQ93L6R6Y3gEs16Qe9Zrjvl',11,'24-29654820-0','2021-08-28 14:30:11');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (81,'20291519','Eziechiele','Kupis',45,'V-5573-VLF','+61-834-947-3563','ekupis28@ucoz.ru','sLNjHUQWlAkRrA5GsUVka4HomYizyYGi',8,'25-20291519-6','2021-09-24 00:05:35');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (82,'32134315','Pia','Shevlin',102,'N-1759-TRF','+380-259-215-2494','pshevlin29@biglobe.ne.jp','6w5ueyVdEhscCfxHf9glpOSPkY474GoU',3,'25-32134315-3','2022-02-12 04:37:30');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (83,'38255138','Kassey','Filipczynski',123,'Q-9853-XHT',NULL,'kfilipczynski2a@imageshack.us','bZO40t6UiRuYNeuORmJfUZipCRme45bm',10,'27-38255138-9','2022-04-01 16:10:36');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (84,'44242982','Lon','Warrick',67,'T-1647-WMG','+1-478-105-9544','lwarrick2b@a8.net','PLQZ0bQw68L8zeLQHDsB2Z4caPKPp2YZ',4,'27-44242982-0','2021-11-25 07:44:11');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (85,'10136896','Rhona','Scanes',90,'U-6438-QQE',NULL,'rscanes2c@slideshare.net','YNIe5ZxjdinxB2Y9bCrwJ3CfYn550xuN',3,'27-10136896-2','2022-01-23 23:52:11');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (86,'27496939','Vaughan','Yea',16,'W-0252-TZN',NULL,'vyea2d@nsw.gov.au','P5krO096bDniDfOoIitkVJcL5zmpjsuZ',1,'26-27496939-8','2021-07-19 00:10:58');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (87,'26354357','Karna','Lefridge',60,'M-6100-PER',NULL,'klefridge2e@oracle.com','Ola5zE3rZ7jxTdpyFtfJmBLAsMR7mSim',3,'25-26354357-0','2021-11-06 14:15:51');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (88,'22481364','Harmonie','Corselles',39,'C-9698-MBV','+420-435-395-3749','hcorselles2f@theguardian.com','2bbDWVBFUwCWT7d1k9t4g5LEo3mOHYE0',3,'25-22481364-4','2021-09-13 20:04:22');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (89,'16354476','Ceciley','Cottesford',119,'W-3780-XDM',NULL,'ccottesford2g@friendfeed.com','Mv9NGJAe0LDdbhKCKqlG0VexE8F76g47',3,'23-16354476-0','2022-03-27 17:34:18');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (90,'20662239','Terese','Leving',68,'Y-5455-KSQ','+386-934-916-4443','tleving2h@yellowbook.com','5n5COd78Mh8VgcEKAxlOyey3U2tXnpWm',2,'20-20662239-0','2021-11-27 02:39:02');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (91,'40015435','Giselbert','Zannotelli',1,'B-1654-CUK','+687-119-515-9448','gzannotelli2i@nifty.com','j7FKOTbeMIqdDC8rRp8GrqeCAGPzxbRs',11,'27-40015435-7','2021-06-18 02:54:52');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (92,'42458274','Kimbell','Ranson',13,'X-0516-BAE','+62-283-384-4928','kranson2j@cyberchimps.com','7EFxPVzIyEj82U4pGzXWu9EQGP2XBpQ7',10,'27-42458274-4','2021-07-15 06:04:31');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (93,'39195350','Concettina','Gooble',139,'J-0388-WQO','+1-973-514-0905','cgooble2k@artisteer.com','OaJy5Fug8ObqZAo8xpPG2Sq4evXfTUL5',2,'27-39195350-1','2022-05-25 20:45:44');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (94,'29016212','Derk','Peattie',145,'T-3945-ZPY',NULL,'dpeattie2l@patch.com','GCKiSYHjxLfsqK7dG5KZF6ANvfXfvkXr',3,'26-29016212-0','2022-06-05 07:19:25');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (95,'35714820','Terrel','Sweetman',58,'D-9573-YMU',NULL,'tsweetman2m@merriam-webster.com','D4GluHXkySIFLcgbnLGKemucpRQEMW6m',3,'26-35714820-6','2021-10-27 13:34:30');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (96,'10836232','Gerrie','Klugel',8,'S-2088-JWC','+1-845-458-8349','gklugel2n@ebay.com','UG1ZzicC3q4xvEEOPqr4m2ZCLnjxEEeI',9,'27-10836232-6','2021-07-02 06:51:08');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (97,'11596900','Ainslee','McAirt',117,'H-2007-CRM','+86-224-376-7859','amcairt2o@deviantart.com','jUKGVq5bxpZ6ZXVRlFPnqcfkYZpNhq42',3,'25-11596900-6','2022-03-19 22:12:43');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (98,'20270676','Florentia','Townsley',124,'T-8217-PDV',NULL,'ftownsley2p@sbwire.com','QQCsRBbbFcIG1Vxd3PKTSKhsSCrg9cIS',1,'27-20270676-9','2022-04-02 17:32:07');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (99,'33610909','Alwyn','Proppers',28,'P-5009-PUH','+63-618-384-4355','aproppers2q@china.com.cn','eoq9zjt00dFyDgEip9aBQgvOZjNevQBj',1,'20-33610909-2','2021-08-19 04:20:04');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (100,'37546284','Adele','Merriman',80,'M-9457-YSC','+98-519-329-3992','amerriman2r@umn.edu','pg9hfjPwfWfboUkagkbJXDVS3zsRh5DZ',3,'24-37546284-0','2022-01-10 19:21:54');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (101,'43190547','Correy','Ascraft',84,'J-3353-ASI','+56-967-406-5232','cascraft2s@go.com','UPu4JDysT3nlcVqh7amNVwQbjfFdYVin',3,'26-43190547-6','2022-01-16 03:55:25');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (102,'29521198','Wanids','Kavanagh',138,'C-5340-YDC',NULL,'wkavanagh2t@tamu.edu','qrSsjnCQNEpps3sM7PDAnedkItbIft8t',2,'23-29521198-9','2022-05-24 03:06:32');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (103,'19759361','Gwynne','Farnes',10,'H-5817-KXW',NULL,'gfarnes2u@people.com.cn','zQK3WOv9tzI469zlyjOUPIxzDiQ94YFP',9,'26-19759361-0','2021-07-09 18:53:06');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (104,'26705682','Beverly','Polden',53,'X-0643-ACW',NULL,'bpolden2v@economist.com','vDxhkfFGK6JqcEwguHjHxp1ZApjQRCju',3,'25-26705682-8','2021-10-14 05:39:26');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (105,'14960705','Kathi','Gallienne',47,'Y-4625-BBA','+221-539-245-4743','kgallienne2w@google.co.jp','yzEBlfcIUlm7e9hD6YQVnQZn6R2nTMTp',1,'27-14960705-5','2021-09-30 08:18:18');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (106,'37351542','Tadeas','Pratty',50,'P-1521-CPA','+380-260-655-6608','tpratty2x@newyorker.com','M3M6UIjIxkTPrmHhxEkmNE7k1IaFGlKl',9,'24-37351542-9','2021-10-03 11:00:11');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (107,'13226838','Krishnah','Ixor',113,'Q-3071-VWR','+55-459-246-5670','kixor2y@surveymonkey.com','ZvG8V2Dhx0WaPLqOOzO5OpP94KJQLh0r',1,'24-13226838-8','2022-03-11 12:04:39');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (108,'10457572','Lilah','Maisey',86,'S-2833-ZPB','+86-500-530-0732','lmaisey2z@cdbaby.com','7KEuXJkewbzI825VEFVIWPwsaiBoH9I0',2,'24-10457572-8','2022-01-16 23:50:05');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (109,'11848327','Andeee','Dabell',30,'H-3654-CFR','+62-625-574-6437','adabell30@jigsy.com','pYGcmSeCmSjUsqWI7Dt8x0dVOetpZUAO',3,'24-11848327-0','2021-08-23 17:55:36');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (110,'43352362','Carling','Becke',70,'I-1396-MRC',NULL,'cbecke31@gravatar.com','eOqCgqRb0kcqfACSZ74YfMPyUnESDy0x',3,'27-43352362-9','2021-12-10 05:58:26');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (111,'25641483','Willabella','Shawell',127,'E-1584-VZA',NULL,'wshawell32@nps.gov','SaMwCPBc7cyWjE1s1589vAFyUZlJnv6c',10,'24-25641483-1','2022-04-04 04:12:25');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (112,'21917717','Erwin','Mertel',71,'I-5003-IWY','+351-245-283-7600','emertel33@google.com.hk','9AaC0ecmRqTuRcEie3KaqToz9pGXSR9A',3,'27-21917717-3','2021-12-14 11:17:19');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (113,'44537979','Trudie','Antcliffe',146,'C-5581-JQD','+86-896-878-7279','tantcliffe34@washingtonpost.com','Tsn1hZNeicSi6vu4SH1l9sGB61CBpDQU',11,'24-44537979-8','2022-06-06 07:14:42');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (114,'34512338','Adrien','Thomel',9,'T-1840-XIS',NULL,'athomel35@paginegialle.it','fUI6D9906ykkbKh6C6tT1pXFw20rUsQb',3,'25-34512338-7','2021-07-09 01:12:38');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (115,'35784232','Alric','Bodycote',49,'K-3939-SHW',NULL,'abodycote36@craigslist.org','epCrXzOOBiv2MXxxV7qQcplTfd3uJlNs',2,'20-35784232-7','2021-10-01 08:12:18');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (116,'21551258','Dal','Dunklee',52,'K-1206-EDX','+46-827-774-6410','ddunklee37@indiegogo.com','rM4cAhtoe2xEHbcs8cskjJ0ve7OQqRfL',8,'26-21551258-8','2021-10-12 15:29:23');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (117,'17259534','Ariadne','Ferras',35,'R-5977-KVD',NULL,'aferras38@hp.com','LVsVce6tGSA9yr8Rsc7s3llteikahh1W',11,'23-17259534-5','2021-08-30 18:39:08');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (118,'38484767','Casi','Matteacci',27,'H-2656-UGO','+86-559-667-5683','cmatteacci39@yolasite.com','vJHGAFcwQWPeI5kRmQdC7J6FHA8t4vDV',1,'20-38484767-7','2021-08-18 19:48:38');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (119,'32654957','Camella','Kipping',129,'O-5294-KUL',NULL,'ckipping3a@sciencedaily.com','q9O1sUOU6PiHEwfeUr0A1IG6U52ApdQs',8,'26-32654957-4','2022-04-10 22:55:03');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (120,'28660234','Lissa','Samudio',57,'M-4756-KRE',NULL,'lsamudio3b@fda.gov','AkyQFackG26AZ1AUqFZUMJXDfRWjDPsY',11,'24-28660234-4','2021-10-26 14:13:31');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (121,'22848796','Arri','Woodall',125,'D-7382-DUT',NULL,'awoodall3c@ft.com','UJCarx9GLRKZxcuKjBY0dOpwlkAwt9Kv',3,'20-22848796-3','2022-04-03 00:22:17');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (122,'14433741','Hildagard','Shackle',25,'C-2728-QPP',NULL,'hshackle3d@icio.us','mp1toydIo6M5r6uEt1e1LxubvjNYhETT',11,'20-14433741-3','2021-08-15 14:15:31');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (123,'26601602','Cob','Deering',140,'V-0630-JKQ',NULL,'cdeering3e@intel.com','Q0EF68L3nt3IYn44BJwgInh8blfmNvu9',3,'25-26601602-4','2022-05-27 00:03:25');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (124,'20640684','Leila','Harlow',133,'O-0018-UHX','+7-116-937-9053','lharlow3f@google.com.br','d9NOvQj6uL3LwtXkFUeYuaKEuJH2tZO3',2,'20-20640684-6','2022-05-04 11:11:56');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (125,'34219428','Brantley','Maryman',62,'M-3292-RXC','+33-795-988-9267','bmaryman3g@fastcompany.com','Gful9we3izMQ4WO49YmwHjf7QvPa07Cn',3,'24-34219428-8','2021-11-08 22:35:34');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (126,'14050986','Lea','Hardes',31,'B-0327-AAY','+850-651-494-7938','lhardes3h@phoca.cz','FVHHR5wwp89Kx1XKtrKPONwtng9mIz4K',4,'27-14050986-0','2021-08-27 21:26:00');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (127,'18882759','Andi','Januszkiewicz',55,'N-8572-VQT','+86-940-336-9997','ajanuszkiewicz3i@wsj.com','g5nHtOaOVZFaP9HaxOfqcuGg2BxJBkXs',11,'25-18882759-1','2021-10-18 03:07:02');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (128,'40292037','Staford','Bunner',97,'I-4681-IMG','+63-413-988-6427','sbunner3j@fc2.com','I8AXXaSjaXK48tuPhYNjkUtR2myP5AQl',3,'27-40292037-7','2022-02-01 04:33:02');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (129,'38932419','Leonanie','Addy',88,'S-9834-BSM',NULL,'laddy3k@vistaprint.com','MDWkiCabwB78OTN0o0eZHCNaLFjrBXso',3,'27-38932419-8','2022-01-21 14:59:15');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (130,'43223636','Vinny','McGillacoell',5,'B-7850-GLS','+81-827-495-6782','vmcgillacoell3l@linkedin.com','KlfPyzTuwPHcK6R7nKpU4I8jaVmRHZVP',3,'25-43223636-4','2021-06-29 05:29:42');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (131,'10325342','Emelia','Murtagh',56,'D-0539-FYX',NULL,'emurtagh3m@pcworld.com','BzoPASAdHeNaehHoKy19D8qV9Qo2hmPW',10,'20-10325342-1','2021-10-19 09:23:19');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (132,'32056444','Hadleigh','Conklin',26,'T-3779-IGY',NULL,'hconklin3n@myspace.com','NJJ8tJnodesOYrDBsIlNLjvDg9b33JAJ',9,'23-32056444-6','2021-08-16 19:08:07');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (133,'11443302','Devina','Guest',148,'N-4377-ELQ','+86-192-773-2174','dguest3o@toplist.cz','yh8HZ0Y3RjTk80oEvPfMAIYO4aqUFHQC',8,'20-11443302-8','2022-06-11 10:28:49');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (134,'25132014','Kassie','Lambal',7,'A-5062-MQS','+62-935-630-4345','klambal3p@a8.net','qEOFSm5gWL2jRINPn2jbMYPelHUObQ9K',3,'23-25132014-7','2021-07-01 23:54:12');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (135,'33886955','Oliver','Neeves',87,'C-7016-MEF','+351-940-757-7748','oneeves3q@facebook.com','xAhY3WB2EPWmcPccWNIhEehel2i2P7rk',8,'25-33886955-8','2022-01-19 09:49:42');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (136,'16578968','Isidoro','Rapps',23,'Q-7981-ZEA','+86-657-921-9384','irapps3r@w3.org','Q5FAvhYyT043PlCnbKQ3mMaiAPZPczHC',9,'23-16578968-2','2021-08-11 09:10:43');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (137,'17671410','Korey','Jovovic',73,'G-6018-SJB','+420-168-967-9793','kjovovic3s@google.co.uk','VBSh57qXXzZFtq6sKcBFAT6ew571p1zd',4,'27-17671410-4','2021-12-16 01:41:55');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (138,'23022273','Paloma','Waskett',121,'X-2981-HZH','+7-126-644-7382','pwaskett3t@cbc.ca','NgUzgaPr676WWOTlNevPEf797PBgLe3H',2,'24-23022273-5','2022-03-29 14:00:49');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (139,'29561638','Gerri','Santus',81,'O-9561-UJV','+509-529-957-8445','gsantus3u@biblegateway.com','TkTCtSg0SDZPwyCJaTNc2vArPJ8Jjwyy',3,'26-29561638-2','2022-01-12 12:29:56');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (140,'16858182','Florella','Fairlem',43,'F-9314-QSR',NULL,'ffairlem3v@usa.gov','z3GYWwjjnbm1puSY2LYq1LbbUjxp8YdH',1,'25-16858182-8','2021-09-21 01:50:33');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (141,'33661816','Eleen','Troop',105,'Z-6128-WHI',NULL,'etroop3w@twitpic.com','fKAQwdr3gm906empD2JQHBeuQGvfRAQh',1,'26-33661816-5','2022-02-25 01:24:56');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (142,'23405611','Cathlene','Rawstorne',72,'A-3009-XWH','+54-207-528-2105','crawstorne3x@is.gd','uzGmRkXKWR73pdAbIVpIs8e7MGRRRW6R',3,'27-23405611-0','2021-12-14 17:15:33');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (143,'44286459','Randa','Fardoe',131,'C-1568-DZE','+48-781-152-3660','rfardoe3y@chicagotribune.com','1GajPQTSuHs8mPXuFn3pVuXKBAfWVUC4',3,'25-44286459-3','2022-04-27 08:14:19');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (144,'28782830','Kylie','Capstick',103,'D-5730-KDV',NULL,'kcapstick3z@netlog.com','Z6AChOo6FxolmCto9bP4l6LVsb1Bzgs3',2,'26-28782830-1','2022-02-12 14:07:37');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (145,'26386918','Teresa','Kinde',17,'Q-2821-MRY','+52-590-698-7735','tkinde40@economist.com','eE5cL7oXycTZHSbeK2LDwTWdtnWPmMem',3,'23-26386918-5','2021-07-22 02:50:41');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (146,'10085272','Kira','Woodrough',136,'F-9326-GOO','+420-429-496-4828','kwoodrough41@ox.ac.uk','NXUA62EYbIRkPrG15FjxkZwdyGIvtPQA',3,'27-10085272-0','2022-05-14 21:33:52');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (147,'16075995','Earvin','Eede',63,'W-8119-JAS','+86-881-372-0378','eeede42@chronoengine.com','K4OsU9gMelwSnqRONtztdl7HYwvCpvEd',3,'25-16075995-4','2021-11-09 10:34:02');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (148,'28041759','Archibold','Mulqueen',130,'D-4857-VPQ','+92-124-567-7056','amulqueen43@gravatar.com','oHawdJ0qPKVG4tA7iFE2psfl5sBdAZVR',9,'25-28041759-6','2022-04-19 08:46:48');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (149,'38058438','Carlyn','Haffner',107,'T-1712-VFX','+86-124-978-6089','chaffner44@reverbnation.com','rIr34bGRFfdIqXLn3QCsUdnIk7BfL6hl',10,'23-38058438-6','2022-02-26 19:50:44');
INSERT INTO user (`id_user`,`dni`,`first_name`,`last_name`,`id_address`,`postcode`,`phone`,`email`,`password`,`id_iva`,`cuit_cuil`,`created_at`) VALUES (150,'17023416','Demetris','Carlan',100,'G-4299-AWP',NULL,'dcarlan45@live.com','yfigZSVPcIGKunBAVFCJAMX1RbCrrmVH',2,'24-17023416-5','2022-02-09 15:58:51');

-- Table: category
INSERT INTO category (`id_category`,`category`,`description`) VALUES (1,'bicicletas','Bicicletas urbanas, mtb, ruta, triatlón, bmx y descenso');
INSERT INTO category (`id_category`,`category`,`description`) VALUES (2,'componentes','Componentes para tu bicicleta: ruedas, cuadros, asientos, cuadros y mucho más');
INSERT INTO category (`id_category`,`category`,`description`) VALUES (3,'accesorios','Todos los accesorios: velocímetros, pulsómetros, alforjas, herramientas, luces y mucho más');
INSERT INTO category (`id_category`,`category`,`description`) VALUES (4,'equipamiento','El más completo equipamiento: cascos, lentes, mochilas, protectores y mucho más');
INSERT INTO category (`id_category`,`category`,`description`) VALUES (5,'indumentaria','Todo lo que precisas para disfrutar de montar tu bici al máximo');

-- Table: brand
INSERT INTO brand (`id_brand`,`brand`) VALUES (1,'ALE');
INSERT INTO brand (`id_brand`,`brand`) VALUES (2,'ALPINESTARS');
INSERT INTO brand (`id_brand`,`brand`) VALUES (3,'BELL');
INSERT INTO brand (`id_brand`,`brand`) VALUES (4,'BH');
INSERT INTO brand (`id_brand`,`brand`) VALUES (5,'BNB RACK');
INSERT INTO brand (`id_brand`,`brand`) VALUES (6,'BRYTON');
INSERT INTO brand (`id_brand`,`brand`) VALUES (7,'CAMELBACK');
INSERT INTO brand (`id_brand`,`brand`) VALUES (8,'CANNONDALE');
INSERT INTO brand (`id_brand`,`brand`) VALUES (9,'CASTELLI');
INSERT INTO brand (`id_brand`,`brand`) VALUES (10,'CATEYE');
INSERT INTO brand (`id_brand`,`brand`) VALUES (11,'CONOR');
INSERT INTO brand (`id_brand`,`brand`) VALUES (12,'CONTINENTAL');
INSERT INTO brand (`id_brand`,`brand`) VALUES (13,'CRANKBROTHERS');
INSERT INTO brand (`id_brand`,`brand`) VALUES (14,'CRUZ');
INSERT INTO brand (`id_brand`,`brand`) VALUES (15,'CUBE');
INSERT INTO brand (`id_brand`,`brand`) VALUES (16,'ELTIN');
INSERT INTO brand (`id_brand`,`brand`) VALUES (17,'ENDURA');
INSERT INTO brand (`id_brand`,`brand`) VALUES (18,'ERGON');
INSERT INTO brand (`id_brand`,`brand`) VALUES (19,'FIZIK');
INSERT INTO brand (`id_brand`,`brand`) VALUES (20,'FOX');
INSERT INTO brand (`id_brand`,`brand`) VALUES (21,'GARMIN');
INSERT INTO brand (`id_brand`,`brand`) VALUES (22,'GIANT');
INSERT INTO brand (`id_brand`,`brand`) VALUES (23,'GIRO');
INSERT INTO brand (`id_brand`,`brand`) VALUES (24,'GOBIK');
INSERT INTO brand (`id_brand`,`brand`) VALUES (25,'GORE');
INSERT INTO brand (`id_brand`,`brand`) VALUES (26,'HAST');
INSERT INTO brand (`id_brand`,`brand`) VALUES (27,'KIMOA');
INSERT INTO brand (`id_brand`,`brand`) VALUES (28,'LIV');
INSERT INTO brand (`id_brand`,`brand`) VALUES (29,'MARZOCCHI');
INSERT INTO brand (`id_brand`,`brand`) VALUES (30,'MAVIC');
INSERT INTO brand (`id_brand`,`brand`) VALUES (31,'MAXXIS');
INSERT INTO brand (`id_brand`,`brand`) VALUES (32,'MENABO');
INSERT INTO brand (`id_brand`,`brand`) VALUES (33,'MERIDA');
INSERT INTO brand (`id_brand`,`brand`) VALUES (34,'NUTRISPORT');
INSERT INTO brand (`id_brand`,`brand`) VALUES (35,'OAKLEY');
INSERT INTO brand (`id_brand`,`brand`) VALUES (36,'ORBEA');
INSERT INTO brand (`id_brand`,`brand`) VALUES (37,'ORTLIEB');
INSERT INTO brand (`id_brand`,`brand`) VALUES (38,'PODIUM');
INSERT INTO brand (`id_brand`,`brand`) VALUES (39,'POLAR');
INSERT INTO brand (`id_brand`,`brand`) VALUES (40,'RYME BIKES');
INSERT INTO brand (`id_brand`,`brand`) VALUES (41,'SCOTT');
INSERT INTO brand (`id_brand`,`brand`) VALUES (42,'SELLE ITALIA');
INSERT INTO brand (`id_brand`,`brand`) VALUES (43,'SHIMANO');
INSERT INTO brand (`id_brand`,`brand`) VALUES (44,'SIDI');
INSERT INTO brand (`id_brand`,`brand`) VALUES (45,'SIGMA');
INSERT INTO brand (`id_brand`,`brand`) VALUES (46,'SPECIALIZED');
INSERT INTO brand (`id_brand`,`brand`) VALUES (47,'SPIUK');
INSERT INTO brand (`id_brand`,`brand`) VALUES (48,'SPORTFUL');
INSERT INTO brand (`id_brand`,`brand`) VALUES (49,'SRAM');
INSERT INTO brand (`id_brand`,`brand`) VALUES (50,'TOPEAK');
INSERT INTO brand (`id_brand`,`brand`) VALUES (51,'TUBOLITO');
INSERT INTO brand (`id_brand`,`brand`) VALUES (52,'ZEFAL');

-- Table: provider
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (1,'30-21702578-6','Phillips 66',43,'W-4474-DOO','+62-164-232-9437','htungate0@hp.com',1,'2022-05-12 05:35:35');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (2,'30-10127519-6','Everbridge, Inc.',38,'A-2440-RMB','+63-943-320-4964','tmcgillivrie1@uiuc.edu',4,'2022-04-01 12:04:27');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (3,'30-24737210-5','First Community Corporation',19,'E-2274-NWJ','+351-724-102-7189','jduck2@cloudflare.com',9,'2021-11-20 22:46:06');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (4,'30-31247619-3','Public Storage',44,'R-0927-NUE','+216-568-701-6246','gpirazzi3@dyndns.org',1,'2022-05-16 19:43:31');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (5,'30-16939641-6','Arcadia Biosciences, Inc.',9,'V-1920-AXL',NULL,'cigoe4@noaa.gov',9,'2021-08-10 02:29:52');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (6,'30-24508794-6','Carbonite, Inc.',8,'J-1634-GKC','+86-174-526-4488','cwoollcott5@twitter.com',10,'2021-07-31 07:33:15');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (7,'30-40249106-5','NextEra Energy, Inc.',2,'Y-1409-YUG','+57-725-210-7267','csouter6@samsung.com',1,'2021-06-23 13:33:11');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (8,'30-38165587-3','Morgan Stanley Debt Fund, Inc.',1,'M-5134-UPR','+86-415-689-2915','rshieldon7@comsenz.com',1,'2021-06-21 18:57:07');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (9,'30-27685485-1','Fanhua Inc.',24,'A-5165-DBA','+7-599-148-6459','fhearson8@mapy.cz',10,'2021-12-18 11:18:20');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (10,'30-10685882-7','Jaguar Animal Health, Inc.',29,'D-9724-ZBK','+387-679-276-4867','isemechik9@pen.io',6,'2022-01-21 06:13:14');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (11,'30-13798449-5','HSBC Holdings plc',42,'M-0244-XQF','+86-352-993-9894','kanfussoa@bloglovin.com',1,'2022-04-24 18:53:00');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (12,'30-14206631-8','First Trust Latin America AlphaDEX Fund',36,'W-8182-JJJ','+86-900-897-8899','hmccourtieb@yale.edu',1,'2022-03-27 22:28:42');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (13,'30-14644489-7','Proofpoint, Inc.',18,'V-9487-JDP','+7-291-689-0956','mskeatsc@aol.com',4,'2021-10-30 07:52:50');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (14,'30-10931121-3','KKR Income Opportunities Fund',41,'Q-1699-COT',NULL,'dcaveaud@phoca.cz',9,'2022-04-16 23:50:13');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (15,'30-19994791-5','Hebron Technology Co., Ltd.',33,'U-5951-VHZ',NULL,'sdunke@pinterest.com',1,'2022-03-20 06:23:16');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (16,'30-36704294-8','J P Morgan Chase & Co',28,'H-0830-ZMN',NULL,'mdraytonf@icio.us',4,'2022-01-11 07:20:03');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (17,'30-27516465-9','Perfumania Holdings, Inc',14,'U-2763-KQG','+86-910-168-1917','mstainsg@qq.com',1,'2021-09-19 02:32:55');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (18,'30-27259866-0','ILG, Inc',4,'Q-5147-KSA','+55-499-452-1570','bclyanth@blog.com',8,'2021-06-30 23:05:27');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (19,'30-30571405-3','Hostess Brands, Inc.',37,'S-9460-BQQ','+86-746-109-7666','wabramskyi@multiply.com',9,'2022-03-29 12:37:41');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (20,'30-23488086-3','MSA Safety Incorporporated',21,'D-4029-NCN',NULL,'ctruelockj@mail.ru',6,'2021-11-24 18:41:48');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (21,'30-30141517-6','M B T Financial Corp',6,'N-8561-YAP','+86-347-484-2998','vlecornuk@goo.ne.jp',1,'2021-07-04 15:54:03');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (22,'30-44946180-3','U.S. Silica Holdings, Inc.',30,'C-3215-NPD',NULL,'bwynrehamel@yale.edu',10,'2022-02-22 05:44:09');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (23,'30-32149971-9','The Michaels Companies, Inc.',32,'O-4559-XPX',NULL,'edanatm@topsy.com',10,'2022-03-06 16:35:33');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (24,'30-18798982-7','INVESCO MORTGAGE CAPITAL INC',40,'R-2531-BBO',NULL,'dlegalln@geocities.jp',4,'2022-04-15 08:56:54');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (25,'30-43886477-1','Neptune Technologies & Bioresources Inc',48,'Z-7721-ZXI','+86-833-806-2077','bmcfetridgeo@hatena.ne.jp',1,'2022-06-05 02:43:47');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (26,'30-27974712-3','CommScope Holding Company, Inc.',49,'Q-0230-QYZ',NULL,'bdivisekp@skype.com',1,'2022-06-12 08:35:38');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (27,'30-15600301-9','Old Line Bancshares, Inc.',10,'T-2097-HIP','+62-174-940-7905','yyateq@bigcartel.com',8,'2021-08-13 18:09:11');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (28,'30-15937255-0','Guaranty Federal Bancshares, Inc.',15,'X-1704-KXZ','+63-750-551-0620','cpalekr@deliciousdays.com',1,'2021-10-09 19:00:25');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (29,'30-34735665-9','TICC Capital Corp.',39,'N-9450-VKC',NULL,'mhessentalers@google.cn',1,'2022-04-07 01:08:56');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (30,'30-26180377-2','Liberty Media Corporation',27,'V-4263-IFZ',NULL,'mgrigort@vistaprint.com',1,'2022-01-09 20:57:49');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (31,'30-14265008-0','First BanCorp.',45,'J-5158-HHW',NULL,'vsiseyu@cam.ac.uk',1,'2022-05-30 16:41:33');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (32,'30-36067816-4','Goldman Sachs MLP Income Opportunities Fund',31,'F-4558-AXV','+48-872-904-1580','fgillottv@reference.com',9,'2022-02-27 03:11:03');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (33,'30-42872516-9','Tsakos Energy Navigation Ltd',12,'Q-8843-JUX','+351-265-840-0370','scollissw@businessinsider.com',1,'2021-08-31 08:56:54');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (34,'30-12427955-6','BlackRock Long-Term Municipal Advantage Trust',11,'P-7172-HTZ','+7-495-757-4165','lilbertx@home.pl',1,'2021-08-19 02:37:23');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (35,'30-19777433-4','Anixter International Inc.',25,'L-4009-AEQ','+351-451-573-7258','ccaneroy@php.net',8,'2021-12-27 08:22:47');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (36,'30-17151316-5','NGL ENERGY PARTNERS LP',35,'Z-2042-JEJ','+86-239-530-8607','edominichelliz@army.mil',6,'2022-03-26 12:25:17');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (37,'30-11889066-1','LendingClub Corporation',26,'P-0281-WVK','+62-475-196-5177','owheelwright10@phoca.cz',8,'2022-01-05 03:54:43');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (38,'30-22592219-3','Genesis Healthcare, Inc.',34,'D-8505-NXY','+380-100-244-3072','rcurryer11@nationalgeographic.com',11,'2022-03-21 19:18:29');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (39,'30-39860499-5','CNX Coal Resources LP',16,'A-8015-NSB','+86-285-996-5051','mfardon12@goodreads.com',6,'2021-10-17 23:14:26');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (40,'30-32758812-0','Jones Energy, Inc.',20,'J-9263-SDY','+86-580-102-0429','nroddam13@i2i.jp',11,'2021-11-23 01:15:22');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (41,'30-39931820-7','Marriott International',50,'C-1950-YNN','+86-929-632-5751','gkingscote14@mail.ru',11,'2022-06-16 06:13:58');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (42,'30-13824406-8','AvalonBay Communities, Inc.',7,'K-6631-OLK',NULL,'mmaben15@cyberchimps.com',1,'2021-07-24 08:44:14');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (43,'30-30479245-6','Playa Hotels & Resorts N.V.',47,'R-1235-JIS','+86-293-725-6734','cstirley16@huffingtonpost.com',9,'2022-06-04 06:17:26');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (44,'30-31765992-5','Penn West Petroleum Ltd',22,'W-7727-VTF','+86-510-725-2094','bpyrton17@nasa.gov',6,'2021-12-02 07:39:24');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (45,'30-11336509-1','Career Education Corporation',23,'M-5612-GWF','+48-274-220-3949','lcalcott18@123-reg.co.uk',9,'2021-12-03 05:54:13');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (46,'30-25767329-6','Asta Funding, Inc.',5,'I-0474-RPD',NULL,'eballard19@barnesandnoble.com',2,'2021-07-04 05:58:00');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (47,'30-25937697-1','Skyline Medical Inc.',13,'F-3319-XZC','+970-517-425-5131','hmckeeman1a@mlb.com',2,'2021-09-17 00:33:18');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (48,'30-34086770-2','FlexShares Credit-Scored US Index Fund',46,'T-0366-AEX',NULL,'akingsman1b@eepurl.com',4,'2022-06-02 05:53:54');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (49,'30-32112505-1','VictoryShares Developed Enhanced Wtd ETF',17,'P-1998-HFW','+976-683-634-6135','dgawne1c@blogtalkradio.com',10,'2021-10-26 05:01:10');
INSERT INTO provider (`id_provider`,`cuit`,`name`,`id_address`,`postcode`,`phone`,`email`,`id_iva`,`created_at`) VALUES (50,'30-26385068-8','YuMe, Inc.',3,'U-7156-LQB',NULL,'mdockerty1d@hatena.ne.jp',2,'2021-06-24 15:09:10');

-- Table: product
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (1,'IA-45CTZYI/BX-03','Caramagnola Plástica Podium 0.5L. Versión Eco. Color A Granel.','Fusce consequat. Nulla nisl. Nunc nisl.',38,47,40,3,'/img/products/1629855703-producto1.jpg',450.00,0,'2021-06-18 00:00:00','2021-07-05 04:39:38');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (2,'QO-XD9KUDP/GY-52','Cubierta De Kevlar Maxxis Race King 29 X 2,15.','Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.',31,226,15,2,'/img/products/1636383990-producto2.jpg',4750.00,0,'2021-06-18 00:00:00','2021-12-22 03:00:09');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (3,'PT-MYTLYTT/UT-65','Gel Energizante Nutrisport Con Cafeína 50g. Express.','Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.',34,66,42,4,'/img/products/1634445245-producto3.jpg',125.00,5,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (4,'AX-GJDHROX/WY-43','Casco Specialized Echelon II Ruta. Verde FL / Small.','In congue. Etiam justo. Etiam pretium iaculis justo.',46,226,46,4,'/img/products/1651337062-producto4.jpg',15480.00,17,'2021-06-18 00:00:00','2022-04-05 13:08:26');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (5,'PY-BANZSLJ/SP-34','Velocimetro Cateye Inalámbrico ST-12.','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',10,47,4,3,'/img/products/1632301822-producto5.jpg',3560.00,0,'2021-06-18 00:00:00','2021-11-20 19:47:29');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (6,'BS-X2IEVXK/UE-34','Cámara Tubolito MTB 29 X 1.75.','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.',51,66,15,2,'/img/products/1639809732-producto6.jpg',473.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (7,'DV-IILTW2P/YX-01','Zapatillas Specialized S-Works De Ruta. Blanco. Talle: 42.','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.',46,226,46,5,'/img/products/1629163389-producto7.jpg',14910.00,7,'2021-06-18 00:00:00','2021-09-26 19:07:01');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (8,'VZ-PC00H4N/OA-21','Bicicleta Ruta Giant Propel Advanced Sl 0 Disc 2020',NULL,22,226,30,1,'/img/products/1637044353-producto8.jpg',510000.00,0,'2021-06-18 00:00:00','2021-07-24 01:26:15');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (9,'TI-RY7XSPZ/RJ-13','Bicicleta Ruta Orbea Gain M10 2019','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.',36,66,31,1,'/img/products/1638592138-producto9.jpg',374000.00,20,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (10,'QI-M68BHAX/HE-26','Bicicleta Ruta Specialized Creo Sl E5 Comp 2020','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.',46,226,46,1,'/img/products/1649798351-producto10.jpg',412000.00,0,'2021-06-18 00:00:00','2021-08-05 16:09:05');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (11,'NB-ZMZ7TBC/II-41','Bicicleta Ruta Liv Envi Advanced Pro 1 Disc 2021','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.',28,47,35,1,'/img/products/1643034744-producto11.jpg',437000.00,10,'2021-06-18 00:00:00','2021-11-23 18:54:46');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (12,'NW-MTUYSD7/YX-09','Bicicleta Tria Scott Plasma RC 2021','Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',41,226,50,1,'/img/products/1628096882-producto12.jpg',628000.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (13,'NC-AD2T9I0/DN-75','Bicicleta Ruta Giant TCR Advanced SL 1 Disc 2021',NULL,22,226,30,1,'/img/products/1635743410-producto13.jpg',475000.00,0,'2021-06-18 00:00:00','2021-07-20 18:04:18');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (14,'CS-4Y31D4X/FW-20','Bicicleta Ruta Specialized Turbo Levo Comp 29\'\' 2021','Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.',46,226,46,1,'/img/products/1654711502-producto14.jpg',523000.00,0,'2021-06-18 00:00:00','2021-06-30 13:33:01');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (15,'BZ-C1247IZ/RI-50','Bicicleta MTB Cannondale Scalpel Carbon 3 2021','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.',8,226,9,1,'/img/products/1646928628-producto15.jpg',482000.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (16,'HR-PQ0FUR1/PF-05','Bicicleta MTB Orbea Oiz M30 29\'\' 2020','Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.',36,66,31,1,'/img/products/1650504845-producto16.jpg',342000.00,20,'2021-06-18 00:00:00','2021-07-30 00:17:46');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (17,'AI-ICLSTZI/CJ-17','Bicicleta MTB Merida Big Nine 100 2x 2021','Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.',33,47,42,1,'/img/products/1652085458-producto17.jpg',118000.00,10,'2021-06-18 00:00:00','2022-03-12 00:34:27');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (18,'WT-8U6RMAA/QQ-02','Bicicleta MTB Cannondale Trail 7 2021','Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.',8,226,9,1,'/img/products/1636856491-producto18.jpg',157000.00,0,'2021-06-18 00:00:00','2021-09-25 23:11:58');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (19,'UE-NCNXKT8/SP-37','Bicicleta MTB Giant XTC Advanced SL 29 1 2021','Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.',22,226,30,1,'/img/products/1626512677-producto19.jpg',423000.00,0,'2021-06-18 00:00:00','2021-07-05 07:43:46');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (20,'TW-CGZD57K/AI-62','Bicicleta Urbana Conor Milano 28\'\' 2021','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.',11,47,6,1,'/img/products/1636503619-producto20.jpg',42000.00,0,'2021-06-18 00:00:00','2022-04-22 12:33:41');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (21,'DR-SY8Y321/HM-90','Bicicleta Urbana Ryme Dubai 28\'\' 2021','Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.',40,47,39,1,'/img/products/1628092129-producto21.jpg',53000.00,15,'2021-06-18 00:00:00','2022-04-13 08:01:39');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (22,'SA-DEXE7BH/SW-06','Bicicleta Urbana BH Ibiza 2021','Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.',4,47,4,1,'/img/products/1633385551-producto22.jpg',68000.00,0,'2021-06-18 00:00:00','2021-07-19 10:21:27');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (23,'YG-I2N9O16/JN-08','Marzocchi Bomber Z2 E- Bike 29\'\' Air 130 Rail Boost','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.',29,108,37,2,'/img/products/1636370025-producto23.jpg',58000.00,15,'2021-06-18 00:00:00','2021-10-10 18:09:58');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (24,'GZ-WOPB7ZO/JR-22','Manillar Carretera Specialized S-Works Shallow Bend Carbon','Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.',46,226,46,2,'/img/products/1630569436-producto24.jpg',51000.00,8,'2021-06-18 00:00:00','2022-02-13 13:48:33');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (25,'AC-31B7DCJ/AI-53','Grupo Completo MTB Sram XX1 Eagle AXS DUB Boost 175mm 34T','Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.',49,226,50,2,'/img/products/1637980681-producto25.jpg',123000.00,13,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (26,'YX-IY06BAC/YQ-25','Disco De Freno Shimano 180mm Rt-MT800','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',43,112,46,2,'/img/products/1630301963-producto26.jpg',9800.00,10,'2021-06-18 00:00:00','2022-04-27 00:38:36');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (27,'SY-7DFFIU2/DV-91','Freno Shimano XTR 9000 Delantero','Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.',43,112,46,2,'/img/products/1639741081-producto27.jpg',17800.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (28,'CB-ZNE6GIZ/ME-16','Freno Shimano XTR 9000 Trasero Post Resina Carbono X','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.',43,112,46,2,'/img/products/1633369705-producto28.jpg',19200.00,0,'2021-06-18 00:00:00','2021-09-26 10:35:34');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (29,'QJ-4LZ8QNN/VT-62','Freno Sram Code RSC A1 Delantero','Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.',49,226,50,2,'/img/products/1650127798-producto29.jpg',25400.00,14,'2021-06-18 00:00:00','2021-07-04 19:04:18');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (30,'OT-A7AIP8V/QC-71','Freno Sram Code RSC A1 Trasero','Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.',49,226,50,2,'/img/products/1636712633-producto30.jpg',25800.00,14,'2021-06-18 00:00:00','2022-02-10 12:06:16');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (31,'HH-D9A7R7F/DV-52','Cubierta Continental X-King 26x2.20 Rígida','In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.',12,55,15,2,'/img/products/1646199999-producto31.jpg',2840.00,20,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (32,'HK-JQWJE6Y/LD-87','Cubierta Specialized Ground Control Grid Tubeless Ready 29x2.3',NULL,46,226,46,2,'/img/products/1653195148-producto32.jpg',5280.00,0,'2021-06-18 00:00:00','2022-01-12 06:19:46');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (33,'IJ-PH9KPX9/WW-22','Cubierta Continental Grand Prix 5000 700 X 25','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.',12,55,15,2,'/img/products/1624601202-producto33.jpg',4860.00,15,'2021-06-18 00:00:00','2021-11-27 19:08:50');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (34,'BE-J2N01HV/RP-46','Cubierta Continental Gatorskin 700 X 25','Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',12,55,15,2,'/img/products/1631787681-producto34.jpg',3590.00,12,'2021-06-18 00:00:00','2021-06-22 12:39:29');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (35,'NM-ZCGO9JM/US-98','Cubierta Maxxis Pursuer 700 X 25',NULL,31,226,15,2,'/img/products/1638106832-producto35.jpg',2580.00,12,'2021-06-18 00:00:00','2022-01-20 23:26:46');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (36,'FU-ETNB722/EI-56','Cuadro Triatlón Giant Trinity Advanced Pro Tri 2020','Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.',22,226,30,2,'/img/products/1649026991-producto36.jpg',258000.00,0,'2021-06-18 00:00:00','2022-01-11 07:07:59');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (37,'QC-IKLL1EV/KY-79','Sillín Fizik Antares R1 Carbon',NULL,19,66,23,2,'/img/products/1628489215-producto37.jpg',15400.00,0,'2021-06-18 00:00:00','2021-10-18 09:27:23');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (38,'WC-6X2P653/RA-54','Sillín Selle Italia MAX SLR Gel Superflow','In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.',42,108,23,2,'/img/products/1647168403-producto38.jpg',11900.00,0,'2021-06-18 00:00:00','2021-11-08 18:00:03');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (39,'BK-4LN7B6T/WT-88','Ruedas MTB Specialized Stout SL Disc 29\'\'',NULL,46,226,46,2,'/img/products/1633908958-producto39.jpg',21800.00,0,'2021-06-18 00:00:00','2022-03-11 03:04:56');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (40,'SY-ZY8MI13/PH-68','Ruedas MTB Mavic Crossmax Elite Carbon 29 Boost XD Intl.','Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.',30,73,39,2,'/img/products/1627858287-producto40.jpg',111900.00,0,'2021-06-18 00:00:00','2021-08-22 06:46:57');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (41,'BX-RWAITT4/AQ-90','Alforjas Topeak Bolsa Trunkbag DXP Velcro','Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',50,47,7,3,'/img/products/1635855021-producto41.jpg',9090.00,0,'2021-06-18 00:00:00','2022-05-05 20:32:29');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (42,'KF-OBYSOMI/TK-89','Bolso Zefal Traveler 80','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.',52,47,50,3,'/img/products/1624483745-producto42.jpg',5600.00,15,'2021-06-18 00:00:00','2021-12-10 15:29:34');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (43,'GB-E5RHNGT/MX-70','Alforjas Ortlieb Sport-Roller Plus QL2.1 12.5L','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.',37,55,15,3,'/img/products/1643420578-producto43.jpg',13600.00,17,'2021-06-18 00:00:00','2021-07-29 22:10:58');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (44,'IJ-1N15BYY/XC-85','Portabici Techo Cruz Alu Bike','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.',14,226,6,3,'/img/products/1624393731-producto44.jpg',12800.00,27,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (45,'CH-4LS63O6/PV-55','Portabici Techo Hast Fijación Cuadro','Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.',26,55,17,3,'/img/products/1655444408-producto45.jpg',15900.00,0,'2021-06-18 00:00:00','2022-06-06 01:34:59');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (46,'DH-FDOGFMM/LR-59','Barras Porta Portón Menabo Stand Up 3','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.',32,66,40,3,'/img/products/1653166905-producto46.jpg',25600.00,0,'2021-06-18 00:00:00','2021-06-30 22:45:18');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (47,'OM-0PRAHIM/KJ-60','Barras Porta BNB Rack 2 Biker 4x4',NULL,5,47,6,3,'/img/products/1626003282-producto47.jpg',55000.00,16,'2021-06-18 00:00:00','2021-09-16 10:08:34');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (48,'LJ-TQN3SB2/XU-46','Pulsómetro De Bicicleta Garmin Edge 530 Pack',NULL,21,226,27,3,'/img/products/1645522526-producto48.jpg',36700.00,8,'2021-06-18 00:00:00','2022-03-06 12:06:03');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (49,'JN-QIH8PPT/TV-06','Pulsómetro De Bicicleta Bryton Rider 750 T Cadencia, FC Y Veloc.','Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.',6,226,4,3,'/img/products/1628135594-producto49.jpg',33900.00,0,'2021-06-18 00:00:00','2021-12-16 21:53:28');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (50,'TF-Z2ZDC0N/OD-54','Pulsómetro De Pulsera Polar Ignite Gen','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.',39,226,27,3,'/img/products/1631213332-producto50.jpg',19900.00,0,'2021-06-18 00:00:00','2021-07-07 14:07:18');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (51,'UJ-4J033IO/GH-52','Pulsómetro De Pulsera Garmin Fenix 6 Solar Black Strap','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',21,226,27,3,'/img/products/1649250879-producto51.jpg',69900.00,0,'2021-06-18 00:00:00','2022-04-22 01:42:20');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (52,'IX-PH3S90B/SN-84','Cadena Sram PCX! 118 Powerlock 11V','In congue. Etiam justo. Etiam pretium iaculis justo.',49,226,50,3,'/img/products/1642388024-producto52.jpg',2850.00,0,'2021-06-18 00:00:00','2021-09-19 03:17:53');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (53,'IJ-LQZNS0A/EX-11','Cadena Shimano Deore CN-M6100 12V','Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.',43,112,46,3,'/img/products/1655068617-producto53.jpg',3260.00,0,'2021-06-18 00:00:00','2022-04-03 19:12:53');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (54,'EM-XPYRY80/QD-31','Corta Cadena Topeak Super','Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.',50,47,7,3,'/img/products/1634242495-producto54.jpg',1240.00,18,'2021-06-18 00:00:00','2022-01-15 21:24:27');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (55,'UI-TD4T6W7/GG-26','Multiherramienta Topeak Survival Gearbox','Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.',50,47,7,3,'/img/products/1644474573-producto55.jpg',2500.00,0,'2021-06-18 00:00:00','2021-06-27 14:49:12');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (56,'SX-YM4R11E/KA-76','Multiherramienta Crankbrothers M-19','Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.',13,226,9,3,'/img/products/1651148261-producto56.jpg',2900.00,0,'2021-06-18 00:00:00','2021-08-17 16:19:58');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (57,'DH-Q92NQKG/PS-36','Juego De Luces Sigma Aura 80 + Blaze',NULL,45,47,42,3,'/img/products/1627749708-producto57.jpg',6700.00,15,'2021-06-18 00:00:00','2021-10-12 03:23:02');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (58,'MF-AZMOO6J/AC-66','Casco Specialized Chamonix Mips','Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.',46,226,46,4,'/img/products/1644016324-producto58.jpg',7230.00,0,'2021-06-18 00:00:00','2021-09-14 01:49:06');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (59,'WM-GAOPZGY/WR-17','Casco Giro Agilis','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.',23,108,13,4,'/img/products/1649464049-producto59.jpg',6700.00,12,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (60,'WX-DRCVNQP/BJ-50','Casco Cube AM Race','Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',15,55,17,4,'/img/products/1629833633-producto60.jpg',5960.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (61,'SQ-6WGVM84/RL-14','Casco Bell Avenue','Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',3,226,2,4,'/img/products/1639429549-producto61.jpg',5030.00,14,'2021-06-18 00:00:00','2022-05-15 12:27:23');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (62,'MH-1QQ0CKZ/MI-36','Lentes Oakley Flight Jacket Matte Black','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',35,226,30,4,'/img/products/1628784952-producto62.jpg',14300.00,0,'2021-06-18 00:00:00','2022-03-26 03:17:12');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (63,'EA-TU1P53N/EK-01','Lentes Oakley Radar EV Path Steel Fotocromático','Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.',35,226,30,4,'/img/products/1653987146-producto63.jpg',15900.00,0,'2021-06-18 00:00:00','2022-01-17 19:23:18');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (64,'UR-ZY1XEEE/VZ-36','Lentes Spiuk Jifter Espejo','Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',47,47,42,4,'/img/products/1648560028-producto64.jpg',4450.00,14,'2021-06-18 00:00:00','2021-08-17 04:24:52');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (65,'SD-IFG4AP8/KY-24','Lentes Eltin Full Oversize','Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.',16,47,9,4,'/img/products/1648001132-producto65.jpg',3990.00,10,'2021-06-18 00:00:00','2021-11-06 04:12:22');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (66,'GL-X2XI2TE/TW-38','Protector Coraza Fox Head Raceframe','Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.',20,226,18,4,'/img/products/1630598915-producto66.jpg',12500.00,17,'2021-06-18 00:00:00','2022-03-24 15:11:46');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (67,'DL-WPVWKXX/GQ-29','Protector Rodillera Alpinestars E-Ride Knee','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.',2,47,2,4,'/img/products/1633474154-producto67.jpg',6700.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (68,'UR-Z73UQ0G/YL-04','Mochila Camelback Mini Mule 1.5L','Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.',7,226,7,4,'/img/products/1638833369-producto68.jpg',4600.00,0,'2021-06-18 00:00:00','2021-10-21 07:21:36');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (69,'LL-OOQFTOX/XV-94','Mochila Ergon BE2 Enduro',NULL,18,47,19,4,'/img/products/1626299213-producto69.jpg',12400.00,19,'2021-06-18 00:00:00','2021-10-16 13:09:45');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (70,'TL-8AF12YH/DW-14','Mochila Camelback Hydroback Light 1.5L','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',7,226,7,4,'/img/products/1627381485-producto70.jpg',4360.00,22,'2021-06-18 00:00:00','2021-08-10 01:54:18');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (71,'CX-HR92IJP/CT-45','Mochila Ergon BE3 Enduro','Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.',18,47,19,4,'/img/products/1650950480-producto71.jpg',13590.00,12,'2021-06-18 00:00:00','2022-01-15 05:16:45');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (72,'AF-3VIO02P/LM-10','Protector Codera Alpinestars E-Vent',NULL,2,47,2,4,'/img/products/1627441823-producto72.jpg',6420.00,10,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (73,'VT-AFEMXS0/ZA-10','Protector Rodillera Endura MT500 Lite','Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.',17,47,18,4,'/img/products/1636527700-producto73.jpg',6340.00,9,'2021-06-18 00:00:00','2022-01-27 02:42:57');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (74,'GS-ESP531W/JU-06','Remera Castelli Competizione Ineos Grenadiers','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',9,108,13,5,'/img/products/1639649319-producto74.jpg',7995.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (75,'HE-T3J9CUA/WX-76','Remera Cube TeamLine L/S','In congue. Etiam justo. Etiam pretium iaculis justo.',15,55,17,5,'/img/products/1647891243-producto75.jpg',5490.00,23,'2021-06-18 00:00:00','2021-10-11 08:17:13');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (76,'SY-38YT7O3/AQ-36','Remera Ale Movistar 2020 Prime','Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.',1,47,2,5,'/img/products/1641901310-producto76.jpg',6950.00,18,'2021-06-18 00:00:00','2021-12-31 15:46:58');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (77,'DM-LCZSPUN/XJ-72','Remera Kimoa Lab 01','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',27,47,35,5,'/img/products/1638018746-producto77.jpg',8990.00,0,'2021-06-18 00:00:00','2021-12-26 21:47:27');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (78,'LG-3C2PMWA/UR-34','Remera Giant Ride Like King','Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',22,226,30,5,'/img/products/1648755242-producto78.jpg',5990.00,20,'2021-06-18 00:00:00','2021-08-07 16:24:45');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (79,'RZ-X3N0J37/JD-38','Remera Specialized Roubaix Comp W','Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.',46,226,46,5,'/img/products/1647073476-producto79.jpg',4490.00,16,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (80,'YY-K72BPU4/OJ-32','Remera Cube WLS TeamLine W',NULL,15,55,17,5,'/img/products/1653996551-producto80.jpg',4340.00,16,'2021-06-18 00:00:00','2021-10-07 11:06:25');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (81,'FY-B1NUXQ3/RC-33','Maillot Orbea Skinsuit Lab','Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',36,66,31,5,'/img/products/1635466963-producto81.jpg',18340.00,0,'2021-06-18 00:00:00','2022-03-09 12:50:21');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (82,'XY-FONN6Z4/HY-24','Maillot Castelli Integral Free Sanremo 2','Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',9,108,13,5,'/img/products/1646265254-producto82.jpg',17980.00,0,'2021-06-18 00:00:00','2021-11-13 18:47:16');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (83,'SI-2EP5YW9/ZW-89','Maillot Spiuk Tritraje Universal W','Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.',47,47,42,5,'/img/products/1652012497-producto83.jpg',8000.00,0,'2021-06-18 00:00:00','2021-06-23 02:17:12');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (84,'DR-KD19B4M/NX-05','Calza Gobik Absolute 4.0 K10','Fusce consequat. Nulla nisl. Nunc nisl.',24,66,31,5,'/img/products/1637439337-producto84.jpg',10000.00,0,'2021-06-18 00:00:00','2022-06-15 10:01:29');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (85,'YR-V0NAEPW/PO-04','Calza Specialized Rbx Sport Logo','Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.',46,226,46,5,'/img/products/1630935235-producto85.jpg',6690.00,24,'2021-06-18 00:00:00','2021-07-18 07:21:17');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (86,'XV-EBCH0DK/IL-96','Calza Ale Movistar 2020 Prime','Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.',1,47,2,5,'/img/products/1638984047-producto86.jpg',8090.00,12,'2021-06-18 00:00:00','2022-02-05 13:32:41');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (87,'TZ-NYI6QZ8/OZ-16','Calza Sportful GTS Short','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',48,47,19,5,'/img/products/1642371796-producto87.jpg',7680.00,10,'2021-06-18 00:00:00','2021-11-29 09:53:24');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (88,'IQ-ZFJK61M/DS-41','Calza Cube WLS TeamLine W','Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.',15,55,17,5,'/img/products/1640278610-producto88.jpg',4950.00,0,'2021-06-18 00:00:00','2021-07-03 12:47:40');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (89,'LE-QZX60YE/QT-11','Calza Endura FS260 Pro DS W','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.',17,47,18,5,'/img/products/1637094148-producto89.jpg',9460.00,27,'2021-06-18 00:00:00','2022-05-12 22:19:35');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (90,'PA-IWBXH24/YO-63','Calza Scott Bike RC Pro W','Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',41,226,50,5,'/img/products/1650779438-producto90.jpg',7590.00,0,'2021-06-18 00:00:00','2021-10-26 04:29:35');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (91,'LP-S3K9HUC/NQ-81','Campera Sportful Reflex','In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.',48,47,19,5,'/img/products/1633350991-producto91.jpg',3770.00,25,'2021-06-18 00:00:00','2021-12-08 20:19:37');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (92,'EP-245A0UZ/OF-06','Campera Sportful Hot Pack 6','Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',48,47,19,5,'/img/products/1626513100-producto92.jpg',6280.00,0,'2021-06-18 00:00:00','2022-05-21 13:37:51');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (93,'ZO-KYMJ09Q/MK-74','Campera Chaleco Cube TeamLine','Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.',15,55,17,5,'/img/products/1644338378-producto93.jpg',3850.00,15,'2021-06-18 00:00:00','2022-04-04 08:01:50');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (94,'WE-E89WEYG/RC-91','Campera Chaleco Castelli Aria Vest','Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.',9,108,13,5,'/img/products/1624895342-producto94.jpg',8495.00,0,'2021-06-18 00:00:00','2021-11-16 04:14:01');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (95,'SB-XEYM686/IK-77','Campera Endura FS260-Pro Adenaline Race Cape W','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.',17,47,18,5,'/img/products/1650818852-producto95.jpg',7200.00,0,'2021-06-18 00:00:00','2022-03-26 10:13:09');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (96,'TZ-8G0UKYM/YF-52','Campera Gore C5 Gore-Text Active W','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.',25,226,19,5,'/img/products/1634977085-producto96.jpg',16800.00,0,'2021-06-18 00:00:00','2021-07-07 11:18:11');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (97,'XI-LU39QA9/ED-12','Guantes Endura Windchill W','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.',17,47,18,5,'/img/products/1626314198-producto97.jpg',2880.00,20,'2021-06-18 00:00:00','2022-02-15 19:34:08');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (98,'YK-YFWOAK6/CH-60','Guantes Specialized BG Grail W',NULL,46,226,46,5,'/img/products/1637792324-producto98.jpg',2380.00,0,'2021-06-18 00:00:00',NULL);
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (99,'AF-ORL1TX6/ED-86','Guantes Specialized BG Sport Gel SF','Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.',46,226,46,5,'/img/products/1646256764-producto99.jpg',2590.00,0,'2021-06-18 00:00:00','2021-07-07 12:24:54');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (100,'UT-AUS1E0R/XA-09','Guantes Endura Hummvee Plus 2','In congue. Etiam justo. Etiam pretium iaculis justo.',17,47,18,5,'/img/products/1638291141-producto100.jpg',2550.00,0,'2021-06-18 00:00:00','2022-02-17 03:47:25');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (101,'NA-25P3CTO/HV-86','Zapatillas Specialized Torch 3.0 Road','Fusce consequat. Nulla nisl. Nunc nisl.',46,226,46,5,'/img/products/1624699814-producto101.jpg',22990.00,0,'2021-06-18 00:00:00','2022-02-05 15:00:09');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (102,'ZQ-DX60OOM/TF-08','Zapatillas Sidi Shot Carbon Matt',NULL,44,108,37,5,'/img/products/1631577715-producto102.jpg',24890.00,0,'2021-06-18 00:00:00','2022-05-02 00:03:43');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (103,'SD-5BRM1I6/SX-37','Zapatillas Shimano RC500','Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',43,112,46,5,'/img/products/1633688709-producto103.jpg',11890.00,12,'2021-06-18 00:00:00','2021-10-21 03:40:46');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (104,'SV-URKN3LA/MB-10','Zapatillas Scott MTB RC W','Phasellus in felis. Donec semper sapien a libero. Nam dui.',41,226,50,5,'/img/products/1626859545-producto104.jpg',22420.00,0,'2021-06-18 00:00:00','2022-06-03 00:04:31');
INSERT INTO product (`id_product`,`code`,`name`,`description`,`id_brand`,`id_country`,`id_provider`,`id_category`,`thumbnail`,`price`,`discount`,`created_at`,`last_update`) VALUES (105,'LT-JVFYGUB/BU-16','Zapatillas Giro Cylinder 2 W','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.',23,108,13,5,'/img/products/1645433305-producto105.jpg',12900.00,13,'2021-06-18 00:00:00','2022-01-19 10:52:52');

-- Table: stock
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (1,50,'2022-06-18 10:21:01');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (2,20,'2022-06-19 17:41:53');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (3,200,'2022-06-20 18:39:19');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (4,10,'2022-06-20 04:49:42');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (5,0,'2022-06-20 22:03:45');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (6,18,'2022-06-20 13:39:32');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (7,5,'2022-06-20 22:46:15');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (8,4,'2022-06-20 14:02:50');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (9,3,'2022-06-19 04:48:50');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (10,6,'2022-06-19 02:47:35');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (11,7,'2022-06-19 16:31:22');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (12,4,'2022-06-19 17:11:37');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (13,5,'2022-06-19 15:29:38');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (14,4,'2022-06-18 00:33:26');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (15,6,'2022-06-18 10:31:43');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (16,4,'2022-06-18 04:13:43');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (17,8,'2022-06-19 13:52:44');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (18,8,'2022-06-19 11:26:16');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (19,5,'2022-06-19 17:20:44');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (20,5,'2022-06-19 14:26:06');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (21,0,'2022-06-19 16:36:07');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (22,4,'2022-06-20 00:36:08');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (23,6,'2022-06-19 01:27:45');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (24,8,'2022-06-18 17:01:33');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (25,8,'2022-06-18 09:23:35');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (26,9,'2022-06-18 06:07:35');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (27,8,'2022-06-18 15:35:13');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (28,8,'2022-06-18 03:04:36');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (29,0,'2022-06-18 22:14:22');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (30,7,'2022-06-20 08:24:56');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (31,7,'2022-06-20 10:39:51');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (32,0,'2022-06-18 14:04:41');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (33,12,'2022-06-20 14:36:36');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (34,12,'2022-06-20 18:23:02');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (35,15,'2022-06-20 10:30:52');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (36,3,'2022-06-18 04:01:34');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (37,11,'2022-06-18 15:31:24');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (38,8,'2022-06-19 21:08:41');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (39,18,'2022-06-18 12:54:26');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (40,12,'2022-06-19 05:13:53');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (41,5,'2022-06-18 01:34:31');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (42,10,'2022-06-18 19:26:07');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (43,9,'2022-06-18 15:05:41');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (44,12,'2022-06-18 07:22:14');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (45,6,'2022-06-20 02:57:41');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (46,8,'2022-06-18 07:13:33');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (47,8,'2022-06-18 17:34:18');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (48,8,'2022-06-19 18:34:14');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (49,8,'2022-06-20 02:22:20');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (50,8,'2022-06-20 12:39:30');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (51,4,'2022-06-19 01:03:09');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (52,8,'2022-06-19 13:48:31');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (53,0,'2022-06-19 07:24:18');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (54,11,'2022-06-19 13:33:59');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (55,15,'2022-06-19 23:28:12');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (56,11,'2022-06-20 20:47:19');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (57,10,'2022-06-19 14:45:03');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (58,8,'2022-06-20 08:39:48');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (59,7,'2022-06-19 02:12:30');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (60,9,'2022-06-19 01:53:24');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (61,0,'2022-06-19 13:26:56');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (62,8,'2022-06-20 01:01:14');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (63,8,'2022-06-19 11:48:25');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (64,15,'2022-06-18 23:27:29');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (65,11,'2022-06-19 06:16:23');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (66,8,'2022-06-19 04:50:41');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (67,8,'2022-06-19 13:17:57');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (68,8,'2022-06-19 17:16:24');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (69,8,'2022-06-20 00:50:30');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (70,12,'2022-06-18 17:29:00');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (71,11,'2022-06-19 21:53:58');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (72,6,'2022-06-20 18:54:04');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (73,7,'2022-06-19 19:34:05');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (74,10,'2022-06-20 17:42:03');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (75,9,'2022-06-18 13:58:22');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (76,15,'2022-06-20 05:01:15');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (77,0,'2022-06-19 07:37:42');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (78,8,'2022-06-18 03:15:30');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (79,5,'2022-06-18 14:45:26');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (80,6,'2022-06-18 15:01:25');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (81,6,'2022-06-19 20:11:41');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (82,7,'2022-06-20 00:03:45');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (83,6,'2022-06-18 22:40:39');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (84,6,'2022-06-18 22:13:19');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (85,8,'2022-06-19 14:54:18');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (86,8,'2022-06-20 00:01:18');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (87,8,'2022-06-18 09:54:46');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (88,8,'2022-06-18 11:02:42');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (89,8,'2022-06-18 10:05:57');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (90,5,'2022-06-18 21:44:29');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (91,8,'2022-06-18 21:52:05');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (92,11,'2022-06-18 19:49:17');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (93,10,'2022-06-18 13:08:21');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (94,9,'2022-06-19 07:30:23');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (95,12,'2022-06-19 02:03:28');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (96,11,'2022-06-18 22:06:50');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (97,10,'2022-06-20 01:11:16');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (98,12,'2022-06-20 23:44:46');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (99,15,'2022-06-20 15:53:37');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (100,9,'2022-06-20 03:43:54');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (101,12,'2022-06-20 05:09:56');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (102,10,'2022-06-18 16:09:41');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (103,12,'2022-06-20 23:20:09');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (104,8,'2022-06-20 05:00:17');
INSERT INTO stock (`id_product`,`stock`,`last_update`) VALUES (105,10,'2022-06-20 19:01:27');

-- Table: favorite
INSERT INTO favorite (`id_user`,`id_product`) VALUES (1,2);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (5,5);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (12,5);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (1,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (17,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (20,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (32,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (53,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (71,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (103,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (111,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (128,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (146,7);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (20,8);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (26,11);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (7,12);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (45,12);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (1,19);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (62,22);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (5,23);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (95,23);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (146,24);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (1,25);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (20,25);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (128,25);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (53,28);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (111,31);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (12,33);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (5,35);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (45,35);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (71,39);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (103,39);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (139,39);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (32,44);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (20,45);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (57,45);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (139,45);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (12,56);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (62,56);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (146,58);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (37,65);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (45,66);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (5,67);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (95,67);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (111,72);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (32,78);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (84,81);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (37,82);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (7,89);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (62,89);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (45,98);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (17,102);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (111,102);
INSERT INTO favorite (`id_user`,`id_product`) VALUES (111,103);

-- Table: topic
INSERT INTO topic (`id_topic`,`topic`,`description`) VALUES (1,'newsletter','Noticias destacadas del mundo del ciclismo');
INSERT INTO topic (`id_topic`,`topic`,`description`) VALUES (2,'novedades','Novedades de nuestro catálogo de productos');
INSERT INTO topic (`id_topic`,`topic`,`description`) VALUES (3,'ofertas','Productos en ofertas por tiempo limitado');
INSERT INTO topic (`id_topic`,`topic`,`description`) VALUES (4,'lanzamientos','Próximos lanzamientos de productos');
INSERT INTO topic (`id_topic`,`topic`,`description`) VALUES (5,'cursos','Cursos de divulgación que dictamos junto a nuestros mecánicos y especialistas');

-- Table: subscription
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (3,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (6,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (22,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (33,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (49,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (52,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (58,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (62,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (76,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (81,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (93,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (94,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (108,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (114,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (125,1);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (9,2);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (44,2);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (122,2);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (145,2);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (12,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (21,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (22,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (43,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (45,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (55,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (62,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (69,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (81,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (89,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (93,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (95,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (110,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (115,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (123,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (131,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (148,3);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (55,4);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (68,4);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (92,4);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (102,4);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (130,4);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (133,4);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (36,5);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (74,5);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (81,5);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (102,5);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (103,5);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (124,5);
INSERT INTO subscription (`id_user`,`id_topic`) VALUES (131,5);

-- Table: cart
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (1,1,'2022-06-08 22:12:00');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (2,11,'2022-05-28 09:30:20');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (3,15,'2022-06-14 16:47:20');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (4,22,'2022-06-09 15:20:08');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (5,28,'2022-05-31 23:24:04');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (6,34,'2022-05-28 09:22:06');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (7,39,'2022-05-29 01:07:55');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (8,41,'2022-05-29 12:04:14');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (9,44,'2022-06-03 20:20:43');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (10,45,'2022-06-11 09:43:31');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (11,48,'2022-05-29 06:25:01');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (12,53,'2022-05-27 11:25:57');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (13,56,'2022-06-01 20:51:31');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (14,60,'2022-06-15 23:40:17');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (15,62,'2022-05-26 03:15:18');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (16,65,'2022-06-17 05:08:10');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (17,67,'2022-06-06 07:23:46');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (18,86,'2022-06-18 05:39:00');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (19,94,'2022-05-26 05:37:58');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (20,102,'2022-05-27 08:52:27');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (21,110,'2022-06-10 15:57:48');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (22,120,'2022-06-04 22:11:53');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (23,123,'2022-05-30 18:15:04');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (24,125,'2022-06-15 13:18:17');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (25,127,'2022-06-10 12:19:33');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (26,129,'2022-06-09 07:33:37');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (27,131,'2022-06-01 10:55:39');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (28,135,'2022-05-26 18:51:52');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (29,145,'2022-06-14 14:40:14');
INSERT INTO cart (`id_cart`,`id_user`,`last_update`) VALUES (30,147,'2022-06-17 06:03:09');

-- Table: cart_detail
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (1,69,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (2,34,2);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (2,79,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (3,3,3);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (4,94,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (5,2,2);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (5,18,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (5,76,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (6,101,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (7,18,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (8,32,2);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (9,3,3);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (9,67,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (9,87,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (10,105,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (11,66,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (12,34,2);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (13,3,2);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (13,53,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (13,91,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (13,104,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (14,88,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (15,89,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (16,2,2);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (17,3,5);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (17,41,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (18,103,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (19,54,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (20,35,2);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (20,98,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (21,95,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (22,53,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (23,3,4);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (24,81,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (25,50,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (26,3,7);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (26,69,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (26,73,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (27,103,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (28,77,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (29,30,1);
INSERT INTO cart_detail (`id_cart`,`id_product`,`quantity`) VALUES (30,50,1);

-- Table: delivery_type
INSERT INTO delivery_type (`id_delivery`,`delivery_type`) VALUES (1,'Retira por sucursal');
INSERT INTO delivery_type (`id_delivery`,`delivery_type`) VALUES (2,'Envío a domicilio - OCA');
INSERT INTO delivery_type (`id_delivery`,`delivery_type`) VALUES (3,'Envío a domicilio - Andreani');
INSERT INTO delivery_type (`id_delivery`,`delivery_type`) VALUES (4,'Envío a domicilio - UPS');
INSERT INTO delivery_type (`id_delivery`,`delivery_type`) VALUES (5,'Envío a sucursal de Correo Argentino ');
INSERT INTO delivery_type (`id_delivery`,`delivery_type`) VALUES (6,'Envío a punto pick it');

-- Table: order
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (1,79,3,'enviada',1,'2022-04-20 07:46:48');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (2,76,2,'enviada',1,'2022-04-25 04:11:33');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (3,20,6,'enviada',1,'2022-04-27 06:57:06');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (4,146,5,'enviada',1,'2022-04-29 09:29:47');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (5,44,5,'cancelada',0,'2022-04-30 04:54:04');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (6,44,6,'enviada',1,'2022-04-30 18:19:29');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (7,100,6,'enviada',1,'2022-05-02 04:22:03');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (8,150,2,'enviada',1,'2022-05-03 02:14:27');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (9,62,2,'pausada',1,'2022-05-03 11:03:03');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (10,113,6,'enviada',1,'2022-05-03 22:43:09');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (11,65,2,'enviada',1,'2022-05-04 17:55:57');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (12,97,3,'enviada',1,'2022-05-05 06:12:25');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (13,24,5,'enviada',1,'2022-05-05 12:59:35');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (14,125,1,'enviada',1,'2022-05-08 10:57:07');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (15,75,2,'enviada',1,'2022-05-09 15:17:29');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (16,67,2,'enviada',1,'2022-05-10 15:16:29');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (17,45,1,'enviada',1,'2022-05-11 01:18:22');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (18,117,2,'enviada',1,'2022-05-11 08:38:08');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (19,128,1,'enviada',1,'2022-05-13 06:45:50');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (20,62,1,'enviada',1,'2022-05-14 04:00:28');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (21,35,5,'enviada',1,'2022-05-16 07:56:27');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (22,133,3,'enviada',1,'2022-05-16 14:47:54');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (23,126,2,'enviada',1,'2022-05-17 16:41:24');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (24,91,3,'enviada',1,'2022-05-18 12:16:10');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (25,8,6,'enviada',1,'2022-05-19 05:01:21');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (26,99,6,'enviada',1,'2022-05-21 06:31:34');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (27,80,1,'enviada',1,'2022-05-23 05:36:56');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (28,94,6,'proceso',1,'2022-05-25 23:21:02');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (29,42,5,'proceso',1,'2022-05-25 23:29:58');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (30,65,5,'proceso',1,'2022-05-26 05:20:16');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (31,125,1,'proceso',1,'2022-05-26 13:36:34');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (32,111,1,'proceso',1,'2022-05-27 07:28:27');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (33,110,3,'generada',1,'2022-05-27 11:49:58');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (34,134,6,'proceso',1,'2022-05-27 17:02:06');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (35,34,3,'proceso',1,'2022-05-27 18:53:05');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (36,44,3,'generada',1,'2022-05-29 19:24:52');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (37,122,6,'proceso',1,'2022-05-30 02:18:34');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (38,21,3,'proceso',1,'2022-05-30 05:34:55');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (39,91,2,'generada',1,'2022-05-31 23:15:46');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (40,14,6,'generada',1,'2022-06-01 00:49:10');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (41,150,1,'cancelada',0,'2022-06-01 02:05:21');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (42,107,3,'generada',1,'2022-06-04 08:07:33');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (43,80,5,'generada',1,'2022-06-10 15:32:50');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (44,34,2,'generada',1,'2022-06-11 06:23:11');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (45,23,2,'generada',0,'2022-06-11 18:16:23');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (46,72,5,'generada',1,'2022-06-13 11:53:26');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (47,2,2,'generada',1,'2022-06-14 12:27:15');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (48,110,3,'generada',1,'2022-06-14 13:53:35');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (49,72,6,'generada',0,'2022-06-14 17:47:43');
INSERT INTO `order` (`id_order`,`id_user`,`id_delivery`,`status`,`paid`,`created_at`) VALUES (50,132,5,'generada',1,'2022-06-17 09:19:01');

-- Table: order_detail
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (1,3,3,125.00,5);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (2,9,1,374000.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (3,1,1,450.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (3,3,5,125.00,5);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (3,32,2,5280.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (4,15,1,482000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (4,82,1,17980.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (5,1,1,450.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (6,10,1,412000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (7,26,1,9800.00,10);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (8,1,1,450.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (9,5,1,3560.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (9,9,1,374000.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (10,76,1,6950.00,18);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (11,36,1,258000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (12,3,7,125.00,5);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (13,6,2,473.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (13,31,2,2840.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (14,62,1,14300.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (15,33,2,4860.00,15);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (16,6,2,473.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (16,103,1,11890.00,12);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (17,23,1,58000.00,15);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (18,10,1,412000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (19,3,2,125.00,5);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (20,2,2,4750.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (20,15,1,482000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (20,68,1,4600.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (21,31,2,2840.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (22,1,1,450.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (23,21,1,53000.00,15);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (24,9,1,374000.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (25,16,1,342000.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (26,3,10,125.00,5);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (26,19,1,423000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (27,10,1,412000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (28,26,1,9800.00,10);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (29,21,1,53000.00,15);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (30,1,1,450.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (30,3,4,125.00,5);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (30,33,2,4860.00,15);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (30,67,1,6700.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (31,29,1,25400.00,14);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (32,2,2,4750.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (33,9,1,374000.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (34,60,1,5960.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (35,91,1,3770.00,25);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (36,67,1,6700.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (37,105,1,12900.00,13);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (38,15,1,482000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (38,97,1,2880.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (39,69,1,12400.00,19);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (40,10,1,412000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (41,6,2,473.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (41,21,1,53000.00,15);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (42,41,1,9090.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (43,13,1,475000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (44,67,1,6700.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (45,3,2,125.00,5);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (46,9,1,374000.00,20);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (46,15,1,482000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (47,20,1,42000.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (48,6,2,473.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (48,102,1,24890.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (49,92,1,6280.00,0);
INSERT INTO order_detail (`id_order`,`id_product`,`quantity`,`unit_price`,`discount`) VALUES (50,28,1,19200.00,0);

-- Table: payment_method
INSERT INTO payment_method (`id_p_method`,`payment_method`) VALUES (1,'Tarjeta de débito');
INSERT INTO payment_method (`id_p_method`,`payment_method`) VALUES (2,'Tarjeta de crédito');
INSERT INTO payment_method (`id_p_method`,`payment_method`) VALUES (3,'Mercado pago');
INSERT INTO payment_method (`id_p_method`,`payment_method`) VALUES (4,'Paypal');

-- Table: date
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (1,'2021-01-01',1,'viernes',1,'enero',1,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (2,'2021-01-02',2,'sábado',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (3,'2021-01-03',3,'domingo',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (4,'2021-01-04',4,'lunes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (5,'2021-01-05',5,'martes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (6,'2021-01-06',6,'miércoles',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (7,'2021-01-07',7,'jueves',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (8,'2021-01-08',8,'viernes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (9,'2021-01-09',9,'sábado',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (10,'2021-01-10',10,'domingo',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (11,'2021-01-11',11,'lunes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (12,'2021-01-12',12,'martes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (13,'2021-01-13',13,'miércoles',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (14,'2021-01-14',14,'jueves',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (15,'2021-01-15',15,'viernes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (16,'2021-01-16',16,'sábado',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (17,'2021-01-17',17,'domingo',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (18,'2021-01-18',18,'lunes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (19,'2021-01-19',19,'martes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (20,'2021-01-20',20,'miércoles',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (21,'2021-01-21',21,'jueves',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (22,'2021-01-22',22,'viernes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (23,'2021-01-23',23,'sábado',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (24,'2021-01-24',24,'domingo',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (25,'2021-01-25',25,'lunes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (26,'2021-01-26',26,'martes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (27,'2021-01-27',27,'miércoles',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (28,'2021-01-28',28,'jueves',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (29,'2021-01-29',29,'viernes',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (30,'2021-01-30',30,'sábado',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (31,'2021-01-31',31,'domingo',1,'enero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (32,'2021-02-01',1,'lunes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (33,'2021-02-02',2,'martes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (34,'2021-02-03',3,'miércoles',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (35,'2021-02-04',4,'jueves',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (36,'2021-02-05',5,'viernes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (37,'2021-02-06',6,'sábado',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (38,'2021-02-07',7,'domingo',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (39,'2021-02-08',8,'lunes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (40,'2021-02-09',9,'martes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (41,'2021-02-10',10,'miércoles',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (42,'2021-02-11',11,'jueves',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (43,'2021-02-12',12,'viernes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (44,'2021-02-13',13,'sábado',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (45,'2021-02-14',14,'domingo',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (46,'2021-02-15',15,'lunes',2,'febrero',1,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (47,'2021-02-16',16,'martes',2,'febrero',1,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (48,'2021-02-17',17,'miércoles',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (49,'2021-02-18',18,'jueves',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (50,'2021-02-19',19,'viernes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (51,'2021-02-20',20,'sábado',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (52,'2021-02-21',21,'domingo',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (53,'2021-02-22',22,'lunes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (54,'2021-02-23',23,'martes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (55,'2021-02-24',24,'miércoles',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (56,'2021-02-25',25,'jueves',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (57,'2021-02-26',26,'viernes',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (58,'2021-02-27',27,'sábado',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (59,'2021-02-28',28,'domingo',2,'febrero',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (60,'2021-03-01',1,'lunes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (61,'2021-03-02',2,'martes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (62,'2021-03-03',3,'miércoles',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (63,'2021-03-04',4,'jueves',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (64,'2021-03-05',5,'viernes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (65,'2021-03-06',6,'sábado',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (66,'2021-03-07',7,'domingo',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (67,'2021-03-08',8,'lunes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (68,'2021-03-09',9,'martes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (69,'2021-03-10',10,'miércoles',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (70,'2021-03-11',11,'jueves',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (71,'2021-03-12',12,'viernes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (72,'2021-03-13',13,'sábado',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (73,'2021-03-14',14,'domingo',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (74,'2021-03-15',15,'lunes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (75,'2021-03-16',16,'martes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (76,'2021-03-17',17,'miércoles',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (77,'2021-03-18',18,'jueves',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (78,'2021-03-19',19,'viernes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (79,'2021-03-20',20,'sábado',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (80,'2021-03-21',21,'domingo',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (81,'2021-03-22',22,'lunes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (82,'2021-03-23',23,'martes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (83,'2021-03-24',24,'miércoles',3,'marzo',1,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (84,'2021-03-25',25,'jueves',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (85,'2021-03-26',26,'viernes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (86,'2021-03-27',27,'sábado',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (87,'2021-03-28',28,'domingo',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (88,'2021-03-29',29,'lunes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (89,'2021-03-30',30,'martes',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (90,'2021-03-31',31,'miércoles',3,'marzo',1,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (91,'2021-04-01',1,'jueves',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (92,'2021-04-02',2,'viernes',4,'abril',2,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (93,'2021-04-03',3,'sábado',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (94,'2021-04-04',4,'domingo',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (95,'2021-04-05',5,'lunes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (96,'2021-04-06',6,'martes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (97,'2021-04-07',7,'miércoles',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (98,'2021-04-08',8,'jueves',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (99,'2021-04-09',9,'viernes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (100,'2021-04-10',10,'sábado',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (101,'2021-04-11',11,'domingo',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (102,'2021-04-12',12,'lunes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (103,'2021-04-13',13,'martes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (104,'2021-04-14',14,'miércoles',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (105,'2021-04-15',15,'jueves',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (106,'2021-04-16',16,'viernes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (107,'2021-04-17',17,'sábado',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (108,'2021-04-18',18,'domingo',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (109,'2021-04-19',19,'lunes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (110,'2021-04-20',20,'martes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (111,'2021-04-21',21,'miércoles',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (112,'2021-04-22',22,'jueves',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (113,'2021-04-23',23,'viernes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (114,'2021-04-24',24,'sábado',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (115,'2021-04-25',25,'domingo',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (116,'2021-04-26',26,'lunes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (117,'2021-04-27',27,'martes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (118,'2021-04-28',28,'miércoles',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (119,'2021-04-29',29,'jueves',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (120,'2021-04-30',30,'viernes',4,'abril',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (121,'2021-05-01',1,'sábado',5,'mayo',2,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (122,'2021-05-02',2,'domingo',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (123,'2021-05-03',3,'lunes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (124,'2021-05-04',4,'martes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (125,'2021-05-05',5,'miércoles',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (126,'2021-05-06',6,'jueves',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (127,'2021-05-07',7,'viernes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (128,'2021-05-08',8,'sábado',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (129,'2021-05-09',9,'domingo',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (130,'2021-05-10',10,'lunes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (131,'2021-05-11',11,'martes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (132,'2021-05-12',12,'miércoles',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (133,'2021-05-13',13,'jueves',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (134,'2021-05-14',14,'viernes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (135,'2021-05-15',15,'sábado',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (136,'2021-05-16',16,'domingo',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (137,'2021-05-17',17,'lunes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (138,'2021-05-18',18,'martes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (139,'2021-05-19',19,'miércoles',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (140,'2021-05-20',20,'jueves',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (141,'2021-05-21',21,'viernes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (142,'2021-05-22',22,'sábado',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (143,'2021-05-23',23,'domingo',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (144,'2021-05-24',24,'lunes',5,'mayo',2,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (145,'2021-05-25',25,'martes',5,'mayo',2,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (146,'2021-05-26',26,'miércoles',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (147,'2021-05-27',27,'jueves',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (148,'2021-05-28',28,'viernes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (149,'2021-05-29',29,'sábado',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (150,'2021-05-30',30,'domingo',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (151,'2021-05-31',31,'lunes',5,'mayo',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (152,'2021-06-01',1,'martes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (153,'2021-06-02',2,'miércoles',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (154,'2021-06-03',3,'jueves',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (155,'2021-06-04',4,'viernes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (156,'2021-06-05',5,'sábado',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (157,'2021-06-06',6,'domingo',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (158,'2021-06-07',7,'lunes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (159,'2021-06-08',8,'martes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (160,'2021-06-09',9,'miércoles',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (161,'2021-06-10',10,'jueves',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (162,'2021-06-11',11,'viernes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (163,'2021-06-12',12,'sábado',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (164,'2021-06-13',13,'domingo',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (165,'2021-06-14',14,'lunes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (166,'2021-06-15',15,'martes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (167,'2021-06-16',16,'miércoles',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (168,'2021-06-17',17,'jueves',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (169,'2021-06-18',18,'viernes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (170,'2021-06-19',19,'sábado',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (171,'2021-06-20',20,'domingo',6,'junio',2,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (172,'2021-06-21',21,'lunes',6,'junio',2,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (173,'2021-06-22',22,'martes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (174,'2021-06-23',23,'miércoles',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (175,'2021-06-24',24,'jueves',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (176,'2021-06-25',25,'viernes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (177,'2021-06-26',26,'sábado',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (178,'2021-06-27',27,'domingo',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (179,'2021-06-28',28,'lunes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (180,'2021-06-29',29,'martes',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (181,'2021-06-30',30,'miércoles',6,'junio',2,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (182,'2021-07-01',1,'jueves',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (183,'2021-07-02',2,'viernes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (184,'2021-07-03',3,'sábado',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (185,'2021-07-04',4,'domingo',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (186,'2021-07-05',5,'lunes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (187,'2021-07-06',6,'martes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (188,'2021-07-07',7,'miércoles',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (189,'2021-07-08',8,'jueves',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (190,'2021-07-09',9,'viernes',7,'julio',3,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (191,'2021-07-10',10,'sábado',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (192,'2021-07-11',11,'domingo',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (193,'2021-07-12',12,'lunes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (194,'2021-07-13',13,'martes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (195,'2021-07-14',14,'miércoles',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (196,'2021-07-15',15,'jueves',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (197,'2021-07-16',16,'viernes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (198,'2021-07-17',17,'sábado',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (199,'2021-07-18',18,'domingo',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (200,'2021-07-19',19,'lunes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (201,'2021-07-20',20,'martes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (202,'2021-07-21',21,'miércoles',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (203,'2021-07-22',22,'jueves',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (204,'2021-07-23',23,'viernes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (205,'2021-07-24',24,'sábado',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (206,'2021-07-25',25,'domingo',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (207,'2021-07-26',26,'lunes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (208,'2021-07-27',27,'martes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (209,'2021-07-28',28,'miércoles',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (210,'2021-07-29',29,'jueves',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (211,'2021-07-30',30,'viernes',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (212,'2021-07-31',31,'sábado',7,'julio',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (213,'2021-08-01',1,'domingo',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (214,'2021-08-02',2,'lunes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (215,'2021-08-03',3,'martes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (216,'2021-08-04',4,'miércoles',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (217,'2021-08-05',5,'jueves',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (218,'2021-08-06',6,'viernes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (219,'2021-08-07',7,'sábado',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (220,'2021-08-08',8,'domingo',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (221,'2021-08-09',9,'lunes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (222,'2021-08-10',10,'martes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (223,'2021-08-11',11,'miércoles',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (224,'2021-08-12',12,'jueves',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (225,'2021-08-13',13,'viernes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (226,'2021-08-14',14,'sábado',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (227,'2021-08-15',15,'domingo',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (228,'2021-08-16',16,'lunes',8,'agosto',3,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (229,'2021-08-17',17,'martes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (230,'2021-08-18',18,'miércoles',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (231,'2021-08-19',19,'jueves',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (232,'2021-08-20',20,'viernes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (233,'2021-08-21',21,'sábado',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (234,'2021-08-22',22,'domingo',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (235,'2021-08-23',23,'lunes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (236,'2021-08-24',24,'martes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (237,'2021-08-25',25,'miércoles',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (238,'2021-08-26',26,'jueves',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (239,'2021-08-27',27,'viernes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (240,'2021-08-28',28,'sábado',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (241,'2021-08-29',29,'domingo',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (242,'2021-08-30',30,'lunes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (243,'2021-08-31',31,'martes',8,'agosto',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (244,'2021-09-01',1,'miércoles',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (245,'2021-09-02',2,'jueves',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (246,'2021-09-03',3,'viernes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (247,'2021-09-04',4,'sábado',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (248,'2021-09-05',5,'domingo',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (249,'2021-09-06',6,'lunes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (250,'2021-09-07',7,'martes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (251,'2021-09-08',8,'miércoles',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (252,'2021-09-09',9,'jueves',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (253,'2021-09-10',10,'viernes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (254,'2021-09-11',11,'sábado',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (255,'2021-09-12',12,'domingo',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (256,'2021-09-13',13,'lunes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (257,'2021-09-14',14,'martes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (258,'2021-09-15',15,'miércoles',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (259,'2021-09-16',16,'jueves',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (260,'2021-09-17',17,'viernes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (261,'2021-09-18',18,'sábado',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (262,'2021-09-19',19,'domingo',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (263,'2021-09-20',20,'lunes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (264,'2021-09-21',21,'martes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (265,'2021-09-22',22,'miércoles',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (266,'2021-09-23',23,'jueves',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (267,'2021-09-24',24,'viernes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (268,'2021-09-25',25,'sábado',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (269,'2021-09-26',26,'domingo',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (270,'2021-09-27',27,'lunes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (271,'2021-09-28',28,'martes',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (272,'2021-09-29',29,'miércoles',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (273,'2021-09-30',30,'jueves',9,'septiembre',3,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (274,'2021-10-01',1,'viernes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (275,'2021-10-02',2,'sábado',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (276,'2021-10-03',3,'domingo',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (277,'2021-10-04',4,'lunes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (278,'2021-10-05',5,'martes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (279,'2021-10-06',6,'miércoles',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (280,'2021-10-07',7,'jueves',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (281,'2021-10-08',8,'viernes',10,'octubre',4,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (282,'2021-10-09',9,'sábado',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (283,'2021-10-10',10,'domingo',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (284,'2021-10-11',11,'lunes',10,'octubre',4,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (285,'2021-10-12',12,'martes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (286,'2021-10-13',13,'miércoles',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (287,'2021-10-14',14,'jueves',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (288,'2021-10-15',15,'viernes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (289,'2021-10-16',16,'sábado',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (290,'2021-10-17',17,'domingo',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (291,'2021-10-18',18,'lunes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (292,'2021-10-19',19,'martes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (293,'2021-10-20',20,'miércoles',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (294,'2021-10-21',21,'jueves',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (295,'2021-10-22',22,'viernes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (296,'2021-10-23',23,'sábado',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (297,'2021-10-24',24,'domingo',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (298,'2021-10-25',25,'lunes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (299,'2021-10-26',26,'martes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (300,'2021-10-27',27,'miércoles',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (301,'2021-10-28',28,'jueves',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (302,'2021-10-29',29,'viernes',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (303,'2021-10-30',30,'sábado',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (304,'2021-10-31',31,'domingo',10,'octubre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (305,'2021-11-01',1,'lunes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (306,'2021-11-02',2,'martes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (307,'2021-11-03',3,'miércoles',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (308,'2021-11-04',4,'jueves',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (309,'2021-11-05',5,'viernes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (310,'2021-11-06',6,'sábado',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (311,'2021-11-07',7,'domingo',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (312,'2021-11-08',8,'lunes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (313,'2021-11-09',9,'martes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (314,'2021-11-10',10,'miércoles',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (315,'2021-11-11',11,'jueves',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (316,'2021-11-12',12,'viernes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (317,'2021-11-13',13,'sábado',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (318,'2021-11-14',14,'domingo',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (319,'2021-11-15',15,'lunes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (320,'2021-11-16',16,'martes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (321,'2021-11-17',17,'miércoles',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (322,'2021-11-18',18,'jueves',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (323,'2021-11-19',19,'viernes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (324,'2021-11-20',20,'sábado',11,'noviembre',4,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (325,'2021-11-21',21,'domingo',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (326,'2021-11-22',22,'lunes',11,'noviembre',4,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (327,'2021-11-23',23,'martes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (328,'2021-11-24',24,'miércoles',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (329,'2021-11-25',25,'jueves',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (330,'2021-11-26',26,'viernes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (331,'2021-11-27',27,'sábado',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (332,'2021-11-28',28,'domingo',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (333,'2021-11-29',29,'lunes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (334,'2021-11-30',30,'martes',11,'noviembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (335,'2021-12-01',1,'miércoles',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (336,'2021-12-02',2,'jueves',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (337,'2021-12-03',3,'viernes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (338,'2021-12-04',4,'sábado',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (339,'2021-12-05',5,'domingo',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (340,'2021-12-06',6,'lunes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (341,'2021-12-07',7,'martes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (342,'2021-12-08',8,'miércoles',12,'diciembre',4,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (343,'2021-12-09',9,'jueves',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (344,'2021-12-10',10,'viernes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (345,'2021-12-11',11,'sábado',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (346,'2021-12-12',12,'domingo',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (347,'2021-12-13',13,'lunes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (348,'2021-12-14',14,'martes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (349,'2021-12-15',15,'miércoles',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (350,'2021-12-16',16,'jueves',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (351,'2021-12-17',17,'viernes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (352,'2021-12-18',18,'sábado',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (353,'2021-12-19',19,'domingo',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (354,'2021-12-20',20,'lunes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (355,'2021-12-21',21,'martes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (356,'2021-12-22',22,'miércoles',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (357,'2021-12-23',23,'jueves',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (358,'2021-12-24',24,'viernes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (359,'2021-12-25',25,'sábado',12,'diciembre',4,2021,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (360,'2021-12-26',26,'domingo',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (361,'2021-12-27',27,'lunes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (362,'2021-12-28',28,'martes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (363,'2021-12-29',29,'miércoles',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (364,'2021-12-30',30,'jueves',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (365,'2021-12-31',31,'viernes',12,'diciembre',4,2021,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (366,'2022-01-01',1,'sábado',1,'enero',1,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (367,'2022-01-02',2,'domingo',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (368,'2022-01-03',3,'lunes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (369,'2022-01-04',4,'martes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (370,'2022-01-05',5,'miércoles',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (371,'2022-01-06',6,'jueves',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (372,'2022-01-07',7,'viernes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (373,'2022-01-08',8,'sábado',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (374,'2022-01-09',9,'domingo',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (375,'2022-01-10',10,'lunes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (376,'2022-01-11',11,'martes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (377,'2022-01-12',12,'miércoles',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (378,'2022-01-13',13,'jueves',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (379,'2022-01-14',14,'viernes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (380,'2022-01-15',15,'sábado',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (381,'2022-01-16',16,'domingo',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (382,'2022-01-17',17,'lunes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (383,'2022-01-18',18,'martes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (384,'2022-01-19',19,'miércoles',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (385,'2022-01-20',20,'jueves',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (386,'2022-01-21',21,'viernes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (387,'2022-01-22',22,'sábado',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (388,'2022-01-23',23,'domingo',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (389,'2022-01-24',24,'lunes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (390,'2022-01-25',25,'martes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (391,'2022-01-26',26,'miércoles',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (392,'2022-01-27',27,'jueves',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (393,'2022-01-28',28,'viernes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (394,'2022-01-29',29,'sábado',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (395,'2022-01-30',30,'domingo',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (396,'2022-01-31',31,'lunes',1,'enero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (397,'2022-02-01',1,'martes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (398,'2022-02-02',2,'miércoles',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (399,'2022-02-03',3,'jueves',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (400,'2022-02-04',4,'viernes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (401,'2022-02-05',5,'sábado',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (402,'2022-02-06',6,'domingo',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (403,'2022-02-07',7,'lunes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (404,'2022-02-08',8,'martes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (405,'2022-02-09',9,'miércoles',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (406,'2022-02-10',10,'jueves',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (407,'2022-02-11',11,'viernes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (408,'2022-02-12',12,'sábado',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (409,'2022-02-13',13,'domingo',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (410,'2022-02-14',14,'lunes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (411,'2022-02-15',15,'martes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (412,'2022-02-16',16,'miércoles',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (413,'2022-02-17',17,'jueves',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (414,'2022-02-18',18,'viernes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (415,'2022-02-19',19,'sábado',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (416,'2022-02-20',20,'domingo',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (417,'2022-02-21',21,'lunes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (418,'2022-02-22',22,'martes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (419,'2022-02-23',23,'miércoles',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (420,'2022-02-24',24,'jueves',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (421,'2022-02-25',25,'viernes',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (422,'2022-02-26',26,'sábado',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (423,'2022-02-27',27,'domingo',2,'febrero',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (424,'2022-02-28',28,'lunes',2,'febrero',1,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (425,'2022-03-01',1,'martes',3,'marzo',1,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (426,'2022-03-02',2,'miércoles',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (427,'2022-03-03',3,'jueves',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (428,'2022-03-04',4,'viernes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (429,'2022-03-05',5,'sábado',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (430,'2022-03-06',6,'domingo',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (431,'2022-03-07',7,'lunes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (432,'2022-03-08',8,'martes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (433,'2022-03-09',9,'miércoles',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (434,'2022-03-10',10,'jueves',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (435,'2022-03-11',11,'viernes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (436,'2022-03-12',12,'sábado',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (437,'2022-03-13',13,'domingo',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (438,'2022-03-14',14,'lunes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (439,'2022-03-15',15,'martes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (440,'2022-03-16',16,'miércoles',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (441,'2022-03-17',17,'jueves',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (442,'2022-03-18',18,'viernes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (443,'2022-03-19',19,'sábado',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (444,'2022-03-20',20,'domingo',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (445,'2022-03-21',21,'lunes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (446,'2022-03-22',22,'martes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (447,'2022-03-23',23,'miércoles',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (448,'2022-03-24',24,'jueves',3,'marzo',1,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (449,'2022-03-25',25,'viernes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (450,'2022-03-26',26,'sábado',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (451,'2022-03-27',27,'domingo',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (452,'2022-03-28',28,'lunes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (453,'2022-03-29',29,'martes',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (454,'2022-03-30',30,'miércoles',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (455,'2022-03-31',31,'jueves',3,'marzo',1,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (456,'2022-04-01',1,'viernes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (457,'2022-04-02',2,'sábado',4,'abril',2,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (458,'2022-04-03',3,'domingo',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (459,'2022-04-04',4,'lunes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (460,'2022-04-05',5,'martes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (461,'2022-04-06',6,'miércoles',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (462,'2022-04-07',7,'jueves',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (463,'2022-04-08',8,'viernes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (464,'2022-04-09',9,'sábado',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (465,'2022-04-10',10,'domingo',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (466,'2022-04-11',11,'lunes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (467,'2022-04-12',12,'martes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (468,'2022-04-13',13,'miércoles',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (469,'2022-04-14',14,'jueves',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (470,'2022-04-15',15,'viernes',4,'abril',2,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (471,'2022-04-16',16,'sábado',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (472,'2022-04-17',17,'domingo',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (473,'2022-04-18',18,'lunes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (474,'2022-04-19',19,'martes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (475,'2022-04-20',20,'miércoles',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (476,'2022-04-21',21,'jueves',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (477,'2022-04-22',22,'viernes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (478,'2022-04-23',23,'sábado',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (479,'2022-04-24',24,'domingo',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (480,'2022-04-25',25,'lunes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (481,'2022-04-26',26,'martes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (482,'2022-04-27',27,'miércoles',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (483,'2022-04-28',28,'jueves',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (484,'2022-04-29',29,'viernes',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (485,'2022-04-30',30,'sábado',4,'abril',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (486,'2022-05-01',1,'domingo',5,'mayo',2,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (487,'2022-05-02',2,'lunes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (488,'2022-05-03',3,'martes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (489,'2022-05-04',4,'miércoles',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (490,'2022-05-05',5,'jueves',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (491,'2022-05-06',6,'viernes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (492,'2022-05-07',7,'sábado',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (493,'2022-05-08',8,'domingo',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (494,'2022-05-09',9,'lunes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (495,'2022-05-10',10,'martes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (496,'2022-05-11',11,'miércoles',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (497,'2022-05-12',12,'jueves',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (498,'2022-05-13',13,'viernes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (499,'2022-05-14',14,'sábado',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (500,'2022-05-15',15,'domingo',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (501,'2022-05-16',16,'lunes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (502,'2022-05-17',17,'martes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (503,'2022-05-18',18,'miércoles',5,'mayo',2,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (504,'2022-05-19',19,'jueves',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (505,'2022-05-20',20,'viernes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (506,'2022-05-21',21,'sábado',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (507,'2022-05-22',22,'domingo',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (508,'2022-05-23',23,'lunes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (509,'2022-05-24',24,'martes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (510,'2022-05-25',25,'miércoles',5,'mayo',2,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (511,'2022-05-26',26,'jueves',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (512,'2022-05-27',27,'viernes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (513,'2022-05-28',28,'sábado',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (514,'2022-05-29',29,'domingo',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (515,'2022-05-30',30,'lunes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (516,'2022-05-31',31,'martes',5,'mayo',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (517,'2022-06-01',1,'miércoles',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (518,'2022-06-02',2,'jueves',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (519,'2022-06-03',3,'viernes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (520,'2022-06-04',4,'sábado',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (521,'2022-06-05',5,'domingo',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (522,'2022-06-06',6,'lunes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (523,'2022-06-07',7,'martes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (524,'2022-06-08',8,'miércoles',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (525,'2022-06-09',9,'jueves',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (526,'2022-06-10',10,'viernes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (527,'2022-06-11',11,'sábado',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (528,'2022-06-12',12,'domingo',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (529,'2022-06-13',13,'lunes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (530,'2022-06-14',14,'martes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (531,'2022-06-15',15,'miércoles',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (532,'2022-06-16',16,'jueves',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (533,'2022-06-17',17,'viernes',6,'junio',2,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (534,'2022-06-18',18,'sábado',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (535,'2022-06-19',19,'domingo',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (536,'2022-06-20',20,'lunes',6,'junio',2,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (537,'2022-06-21',21,'martes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (538,'2022-06-22',22,'miércoles',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (539,'2022-06-23',23,'jueves',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (540,'2022-06-24',24,'viernes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (541,'2022-06-25',25,'sábado',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (542,'2022-06-26',26,'domingo',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (543,'2022-06-27',27,'lunes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (544,'2022-06-28',28,'martes',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (545,'2022-06-29',29,'miércoles',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (546,'2022-06-30',30,'jueves',6,'junio',2,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (547,'2022-07-01',1,'viernes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (548,'2022-07-02',2,'sábado',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (549,'2022-07-03',3,'domingo',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (550,'2022-07-04',4,'lunes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (551,'2022-07-05',5,'martes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (552,'2022-07-06',6,'miércoles',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (553,'2022-07-07',7,'jueves',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (554,'2022-07-08',8,'viernes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (555,'2022-07-09',9,'sábado',7,'julio',3,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (556,'2022-07-10',10,'domingo',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (557,'2022-07-11',11,'lunes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (558,'2022-07-12',12,'martes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (559,'2022-07-13',13,'miércoles',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (560,'2022-07-14',14,'jueves',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (561,'2022-07-15',15,'viernes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (562,'2022-07-16',16,'sábado',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (563,'2022-07-17',17,'domingo',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (564,'2022-07-18',18,'lunes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (565,'2022-07-19',19,'martes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (566,'2022-07-20',20,'miércoles',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (567,'2022-07-21',21,'jueves',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (568,'2022-07-22',22,'viernes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (569,'2022-07-23',23,'sábado',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (570,'2022-07-24',24,'domingo',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (571,'2022-07-25',25,'lunes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (572,'2022-07-26',26,'martes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (573,'2022-07-27',27,'miércoles',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (574,'2022-07-28',28,'jueves',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (575,'2022-07-29',29,'viernes',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (576,'2022-07-30',30,'sábado',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (577,'2022-07-31',31,'domingo',7,'julio',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (578,'2022-08-01',1,'lunes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (579,'2022-08-02',2,'martes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (580,'2022-08-03',3,'miércoles',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (581,'2022-08-04',4,'jueves',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (582,'2022-08-05',5,'viernes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (583,'2022-08-06',6,'sábado',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (584,'2022-08-07',7,'domingo',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (585,'2022-08-08',8,'lunes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (586,'2022-08-09',9,'martes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (587,'2022-08-10',10,'miércoles',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (588,'2022-08-11',11,'jueves',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (589,'2022-08-12',12,'viernes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (590,'2022-08-13',13,'sábado',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (591,'2022-08-14',14,'domingo',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (592,'2022-08-15',15,'lunes',8,'agosto',3,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (593,'2022-08-16',16,'martes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (594,'2022-08-17',17,'miércoles',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (595,'2022-08-18',18,'jueves',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (596,'2022-08-19',19,'viernes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (597,'2022-08-20',20,'sábado',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (598,'2022-08-21',21,'domingo',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (599,'2022-08-22',22,'lunes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (600,'2022-08-23',23,'martes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (601,'2022-08-24',24,'miércoles',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (602,'2022-08-25',25,'jueves',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (603,'2022-08-26',26,'viernes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (604,'2022-08-27',27,'sábado',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (605,'2022-08-28',28,'domingo',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (606,'2022-08-29',29,'lunes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (607,'2022-08-30',30,'martes',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (608,'2022-08-31',31,'miércoles',8,'agosto',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (609,'2022-09-01',1,'jueves',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (610,'2022-09-02',2,'viernes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (611,'2022-09-03',3,'sábado',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (612,'2022-09-04',4,'domingo',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (613,'2022-09-05',5,'lunes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (614,'2022-09-06',6,'martes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (615,'2022-09-07',7,'miércoles',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (616,'2022-09-08',8,'jueves',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (617,'2022-09-09',9,'viernes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (618,'2022-09-10',10,'sábado',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (619,'2022-09-11',11,'domingo',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (620,'2022-09-12',12,'lunes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (621,'2022-09-13',13,'martes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (622,'2022-09-14',14,'miércoles',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (623,'2022-09-15',15,'jueves',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (624,'2022-09-16',16,'viernes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (625,'2022-09-17',17,'sábado',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (626,'2022-09-18',18,'domingo',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (627,'2022-09-19',19,'lunes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (628,'2022-09-20',20,'martes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (629,'2022-09-21',21,'miércoles',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (630,'2022-09-22',22,'jueves',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (631,'2022-09-23',23,'viernes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (632,'2022-09-24',24,'sábado',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (633,'2022-09-25',25,'domingo',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (634,'2022-09-26',26,'lunes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (635,'2022-09-27',27,'martes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (636,'2022-09-28',28,'miércoles',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (637,'2022-09-29',29,'jueves',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (638,'2022-09-30',30,'viernes',9,'septiembre',3,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (639,'2022-10-01',1,'sábado',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (640,'2022-10-02',2,'domingo',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (641,'2022-10-03',3,'lunes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (642,'2022-10-04',4,'martes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (643,'2022-10-05',5,'miércoles',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (644,'2022-10-06',6,'jueves',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (645,'2022-10-07',7,'viernes',10,'octubre',4,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (646,'2022-10-08',8,'sábado',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (647,'2022-10-09',9,'domingo',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (648,'2022-10-10',10,'lunes',10,'octubre',4,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (649,'2022-10-11',11,'martes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (650,'2022-10-12',12,'miércoles',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (651,'2022-10-13',13,'jueves',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (652,'2022-10-14',14,'viernes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (653,'2022-10-15',15,'sábado',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (654,'2022-10-16',16,'domingo',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (655,'2022-10-17',17,'lunes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (656,'2022-10-18',18,'martes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (657,'2022-10-19',19,'miércoles',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (658,'2022-10-20',20,'jueves',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (659,'2022-10-21',21,'viernes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (660,'2022-10-22',22,'sábado',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (661,'2022-10-23',23,'domingo',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (662,'2022-10-24',24,'lunes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (663,'2022-10-25',25,'martes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (664,'2022-10-26',26,'miércoles',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (665,'2022-10-27',27,'jueves',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (666,'2022-10-28',28,'viernes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (667,'2022-10-29',29,'sábado',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (668,'2022-10-30',30,'domingo',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (669,'2022-10-31',31,'lunes',10,'octubre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (670,'2022-11-01',1,'martes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (671,'2022-11-02',2,'miércoles',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (672,'2022-11-03',3,'jueves',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (673,'2022-11-04',4,'viernes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (674,'2022-11-05',5,'sábado',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (675,'2022-11-06',6,'domingo',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (676,'2022-11-07',7,'lunes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (677,'2022-11-08',8,'martes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (678,'2022-11-09',9,'miércoles',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (679,'2022-11-10',10,'jueves',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (680,'2022-11-11',11,'viernes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (681,'2022-11-12',12,'sábado',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (682,'2022-11-13',13,'domingo',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (683,'2022-11-14',14,'lunes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (684,'2022-11-15',15,'martes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (685,'2022-11-16',16,'miércoles',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (686,'2022-11-17',17,'jueves',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (687,'2022-11-18',18,'viernes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (688,'2022-11-19',19,'sábado',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (689,'2022-11-20',20,'domingo',11,'noviembre',4,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (690,'2022-11-21',21,'lunes',11,'noviembre',4,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (691,'2022-11-22',22,'martes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (692,'2022-11-23',23,'miércoles',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (693,'2022-11-24',24,'jueves',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (694,'2022-11-25',25,'viernes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (695,'2022-11-26',26,'sábado',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (696,'2022-11-27',27,'domingo',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (697,'2022-11-28',28,'lunes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (698,'2022-11-29',29,'martes',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (699,'2022-11-30',30,'miércoles',11,'noviembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (700,'2022-12-01',1,'jueves',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (701,'2022-12-02',2,'viernes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (702,'2022-12-03',3,'sábado',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (703,'2022-12-04',4,'domingo',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (704,'2022-12-05',5,'lunes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (705,'2022-12-06',6,'martes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (706,'2022-12-07',7,'miércoles',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (707,'2022-12-08',8,'jueves',12,'diciembre',4,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (708,'2022-12-09',9,'viernes',12,'diciembre',4,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (709,'2022-12-10',10,'sábado',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (710,'2022-12-11',11,'domingo',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (711,'2022-12-12',12,'lunes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (712,'2022-12-13',13,'martes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (713,'2022-12-14',14,'miércoles',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (714,'2022-12-15',15,'jueves',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (715,'2022-12-16',16,'viernes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (716,'2022-12-17',17,'sábado',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (717,'2022-12-18',18,'domingo',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (718,'2022-12-19',19,'lunes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (719,'2022-12-20',20,'martes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (720,'2022-12-21',21,'miércoles',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (721,'2022-12-22',22,'jueves',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (722,'2022-12-23',23,'viernes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (723,'2022-12-24',24,'sábado',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (724,'2022-12-25',25,'domingo',12,'diciembre',4,2022,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (725,'2022-12-26',26,'lunes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (726,'2022-12-27',27,'martes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (727,'2022-12-28',28,'miércoles',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (728,'2022-12-29',29,'jueves',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (729,'2022-12-30',30,'viernes',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (730,'2022-12-31',31,'sábado',12,'diciembre',4,2022,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (731,'2023-01-01',1,'domingo',1,'enero',1,2023,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (732,'2023-01-02',2,'lunes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (733,'2023-01-03',3,'martes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (734,'2023-01-04',4,'miércoles',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (735,'2023-01-05',5,'jueves',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (736,'2023-01-06',6,'viernes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (737,'2023-01-07',7,'sábado',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (738,'2023-01-08',8,'domingo',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (739,'2023-01-09',9,'lunes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (740,'2023-01-10',10,'martes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (741,'2023-01-11',11,'miércoles',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (742,'2023-01-12',12,'jueves',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (743,'2023-01-13',13,'viernes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (744,'2023-01-14',14,'sábado',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (745,'2023-01-15',15,'domingo',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (746,'2023-01-16',16,'lunes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (747,'2023-01-17',17,'martes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (748,'2023-01-18',18,'miércoles',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (749,'2023-01-19',19,'jueves',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (750,'2023-01-20',20,'viernes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (751,'2023-01-21',21,'sábado',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (752,'2023-01-22',22,'domingo',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (753,'2023-01-23',23,'lunes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (754,'2023-01-24',24,'martes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (755,'2023-01-25',25,'miércoles',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (756,'2023-01-26',26,'jueves',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (757,'2023-01-27',27,'viernes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (758,'2023-01-28',28,'sábado',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (759,'2023-01-29',29,'domingo',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (760,'2023-01-30',30,'lunes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (761,'2023-01-31',31,'martes',1,'enero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (762,'2023-02-01',1,'miércoles',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (763,'2023-02-02',2,'jueves',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (764,'2023-02-03',3,'viernes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (765,'2023-02-04',4,'sábado',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (766,'2023-02-05',5,'domingo',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (767,'2023-02-06',6,'lunes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (768,'2023-02-07',7,'martes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (769,'2023-02-08',8,'miércoles',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (770,'2023-02-09',9,'jueves',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (771,'2023-02-10',10,'viernes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (772,'2023-02-11',11,'sábado',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (773,'2023-02-12',12,'domingo',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (774,'2023-02-13',13,'lunes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (775,'2023-02-14',14,'martes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (776,'2023-02-15',15,'miércoles',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (777,'2023-02-16',16,'jueves',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (778,'2023-02-17',17,'viernes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (779,'2023-02-18',18,'sábado',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (780,'2023-02-19',19,'domingo',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (781,'2023-02-20',20,'lunes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (782,'2023-02-21',21,'martes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (783,'2023-02-22',22,'miércoles',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (784,'2023-02-23',23,'jueves',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (785,'2023-02-24',24,'viernes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (786,'2023-02-25',25,'sábado',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (787,'2023-02-26',26,'domingo',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (788,'2023-02-27',27,'lunes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (789,'2023-02-28',28,'martes',2,'febrero',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (790,'2023-03-01',1,'miércoles',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (791,'2023-03-02',2,'jueves',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (792,'2023-03-03',3,'viernes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (793,'2023-03-04',4,'sábado',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (794,'2023-03-05',5,'domingo',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (795,'2023-03-06',6,'lunes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (796,'2023-03-07',7,'martes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (797,'2023-03-08',8,'miércoles',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (798,'2023-03-09',9,'jueves',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (799,'2023-03-10',10,'viernes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (800,'2023-03-11',11,'sábado',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (801,'2023-03-12',12,'domingo',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (802,'2023-03-13',13,'lunes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (803,'2023-03-14',14,'martes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (804,'2023-03-15',15,'miércoles',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (805,'2023-03-16',16,'jueves',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (806,'2023-03-17',17,'viernes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (807,'2023-03-18',18,'sábado',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (808,'2023-03-19',19,'domingo',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (809,'2023-03-20',20,'lunes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (810,'2023-03-21',21,'martes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (811,'2023-03-22',22,'miércoles',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (812,'2023-03-23',23,'jueves',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (813,'2023-03-24',24,'viernes',3,'marzo',1,2023,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (814,'2023-03-25',25,'sábado',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (815,'2023-03-26',26,'domingo',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (816,'2023-03-27',27,'lunes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (817,'2023-03-28',28,'martes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (818,'2023-03-29',29,'miércoles',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (819,'2023-03-30',30,'jueves',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (820,'2023-03-31',31,'viernes',3,'marzo',1,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (821,'2023-04-01',1,'sábado',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (822,'2023-04-02',2,'domingo',4,'abril',2,2023,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (823,'2023-04-03',3,'lunes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (824,'2023-04-04',4,'martes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (825,'2023-04-05',5,'miércoles',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (826,'2023-04-06',6,'jueves',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (827,'2023-04-07',7,'viernes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (828,'2023-04-08',8,'sábado',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (829,'2023-04-09',9,'domingo',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (830,'2023-04-10',10,'lunes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (831,'2023-04-11',11,'martes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (832,'2023-04-12',12,'miércoles',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (833,'2023-04-13',13,'jueves',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (834,'2023-04-14',14,'viernes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (835,'2023-04-15',15,'sábado',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (836,'2023-04-16',16,'domingo',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (837,'2023-04-17',17,'lunes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (838,'2023-04-18',18,'martes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (839,'2023-04-19',19,'miércoles',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (840,'2023-04-20',20,'jueves',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (841,'2023-04-21',21,'viernes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (842,'2023-04-22',22,'sábado',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (843,'2023-04-23',23,'domingo',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (844,'2023-04-24',24,'lunes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (845,'2023-04-25',25,'martes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (846,'2023-04-26',26,'miércoles',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (847,'2023-04-27',27,'jueves',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (848,'2023-04-28',28,'viernes',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (849,'2023-04-29',29,'sábado',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (850,'2023-04-30',30,'domingo',4,'abril',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (851,'2023-05-01',1,'lunes',5,'mayo',2,2023,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (852,'2023-05-02',2,'martes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (853,'2023-05-03',3,'miércoles',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (854,'2023-05-04',4,'jueves',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (855,'2023-05-05',5,'viernes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (856,'2023-05-06',6,'sábado',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (857,'2023-05-07',7,'domingo',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (858,'2023-05-08',8,'lunes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (859,'2023-05-09',9,'martes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (860,'2023-05-10',10,'miércoles',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (861,'2023-05-11',11,'jueves',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (862,'2023-05-12',12,'viernes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (863,'2023-05-13',13,'sábado',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (864,'2023-05-14',14,'domingo',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (865,'2023-05-15',15,'lunes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (866,'2023-05-16',16,'martes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (867,'2023-05-17',17,'miércoles',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (868,'2023-05-18',18,'jueves',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (869,'2023-05-19',19,'viernes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (870,'2023-05-20',20,'sábado',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (871,'2023-05-21',21,'domingo',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (872,'2023-05-22',22,'lunes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (873,'2023-05-23',23,'martes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (874,'2023-05-24',24,'miércoles',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (875,'2023-05-25',25,'jueves',5,'mayo',2,2023,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (876,'2023-05-26',26,'viernes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (877,'2023-05-27',27,'sábado',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (878,'2023-05-28',28,'domingo',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (879,'2023-05-29',29,'lunes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (880,'2023-05-30',30,'martes',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (881,'2023-05-31',31,'miércoles',5,'mayo',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (882,'2023-06-01',1,'jueves',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (883,'2023-06-02',2,'viernes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (884,'2023-06-03',3,'sábado',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (885,'2023-06-04',4,'domingo',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (886,'2023-06-05',5,'lunes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (887,'2023-06-06',6,'martes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (888,'2023-06-07',7,'miércoles',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (889,'2023-06-08',8,'jueves',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (890,'2023-06-09',9,'viernes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (891,'2023-06-10',10,'sábado',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (892,'2023-06-11',11,'domingo',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (893,'2023-06-12',12,'lunes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (894,'2023-06-13',13,'martes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (895,'2023-06-14',14,'miércoles',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (896,'2023-06-15',15,'jueves',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (897,'2023-06-16',16,'viernes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (898,'2023-06-17',17,'sábado',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (899,'2023-06-18',18,'domingo',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (900,'2023-06-19',19,'lunes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (901,'2023-06-20',20,'martes',6,'junio',2,2023,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (902,'2023-06-21',21,'miércoles',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (903,'2023-06-22',22,'jueves',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (904,'2023-06-23',23,'viernes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (905,'2023-06-24',24,'sábado',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (906,'2023-06-25',25,'domingo',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (907,'2023-06-26',26,'lunes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (908,'2023-06-27',27,'martes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (909,'2023-06-28',28,'miércoles',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (910,'2023-06-29',29,'jueves',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (911,'2023-06-30',30,'viernes',6,'junio',2,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (912,'2023-07-01',1,'sábado',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (913,'2023-07-02',2,'domingo',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (914,'2023-07-03',3,'lunes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (915,'2023-07-04',4,'martes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (916,'2023-07-05',5,'miércoles',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (917,'2023-07-06',6,'jueves',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (918,'2023-07-07',7,'viernes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (919,'2023-07-08',8,'sábado',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (920,'2023-07-09',9,'domingo',7,'julio',3,2023,1);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (921,'2023-07-10',10,'lunes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (922,'2023-07-11',11,'martes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (923,'2023-07-12',12,'miércoles',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (924,'2023-07-13',13,'jueves',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (925,'2023-07-14',14,'viernes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (926,'2023-07-15',15,'sábado',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (927,'2023-07-16',16,'domingo',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (928,'2023-07-17',17,'lunes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (929,'2023-07-18',18,'martes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (930,'2023-07-19',19,'miércoles',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (931,'2023-07-20',20,'jueves',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (932,'2023-07-21',21,'viernes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (933,'2023-07-22',22,'sábado',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (934,'2023-07-23',23,'domingo',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (935,'2023-07-24',24,'lunes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (936,'2023-07-25',25,'martes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (937,'2023-07-26',26,'miércoles',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (938,'2023-07-27',27,'jueves',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (939,'2023-07-28',28,'viernes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (940,'2023-07-29',29,'sábado',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (941,'2023-07-30',30,'domingo',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (942,'2023-07-31',31,'lunes',7,'julio',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (943,'2023-08-01',1,'martes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (944,'2023-08-02',2,'miércoles',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (945,'2023-08-03',3,'jueves',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (946,'2023-08-04',4,'viernes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (947,'2023-08-05',5,'sábado',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (948,'2023-08-06',6,'domingo',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (949,'2023-08-07',7,'lunes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (950,'2023-08-08',8,'martes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (951,'2023-08-09',9,'miércoles',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (952,'2023-08-10',10,'jueves',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (953,'2023-08-11',11,'viernes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (954,'2023-08-12',12,'sábado',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (955,'2023-08-13',13,'domingo',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (956,'2023-08-14',14,'lunes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (957,'2023-08-15',15,'martes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (958,'2023-08-16',16,'miércoles',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (959,'2023-08-17',17,'jueves',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (960,'2023-08-18',18,'viernes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (961,'2023-08-19',19,'sábado',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (962,'2023-08-20',20,'domingo',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (963,'2023-08-21',21,'lunes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (964,'2023-08-22',22,'martes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (965,'2023-08-23',23,'miércoles',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (966,'2023-08-24',24,'jueves',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (967,'2023-08-25',25,'viernes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (968,'2023-08-26',26,'sábado',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (969,'2023-08-27',27,'domingo',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (970,'2023-08-28',28,'lunes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (971,'2023-08-29',29,'martes',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (972,'2023-08-30',30,'miércoles',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (973,'2023-08-31',31,'jueves',8,'agosto',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (974,'2023-09-01',1,'viernes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (975,'2023-09-02',2,'sábado',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (976,'2023-09-03',3,'domingo',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (977,'2023-09-04',4,'lunes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (978,'2023-09-05',5,'martes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (979,'2023-09-06',6,'miércoles',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (980,'2023-09-07',7,'jueves',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (981,'2023-09-08',8,'viernes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (982,'2023-09-09',9,'sábado',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (983,'2023-09-10',10,'domingo',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (984,'2023-09-11',11,'lunes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (985,'2023-09-12',12,'martes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (986,'2023-09-13',13,'miércoles',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (987,'2023-09-14',14,'jueves',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (988,'2023-09-15',15,'viernes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (989,'2023-09-16',16,'sábado',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (990,'2023-09-17',17,'domingo',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (991,'2023-09-18',18,'lunes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (992,'2023-09-19',19,'martes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (993,'2023-09-20',20,'miércoles',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (994,'2023-09-21',21,'jueves',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (995,'2023-09-22',22,'viernes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (996,'2023-09-23',23,'sábado',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (997,'2023-09-24',24,'domingo',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (998,'2023-09-25',25,'lunes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (999,'2023-09-26',26,'martes',9,'septiembre',3,2023,0);
INSERT INTO date (`id_date`,`date`,`d_number`,`d_name`,`m_number`,`m_name`,`trimester`,`year`,`holiday`) VALUES (1000,'2023-09-27',27,'miércoles',9,'septiembre',3,2023,0);

-- Table: invoice
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (1,'B-0001-00000001','B',1,476,356.25,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (2,'A-0001-00000001','A',2,483,299200.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (3,'B-0001-00000002','B',3,485,11603.75,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (4,'B-0001-00000003','B',4,487,499980.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (5,'A-0001-00000002','A',6,486,412000.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (6,'B-0001-00000004','B',7,489,8820.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (7,'B-0001-00000005','B',8,491,450.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (8,'A-0001-00000003','A',10,489,5699.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (9,'A-0001-00000004','A',11,490,258000.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (10,'B-0001-00000006','B',12,493,831.25,4);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (11,'A-0001-00000005','A',13,492,5490.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (12,'B-0001-00000007','B',14,494,14300.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (13,'A-0001-00000006','A',15,497,8262.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (14,'B-0001-00000008','B',16,498,11409.20,3);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (15,'B-0001-00000009','B',17,498,49300.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (16,'A-0001-00000007','A',18,499,412000.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (17,'B-0001-00000010','B',19,499,237.50,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (18,'A-0001-00000008','A',20,502,496100.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (19,'B-0001-00000011','B',21,504,4544.00,3);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (20,'B-0001-00000012','B',22,503,450.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (21,'A-0001-00000009','A',23,504,45050.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (22,'A-0001-00000010','A',24,505,299200.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (23,'B-0001-00000013','B',25,505,273600.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (24,'A-0001-00000011','A',26,508,424187.50,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (25,'A-0001-00000012','A',27,511,412000.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (26,'B-0001-00000014','B',28,513,8820.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (27,'B-0001-00000015','B',29,511,45050.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (28,'A-0001-00000013','A',30,513,15887.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (29,'B-0001-00000016','B',31,512,21844.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (30,'B-0001-00000017','B',32,514,9500.00,2);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (31,'B-0001-00000018','B',34,514,5960.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (32,'A-0001-00000014','A',35,513,2827.50,3);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (33,'A-0001-00000015','A',37,516,11223.00,1);
INSERT INTO invoice (`id_invoice`,`invoice_n`,`type`,`id_order`,`id_date`,`amount`,`id_p_method`) VALUES (34,'B-0001-00000019','B',38,518,484304.00,2);

-- Table: card_issuer
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (1,'Visa');
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (2,'Master Card');
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (3,'American Express');
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (4,'Naranja');
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (5,'Cabal');
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (6,'Diners');
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (7,'Italcred');
INSERT INTO card_issuer (`id_card_issuer`,`card_issuer`) VALUES (8,'Argencard');

-- Table: card_payment
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (1,1,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (2,2,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (3,3,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (4,4,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (5,5,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (6,6,3);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (7,7,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (8,8,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (9,9,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (10,11,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (11,12,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (12,13,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (13,15,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (14,16,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (15,17,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (16,18,4);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (17,20,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (18,21,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (19,22,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (20,23,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (21,24,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (22,25,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (23,26,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (24,27,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (25,28,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (26,29,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (27,30,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (28,31,2);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (29,33,1);
INSERT INTO card_payment (`id_card_payment`,`id_invoice`,`id_card_issuer`) VALUES (30,34,1);


/*************************************************
				CREACIÓN DE VISTAS
 *************************************************/
 
 -- View: user_list
 -- Objetivo: Presentar de manera ordenada la información de mayor utilidad de los usuarios registrados en el ecommerce
CREATE OR REPLACE VIEW user_list AS
	(SELECT u.id_user ID, u.last_name, u.first_name, u.email, u.dni, u.cuit_cuil, u.phone, u.postcode, a.address, c.city, p.province  
	 FROM user u JOIN address a
	 ON u.id_address=a.id_address
	 JOIN city c
	 ON a.id_city=c.id_city
	 JOIN province p
	 ON c.id_province=p.id_province
	 ORDER BY last_name, first_name
	 );

-- View: favorite_rank
-- Objetivo: Mostrar los productos que poseen mayor cantidad de usuarios que lo eligieron como favorito, ordenados de manera decreciente según esta cantidad
CREATE OR REPLACE VIEW favorite_rank AS    
	(SELECT p.id_product ID, p.name, b.brand, COUNT(*) fav_quantity 
	 FROM favorite f JOIN product p
	 ON f.id_product =p.id_product
	 JOIN brand b
	 ON p.id_brand=b.id_brand
	 GROUP BY p.id_product
	 ORDER BY fav_quantity DESC
	);

-- View: subscription_by_topic 
-- Objetivo: Mostrar la cantidad de usuarios suscriptos por cada uno de los temas de interés, ordenados de manera decreciente según esta cantidad   
CREATE OR REPLACE VIEW subscription_by_topic AS    
	(SELECT t.topic, COUNT(*) subscriptions 
	 FROM subscription s JOIN topic t
	 ON s.id_topic=t.id_topic
	 GROUP BY t.topic
	 ORDER BY t.topic
	);

-- View: product_list
-- Objetivo: Presentar el catálogo de productos del ecommerce junto a su lista de precios        
CREATE OR REPLACE VIEW product_list AS    
	(SELECT p.id_product ID, p.name, p.description, b.brand, a.category, c.country, ROUND((p.price/1.21),2) PL, p.discount, p.price PLF, ROUND((p.price*(1-p.discount/100)),2) PVF
	 FROM product p JOIN brand b
	 ON p.id_brand=b.id_brand
	 JOIN country c
	 ON p.id_country=c.id_country
	 JOIN category a
	 ON p.id_category=a.id_category
	 ORDER BY a.category, p.name
	);

-- View: product_without_stock
-- Objetivo: Listar los productos que no cuentan con stock al momento de la consulta
CREATE OR REPLACE VIEW product_without_stock AS
	(SELECT p.id_product ID, p.name, b.brand, a.category, pr.name provider
	 FROM product p JOIN brand b
	 ON p.id_brand=b.id_brand
	 JOIN provider pr
	 ON p.id_provider=pr.id_provider
	 JOIN category a
	 ON p.id_category=a.id_category
	 WHERE p.id_product in (
							 SELECT id_product
							 FROM stock
							 WHERE stock=0
							)
	  ORDER BY a.category, p.name
	);

-- View: provider_list
-- Objetivo: Presentar de manera ordenada la información de mayor utilidad de los proveedores del ecommerce
CREATE OR REPLACE VIEW provider_list AS
	(SELECT pr.id_provider ID, pr.name, pr.cuit, pr.email, pr.phone, pr.postcode, a.address, c.city, p.province  
	 FROM provider pr JOIN address a
	 ON pr.id_address=a.id_address
	 JOIN city c
	 ON a.id_city=c.id_city
	 JOIN province p
	 ON c.id_province=p.id_province
	 ORDER BY pr.name
	 );

-- View: order_list
-- Objetivo: Generar un informe con la información más relevante del estado de los pedidos registrados
CREATE OR REPLACE VIEW order_list AS  
	(SELECT o.id_order IDO, u.email, CONCAT(u.last_name,", ",u.first_name) user, d.delivery_type, o.status, o.paid, o.created_at
	FROM `order` o JOIN user u
	ON o.id_user=u.id_user
	JOIN delivery_type d
	ON o.id_delivery=d.id_delivery 
	ORDER BY IDO
	);

-- View: order_to_prepare
-- Objetivo: Mostrar la información básica sobre los pedidos que estan en condiciones para comenzar con su preparación
CREATE OR REPLACE VIEW order_to_prepare AS 
	(SELECT o.id_order IDO, CONCAT(u.last_name,", ",u.first_name) user, d.delivery_type, o.created_at
	FROM `order` o JOIN user u
	ON o.id_user=u.id_user
	JOIN delivery_type d
	ON o.id_delivery=d.id_delivery  
	WHERE o.status="generada" AND o.paid=1
	ORDER BY IDO
	);

-- View: sales_by_day_of_week
-- Objetivo: Presentar un informe con los totales de venta históricos agrupados según los días de la semana
CREATE OR REPLACE VIEW sales_by_day_of_week AS 
	(select d.d_name day, sum(i.amount) sales
	 from invoice i join date d
	 on i.id_date=d.id_date
	 GROUP BY day
	 ORDER BY sales desc
     );    

-- View: sales_by_product_category
-- Objetivo: Presentar un informa con los totales de venta históricos agrupados según las categorías de los productos
CREATE OR REPLACE VIEW sales_by_product_category AS 
	(SELECT c.category, ROUND(SUM(od.quantity*od.unit_price*(1-od.discount/100)),2) sales
	 FROM order_detail od join product p
	 on od.id_product=p.id_product
	 join category c
	 on p.id_category=c.id_category
	 WHERE od.id_order in (
							SELECT DISTINCT id_order
							from invoice
						  )
	 group by c.category
	 ORDER BY sales desc
     );  
     
     
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
