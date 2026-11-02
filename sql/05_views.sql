-- 05_views.sql : reusable clean layers. Every later query uses these views.
-- Safe to re-run: the old views are dropped first.
 
DROP VIEW IF EXISTS v_item_detail, v_delivered_orders, v_order_reviews, v_order_revenue CASCADE;
 
-- One row per order: item value and freight
CREATE VIEW v_order_revenue AS
SELECT order_id,
       COUNT(*)           AS item_count,
       SUM(price)         AS items_value,
       SUM(freight_value) AS freight_value
FROM order_items
GROUP BY order_id;
 
-- One review per order (the most recent one)
CREATE VIEW v_order_reviews AS
SELECT DISTINCT ON (order_id)
       order_id, review_score, review_creation_date
FROM order_reviews
ORDER BY order_id, review_answer_timestamp DESC NULLS LAST;
 
-- Main analysis table: one row per DELIVERED order that has a delivery date
CREATE VIEW v_delivered_orders AS
SELECT o.order_id,
       c.customer_unique_id,
       c.customer_state,
       c.customer_city,
       o.order_purchase_timestamp::date                                            AS purchase_date,
       date_trunc('month', o.order_purchase_timestamp)::date                       AS purchase_month,
       o.order_estimated_delivery_date::date                                       AS estimated_date,
       o.order_delivered_customer_date::date                                       AS delivered_date,
       ROUND((EXTRACT(EPOCH FROM (o.order_delivered_customer_date
                                  - o.order_purchase_timestamp)) / 86400)::numeric, 1) AS delivery_days,
       (o.order_delivered_customer_date::date
        - o.order_estimated_delivery_date::date)                                   AS delay_days,   -- negative = early
       (o.order_delivered_customer_date::date
        > o.order_estimated_delivery_date::date)                                   AS is_late,
       r.items_value,
       r.freight_value,
       r.item_count,
       v.review_score
FROM orders o
JOIN customers c          ON c.customer_id = o.customer_id
LEFT JOIN v_order_revenue r ON r.order_id = o.order_id
LEFT JOIN v_order_reviews v ON v.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;
 
-- One row per item sold (delivered orders only), with English category and seller state
CREATE VIEW v_item_detail AS
SELECT i.order_id,
       i.order_item_id,
       i.seller_id,
       s.seller_state,
       COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
       i.price,
       i.freight_value
FROM order_items i
JOIN v_delivered_orders d ON d.order_id = i.order_id
LEFT JOIN products p ON p.product_id = i.product_id
LEFT JOIN product_category_translation t ON t.product_category_name = p.product_category_name
LEFT JOIN sellers s ON s.seller_id = i.seller_id;
