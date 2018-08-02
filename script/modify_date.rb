#rails runner script/modify_date.rb

o=Order.find 1
o.created_at="2015-04-05 15:48:11"
o.updated_at="2015-04-05 15:48:11"
o.save

o=Order.find 2
o.created_at="2015-04-01 10:18:21"
o.updated_at="2015-04-01 10:18:21"
o.save

o=Order.find 3
o.created_at="2013-09-25 10:39:20"
o.updated_at="2013-09-25 10:39:20"
o.save

o=Order.find 4
o.created_at="2013-10-04 10:39:20"
o.updated_at="2013-10-04 10:39:20"
o.save

o=Order.find 5
o.created_at="2013-11-20 10:39:20"
o.updated_at="2013-11-20 10:39:20"
o.save

o=Order.find 6
o.created_at="2012-10-04 10:39:20"
o.updated_at="2012-10-04 10:39:20"
o.save

o=Order.find 7
o.created_at="2014-07-04 10:39:20"
o.updated_at="2014-07-04 10:39:20"
o.save

o=Order.find 8
o.created_at="2015-01-04 10:39:20"
o.updated_at="2015-01-04 10:39:20"
o.save

o=Order.find 9
o.created_at="2015-01-13 20:18:41"
o.updated_at="2015-01-13 20:18:41"
o.save

o=Order.find 10
o.created_at="2014-10-08 10:39:20"
o.updated_at="2014-10-08 10:39:20"
o.save

o=Order.find 11
o.created_at="2015-01-28 12:38:59"
o.updated_at="2015-01-28 12:38:59"
o.save

o=Order.find 12
o.created_at="2015-04-06 10:39:20"
o.updated_at="2015-04-06 10:39:20"
o.save





