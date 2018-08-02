# exercise
E-commerce store, including Restful API service with JWT,deploy with nginx+unicorn ,redis,memcache,postgres

## database: postgresql

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

## Find how many customers(NewCustomers, repeatCustomers) who orders on the basis of previous and current month

### orders表
    +-------------+---------------------------+
    | customer_id | created_at                |
    +-------------+---------------------------+
    | 1           | 2015-04-05 15:48:11 +0800 |
    | 2           | 2015-04-01 10:18:21 +0800 |
    | 3           | 2013-09-25 10:39:20 +0800 |
    | 4           | 2013-10-04 10:39:20 +0800 |
    | 5           | 2013-11-20 10:39:20 +0800 |
    | 6           | 2012-10-04 10:39:20 +0800 |
    | 7           | 2014-07-04 10:39:20 +0800 |
    | 8           | 2015-01-04 10:39:20 +0800 |
    | 2           | 2015-01-13 20:18:41 +0800 |
    | 3           | 2014-10-08 10:39:20 +0800 |
    | 4           | 2015-01-28 12:38:59 +0800 |
    | 4           | 2015-04-06 10:39:20 +0800 |
    +-------------+---------------------------+

    def new_vs_reccuring_customers
      sql="SELECT date_part('year',o.created_at) AS year, date_part('month',o.created_at) AS month,COUNT(DISTINCT o.customer_id) AS total,COUNT(CASE WHEN o.created_at = oo.min_created THEN o.customer_id END) AS new_customer_count,COUNT(DISTINCT o.customer_id)-COUNT(CASE WHEN o.created_at = oo.min_created THEN o.customer_id END) AS reccuring_customer_count
      FROM orders o JOIN
      (SELECT customer_id, MIN(created_at) AS min_created
       FROM orders
       GROUP BY customer_id
      ) oo
      ON o.customer_id = oo.customer_id
      GROUP BY date_part('year',o.created_at), date_part('month',o.created_at)
      ORDER BY date_part('year',o.created_at), date_part('month',o.created_at)"
      self.find_by_sql(sql)
    end
    
    +------+-------+-------+--------------------+--------------------------+
    | year | month | total | new_customer_count | reccuring_customer_count |
    +------+-------+-------+--------------------+--------------------------+
    | 2012 | 10    | 1     | 1                  | 0                        |
    | 2013 | 9     | 1     | 1                  | 0                        |
    | 2013 | 10    | 1     | 1                  | 0                        |
    | 2013 | 11    | 1     | 1                  | 0                        |
    | 2014 | 7     | 1     | 1                  | 0                        |
    | 2014 | 10    | 1     | 0                  | 1                        |
    | 2015 | 1     | 3     | 2                  | 1                        |
    | 2015 | 4     | 3     | 1                  | 2                        |
    +------+-------+-------+--------------------+--------------------------+

    
## Find order uniq customer count by number of orders

### orders表

    +----+-------------+
    | id | customer_id |
    +----+-------------+
    | 1  | 1           |
    | 2  | 2           |
    | 3  | 3           |
    | 4  | 4           |
    | 5  | 5           |
    | 6  | 6           |
    | 7  | 7           |
    | 8  | 8           |
    | 9  | 2           |
    | 10 | 3           |
    | 11 | 4           |
    | 12 | 4           |
    +----+-------------+


    def customers_count_by_order_count
      query="SELECT t.orders_count,COUNT(t.orders_count) AS customers_count, CONCAT(CAST(ROUND(100.0 * (COUNT(t.orders_count)/SUM(COUNT(t.orders_count)) OVER ()), 1) AS text),'%') AS percentage FROM (SELECT orders.customer_id,COUNT(orders.customer_id) AS orders_count FROM orders GROUP BY orders.customer_id ORDER BY orders.customer_id) AS t GROUP BY t.orders_count ORDER BY t.orders_count"
      self.find_by_sql(query)
    end
    
    +--------------+-----------------+------------+
    | orders_count | customers_count | percentage |
    +--------------+-----------------+------------+
    | 1            | 5               | 62.5%      |
    | 2            | 2               | 25.0%      |
    | 3            | 1               | 12.5%      |
    +--------------+-----------------+------------+
    

