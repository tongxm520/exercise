TITLES=["Mini BM50 Quad Band Unlocked Phone","AIEK E1 Quad Band Card Phone 1.0 inch","AGM M1 3G Bar Phone","HOMTOM HT3 Pro 4G Smartphone","Casual Letter One Shoulder Unisex Chest Bags","SEONYU Business Half Flap Men Shoulder Crossbody Bag","SKMEI 1172 Male Digital Sport Watch","BISTEC 208 Men Dual Movt Digital Quartz Sport Watch","USB AAA Clip LED Gooseneck Lamp Reading Light","KKBOL 6W Solar Powered LED Desk Lamp with USB","酒红亮片蕾丝长款旗袍修身显瘦短袖中式改良年会演出宴会旗袍礼服","秀禾服新娘结婚礼服敬酒服旗袍嫁衣2017新款中式喜服龙凤褂秀和服 旗袍","名兰世家复古女装高端品牌中年妈妈结婚礼中式礼服红色旗袍绣花秋 旗袍","日常改良修身显瘦真丝旗袍连衣裙中长款优雅少女旗袍夏季2017新款 旗袍","翔野24英寸电脑显示器2K窄边高清IPS电竞游戏台式液晶显示屏幕23","AOC刀锋显示器23.8英寸24无边框22台式电脑液晶ps4显示屏幕I2481","Dell/戴尔 E2016 20英寸LED IPS液晶显示器 三年保修 16：10 VGA","宁美国度 NEC VE2308XI 23英寸IPS屏幕高清超薄液晶电脑显示器24","AFU阿芙荷荷巴套装女夏季深层补水保湿滋润爽肤水乳液孕妇护肤品","特卖雅诗兰黛红石榴套装补水面部护理保养化妆护肤品小样旅行套装","大宝SOD蜜男女补水保湿滋润春夏懒人面霜润肤乳液国货护肤化妆品"]
DESCS=["《资治通鉴》是司马光及其助刘攽、刘怒、范祖禹等根据大量的史料编纂而成的一部编年体史书，记载了上起周威烈士二十三年（公元前403年），下讫后周世宗显德六年（公元959年）共1362年的历史。书中描绘了战略至五代期间的历史发展脉络，探讨了秦、汉、晋、隋、唐等统一的王朝和战国七雄、魏蜀吴三国、五胡十六国、南北朝、五代十国等几十个政权的盛衰之由，生动地刻画了帝王将相们的为政治国、待人处世之道，以及他们在历史旋涡中的生死悲欢。
《资治通鉴》为我国第一部编年体通史，上起周威烈王二十三年（前403年），下迄周世宗显德六年（959年），16朝1362年史事囊括无遗，备受历代统治者及文人学士兵青睐，视之为必读之书。
　　司马光（1019—1086），字君实，陕州夏县（今山西夏县）人。他爱好历史，出仕以后，仍治史不懈。治平三年（1066年），司马光撰成一部战国至秦共八卷本的编年史，名为《通志》，进呈宋英宗，英宗命其设局续修。此后，司马光无论在政治上如何进退沉浮，书局一直随身而设。1067年神宗即位，开经筵，司马光进读《通志》，神宗以其“鉴于往事，有资于治道”，命名为《资治通鉴》。王安石行新政时，司马光竭力反对，被任命为枢密事使而坚辞不就，于熙宁三年（1070年）出知永兴军（今陕西西安）。次年退居洛阳，专心编撰《资治通鉴》，至元丰七年（1084年）成书。从治平三年开局，至此共用了19年的时间。","The Pragmatic Programmers classic is back! Freshly updated for modern software development, Pragmatic Unit Testing in Java 8 With JUnit teaches you how to write and run easily maintained unit tests in JUnit with confidence. You’ll learn mnemonics to help you know what tests to write, how to remember all the boundary conditions, and what the qualities of a good test are. You’ll see how unit tests can pay off by allowing you to keep your system code clean, and you’ll learn how to handle the stuff that seems too tough to test."]

IMAGES=["auto.jpg","svn.jpg","utc.jpg","mingchao.jpg","daying.jpg","shiji.jpg",
"tongjian.jpg","shuhua.jpg","maocheng.jpg","ServiceWorker.jpg","bootstrap.jpg"]

PRODUCT_COUNT=15

def add_products(categories, arr)
	categories.each do |c|
		if c.children.count >0
      add_products(c.children,arr)
    else
      PRODUCT_COUNT.times do
        arr << c.id
        if c.products.count < 15
		      c.products.build({:title=>TITLES[rand(TITLES.count)],
		                        :description=>DESCS[rand(DESCS.count)],
		                        :image_url=>IMAGES[rand(IMAGES.count)],
		                        :price=>(50+rand(1000)+rand).round(2)}).save(:validate=>false)
        end
      end
    end
	end
end

arr=[]
categories=Category.where("parent_id=?",0)
add_products(categories,arr)

puts arr.count

#cd /home/simon/exercise/spider
#ruby parse_html.rb
#cd /home/simon/exercise
#rails runner script/load_products.rb







