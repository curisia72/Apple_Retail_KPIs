CREATE OR REPLACE VIEW sales_summary AS
SELECT
    sa.sale_id,
    sa.sale_date_converted AS sale_date,
    s.Store_Name,
    s.City,
    s.Country,
    p.Product_Name,
    c.category_name,
    p.Price,
    sa.quantity,
    (p.Price * sa.quantity) AS total_revenue,
    w.repair_status
FROM sales sa
JOIN stores s ON sa.store_id = s.store_id
JOIN products p ON sa.product_id = p.product_id
JOIN category c ON p.category_id = c.category_id
JOIN warranty w ON sa.sale_id = w.sale_id;

SELECT * FROM sales_summary;
