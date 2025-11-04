USE apple;

-- Total Sales Revenue by Store
SELECT 
    s.Store_Name,
    SUM(p.Price * sa.quantity) AS total_revenue
FROM sales sa
JOIN stores s ON sa.store_id = s.store_id
JOIN products p ON sa.product_id = p.product_id
GROUP BY s.Store_Name
ORDER BY total_revenue DESC;

-- Top 5 Best Selling Products
SELECT 
    p.Product_Name,
    SUM(sa.quantity) AS total_units_sold
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
GROUP BY p.Product_Name
ORDER BY total_units_sold DESC
LIMIT 5;

-- Revenue by Product Category
SELECT 
    c.category_name,
    SUM(p.Price * sa.quantity) AS total_revenue
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- Warranty Claim Rate by Category
SELECT 
    c.category_name,
    COUNT(DISTINCT w.claim_id) * 1.0 / COUNT(DISTINCT sa.sale_id) AS claim_rate
FROM sales sa
JOIN products p ON sa.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
LEFT JOIN warranty w ON sa.sale_id = w.sale_id
GROUP BY c.category_name
ORDER BY claim_rate DESC;

-- Average Product Price by Category
SELECT 
    c.category_name,
    ROUND(AVG(p.Price), 2) AS avg_price
FROM products p
JOIN category c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY avg_price DESC;

-- Store Sales by Country
SELECT 
    s.Country,
    SUM(p.Price * sa.quantity) AS total_revenue
FROM sales sa
JOIN stores s ON sa.store_id = s.store_id
JOIN products p ON sa.product_id = p.product_id
GROUP BY s.Country
ORDER BY total_revenue DESC;


