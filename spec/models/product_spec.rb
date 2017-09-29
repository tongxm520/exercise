require 'spec_helper'

describe Product do
  fixtures :products
  
  def new_product(image_url)
    Product.new(:title => "Hello Kitty Wonderful Girl" ,
    :description => "elegant pretty sexy confident brave" ,
    :price => 75.50,
    :image_url => image_url,
    :category_id=>3)
  end
  
	it "product attributes must not be empty" do
    product = Product.new
    product.invalid?.should be_true
    product.errors[:title].any?.should be_true
    product.errors[:description].any?.should be_true
    product.errors[:price].any?.should be_true
    product.errors[:image_url].any?.should be_true
  end

  it "product price must be positive" do
    product = Product.new(:title => "My Book Title" ,
                          :description => "yyy" ,
                          :image_url => "zzz.jpg" ,
                          :category_id=>3)
    product.price = -1
    product.invalid?.should be_true
    product.errors[:price].join(';').should eql("must be greater than or equal to 0.01")
    product.price = 0
    product.invalid?.should be_true
    product.errors[:price].join(';').should eql("must be greater than or equal to 0.01")
    product.price = 1
    product.valid?.should be_true
  end

  it "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
    http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      new_product(name).valid?.should be_true
    end
    bad.each do |name|
      new_product(name).invalid?.should be_true
    end
  end

  it "product is not valid without a unique title" do
    product = Product.new(:title => products(:utc).title,
    :description => "abc" ,
    :price => 1.50,
    :image_url => "fred.gif" ,
    :category_id=>3)
    product.save.should be_false
    product.errors[:title].join(';').should eql("has already been taken")
  end
end


