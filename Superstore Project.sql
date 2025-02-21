use projects;

select * from superstore;

# 1. Sales & Profit Analysis--->

select round(sum(sales), 2) from superstore; #Total Sales Value

select round(sum(profit), 2) from superstore; #Total Profit Value

#Yearly Total Sales & Total Profit Analysis
select year(str_to_date(`order date`, '%m/%d/%Y')) as Year,
round(sum(sales),2) as Total_Sales,
round(Sum(profit), 2) as Total_Profit 
from superstore group by Year order by Year;

#Quaterly Total Sales & Total Profit Analysis
select year(str_to_date(`order date`, '%m/%d/%Y')) as Year,
quarter(str_to_date(`order date`, '%m/%d/%Y')) as Quarter,
round(sum(sales),2) as Total_Sales,
round(sum(profit),2) as Total_Profit
from superstore group by year, quarter
order by year, quarter asc;


#Monthly Total Sales & Total Profit Analysis
select month(str_to_date(`order date`, '%m/%d/%Y')) as Month,
Round(sum(sales), 2) as Total_Sales,
Round(sum(profit), 2) as Total_Profit
from superstore group by month order by month asc;


select * from superstore;

#Identifying profit margins for different product catagories and Sub - catagories
select category,
round(sum(profit), 2) as Total_Profit from superstore 
group by category order by round(sum(profit), 2) desc;

select `sub-category`,
round(sum(profit), 2) as Total_Profit from superstore 
group by `sub-category` 
order by round(sum(profit), 2) desc;

#Analyzing 5 top-selling & least-selling products based on total revenue

select `sub-category`, round(sum(sales), 2) as `Total Revenue` 
from superstore 
group by `sub-category` 
order by round(sum(sales), 2) desc limit 5;

select `sub-category`, round(sum(sales), 2) as `Total Revenue` 
from superstore 
group by `sub-category` 
order by round(sum(sales), 2) asc limit 5;


#  2. Customer & Segment Insights --->

#top 10 customers based on total sales and profit
select `customer name` as `Top 5 Customers`, 
round(sum(sales), 2) as `Total sales value (in dollar)` 
from superstore group by `customer name` 
order by round(sum(sales), 2) desc limit 10;

select `customer name` as `Top 5 Customers`, 
round(sum(profit), 2) as `Total profit amount (in dollar)` 
from superstore group by `customer name` 
order by round(sum(profit), 2) desc limit 10;

#Analyzing most contributing customer segment;
select segment, round(sum(sales), 2) from superstore 
group by segment order by round(sum(sales), 2) desc;

#Counting Repeat Customers vs One-time buyers
SELECT 
    Customer_Type, 
    COUNT(*) AS `Customer Count`
FROM (SELECT `Customer ID`,
        CASE WHEN COUNT(`Order ID`) = 1 THEN 'One-Time Buyers'
             ELSE 'Repeat Customers'
             END 
	    AS Customer_Type
FROM superstore
GROUP BY `Customer ID`) AS customer_groups
GROUP BY Customer_Type;



#   3. Regional & State-Wise Performance Analysis--->

#Analyzing total sales and profit per state and region
select state, region, round(sum(sales),2) as `Total Sales`, round(sum(profit),2) as `Total Profit` from superstore group by state, region;

#for top 5 states based on sales
select state, region, round(sum(sales),2) as `Total Sales`, round(sum(profit),2) as `Total Profit` 
from superstore group by state, region order by round(sum(sales),2) desc limit 5;

#Top performing & Bottom performing states in term of Revenue
select state as `Top State`, region, round(sum(sales),2) as `Total Revenue` 
from superstore group by state, region order by round(sum(sales),2) desc limit 1;

select state as `Bottom State`, region, round(sum(sales),2) as `Total Revenue` 
from superstore group by state, region order by round(sum(sales),2) asc limit 1;

#Top performing & Bottom performing states in term of Profit
select state as `Top State`, region, round(sum(profit),2) as `Total Profit` 
from superstore group by state, region order by round(sum(Profit),2) desc limit 1;

select state as `Bottom State`, region, round(sum(profit),2) as `Total Profit` 
from superstore group by state, region order by round(sum(Profit),2) asc limit 1;

#Determining Most profitable & Least profitable cities
select city as `Top City`, round(sum(profit),2) as `Total Profit` 
from superstore group by city order by round(sum(Profit),2) desc limit 1;

select city as `Bottom City`, round(sum(profit),2) as `Total Profit` 
from superstore group by city order by round(sum(Profit),2) asc limit 1;



#   4. DISCOUNT IMPACT ANALYSIS--->

# Relationship between discount percentage and profit based on items
select * from superstore;
select `Sub-Category` as Items, 
round(sum(profit), 2) as `Total Profit`, 
round((sum(discount)/sum(sales))*100,4) as `Total Discount %` 
from superstore group by `Sub-Category` order by  `Total Discount %` desc;

#Finding out the discount thresshold at which profit turns negative
 SELECT 
    ROUND(Discount, 4) AS Discount_Percentage, 
    round(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY Discount
HAVING Total_Profit < 0
ORDER BY Discount_Percentage ASC
LIMIT 1;

#Identifying category and sub-category of items most affected by high discounts
select category, `sub-category`,
       round(Discount, 4) AS Discount_Percentage, 
       round(SUM(Profit),2) AS Total_Profit 
from superstore
group by category, discount, `sub-category`
having Total_Profit<0
order by discount_percentage asc;


# 5. SHIPPING & DELIVERY INSIGHTS----->

select * from superstore;

#calculating average shipping time for different shipping modes
select `ship mode` as Shipping_Mode,
round(avg(datediff(
str_to_date(`ship date`, '%m/%d/%Y'), str_to_date(`order date`, '%m/%d/%Y'))) ,0) as Avg_Shipping_Time
from superstore
group by Shipping_Mode
order by Avg_Shipping_Time asc;

#Finding most frequently used shipping mode and it's impact on profit

select `ship mode`, count(`ship mode`) as Total_Orders, 
round(avg(profit),2) as Avg_Profit_Per_Mode 
from superstore 
group by `ship mode` 
order by Avg_Profit_Per_Mode desc;

select `ship mode`, count(`ship mode`) as Total_Orders, 
round(sum(profit),2) as Total_Profit_Per_Mode 
from superstore 
group by `ship mode` 
order by Total_Profit_Per_Mode desc;

#Analysing relationship b/w delayed shipments & lower sales
select
case
    when datediff(
    str_to_date(`Ship Date`, '%m/%d/%Y'),
    str_to_date(`Order Date`, '%m/%d/%Y')
    ) > 5 then 'Delayed_Shipment'
    else 'On_Time_Shipment'
    end
    as `Shipment Status`,
round(avg(sales),2) as Avg_Sales
from superstore
group by `Shipment Status`;

#   6. CATEGORY & SUB-CATEGORY PERFORMANCE---->

select * from superstore;

#Ranking product categories and sub-categories basd on sales and profit
select category, round(sum(sales),2) as `Total Sales Value` 
from superstore group by category order by `Total Sales Value` desc;

select category, round(sum(profit),2) as `Total profit` 
from superstore group by category order by `Total profit` desc;

select `sub-category`, round(sum(sales),2) as `Total Sales Value` 
from superstore group by `sub-category` order by `Total Sales Value` desc limit 5;

select `sub-category`, round(sum(profit),2) as `Total profit` 
from superstore group by `sub-category` order by `Total profit` desc limit 5;

#Most frequently purchased item

select `sub-category`, count(sales) as Selling_Frequency 
from superstore group by `sub-category` order by Selling_Frequency desc limit 1;

# Calculating profit margin percentage for each items
select `sub-category` as Items, 
round((sum(profit)/sum(sales))*100,2) as `Profit Margin Percentage` 
from superstore 
group by Items 
order by `Profit Margin Percentage` desc; 


#   7. Order Trends & Business Seasonality---->

select * from superstore;

#identifying monthly sales trend over time 
SELECT 
    YEAR(STR_TO_DATE(`Order Date`, '%m/%d/%Y')) AS Year,
    MONTHNAME(STR_TO_DATE(`Order Date`, '%m/%d/%Y')) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY Year, Month_Name
ORDER BY Year ASC, 
         STR_TO_DATE(CONCAT('01-', Month_Name, '-2020'), '%d-%M-%Y') ASC;
         
#Peak & Low sales months
#Peak Month
select round(sum(sales)) as `Total Sales`,
Monthname(str_to_date(`order date`, '%m/%d/%Y')) as Month_Name,
Year(str_to_date(`order date`, '%m/%d/%Y')) as Year
from superstore
group by Year, Month_Name
order by `Total Sales` desc limit 1;

#Low Month
select round(sum(sales)) as `Total Sales`,
Monthname(str_to_date(`order date`, '%m/%d/%Y')) as Month_Name,
Year(str_to_date(`order date`, '%m/%d/%Y')) as Year
from superstore
group by Year, Month_Name
order by `Total Sales` asc limit 1;


#Additional KPI's---->

#Profit Margin Calculation
SELECT ROUND(SUM(profit) / SUM(sales) * 100, 2) AS Profit_Margin_Percentage 
FROM superstore;

#Top 5 Profitable products
SELECT `sub-category` as ITEM, round(SUM(profit),2) AS total_profit
FROM superstore
GROUP BY ITEM
ORDER BY total_profit DESC
LIMIT 5;

#Top 5 Unprofitable products
SELECT `sub-category` as ITEM, round(SUM(profit),2) AS total_profit
FROM superstore
GROUP BY ITEM
ORDER BY total_profit ASC
LIMIT 5;


#Region-wise Sales & Profit
SELECT region, ROUND(SUM(sales), 2) AS total_sales, ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;

         

         









