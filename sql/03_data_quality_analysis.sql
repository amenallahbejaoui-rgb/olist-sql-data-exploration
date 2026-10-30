
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

-- B1. Duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- B2. Duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- B3. Duplicate review IDs
SELECT
    review_id,
    COUNT(*) AS occurrences
FROM order_reviews
WHERE review_id IS NOT NULL
GROUP BY review_id
HAVING COUNT(*) > 1;

-- B4. Orders with multiple review records
SELECT
    order_id,
    COUNT(*) AS review_count
FROM order_reviews
WHERE order_id IS NOT NULL
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC
LIMIT 20;

-- B1. Duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- B2. Duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- B3. Duplicate review IDs
SELECT
    review_id,
    COUNT(*) AS occurrences
FROM order_reviews
WHERE review_id IS NOT NULL
GROUP BY review_id
HAVING COUNT(*) > 1;

-- B4. Orders with multiple review records
SELECT
    order_id,
    COUNT(*) AS review_count
FROM order_reviews
WHERE order_id IS NOT NULL
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC
LIMIT 20;

-- D1. Orders without a matching customer
SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- D2. Order items without a matching order
SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- D3. Order items without a matching product
SELECT COUNT(*) AS orphan_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- D4. Order items without a matching seller
SELECT COUNT(*) AS orphan_sellers
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- D5. Payments without a matching order
SELECT COUNT(*) AS orphan_payments
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

-- D6. Reviews without a matching order
SELECT COUNT(*) AS orphan_reviews
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- E1. Order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM orders), 2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- E2. Order purchase date range
SELECT
    MIN(order_purchase_timestamp) AS first_purchase,
    MAX(order_purchase_timestamp) AS last_purchase
FROM orders;

-- E3. Customer geographical distribution
SELECT
    customer_state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;
