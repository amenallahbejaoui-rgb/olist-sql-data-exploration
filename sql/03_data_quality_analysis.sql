
USE olist_analytics;

-- A1. Orders
SELECT
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date,
    SUM(order_approved_at IS NULL) AS missing_approved_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery_date
FROM orders;

-- A2. Customers
SELECT
    COUNT(*) AS total_rows,
    SUM(customer_unique_id IS NULL) AS missing_unique_id,
    SUM(customer_city IS NULL) AS missing_city,
    SUM(customer_state IS NULL) AS missing_state
FROM customers;

-- A3. Order items
SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(price IS NULL) AS missing_price,
    SUM(freight_value IS NULL) AS missing_freight
FROM order_items;

-- A4. Payments
SELECT
    COUNT(*) AS total_rows,
    SUM(payment_type IS NULL) AS missing_payment_type,
    SUM(payment_value IS NULL) AS missing_payment_value
FROM order_payments;

-- A5. Products
SELECT
    COUNT(*) AS total_rows,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_photos_qty IS NULL) AS missing_photos
FROM products;

-- A6. Reviews
SELECT
    COUNT(*) AS total_rows,
    SUM(review_id IS NULL) AS missing_review_id,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(review_score IS NULL) AS missing_score
FROM order_reviews;
