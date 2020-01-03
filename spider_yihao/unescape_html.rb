RAILS_ROOT="/home/simon/exercise"
path="#{RAILS_ROOT}/spider_yihao/yhd_js.html"

file=open(path,"r")
html=file.read
html.gsub!("&lt;","<").gsub!("&gt;",">")
file=File.open(path,"w")
file.write html
















