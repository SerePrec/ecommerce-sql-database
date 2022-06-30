-- View: user_list
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
CREATE OR REPLACE VIEW subscription_by_topic AS    
	(SELECT t.topic, COUNT(*) subscriptions 
	 FROM subscription s JOIN topic t
	 ON s.id_topic=t.id_topic
	 GROUP BY t.topic
	 ORDER BY t.topic
	);

-- View: product_list        
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
CREATE OR REPLACE VIEW order_list AS  
	(SELECT o.id_order IDO, u.email, CONCAT(u.last_name,", ",u.first_name) user, d.delivery_type, o.status, o.paid, o.created_at
	FROM `order` o JOIN user u
	ON o.id_user=u.id_user
	JOIN delivery_type d
	ON o.id_delivery=d.id_delivery 
	ORDER BY IDO
	);

-- View: order_to_prepare
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
CREATE OR REPLACE VIEW sales_by_day_of_week AS 
	(select d.d_name day, sum(i.amount) sales
	 from invoice i join date d
	 on i.id_date=d.id_date
	 GROUP BY day
	 ORDER BY sales desc
     );    

-- View: sales_by_product_category
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