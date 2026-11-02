-- 04_data_quality.sql : run each query separately and note the result in your README
 
-- DQ1. How many orders per status?
SELECT order_status, COUNT(*) AS orders,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM orders
GROUP BY order_status
ORDER BY orders DESC;
 
-- DQ2. Delivered orders that have no delivery date (cannot calculate delay for these)
SELECT COUNT(*) AS delivered_without_date
FROM orders
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;
 
-- DQ3. Date range of the data
SELECT MIN(order_purchase_timestamp)::date AS first_order,
       MAX(order_purchase_timestamp)::date AS last_order
FROM orders;
 
-- DQ4. Orders with MORE than one review
SELECT COUNT(*) AS orders_with_multiple_reviews
FROM (SELECT order_id FROM order_reviews GROUP BY order_id HAVING COUNT(*) > 1) x;
 
-- DQ5. Orders that have no review at all
SELECT COUNT(*) AS orders_without_review
FROM orders o
WHERE NOT EXISTS (SELECT 1 FROM order_reviews r WHERE r.order_id = o.order_id);
 
-- DQ6. Orders that have no items (should be tiny)
SELECT COUNT(*) AS orders_without_items
FROM orders o
WHERE NOT EXISTS (SELECT 1 FROM order_items i WHERE i.order_id = o.order_id);
 
-- DQ7. Products with no category, and categories missing an English translation
SELECT COUNT(*) FILTER (WHERE product_category_name IS NULL) AS products_no_category,
       COUNT(*) FILTER (WHERE product_category_name IS NOT NULL
                          AND product_category_name NOT IN
                              (SELECT product_category_name FROM product_category_translation))
                                                           AS products_no_translation
FROM products;
 
-- DQ8. Orders with more than one payment row (so never SUM payments after joining to items!)
SELECT COUNT(*) AS orders_with_multiple_payment_rows
FROM (SELECT order_id FROM order_payments GROUP BY order_id HAVING COUNT(*) > 1) x;


SELECT COUNT(*) AS delivered_orders, COUNT(review_score) AS with_review,
       SUM(is_late::int) AS late_orders
FROM v_delivered_orders;