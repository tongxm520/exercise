##Data mining and e-commerce

Data mining is a systematic way of extracting information from data. Techniques include pattern mining, trend discovery, and prediction. For eBay, data mining plays an important role in the following areas:

**Product search**

When the user searches for a product, how do we find the best results for the user? Typically, a user query of a few keywords can match many products. For example, “Verizon Cell phones” is a popular query at eBay, and it matches more than 34,000 listed items.

One factor we can use in product ranking is user click-through rates or product sell-through rate. Both indicate a facet of the popularity of a product page. In addition, user behavioral data gives us the link from a query, to a product page view, and all the way to the purchase event. Through large-scale data analysis of query logs, we can create graphs between queries and products, and between different products. For example, the user who searches for “Verizon cell phones” might click on the Samsung SCH U940 Glyde product, and the LG VX10000 Voyager. We now know the query is related to those two products, and the two products have a relationship to each other since a user viewed (and perhaps considered buying) both.

We can also mine data to understand user query intent. When a user searches for “Honda Civic”, are they searching for a new car, or just repair parts of the car? Query intent detection comes from understanding the user, other users’ searches, and the semantics of query terms.

**Product recommendation**

Recommending similar products is an important part of eBay. A good product recommendation can save hours of search time and delight our users.

Typical recommendation systems are built upon the principle of “collaborative filtering”, where the aggregated choices of similar, past users can be used to provide insights for the current user. We do this in our new product based experience. Try viewing our Apple iPod touch 2nd generation page and scroll down — you’ll see that users who viewed this product also viewed other generations of the iPod touch and the iPod classic.

Discovering item similarity requires understanding product attributes, price ranges, user purchase patterns, and product categories. Given the hundreds of millions of items sold on eBay, and the diversity of merchandise on our website, this is a challenging computational task. Data mining provides possible tools to tackle this problem, and we are always actively improving our approach to the problem.

**Fraud detection**

A problem faced by all e-commerce companies is misuse of our systems and, in some cases, fraud. For example, sellers may deliberately list a product in the wrong category to attract user attention, or the item sold is not as the seller described it. On the buy side, all retailers face problems with users using stolen credit cards to make purchases or register new user accounts.

Fraud detection involves constant monitoring of online activities, and automatic triggering of internal alarms. Data mining uses statistical analysis and machine learning for the technique of “anomaly detection”, that is, detecting abnormal patterns in a data sequence.

Detecting seller fraud requires mining data on seller profile, item category, listing price and auction activities. By combining all of this data, we can have a complete picture and fast detection in real time.

**Business intelligence**

Every company needs to understand its business operation, inventory and sales pattern. The unique problem facing eBay is its large and diverse inventory. eBay is the world’s largest marketplace for buyers and sellers, with items ranging from collectible coins to new cars. There is no complete product catalog that can cover all items sold on eBay’s website. How do we know the exact number of “sunglasses” sold on eBay? They can be listed under different categories, with different titles and descriptions, or even offered as part of a bundle with other items.

Inventory intelligence requires us to use data mining to process items and map them to the correct product category. This involves text mining, natural language understanding, and machine learning techniques. Successful inventory classification also helps us provide a better search experience and gives a user the most relevant product.

We are seeing a growing need for data mining and its huge potential for e-commerce sites. The success of an e-commerce company is determined by the experience it offers its users, which these days is linked to data understanding. Stay tuned for exciting developments and an improved experience at eBay.

-----------------------------------------------------------------

##E-commerce recommendation systems=>
1. Suggest items that are of interest to users based on something
2. Something:
  >Customer characteristics(demographics)
  >Features of items
  >User preferences: rating/purchasing history

##Type of Recommendation
1. Prediction on preferences of customers
Personalized and non personalized
2. Top-N recommendation items for customers
Personalized and non personalized
3. Top-M users who are most likely to purchase an item

##Classification of Recommendation System
1. Popularity-based: best sell
2. Content-based: similar in items features
3. Collaborative filtering: similar user's taste
4. Association-based: related items
5. Demographic-based: user's age,gender...
6. Reputation-based: Represent individual
7. Hybrid

Popularity-based: best sell
Top 10 in demand

procedures of Content-based
1. Feature extraction and selection
2. Representation item pool by feature decided
3. User profile learning
4. recommendation

Collaborative filtering
Recommend items based on options of other similar users
1. Dimension reduction by trimming preference matrix
2. Neighborhood formation for most similar user(s)
3. Recommendation generation

Customers who shopped for this item also shopped for these items

Neighborhood formation
1. Pearson correlation coefficient
2. Constrained Pearson correlation coefficient
3. Spearman rank correlation coefficient
4. Cosine similarity
5. Mean-square

Neighborhood Selection
1. Weight threshold
2. Center-based best-k neighbors
3. Aggregate-based best-k neighbors


Recommendation generation
1. Weighted average
2. Deviation-from-mean
3. Z-score average


Association-based
Item-correlation for individual users
1.Similarity computing 
2.Recommendation generation

Association Rules
- Guns and ammunition
- Cigarette and lighter
- Paper plate and soda

Association-based classification formula

##SKU
A stock keeping unit
##KDS
Knowledge Discovery using SQL

##google: e-commerce data mining examples

























 



