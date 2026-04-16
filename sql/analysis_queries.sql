View all tables
select * from behavior;
select * from customer_info;
select * from income;
select * from membership;
select * from churn;

Count total customers
select count(customer_id) from customer_info;

Show distinct genders
select distinct(Gender) from customer_info;

Find customers older than 35
select customer_ID,age 
from customer_info
where age> 35;

Find customers with income > 50,000
select customer_id,Annual_Income
from income 
where Annual_Income>50000; 

Customers who churned
select * from churn 
where Churn =1;

Customers with spending score < 40
select customer_ID from behavior
where spending_score<40;

Top 10 customers by income
select customer_ID, Annual_Income
from income
order by Annual_Income Desc
limit 10;

Top 10 by spending score
select customer_ID,spending_score
from behavior
order by spending_score Desc
limit 10;

Lowest 5 customers by purchases
select Customer_ID,Online_Purchases
from behavior
order by Online_Purchases 
limit 5;

Sort customers by membership years (desc)
select customer_id,Membership_Years 
from membership
order by Membership_Years desc;

Customers with highest discount usage
SELECT Customer_ID, Discount_Usage
FROM behavior
ORDER BY Discount_Usage DESC
LIMIT 10;

Average income
select AVG(annual_income)  
from income;

Average spending score
select AVG(spending_score)  
from behavior;

Total online purchases
select sum(Online_Purchases)
from behavior;

Max and min membership years
select max(membership_years) as max_membership,
min(membership_years) as min_membership
from membership;

Count customers by churn
select churn, count(customer_id) as total_customer
from churn
group by churn;

Avg income by gender
select Avg(i.annual_income), g.gender
from income i
join customer_info g
on i.Customer_ID = g.customer_ID
group by gender;

Avg spending score by churn
select avg(b.spending_score),c.churn
from behavior b
join churn c
on b.Customer_ID = c.customer_id
group by churn;

Total purchases by gender
select sum(b.online_purchases), c.gender
from behavior b
join customer_info c
on b.customer_id = c.customer_id
group by gender;
 
Avg membership years by churn
select avg(m.membership_years), c.churn
from membership m
join Churn c
on m.customer_id = c.customer_id
group by churn; 

Avg discount usage by gender
select AVG(b.discount_usage), c.gender
from behavior b  
join customer_info c  
on b.customer_id = c.customer_id
group by gender;

Genders with avg income > 50000
select avg(i.annual_income) as average_income,c.gender
from income i
join customer_info c
on i.customer_id = c.customer_id
group by gender
having average_income>50000;

Churn groups with avg purchases > 60
select avg(b.online_purchases) as avg_purchases,c.churn
from behavior b
join churn c  
on b.customer_id = c.customer_id
group by c.churn  
having avg_purchases>60;

Combine customer_info + income
select * from customer_info c
join income i
on c.customer_id = i.Customer_ID;

Combine customer_info + behavior
select * from customer_info c
join behavior b
on c.customer_id = b.Customer_ID;

Show full customer profile
SELECT 
    c.Customer_ID,
    c.Age,
    c.Gender,
    i.Annual_Income,
    b.Spending_Score,
    b.Online_Purchases,
    b.Discount_Usage,
    m.Membership_Years,
    ch.Churn
FROM customer_info c
JOIN income i 
    ON c.Customer_ID = i.Customer_ID
JOIN behavior b 
    ON c.Customer_ID = b.Customer_ID
JOIN membership m 
    ON c.Customer_ID = m.Customer_ID
JOIN churn ch 
    ON c.Customer_ID = ch.Customer_ID;

Show Customer_ID, Gender, and Annual Income for customers who have both customer info and income data.
select c.customer_id, c.gender,i.annual_income
from customer_info c
inner join income i
on c.customer_id = i.Customer_id;

Find customers who:
Have income data
Have spending score
AND spending score > 70
select c.customer_id,i.annual_income,b.spending_score
from customer_info c
inner join income i
on c.Customer_ID = i.Customer_ID
join behavior b
on b.customer_id = c.customer_id
where Spending_Score is not null
and spending_score > 70;

Show all customers with their income (even if missing)
select c.*,i.annual_income
from customer_info c
inner join income i  
on c.customer_id = i.customer_id;

Find customers who don’t have income data
select c.*
from customer_info c
inner join income i  
on i.Customer_ID = c.customer_id 
where i.Annual_Income is null;

High income + high spending
SELECT 
    c.Customer_ID,
    c.Age,
    c.Gender,
    i.Annual_Income,
    b.Spending_Score
FROM customer_info c
JOIN income i 
    ON c.Customer_ID = i.Customer_ID
JOIN behavior b 
    ON c.Customer_ID = b.Customer_ID
WHERE i.Annual_Income >50000
AND b.Spending_Score > 70;

Create age groups (Young, Adult, Senior)
select customer_id, age,
case
when age < 30 then 'young'
when age between 30 and 50 then 'adult'
else 'senior'
end as age_group
from customer_info;

Categorize income (Low, Medium, High)
select * from income;
select customer_id, annual_income, 
case
when annual_income< 30000 then 'low'
when annual_income between 30000 and 60000 then 'medium'
else 'high'
end as average_income
from income;

Label customers as “Loyal” based on membership
select customer_id,membership_years,
case when membership_years>5 then 'loyal'
else 'yet to be loyal'
end as loyal_customer
from membership;

Customers above average income
select customer_id, annual_income
from income
where annual_income>
(select avg(annual_income)  
from income);

Customers below average spending
select customer_id,spending_score
from behavior
where spending_score<
(select avg(spending_score)
from behavior);

Customers with purchases above average
select Customer_ID,Online_Purchases
from behavior
where Online_Purchases>
(select avg(online_purchases)
from behavior);

Rank customers by spending score
select customer_id, spending_score,
rank() over(order by spending_score desc) as spending_rank  
from behavior;

Rank customers by income within gender
select i.*,c.gender,
rank() over(partition by gender order by i.annual_income desc) as 'income_rank'
from income i
join customer_info c
on i.customer_id = c.customer_id;

Running total of purchases
select customer_id, Online_purchases,
sum(online_purchases) over (order by customer_id)as running_total
from behavior;

Top 3 customers per gender
select *  
from(select b.customer_id,b.spending_score,c.gender,
rank() over(order by b.spending_score desc) as rnk
from behavior b
join customer_info c
on b.customer_id = c.customer_id) ranked_data
where rnk <= 3;

CTE questions
1.Find customers above average income using a CTE
with avg_income_cte as
(select avg(annual_income) as average_income
from income)
select i.customer_id,i.annual_income
from income i,avg_income_cte a  
where i.Annual_Income>a.average_income;

Create a CTE for all customers with income > 50,000
WITH customers_above_50 AS (
    SELECT customer_id, annual_income
    FROM income
    WHERE annual_income > 50000)
SELECT * 
FROM customers_above_50;

Create a CTE for customers with spending score > 70
with customer_spending_score as
(select customer_id,spending_score >70
from behavior)
select * from customer_spending_score;

3. Create a CTE for high-income customers
with high_income_customers as 
(select i.customer_id,i.annual_income,c.gender
from income i
join customer_info c
on i.customer_id = c.customer_id
where i.annual_income>45000)
select * from high_income_customers;

🔹 Behavioral Insights
Do discounts increase purchases?
select case
when discount_usage >0.10 then 'low discount'
when discount_usage  between 0.10 and 0.90 then 'medium discount'
else 'high discount'
end as discount_range,
avg(online_purchases) as 'average_purchase'
from behavior b
group by discount_range;

Do loyal customers spend more?
SELECT 
    CASE 
        WHEN m.membership_years > 5 THEN 'Loyal'
        ELSE 'Not Loyal'
    END AS customer_type,
    AVG(b.Spending_Score) AS avg_spending
FROM membership m
JOIN behavior b
ON m.customer_id = b.customer_id
GROUP BY customer_type;

Are high spenders long-term members?
select 
case 
when b.spending_score>65 then 'high spenders' 
else 'low spenders'
end as spender_type,
avg(m.membership_years) as avg_membership
from behavior b
join membership m
on m.customer_id = b.customer_id
group by spender_type;

Identify high-value customers
SELECT 
    b.customer_id,
    b.spending_score,
    b.online_purchases,
    m.membership_years,
    CASE 
        WHEN b.spending_score > 70 
             AND b.online_purchases > 100 
             AND m.membership_years > 5
        THEN 'High Value'
        ELSE 'Normal'
    END AS customer_type
FROM behavior b
JOIN membership m
ON b.customer_id = m.customer_id;

High-value customers are those with high spending, frequent purchases, and long membership. These customers contribute the most to business revenue.

Analyze factors influencing churn
SELECT 
    c.churn,
    AVG(i.annual_income),
    AVG(b.spending_score),
    AVG(b.online_purchases),
    AVG(m.membership_years)
FROM churn c
JOIN income i ON c.customer_id = i.customer_id
JOIN behavior b ON c.customer_id = b.customer_id
JOIN membership m ON c.customer_id = m.customer_id
GROUP BY c.churn;

Customers who churn tend to have lower spending, fewer purchases, and shorter membership duration.

Segment customers based on behavior
SELECT 
    customer_id,
    CASE 
        WHEN spending_score > 70 AND online_purchases > 100 THEN 'High Engagement'
        WHEN spending_score BETWEEN 40 AND 70 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS segment
FROM behavior;
“Customers can be segmented into high, medium, and low engagement groups based on their spending and purchase activity.”

Evaluate impact of discounts on sales
SELECT 
    CASE 
        WHEN discount_usage < 0.3 THEN 'Low'
        WHEN discount_usage BETWEEN 0.3 AND 0.7 THEN 'Medium'
        ELSE 'High'
    END AS discount_group,
    AVG(online_purchases)
FROM behavior
GROUP BY discount_group;

“Higher discount usage is associated with higher purchase activity, indicating discounts may encourage more buying.

Compare loyal vs non-loyal customers
SELECT 
    CASE 
        WHEN membership_years > 5 THEN 'Loyal'
        ELSE 'Not Loyal'
    END AS customer_type,
    AVG(b.spending_score),
    AVG(b.online_purchases)
FROM membership m
JOIN behavior b
ON m.customer_id = b.customer_id
GROUP BY customer_type;
Loyal customers tend to have higher spending and purchase frequency compared to non-loyal customers.
