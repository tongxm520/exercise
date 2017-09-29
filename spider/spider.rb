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

home_header = <<-EOF
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.5
Connection: keep-alive
Host: www.gearbest.com
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:44.0) Gecko/20100101 Firefox/44.0
EOF

target="https://www.gearbest.com/"
output_file="/home/simon/exercise/spider/cookie_file"
output="/home/simon/exercise/spider/result.html"

cookie="AKAM_CLIENTID=640e6f08d7494e95e13a781496a595ef; bizhong=HKD; G_SESSIONID=0iuuns4v9uev9mhin299bjmgk6;ip_country_code=hk; countryId=239; countryName=Hongkong; countryCode=HK; setSiteType=d; setCountry=22277; ORIGINDC=3; Servernode3=node3; isLogin=; first_access=yes; od=10002150427969922099bjmgk608115036979811748; osr=ol=originalurl|href=https://www.gearbest.com/; _ga=GA1.2.1694650181.1504279700; _gid=GA1.2.1787766545.1504279700"

curl(home_header, target, nil,cookie,output_file,output)













