/*
Q1:
    a) Top 10 Seling Products
*/
        with top_products_cte as (
                                select
                                        stockcode,
                                        sum(quantity)as Total_Quantity,
                                        row_number() over(order by sum(quantity) desc)as Top_Products
                                        
                                from
                                        tableretail
                                group by stockcode
                                order by total_quantity desc
        )
        select
                *
        from top_products_cte
        where top_products<=10
        ;
---------------------------------------------------------------------------------------------
/*
    b) Popular Products Combination
*/
        select 
        a.stockcode,
        b.stockcode,
        count(*) as pair_frequency
        from 
                tableretail a
        inner join 
                tableretail b
        on      
                a.invoice = b.invoice
        and    
                a.stockcode < b.stockcode
        group by 
                a.stockcode, b.stockcode
        order by
                pair_frequency DESC
        ;
---------------------------------------------------------------------------------------------
/*
    c) Average Order Value
*/
        with Total_Invoice as
        (select
                distinct invoice,
                sum(quantity * price) over(partition by invoice) as total_invoice_payment
        from 
                tableretail
        )
        select 
                round(stddev(total_invoice_payment)) as Standard_deviation,
                round(avg(total_invoice_payment)) as Average_Order_Value
        from
                Total_Invoice
        ;
---------------------------------------------------------------------------------------------
/*
    d) Sales Trends Over Time
*/
        with retail as 
        (select 
                extract(YEAR FROM TO_date(invoicedate, 'MM-DD-YYYY HH24:MI')) as Year,
                extract(MONTH FROM TO_date(invoicedate, 'MM-DD-YYYY HH24:MI')) as Month,
                sum(quantity * price) as Sales_Per_Month
        from 
                tableretail
        group by
                extract(YEAR FROM TO_date(invoicedate, 'MM-DD-YYYY HH24:MI')),
                extract(MONTH FROM TO_date(invoicedate, 'MM-DD-YYYY HH24:MI'))
        order by
                Year, month)
        select 
                *
        from
                retail
        pivot
                (
                sum(Sales_Per_Month)
                for Month
                in ( 1 as "Jan", 2 as "Feb", 3 as "Mar", 4 as "Apr", 5 as "May", 6 as "Jun",
                    7 as "Jul", 8 as "Aug", 9 as "Sep", 10 as "Oct", 11 as "Nov", 12 as "Dec")
                )
        ;
---------------------------------------------------------------------------------------------
/*
    e) Top Buying Customers
*/
        with Top_Customers AS
        (select 
                distinct customer_id,
                sum(price * quantity) over(partition by customer_id) Customer_Sales
        from
                tableretail)
        select 
                customer_id,
                customer_sales,
                dense_rank() over(order by customer_sales DESC) as Rank
        from 
                Top_Customers
        ;
