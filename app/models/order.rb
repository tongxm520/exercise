class Order < ActiveRecord::Base
  attr_accessible :street, :town, :zip, :pay_type,:phone,:customer_id
  PAYMENT_TYPES = ["direct", "cheque", "paypal"]
  validates :street, :town, :zip, :pay_type, :phone, :presence => true
  validates :pay_type, :inclusion => PAYMENT_TYPES
  validates :zip, format: {with:  /^([0-9]){6}$/, message: '请填写有效邮政编码'}, :on => :create
  validates :phone, format: {with: /^1(3|4|5|7|8)\d{9}$/, message: '请填写有效手机号码'}, :on => :create

  has_many :line_items, :dependent => :destroy
  has_many :products,through: :line_items
  belongs_to :customer

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end
