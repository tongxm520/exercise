# exercise
E-commerce store, including Restful API service with JWT,deploy with nginx+unicorn ,redis,memcache,postgres

## recommand products to customer according to his likes

   def customer_like_categories
     self.joins('INNER JOIN orders ON customers.id=orders.customer_id INNER JOIN line_items ON orders.id=line_items.order_id INNER JOIN products ON products.id=line_items.product_id INNER JOIN categories ON categories.id=products.category_id').
     select("DISTINCT customers.id AS customer_id,customers.first_name AS customer_first_name,categories.id AS category_id,categories.name AS category_name").
     order("customer_first_name,category_name")
   end

	 +-------------+---------------------+-------------+-------------------------+
	 | customer_id | customer_first_name | category_id | category_name           |
	 +-------------+---------------------+-------------+-------------------------+
	 | 5           | Adam                | 215         | Jackets & Coats         |
	 | 1           | John                | 4           | Cooker & Steamer        |
	 | 3           | Kiten               | 323         | Bakeware                |
	 | 3           | Kiten               | 486         | Gaming Headsets         |
	 | 3           | Kiten               | 420         | Smart Riding Equipments |
	 | 2           | Peter               | 52          | Android Tablet          |
	 | 2           | Peter               | 105         | Earbud Headphones       |
	 | 2           | Peter               | 509         | Safety warning device   |
	 | 4           | Wooden              | 503         | GPS Navigation          |
	 | 4           | Wooden              | 298         | LED Watches             |
	 | 4           | Wooden              | 545         | US--LA Warehouse        |
	 +-------------+---------------------+-------------+-------------------------+


