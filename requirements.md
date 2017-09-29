This is a coding exercise used by Bergamotte for technical recruitment purposes. There are no limit of time to perform this task nor any particular restriction, however, please spend no more than six consecutive hours.

## Instructions

Please send a zip archive containing your code and any relevant materials in an email along with your resume and motivations to [jobs@bergamotte.com](jobs@bergamotte.com). Include a readme file explaining your assumptions, providing any necessary assumptions, and stating  what you would accomplish with more time.

The purpose of this test is to verify your abilities to code and see how you architecture an application, so this is the time to show everything you know that is applicable and relevant.

Read through the exercise background, try completing as many tasks and additional questions as you can.

Finally, please note that even if you have questions about the test we will not answer them, do what you think is best.

Thank you for committing this time and effort, we are looking forward to seeing  your results.

## Exercise background

We have a (very) basic e-commerce platform, with the four models (Product, Order, Item and ProductItem). You can find the relationships (if not figured already) in the models files and the database design in the schema file.

## Tasks

Please implement the following  stories.

1. An order belongs to a Customer.

2. A product belongs to a Category.

3. Any customer browse to an account page and is prompted with a login page. They enter their credentials (login and password) and are presented with exactly their orders (sorted by status).

4. Write a SQL query to return the results as display below:

***Example***

customer_id | customer_first_name | category_id | category_name
--- | --- | --- | --- | ---
1 |John | 1 | Bouquets

5. Use active record methods to achieve the result above.

6. Extend ruby Hash Class to use your own implementation of the [Hash#dig](http://ruby-doc.org/core-2.3.0_preview1/Hash.html#method-i-dig) method without ruby 2.3. Make it available in the Rails app.

7. Analytics

  *We need a weekly summary page displaying:*
  1. Breakdown by product of sold quantities (based on orders.created_at)
  2. Breakdown by items of sold quantities (based on orders.created_at)
  3. Add asynchronous navigation to change the displayed week
  4. Display order uniq customer count by number of orders (example 1)
  5. (*On a separate view*) Display repartition between reccuring and new customers for each month (example 2)

***Example 1***

Orders|Customers|Percentage
----|----|----
1 order|70|70%
2 orders|20|20%
3 orders|5|5%

***Example 2***

Month|Reccuring Customer|New customer|Total
----|----|----|----
June 2016|0|800|800
July 2016|15|290|305

# Additional questions
*No coding necessary, explain the concept or sketch your thoughts.*

- We want to add a subscription feature to allow our customers to receive flower automaticaly. How would you design the tables, what are the pros and cons of your approach?

- When facing a high traffic and limited supply, how do you distribute the stock among clients checking out?


##SKU
A stock keeping unit (SKU) is a product and service identification code for a store, often portrayed as a machine-readable bar code that helps track the item for inventory. A stock keeping unit (SKU) does not need to be assigned to physical products in inventory.

库存量单位（SKU）是商店产品和服务标识码，通常被描绘为机器可读条形码，可帮助跟踪物品的库存。 库存量单位（SKU）不需要分配到库存中的实物产品。

##inventory 库存  清单

**What is SPU?**
SPU stands for "Standard Product Unit" and is basically a template with already approved content, shared across sellers, improving content and making QC more efficient, as the SPU part of the product content is already approved.

*"A product" in the future consist of three levels of details:*
SPU - Data shared across all sellers using the SPU
Other details - details specific to the seller, which will apply to all the SKU's a particular seller creates under a SPU
SKU - Details referring the one product - also replacing the old variation concept - one SKU for one product


在电子商务里，一般会提到这样几个词：商品、单品、SPU、SKU
简单理解一下，SPU是标准化产品单元，区分品种；SKU是库存量单位，区分单品；商品特指与商家有关的商品，可对应多个SKU。   

首先，搞清楚商品与单品的区别。例如，iphone是一个单品，但是在淘宝上当很多商家同时出售这个产品的时候，iphone就是一个商品了。 
商品：淘宝叫item，京东叫product，商品特指与商家有关的商品，每个商品有一个商家编码，每个商品下面有多个颜色，款式，可以有多个SKU。  
##SPU = Standard Product Unit （标准化产品单元）
SPU是商品信息聚合的最小单位，是一组可复用、易检索的标准化信息的集合，该集合描述了一个产品的特性。通俗点讲，属性值、特性相同的商品就可以称为一个SPU。例如，iphone4就是一个SPU，N97也是一个SPU，这个与商家无关，与颜色、款式、套餐也无关。   

##SKU=stock keeping unit(库存量单位)
SKU即库存进出计量的单位， 可以是以件、盒、托盘等为单位。在服装、鞋类商品中使用最多最普遍。 例如纺织品中一个SKU通常表示：规格、颜色、款式。 SKU是物理上不可分割的最小存货单元。在使用时要根据不同业态，不同管理模式来处理。比如一香烟是50条，一条里有十盒，一盒中有20支，这些单位就要根据不同的需要来设定SKU。

spu和sku都是属性值的集合, 举个栗子 >>
一部 6S, 它身上有很多的属性和值. 
比如
毛重: 420.00 g
产地: 中国大陆
容量: 16G, 64G, 128G
颜色: 银, 白, 玫瑰金

你跑进苏宁顺电, 说想要一台 6S, 店员也会再继续问: 你想要什么6S? 16G银色? 64G白色?
每一台6S的毛重都是 420.00 g, 产地也都是 中国大陆. 这两个属性就属于 spu 属性.
而容量和颜色, 这种会影响价格和库存的(比如 16G 与 64G 的价格不同, 16G 银色还有货, 金色卖完了)属性就是 sku属性.
spu属性(不会影响到库存和价格的属性, 又叫关键属性) 

>>毛重: 420.00 g
  产地: 中国大陆

sku 属性(会影响到库存和价格的属性, 又叫销售属性) 
>>容量: 16G, 64G, 128G
  颜色: 银, 白, 玫瑰金

sku 在生成时, 会根据属性生成相应的*笛卡尔积*.想像一下扑克牌的黑红梅方和 A-K, 扑克牌是这样的sku属性:
牌面: A - K
花色: 黑红梅方
最终会生成 13 * 4 = 52 张牌, 上面的6S则会生成 3*3 = 9 个 SKU商品: 
iphone 6s 
spu : 包含在每一部6s的属性集合, 与商品是一对一的关系(产地:中国, 毛重:420g...)
sku : 影响价格和库存的属性集合, 与商品是多对一的关系
单品 : 同sku. 国人的另一种叫法!

1. source the data
2. verify the data
3. validate the data
4. de-duplicate the data
5. merge and purge data from two or more sources


##Buyer Seller


