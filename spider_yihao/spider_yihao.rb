def curl(headers_txt, target, post_data = nil,cookie=nil,output_file=nil,output=nil)
	header_param = headers_txt.split("\n").map {|header| "-H \"#{header}\""}.join(' ')

	cmd = "curl #{header_param}"
	cmd += " -d \"#{post_data}\"" if post_data
	cmd += " -b \"#{cookie}\"" if cookie
	cmd += " -c \"#{output_file}\"" if output_file
	cmd += " \"#{target}\" --compressed"
	if output
		cmd += " >#{output}"
	else
		cmd += " 2>/dev/null"
	end

	puts "Execute:\n#{cmd}"
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

RAILS_ROOT="/home/simon/exercise"

home_header = <<-EOF
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.5
Connection: keep-alive
Host: www.yhd.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0
EOF


target="http://www.yhd.com"
output_file="#{RAILS_ROOT}/spider_yihao/cookie_file"
output="#{RAILS_ROOT}/spider_yihao/yhd.html"

curl(home_header, target, nil,nil,output_file,output)


home_header = <<-EOF
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.5
Connection: keep-alive
Host: search.yhd.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0
EOF

target="http://search.yhd.com/c6200-0-0"
output_file_search="#{RAILS_ROOT}/spider_yihao/cookie_file_search"
output="#{RAILS_ROOT}/spider_yihao/yhd_cat.html"

cookie="provinceId=2; cityId=2817; yhd_location=2_2817_51973_0; __jda=218172059.15342329590171684366094.1534232959.1534232959.1534232959.1; __jdb=218172059.2.15342329590171684366094|1.1534232959; __jdc=218172059; __jdv=259140492|direct|-|none|-|1534232959017; cart_num=0; cart_cookie_uuid=b4da9ae7-224b-4b76-8e89-8263076f1828"

cookie=generate_cookie(output_file) + cookie
puts cookie

curl(home_header, target, nil,cookie,output_file_search,output)












