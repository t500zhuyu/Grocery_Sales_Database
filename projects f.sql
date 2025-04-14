use grocery_sales;

select * from customers;

# 
select count(*) from customers;

# to load the sales csv table I have to use
 -- python jupyternotebook for an easy way to load it

# check the number of rows in sales table
select count(*) from sales;

-- Monthly sales performance
 # Analyze sales performance within the four-month period
	# to identify trends and patterns
select * from categories;
select * from cities;
select * from countries;
select * from customers;
select * from employees;
select * from products;
select * from sales;
select * from sales_updated;

-- 1. Monthly Sales Performance
-- use salesID as unique sale key identificator
-- use sales date to get the month

-- use salesID as unique sale key identificator
select salesID, TotalPrice from sales
order by TotalPrice asc;

SELECT EXTRACT(year from salesdate) as year
FROM sales
GROUP BY year; # with this query we only find a unique year in this case 2018

-- use sales date to get the month
SELECT 
    DATE_FORMAT(SalesDate, '%Y-%m') AS month,
    COUNT(DISTINCT salesID) AS total_sales
FROM 
    sales
GROUP BY 
    DATE_FORMAT(SalesDate, '%Y-%m')
ORDER BY 
    month desc;

-- 2. Top Products Identification
	 # Determine which products are the best and worst performers 
		# within the dataset timeframe
	# Rank products based on total sales revenue.
	# Analyze sales quantity and revenue to identify high-demand products.
	# Examine the impact of product classifications on sales performance.

# best performers
select ProductID, Quantity, TotalPrice, SalesDate
from sales_updated
ORDER BY TotalPrice DESC;

# worst performers
select ProductID, Quantity, TotalPrice, SalesDate
from sales_updated
ORDER BY TotalPrice asc;


# Rank products based on total sales revenue.
 -- use productID, unify all the products ID
 -- TotalPrice
-- sum all the products based in ProductID according with the totalprice

 -- use productID, unify all the products ID
SELECT ProductID, SUM(TotalPrice) AS TotalRevenue,
    RANK() OVER (ORDER BY SUM(TotalPrice) DESC) AS RevenueRank
FROM 
    sales_updated
GROUP BY 
    ProductID;


SELECT p.ProductID, p.ProductName,
    SUM(s.TotalPrice) AS TotalRevenue,
    RANK() OVER (ORDER BY SUM(s.TotalPrice) DESC) AS RevenueRank
FROM 
    sales_updated s
JOIN 
    products p ON s.ProductID = p.ProductID
GROUP BY 
    p.ProductID, p.ProductName
LIMIT 15;

select * from products;
select * from sales_updated;

# show in a cell the number of unique discounts (in this case just 3)
SELECT 
    COUNT(DISTINCT discount) AS discount_list
FROM 
    sales
ORDER BY 
    discount desc;

# check all the unique discount values order by descending mode
SELECT DISTINCT discount
FROM sales
WHERE discount IS NOT NULL
ORDER BY discount DESC;
 
-- 3. Customer Purchase Behavior
 -- Objetive  Understand how customers interact with products
   -- during the four-month period.
 
	# Segment customers based on their purchase frequency and total spend.
select * from categories;
select * from cities;
select * from countries;
select * from customers;
select * from employees;
select * from products;
select * from sales_updated;

    
SELECT CustomerID, SUM(TotalPrice) AS TotalPurchase,
    RANK() OVER (ORDER BY SUM(TotalPrice) DESC) AS PurchaseFrequency
FROM sales_updated
GROUP BY CustomerID;

# Identify repeat customers versus one-time buyers.
SELECT COUNT(*) AS one_time_customers
FROM (
    SELECT CustomerID
    FROM sales_updated
    GROUP BY CustomerID
    HAVING COUNT(*) = 1
) AS one_time;

SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT CustomerID
    FROM sales_updated
    GROUP BY CustomerID
    HAVING COUNT(*) < 1
) AS several_times;

# showing the less repeat customers first
SELECT CustomerID, COUNT(*) AS PurchaseCount
FROM sales_updated
GROUP BY CustomerID
order by PurchaseCount asc;

# showing the most repeat customers first
SELECT CustomerID, COUNT(*) AS PurchaseCount
FROM sales_updated
GROUP BY CustomerID
order by PurchaseCount desc;

select CustomerID, AVG(TotalPrice) as avg_order_value
FROM sales_updated
group by CustomerID
order by avg_order_value desc;

-- 4. Salesperson Effectiveness
  -- Objective: Evaluate the performance of sales personnel in driving sales.
   # Calculate total sales attributed to each salesperson.
   
	# correct code
	SELECT SalesPersonID, SUM(TotalPrice) AS TotalSales,
		RANK() OVER (ORDER BY SUM(TotalPrice) DESC) AS SalesAttributed
		FROM sales_updated
		GROUP BY SalesPersonID;
        
   # Identify top-performing and underperforming sales staff.
   SELECT SalesPersonID, SUM(TotalPrice) AS TotalSales,
		RANK() OVER (ORDER BY SUM(TotalPrice) DESC) AS SalesAttributed
		FROM sales_updated
		GROUP BY SalesPersonID
        order by SalesAttributed desc
        limit 10;
        
   # Analyze sales trends based on individual salesperson contributions over time.
	   SELECT 
		SaleMonth,
		SalesPersonID,
		PersonSales,
		RANK() OVER (PARTITION BY SaleMonth ORDER BY PersonSales DESC) AS MonthlyRank
	FROM (
		SELECT 
			DATE_FORMAT(SalesDate, '%Y-%m') AS SaleMonth,
			SalesPersonID,
			SUM(TotalPrice) AS PersonSales
		FROM sales_updated
		GROUP BY SaleMonth, SalesPersonID
	) AS sub
	ORDER BY SaleMonth, MonthlyRank;

   
-- 5. Geographical Sales Insights
 -- Objetive Explore how sales are distributed across different cities and countries within the dataset.
  # Map sales data to specific cities and countries to identify high-performing regions.
	select * from cities;
	select * from countries;
	select * from customers;
	select * from products;
	select * from sales_updated;
    
    # cities
SELECT 
    ci.CityID,
    ci.CityName,
    SUM(s.TotalPrice) AS TotalSales
FROM 
    cities ci 
    INNER JOIN customers cu ON ci.CityID = cu.CityID
    INNER JOIN sales_updated s ON cu.CustomerID = s.CustomerID
GROUP BY 
    ci.CityID, ci.CityName
ORDER BY 
    TotalSales DESC;





























































