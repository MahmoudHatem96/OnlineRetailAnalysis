--Maximum number of consecutive days a customer made purchases
with next_date_cte as(
                        select
                                customer_id,
                                datee,
                                lead(datee) over(order by customer_id)-1 as next_date 
                        from
                                customertransactions
                        order by customer_id, datee),
flag_consecutive_cte as(                   
                        select
                                customer_id,
                                datee,
                                next_date,
                                case
                                    when next_date = datee
                                        then 1
                                    else
                                        0
                                end as rank
                        from
                                next_date_cte),
consecutive_cte as(
                        select 
                                customer_id,
                                datee,
                                next_date,
                                rank
                        from
                               flag_consecutive_cte 
                        where 
                                rank=1

                    )
                    
                    select 
                            customer_id,
                            count(rank) as Max_Consecutive_Days
                    from
                            consecutive_cte
                    group by 
                            customer_id
;
---------------------------------------------------------------
--Transactions does it take a customer to reach a spent threshold of 250 L.E
with
    sum_cte as( 
                            select
                                    customer_id,
                                    datee,
                                    amount,
                                    sum(amount) over(partition by customer_id order by datee rows unbounded preceding) as agg
                            from
                                    customertransactions),
    rank_cte as(                      
                            select 
                                    customer_id,
                                    datee,
                                    amount,
                                    agg,
                                    row_number() over(partition by customer_id order by datee)as rank
                            from
                                    sum_cte),
    threshold_cte as(
                            select 
                                    *
                            from
                                    rank_cte
                            where
                                    agg>=250),
    Transactions_number_cte as(
                            select 
                                    customer_id,
                                    min(rank) as No_of_Transaction
                            from                 
                                    threshold_cte
                                    group by customer_id)
    select
            round(avg(No_of_Transaction)) as Avg_transactions_for_250
    from
            Transactions_number_cte
;



