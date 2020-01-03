require 'rubygems'
require 'nokogiri'
require 'pp'
require "active_record"
require "yaml"
require 'cgi'
require 'sanitize'
require 'securerandom'
require 'fileutils'

RAILS_ROOT="/home/simon/exercise"
$output="#{RAILS_ROOT}/spider_yihao/yhd_cat.html"

Dir["#{RAILS_ROOT}/app/models/*.rb"].each(){|f| require f}
ActiveRecord::Base.establish_connection(YAML.load_file("#{RAILS_ROOT}/config/database.yml")["development"])

DESCS=["《资治通鉴》是司马光及其助刘攽、刘怒、范祖禹等根据大量的史料编纂而成的一部编年体史书，记载了上起周威烈士二十三年（公元前403年），下讫后周世宗显德六年（公元959年）共1362年的历史。书中描绘了战略至五代期间的历史发展脉络，探讨了秦、汉、晋、隋、唐等统一的王朝和战国七雄、魏蜀吴三国、五胡十六国、南北朝、五代十国等几十个政权的盛衰之由，生动地刻画了帝王将相们的为政治国、待人处世之道，以及他们在历史旋涡中的生死悲欢。
《资治通鉴》为我国第一部编年体通史，上起周威烈王二十三年（前403年），下迄周世宗显德六年（959年），16朝1362年史事囊括无遗，备受历代统治者及文人学士兵青睐，视之为必读之书。
　　司马光（1019—1086），字君实，陕州夏县（今山西夏县）人。他爱好历史，出仕以后，仍治史不懈。治平三年（1066年），司马光撰成一部战国至秦共八卷本的编年史，名为《通志》，进呈宋英宗，英宗命其设局续修。此后，司马光无论在政治上如何进退沉浮，书局一直随身而设。1067年神宗即位，开经筵，司马光进读《通志》，神宗以其“鉴于往事，有资于治道”，命名为《资治通鉴》。王安石行新政时，司马光竭力反对，被任命为枢密事使而坚辞不就，于熙宁三年（1070年）出知永兴军（今陕西西安）。次年退居洛阳，专心编撰《资治通鉴》，至元丰七年（1084年）成书。从治平三年开局，至此共用了19年的时间。","The Pragmatic Programmers classic is back! Freshly updated for modern software development, Pragmatic Unit Testing in Java 8 With JUnit teaches you how to write and run easily maintained unit tests in JUnit with confidence. You’ll learn mnemonics to help you know what tests to write, how to remember all the boundary conditions, and what the qualities of a good test are. You’ll see how unit tests can pay off by allowing you to keep your system code clean, and you’ll learn how to handle the stuff that seems too tough to test."]

def extract_products
	doc = Nokogiri.parse(File.read($output))
	products =doc.css('div#itemSearchList div.mod_search_pro')
  arr=[]
	products.each do |item|
    hash={}
		src=item.at_css('div.proImg img').attr('src')
		if src
		  hash[:img]=src
		else
		  src=item.at_css('div.proImg img').attr('original')
		  hash[:img]=src
		end

		price=item.at_css('p.proPrice em').content
		hash[:price]=price.gsub(/\s|¥/,"")

		hash[:title]=item.at_css('p.proName a').attr('title')
    arr << hash
	end
  arr
end

def extract_links
  yhd_js="#{RAILS_ROOT}/spider_yihao/yhd_js_py.html"
  cat_name=nil
  str=File.read(yhd_js)
  ul=str.scan(/<ul\s+class="hd_allsort\s+hd_more_allsort"\s+id="allsort"\s+curid=".+?">.+?\s*<\/div>\s*<\/div>\s*<\/li>\s*<\/ul>/im)
  items=ul[0].scan(/<li.+?index="\d\d?".+?>\s*<h3\s+class="hd_gray_bg">.+?\s*<\/div>\s*<\/div>\s*<\/li>/im)

  cat_hash=Hash.new
  link_count=0

  items.each_with_index do |item,i|
    #puts item
    #puts (i+1).to_s+"----------------------------------------------------"

    li=Nokogiri.parse(item)
    sub_cat_arr=[]
    cat_array=[]
    if [0,10,11].include?(i)
      cat_name = li.at_css('h3.hd_gray_bg>a').content
    else
      links=li.css('h3.hd_gray_bg>a')
      links.each do |cat|
        cat_array << cat.content
      end
      cat_name = cat_array.join("/")     
    end
    sub_cats=li.css('div.hd_good_category>dl')
    sub_cats.each do |c|
      h={}
      sub_cat=c.at_css('dt>a').content
      sub_cats_third=c.css('dd>a')
      h[sub_cat]=[]

      sub_cats_third.each do |s|
        hash={}
        hash[:name]=s.content
        hash[:url]=CGI::unescape(s.attr('href'))
        link_count+=1
        h[sub_cat] << hash
      end
      sub_cat_arr << h
    end
    cat_hash[cat_name]=sub_cat_arr
  end
  #pp cat_hash
  puts "link_count: #{link_count}"
  cat_hash
end

def curl(headers_txt, target, post_data = nil,cookie=nil,output_file=nil,output=nil)
	header_param = headers_txt.split("\n").map {|header| "-H \"#{header}\""}.join(' ')

	cmd = "curl #{header_param}"
	cmd += " -d \"#{post_data}\"" if post_data
	cmd += " -b \"#{cookie}\"" if cookie
	cmd += " -c \"#{output_file}\"" if output_file
	cmd += " \"#{target}\" --compressed 2>/dev/null"
	if output
		cmd += " >#{output}"
	end

	#puts "Execute:\n#{cmd}"
	2.times {puts}

	`#{cmd}`
end

def generate_cookie(cookie_file)
  j=""
	File.open(cookie_file,"r").each_line do |line|
		if line!="" and line=~/JSESSIONID/
		  arr=line.split(/\s/)
		  j=arr[-2]+"="+arr[-1]+";" unless arr.empty?
		end   
	end
  j
end

$home_header = <<-EOF
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.5
Connection: keep-alive
Host: www.yhd.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0
EOF
$output_file="#{RAILS_ROOT}/spider_yihao/cookie_file"

def grab_homepage
  target="http://www.yhd.com"
  output="#{RAILS_ROOT}/spider_yihao/yhd.html"

  curl($home_header, target, nil,nil,$output_file,output)
end

$search_header = <<-EOF
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.5
Connection: keep-alive
Host: search.yhd.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0
EOF

def grab_by_categories(target)
	output_file_search="#{RAILS_ROOT}/spider_yihao/cookie_file_search"
	cookie="provinceId=2; cityId=2817; yhd_location=2_2817_51973_0; __jda=218172059.15342329590171684366094.1534232959.1534232959.1534232959.1; __jdb=218172059.2.15342329590171684366094|1.1534232959; __jdc=218172059; __jdv=259140492|direct|-|none|-|1534232959017; cart_num=0; cart_cookie_uuid=b4da9ae7-224b-4b76-8e89-8263076f1828"
	cookie=generate_cookie($output_file) + cookie

	curl($search_header, target, nil,cookie,output_file_search,$output)
end

if __FILE__==$0
  h=extract_links
  all_cats=[]
  link_count=0
  h.each do |k,v|
    first_level=Category.create(:name=>k,:parent_id=>0,:ancestor=>"0")
    all_cats << k
    v.each do |cat|
      cat.each do |key,value|
        second_level=Category.create(:name=>key,:parent_id=>first_level.id,
        :ancestor=>first_level.id.to_s)
        all_cats << key
        value.each do |sub_cat|
          third_level=Category.create(:name=>sub_cat[:name],:parent_id=>second_level.id,
        :ancestor=>[first_level.id,second_level.id].join("/"))
          all_cats << sub_cat[:name]
          url="https://"+sub_cat[:url].split("//")[1]
          link_count+=1
          grab_homepage
					open($output, "w")  { |fout| fout.write("") }
					grab_by_categories(url)
					products=extract_products
          upload_root="#{RAILS_ROOT}/public/uploads"
          cat_path=[first_level.id,second_level.id,third_level.id].join("/")
          
          if products.count > 0
		        products.each do |p|
		          name=SecureRandom.uuid.gsub(/\\|\-/,"")
		          FileUtils.mkdir_p("#{upload_root}/#{cat_path}")
		          save_path="#{upload_root}/#{cat_path}/#{name}.jpg"
		          path="uploads/#{cat_path}/#{name}.jpg"
		          img_url="https://"+p[:img].split("//")[1]
		          cmd="curl #{img_url} 2>/dev/null > #{save_path}"
		          `#{cmd}`
		          third_level.products.build({:title=>p[:title],
				                      :description=>DESCS[rand(DESCS.count)],
				                      :image_url=>path,
				                      :price=>p[:price].to_f}).save(:validate=>false)
		        end
          end
          puts "#{k}>#{key}>#{sub_cat[:name]}: products=>#{products.count}"
        end
      end
    end
  end
  puts "all_cats: #{all_cats.count}"
  puts "all_cats_uniq: #{all_cats.uniq.count}"
  puts "link_count: #{link_count}"
end

#str.force_encoding('utf-8')
#str.unicode_normalize(:nfkc)
#pp CGI::unescapeHTML(Sanitize.clean(doc.to_s))

=begin
Selecting on  Attribute and value

[att=str] :- attribute value is exactly matching to str
[att*=str] :-  attribute value contains str – value can contain str anywhere either in middle or at end.
[att^=str] :- attribute value starting with str
[att$=str] :- attribute value ends with str
[att] :-  Elements which contain attribute att with any value
=end

=begin
irb
>RAILS_ROOT="/home/simon/exercise"
>yhd_js="#{RAILS_ROOT}/spider_yihao/yhd_js_py.html"
>str=File.read(yhd_js)
=>"...</a>\n\t\t\t\t\t</li>\n\t\t\t\t</ul>\n\t\t\t</div>\n\t\t</div>\n</li>"
匹配 /<li.+?index="\d\d?".+?>\s<h3\sclass="hd_gray_bg">.+?\s*<\/div>\s*<\/div>\s*<\/li>/im
=end










h
