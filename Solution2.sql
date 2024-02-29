--Adjusting the date column format to be able to manipulate
with refernce_date_cte as
                        (select max(TO_date(invoicedate, 'MM-DD-YYYY HH24:MI')) as Reference_Date
                        from tableretail),

--Fetching the latest purchase occured in the dataset to use as a reference  
     last_purchase_cte as
                        (select max(TO_DATE(invoicedate, 'MM-DD-YYYY HH24:MI')) as Last_Purchase,
                        customer_id
                        from tableretail                        
                        group by customer_id),
--Calculating Recency, Frequency, and Total Sales for each customer (to be used next in calculating Monetary)     
     rfm_cte as 
                        (select 
                                distinct r.customer_id as Customer_ID,
                                round((select reference_date from refernce_date_cte) - r.Last_Purchase) as Recency,
                                count(distinct t.invoice) over(partition by t.customer_id) as Frequency,
                                sum(t.price * t.quantity) over(partition by t.customer_id) as Total_Customer_Sales
                        from 
                                tableretail t
                        JOIN 
                                last_purchase_cte r
                        on
                                t.customer_id = r.customer_id),
--Calculating Monetary percent_rank so as the Recency Score    
     r_score_cte as
                        (select
                                Customer_ID,
                                Recency,
                                Frequency, 
                                round(percent_rank() over(order by Total_Customer_Sales), 2) as Monetary,
                                ntile(5) over(order by Recency desc) as r_score
                                
                        from 
                                rfm_cte),
--Calculating Frequency-Monetary Score using the average of them both
    fm_score_cte as
                        (select
                                Customer_ID,
                                Recency,
                                Frequency,
                                Monetary,
                                r_score,
                                ntile(5) over(order by (Frequency + Monetary)/2) as fm_score
                        from
                              r_score_cte)  
--The final step in which we segmenting the customers based on their r_score and fm_score according to the provided information (check the attached photo in question 2 )
select 
        Customer_ID,
        Recency,
        Frequency,
        Monetary,
        r_score,
        fm_score,
        case
            when (r_score = 5 AND fm_score = 5)
            OR (r_score = 5 AND fm_score = 4)
            OR (r_score = 4 AND fm_score = 5)
                THEN 'Champions'
            WHEN (r_score = 5 AND fm_score =3)
            OR (r_score = 4 AND fm_score = 4)
            OR (r_score = 3 AND fm_score = 5)
            OR (r_score = 3 AND fm_score = 4)
                THEN 'Loyal Customers'
            WHEN (r_score = 5 AND fm_score = 2)
            OR (r_score = 4 AND fm_score = 2)
            OR (r_score = 3 AND fm_score = 3)
            OR (r_score = 4 AND fm_score = 3)
                THEN 'Potential Loyalists'
            WHEN r_score = 5 AND fm_score = 1
                THEN 'Recent Customers'
            WHEN (r_score = 4 AND fm_score = 1)
            OR (r_score = 3 AND fm_score = 1)
                THEN 'Promising'
            WHEN (r_score = 3 AND fm_score = 2)
            OR (r_score = 2 AND fm_score = 3)
            OR (r_score = 2 AND fm_score = 2)
                THEN 'Customers Needing Attention'
            WHEN r_score = 2 AND fm_score = 1
                THEN 'About to Sleep'
            WHEN (r_score = 2 AND fm_score = 5)
            OR (r_score = 2 AND fm_score = 4)
            OR (r_score = 1 AND fm_score = 3)
                THEN 'At Risk'
            WHEN (r_score = 1 AND fm_score = 5)
            OR (r_score = 1 AND fm_score = 4)
                THEN 'Cant Lose Them'
            WHEN r_score = 1 AND fm_score = 2
                THEN 'Hibernating'
            WHEN r_score = 1 AND fm_score = 1
                THEN 'Lost'
        END AS cust_segment
from 
        fm_score_cte
;

    