
USE olist_analytics;

SET NAMES utf8mb4;

-- =====================================================
-- OLIST DATA IMPORT
-- Source: data/raw/
-- Existing orders table is intentionally preserved.
-- =====================================================

-- Create the missing category translation table
CREATE TABLE IF NOT EXISTS category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- Reset import tables so the script can be rerun safely.
-- These tables were verified empty before this import.
TRUNCATE TABLE customers;
TRUNCATE TABLE geolocation;
TRUNCATE TABLE order_items;
TRUNCATE TABLE order_payments;
TRUNCATE TABLE order_reviews;
TRUNCATE TABLE products;
TRUNCATE TABLE sellers;
TRUNCATE TABLE category_translation;

-- =====================================================
-- 1. CUSTOMERS
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/olist_customers_dataset.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_unique_id,
    @zip,
    customer_city,
    customer_state
)
SET customer_zip_code_prefix = NULLIF(TRIM(@zip), '');

-- =====================================================
-- 2. GEOLOCATION
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/olist_geolocation_dataset.csv'
INTO TABLE geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @zip,
    @lat,
    @lng,
    geolocation_city,
    geolocation_state
)
SET
    geolocation_zip_code_prefix = NULLIF(TRIM(@zip), ''),
    geolocation_lat = NULLIF(TRIM(@lat), ''),
    geolocation_lng = NULLIF(TRIM(@lng), '');

-- =====================================================
-- 3. ORDER ITEMS
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/olist_order_items_dataset.csv'
INTO TABLE order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    @shipping_date,
    @price,
    @freight
)
SET
    shipping_limit_date = NULLIF(TRIM(@shipping_date), ''),
    price = NULLIF(TRIM(@price), ''),
    freight_value = NULLIF(TRIM(@freight), '');

-- =====================================================
-- 4. ORDER PAYMENTS
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/olist_order_payments_dataset.csv'
INTO TABLE order_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    payment_sequential,
    payment_type,
    @installments,
    @payment
)
SET
    payment_installments = NULLIF(TRIM(@installments), ''),
    payment_value = NULLIF(TRIM(@payment), '');

-- =====================================================
-- 5. ORDER REVIEWS
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    @creation_date,
    @answer_date
)
SET
    review_creation_date = NULLIF(TRIM(@creation_date), ''),
    review_answer_timestamp = NULLIF(TRIM(@answer_date), '');

-- =====================================================
-- 6. PRODUCTS
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/olist_products_dataset.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    @name_length,
    @description_length,
    @photos,
    @weight,
    @length,
    @height,
    @width
)
SET
    product_name_lenght = NULLIF(TRIM(@name_length), ''),
    product_description_lenght = NULLIF(TRIM(@description_length), ''),
    product_photos_qty = NULLIF(TRIM(@photos), ''),
    product_weight_g = NULLIF(TRIM(@weight), ''),
    product_length_cm = NULLIF(TRIM(@length), ''),
    product_height_cm = NULLIF(TRIM(@height), ''),
    product_width_cm = NULLIF(TRIM(@width), '');

-- =====================================================
-- 7. SELLERS
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/olist_sellers_dataset.csv'
INTO TABLE sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    seller_id,
    @zip,
    seller_city,
    seller_state
)
SET seller_zip_code_prefix = NULLIF(TRIM(@zip), '');

-- =====================================================
-- 8. CATEGORY TRANSLATIONS
-- =====================================================

LOAD DATA LOCAL INFILE
'C:/Users/amenn/Desktop/olist-sql-data-exploration/data/raw/product_category_name_translation.csv'
INTO TABLE category_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_category_name,
    product_category_name_english
);

-- =====================================================
-- IMPORT SUMMARY
-- =====================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation
ORDER BY table_name;
