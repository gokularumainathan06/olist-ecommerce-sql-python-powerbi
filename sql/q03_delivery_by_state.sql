-- Q3. Delivery performance by customer state
SELECT customer_state,
       COUNT(*) AS orders,
       ROUND(AVG(delivery_days), 1) AS avg_delivery_days,
       ROUND(100.0 * AVG(is_late::int), 1) AS late_pct,
       ROUND(AVG(review_score), 2) AS avg_review_score
FROM v_delivered_orders
GROUP BY customer_state
HAVING COUNT(*) >= 50
ORDER BY late_pct DESC;