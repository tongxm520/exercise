class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id,:position,:ancestor

  belongs_to :parent, :class_name=>"Category"
  has_many :children,:foreign_key=>:parent_id,:class_name=>"Category"
  has_many :products

	def self.fetch_categories
		cats=self.all

		first_level_cats=cats.select {|c| c.parent_id==0}.sort_by{|c| c.position}
		second_arr=[]
		third_arr=[]
    if first_level_cats.present?
			first_level_cats.each do |cat|
				second_level_cats=cats.select {|c| c.parent_id==cat.id}.sort_by{|c| c.position}
				arr=[]
				second_level_cats.each do |item|
					third_level_cats=cats.select {|c| c.parent_id==item.id}.sort_by{|c| c.position}
					arr << third_level_cats
				end
				third_arr << arr
				second_arr << second_level_cats
			end
    end
    [first_level_cats,second_arr,third_arr]
	end  
end


