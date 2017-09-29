require 'rubygems'
require 'nokogiri'
require 'pp'
require "active_record"
require "yaml"


RAILS_ROOT="/home/simon/exercise"
HTML_NAV="#{RAILS_ROOT}/spider/result.html"
CATEGORY="#{RAILS_ROOT}/spider/category.html"

env="development"
if ARGV[0]=="development"
  env="development"
elsif ARGV[0]=="production"
  env="production"
end

puts "environment: #{env}"

Dir["#{RAILS_ROOT}/app/models/*.rb"].each(){|f| require f}
ActiveRecord::Base.establish_connection(YAML.load_file("#{RAILS_ROOT}/config/database.yml")[env])


doc = Nokogiri.parse(File.read(HTML_NAV))
ul=doc.css('ul.categories-list-box')

first_level_cats=[]
ul.css('li > a:nth-child(1)').each do |link|
  #puts link.content.strip
  first_level_cats << link.content.strip
end

total_dts=[]
total_dds=[]

ul.css('li div.sub_cate_main').each do |div|
  main_dts=[]
  main_dds=[]
  div.css('div.sub_cate_row dl.sub_cate_items').each do |dl|
    #puts dl.to_s
    row_dts=[]
    dl.css('dt').each do |dt|
      #puts dt.css('a')[0].content.strip
      row_dts << dt.css('a')[0].content.strip
    end
    
    row_dds=[]
    dl.css('dd').each do |dd|
      dd_links=[]
      dd.css('a').each do |link|
        #puts link[:href]
        dd_links << link.content.strip
      end
      row_dds << dd_links
    end
 
    
    main_dts += row_dts
    main_dds += row_dds
  end

  total_dts <<  main_dts
  total_dds <<  main_dds
  
  #puts "-------------------------------------------------"
end

=begin
pp first_level_cats[5]
pp first_level_cats.count
pp total_dts[5]
pp total_dts.count
pp total_dds[5]
pp total_dds.count
=end


if Category.count==0
	first_level_cats.each_with_index do |c,i|
		first_level=Category.create(:name=>c,:parent_id=>0,:position=>i+1,:ancestor=>"0")
		if total_dts[i].present?
		  total_dts[i].each_with_index do |dt,j|
		    second_level=Category.create(:name=>dt,:parent_id=>first_level.id,:position=>j+1,:ancestor=>first_level.id.to_s)
		    if total_dds[i][j].present?
		      total_dds[i][j].each_with_index do |dd,k|
		        Category.create(:name=>dd,:parent_id=>second_level.id,:position=>k+1,:ancestor=>[first_level.id,second_level.id].join("/"))
		      end
		    end
		  end
		end
	end
end

puts (first_level_cats.flatten.compact+total_dts.flatten.compact+total_dds.flatten.compact).count


#ruby parse_html.rb
#ruby parse_html.rb "development"
#ruby parse_html.rb "production"








