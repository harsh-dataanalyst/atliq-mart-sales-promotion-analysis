===========================================================
📊 ATLIQ MART PROMOTION ANALYSIS - SQL SOLUTIONS
===========================================================

👨‍💻 Project: Codebasics Resume Challenge  
🎯 Goal: Analyze promotional performance and provide insights  
🛠️ Tools Used: SQL (MySQL), Power BI  

-----------------------------------------------------------
📌 WHAT THIS FILE CONTAINS
-----------------------------------------------------------
This file includes:
- Business questions asked by stakeholders
- SQL queries used to solve them
- Simple explanation of each solution

-----------------------------------------------------------
📌 KEY METRICS USED
-----------------------------------------------------------

1. Revenue = base_price × quantity_sold  
2. ISU% (Incremental Sold Quantity)  
   = ((After - Before) / Before) × 100  

3. IR% (Incremental Revenue)  
   = ((Revenue After - Revenue Before) / Revenue Before) × 100  

-----------------------------------------------------------
🔹 QUESTION 1
-----------------------------------------------------------
👉 Find products with base price > 500 and BOGOF promotion

🎯 Purpose:
Identify high-value products under heavy discount

💻 SQL QUERY:
-----------------------------------------------------------
SELECT DISTINCT
    product_code,
    product_name,
    base_price
FROM dim_products p
JOIN fact_events e USING(product_code)
WHERE base_price > 500
AND promo_type = 'BOGOF'
ORDER BY base_price;
-----------------------------------------------------------

🧠 Explanation:
Filters expensive products and checks if they were part of BOGOF promotions.

===========================================================

🔹 QUESTION 2
-----------------------------------------------------------
👉 Count number of stores in each city

🎯 Purpose:
Understand store distribution across cities

💻 SQL QUERY:
-----------------------------------------------------------
SELECT 
    city,
    COUNT(store_id) AS total_stores
FROM dim_stores
GROUP BY city
ORDER BY total_stores DESC;
-----------------------------------------------------------

🧠 Explanation:
Groups stores by city and counts how many stores are present.

===========================================================

🔹 QUESTION 3
-----------------------------------------------------------
👉 Revenue before and after promotion (in millions)

🎯 Purpose:
Evaluate campaign financial performance

💻 SQL QUERY:
-----------------------------------------------------------
SELECT 
    campaign_name,
    CONCAT(ROUND(SUM(base_price * `quantity_sold_(before_promo)`) / 1000000,2),' M') 
    AS revenue_before,
    CONCAT(ROUND(SUM(base_price * `quantity_sold_(after_promo)`) / 1000000,2),' M') 
    AS revenue_after
FROM dim_campaigns c
JOIN fact_events e USING (campaign_id)
GROUP BY campaign_name;
-----------------------------------------------------------

🧠 Explanation:
Calculates total revenue before and after promotion and converts it into millions.

===========================================================

🔹 QUESTION 4
-----------------------------------------------------------
👉 ISU% (Incremental Sold Quantity) by category with ranking

🎯 Purpose:
Identify which categories performed best in terms of quantity growth

💻 SQL QUERY:
-----------------------------------------------------------
WITH sold_quantity AS (
SELECT 
    category,
    ROUND(
    ((SUM(`quantity_sold_(after_promo)`) - 
      SUM(`quantity_sold_(before_promo)`)) 
      / SUM(`quantity_sold_(before_promo)`)) * 100 ,2
    ) AS ISU_percent
FROM dim_products p
JOIN fact_events e USING (product_code)
GROUP BY category
)

SELECT 
    ROW_NUMBER() OVER(ORDER BY ISU_percent DESC) AS rank_order,
    category,
    ISU_percent
FROM sold_quantity;
-----------------------------------------------------------

🧠 Explanation:
Calculates percentage increase in quantity sold and ranks categories.

===========================================================

🔹 QUESTION 5
-----------------------------------------------------------
👉 Top 5 products based on IR% (Incremental Revenue)

🎯 Purpose:
Find products generating highest revenue growth

💻 SQL QUERY:
-----------------------------------------------------------
SELECT 
    p.product_name,
    p.category,
    ROUND(
    (SUM(base_price * `quantity_sold_(after_promo)`) - 
     SUM(base_price * `quantity_sold_(before_promo)`)) 
    / SUM(base_price * `quantity_sold_(before_promo)`) * 100,
    2) AS IR_percent
FROM fact_events e
JOIN dim_products p USING (product_code)
GROUP BY p.product_name, p.category
ORDER BY IR_percent DESC
LIMIT 5;
-----------------------------------------------------------

🧠 Explanation:
Calculates revenue growth percentage and selects top 5 products.

===========================================================

🚀 FINAL NOTE
-----------------------------------------------------------
This analysis helps:
✔ Identify successful promotions  
✔ Understand product & category performance  
✔ Support data-driven business decisions  

===========================================================
