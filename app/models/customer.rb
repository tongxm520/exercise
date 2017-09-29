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


