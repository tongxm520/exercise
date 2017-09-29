class Product < ActiveRecord::Base
  attr_accessible :title,:description,:image_url,:price,:category_id
  default_scope :order => 'id asc'

  has_many :line_items
  has_many :orders,through: :line_items
  belongs_to :category
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with => %r{\.(gif|jpg|png)$}i,
    :message => 'must be a URL for GIF, JPG or PNG image.'
  }
  
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else
      errors[:base] << "无法删除,有些LineItem引用了product_id"
      return false
    end
  end
end

