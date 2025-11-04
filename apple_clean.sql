create database apple;

use apple;

select * from category;
select * from products;
select * from sales;
select * from stores;
select * from warranty;

-- updating dates so they are type date instead of text
ALTER TABLE sales ADD COLUMN sale_date_converted DATE;
UPDATE sales SET sale_date_converted = STR_TO_DATE(sale_date, '%d-%m-%Y');
ALTER TABLE sales DROP COLUMN sale_date;

ALTER TABLE products ADD COLUMN launch_date_converted DATE;
UPDATE products SET launch_date_converted = STR_TO_DATE(launch_date, '%Y-%m-%d');
ALTER TABLE products DROP COLUMN launch_date;

ALTER TABLE warranty ADD COLUMN claim_date_converted DATE;
UPDATE warranty SET claim_date_converted = STR_TO_DATE(claim_date, '%Y-%m-%d');
ALTER TABLE warranty DROP COLUMN claim_date;

-- Changing type from text to varchar(50) so can upgrade attributes to pk
ALTER TABLE category MODIFY category_id VARCHAR(50);
ALTER TABLE category ADD PRIMARY KEY (category_id);

ALTER TABLE products MODIFY product_id VARCHAR(50);
ALTER TABLE products ADD PRIMARY KEY (product_id);

ALTER TABLE sales MODIFY sale_id VARCHAR(50);
ALTER TABLE sales ADD PRIMARY KEY (sale_id);

ALTER TABLE stores MODIFY store_id VARCHAR(50);
ALTER TABLE stores ADD PRIMARY KEY (store_id);

ALTER TABLE warranty MODIFY claim_id VARCHAR(50);
ALTER TABLE warranty ADD PRIMARY KEY (claim_id);

-- Adding foreign key connections between tables
-- CATEGORY is parent table (no FKs)

-- PRODUCTS → CATEGORY
ALTER TABLE products MODIFY category_id VARCHAR(50);

ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES category(category_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- SALES → PRODUCTS
ALTER TABLE sales MODIFY product_id VARCHAR(50);

ALTER TABLE sales
ADD CONSTRAINT fk_sales_product
FOREIGN KEY (product_id)
REFERENCES products(product_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- SALES → STORES
ALTER TABLE sales MODIFY store_id VARCHAR(50);

ALTER TABLE sales
ADD CONSTRAINT fk_sales_store
FOREIGN KEY (store_id)
REFERENCES stores(store_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- tried adding the FK but stated there was an error. after inspecting the data, there are different prefixes in front which leads
-- to the two attributes not having the same value hence not joining correct

-- Check if my thinking was correct by seeing if the id's without the prefixes are the same
-- If there is no output, means that there are no mismatches between sales_num and warranty_num which is what I want

SELECT * 
FROM 
(SELECT 
    LEFT(s.sale_id, 2) AS sales_prefix,
    LEFT(w.sale_id, 2) AS warranty_prefix,
    SUBSTRING_INDEX(s.sale_id, '-', -1) AS sales_num,
    SUBSTRING_INDEX(w.sale_id, '-', -1) AS warranty_num
FROM sales s
JOIN warranty w 
  ON SUBSTRING_INDEX(s.sale_id, '-', -1) = SUBSTRING_INDEX(w.sale_id, '-', -1)
) AS test
WHERE sales_num != warranty_num;

-- Update both tables to get rid of the prefix so I can add FK constraint
UPDATE warranty SET sale_id = SUBSTRING_INDEX(sale_id, '-', -1);

-- when trying to update sale_id got a duplicate pk violation so I deleted the duplicates
DELETE s1
FROM sales s1
JOIN sales s2
  ON SUBSTRING_INDEX(s1.sale_id, '-', -1) = SUBSTRING_INDEX(s2.sale_id, '-', -1)
 AND s1.sale_id > s2.sale_id;
 
 UPDATE sales SET sale_id = SUBSTRING_INDEX(sale_id, '-', -1);

-- tried to add the constraint (AGAIN) but found that there were tuplies in warranty that didn't correspond to sales, I deleted them
DELETE FROM warranty
WHERE NOT EXISTS (
    SELECT 1 
    FROM sales 
    WHERE sales.sale_id = warranty.sale_id
);

-- WARRANTY -> SALES
ALTER TABLE warranty MODIFY sale_id VARCHAR(50);

ALTER TABLE warranty
ADD CONSTRAINT fk_warranty_sale
FOREIGN KEY (sale_id)
REFERENCES sales(sale_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 