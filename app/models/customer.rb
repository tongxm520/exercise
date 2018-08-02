require 'digest/sha2'

class Customer < ActiveRecord::Base
  attr_accessible :hashed_password, :user_name, :salt,:email,:first_name,:last_name
  attr_accessible :password_confirmation,:password
  attr_accessor :password_confirmation
  attr_reader :password
  
  validates :user_name,:first_name,:last_name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :email, format: {with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, message: '请填写有效电子邮箱'}, :on => :create
  validates :password, :confirmation => true
  validate :password_must_be_present

  after_destroy :ensure_an_admin_remains
  has_many :orders
  
  class << self
    def authenticate(email, password)
      user = self.find_by_email(email)
      if user
        expected_password = encrypt_password(password, user.salt)
        if user.hashed_password != expected_password
          user = nil
        end
      end
      user
    end
    
    def encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "wibble" + salt)
    end

    #recommand products to customer according to his likes
    #SELECT DISTINCT customers.id AS customer_id,customers.first_name AS customer_first_name,categories.id AS category_id,categories.name AS category_name FROM customers INNER JOIN orders ON customers.id=orders.customer_id INNER JOIN line_items ON orders.id=line_items.order_id INNER JOIN products ON products.id=line_items.product_id INNER JOIN categories ON categories.id=products.category_id ORDER BY customer_first_name,category_name
    def customer_like_categories
      self.joins('INNER JOIN orders ON customers.id=orders.customer_id INNER JOIN line_items ON orders.id=line_items.order_id INNER JOIN products ON products.id=line_items.product_id INNER JOIN categories ON categories.id=products.category_id').
		  select("DISTINCT customers.id AS customer_id,customers.first_name AS customer_first_name,categories.id AS category_id,categories.name AS category_name").
		  order("customer_first_name,category_name")
    end

    #Find how many customers(NewCustomers, repeatCustomers) who orders on the basis of previous and current month
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

    #Find order uniq customer count by number of orders
    #(COUNT(t.orders_count)/SUM(COUNT(t.orders_count)) OVER ()) AS percentage
    def customers_count_by_order_count
      query="SELECT t.orders_count,COUNT(t.orders_count) AS customers_count, CONCAT(CAST(ROUND(100.0 * (COUNT(t.orders_count)/SUM(COUNT(t.orders_count)) OVER ()), 1) AS text),'%') AS percentage FROM (SELECT orders.customer_id,COUNT(orders.customer_id) AS orders_count FROM orders GROUP BY orders.customer_id ORDER BY orders.customer_id) AS t GROUP BY t.orders_count ORDER BY t.orders_count"
      self.find_by_sql(query)
    end
  end
  
  # 'password' is a virtual attribute
  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  def ensure_an_admin_remains
    if self.class.count.zero?
      raise "Can't delete last user"
    end
  end
 
  #The .distinct option was added for rails 4 which is what the latest guides refer to. If you are still on rails 3 you will need to use: Client.select(:name).uniq
  def order_by_category
    Customer.joins(orders: {products: :category}).
      where('customers.id = ?',self.id).
      select("orders.customer_id,
        customers.first_name AS customer_first_name,
        products.category_id,
        categories.name AS category_name").
      uniq
  end

  private
  def password_must_be_present
    errors.add(:password, "Missing password" ) unless hashed_password.present?
  end
  
  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end


