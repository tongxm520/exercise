class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id,:position,:ancestor

  belongs_to :parent, :class_name=>"Category"
  has_many :children,:foreign_key=>:parent_id,:class_name=>"Category"
  has_many :products

	def self.fetch_categories
		first_level_cats=self.cached_cats(0)
		second_arr=[]
		third_arr=[]
	  if first_level_cats.present?
			first_level_cats.each do |cat|
				second_level_cats=self.cached_cats(cat.id)
				arr=[]
				second_level_cats.each do |item|
					third_level_cats=self.cached_cats(item.id)
					arr << third_level_cats
				end
				third_arr << arr
				second_arr << second_level_cats
			end
	  end
	  [first_level_cats,second_arr,third_arr]
	end 

  def self.cached_cats(parent_id)
    Rails.cache.fetch("#{parent_id}-children") do 
      self.where("parent_id=?",parent_id).order("position").to_a
    end
  end 
end

# users = User.where(city: 'Miami').order('id desc').limit(3)
# users.cache_key
# => "users/query-57ee9977bb0b04c84711702600aaa24b-3-20160116144936949365"

#active.where("badges_count > 1").order("Random()").limit(5)



