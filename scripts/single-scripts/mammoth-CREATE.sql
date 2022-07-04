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