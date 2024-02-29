# Question 2
After exploring the data now you are required to implement a *Monetary Model* for customers behavior for product purchasing and segment each customer based on the below groups
- Champions
- Loyal Customers
- Potential Loyalists
- Recent Customers 
- Promising
- Customers Needing Attention 
- At Risk
- Can not Lose Them 
- Hibernating
- Lost
  
### The customers will be grouped based on 3 main values:
- *Recency*   ->    how recent the last transaction is (Hint: choose a reference date, which is the most recent purchase in the dataset )
- *Frequency* ->    how many times the customer has bought from our store
- *Monetary*  ->    how much each customer has paid for our products
  
As there are many groups for each of the R, F, and M features, there are also many potential permutations, this number is too much to manage in terms of marketing strategies.
For this, we would decrease the permutations by getting the average scores of the frequency and monetary (as both of them are indicative to purchase volume anyway)

Expected outcome:
![image](https://github.com/MahmoudHatem96/OnlineRetailAnalysis/assets/155321343/574742f1-04f8-4de1-ab6b-15fc023671c6)

Label each customer based on the below values:
![image](https://github.com/MahmoudHatem96/OnlineRetailAnalysis/assets/155321343/1205850a-430b-4333-b80f-f9be1e6e0b4c)
