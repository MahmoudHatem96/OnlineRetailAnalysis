# Solution 1 - Explaination
In the first question, we have to think of 5 queries that gives a business meaning. After exploring the data, I thought we can answer five questions that may help the business analyze their history so as to aid in the future planing as follow:
1. What are the Top 10 selling products?
   > We are here figuring out which products should gain more attention as they are important to the market. We should always ensure their availablity as they contribute directly to the business profit.
2. What are the Popular Product Combinations?
   > Answering this question, we will have a clear picture of pairs of products are bought together. This can help in online shopping to suggest the product for the customer if he added the other one of the pair to his cart.
3. What is the Average Order Value?
    > In this question we get an overview of how much the a customer pay per order on average. This can help in defining customers we should keep our eyes on and those who do not need much attention.
7. What are Sales Trends Over Time?
   > This gives us a pattern of the active months for the customers that need both attention and effort in marketing and operation, and other months that are with no great benefit so we can focus in development in that phase or just making offers or any other solution.
9. Who are the Top 10 buying customers?
    > Customers with high payment rate over time must gain equivalent attention. By answering this question, we can get a clearer image of these customers.




# Solution 2 - Explaination
In the second question, we want to apply the Moentry Model, in which we get Recency (*the latest order made by the customer*), Frequency (*number of orders the customer made*), and Monetary (*total amount of money gained from each customer*). In addition, we will segment customers into groups based on Recency Score, Frequency Score, and Monetary Score. This is done following these steps:
1. Creating a cte to bring the latest date a transaction done in the dataset to use later as a reference date using MAX() TO_DATE()
2. Creating a cte to bring the latest date a transaction done by each user using MAX() TO_DATE()
3. Calculating Recency by substracting the above results (latest_transaction - reference_date), Frequency using COUNT() to count number of transactions for each customer, and Total Spending for the customer (we didn't call it Monetary as we will calculate its percent rank the next step) by multiplying quantity * price for all orders made by each customer thus we get his total spendings.
4. Calculating Monetary Percent Rank using PECENT_RANK() and Recency Score using NTILE() to segment the data in five groups.
5. Calculating FM SCORE using NTILE() to segment customers into five groups based on the average of their Monetary and Frequency together.
6. The final step comes by quering all these data in addition to creating the column that stores each label assigned to each customer using CASE in the select statement.




# Solution 3 - Explaination
- Regarding the first question that requires the maximum number of consecutive days a customer made purchases:
   > - The idea is to fetch dates of all purchases made by the customer along side with the next order date -1 using LEAD()
   > - In the case of the next purchase was also in the following day, the values of both columns should be the same
   > ![image](https://github.com/MahmoudHatem96/OnlineRetailAnalysis/assets/155321343/4eade462-6456-4613-925c-6ee6f566d470)
   > - Then, I assigned a flag to each positive result where two columns are equal, filtering the data for these rows only.
   > - The final step is to count all these remaining rows over each employee to get number of consecutive days.

- Regarding the second question that requires number of transactions for each customer to reach 250 L.E
  > - The idea is to continuosly aggregate the total spending for each customer so as to know where he exceeded 250 L.E
  > ![image](https://github.com/MahmoudHatem96/OnlineRetailAnalysis/assets/155321343/a488eba6-512a-40a3-9e65-3209a73de8ed)
  > - In the next step, we will give a rank to each transaction grouped by each customer.
  > - This rank that made in order of date of transactions for each cusotmer will be used later in calculating the average.
  > ![image](https://github.com/MahmoudHatem96/OnlineRetailAnalysis/assets/155321343/a24b9188-e3df-4b41-924c-f28d377d3aa6)
  > - Before calculating the average of rank, we need apply a filter to exclude all data that is less than or higher than 250 L.E, we just want the first value to reah this number.
  > - The final step is calculating the average of these numbers remaining which resemble days needed for each customer to reach 250 L.E
