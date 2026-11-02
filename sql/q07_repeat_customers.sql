-- Q7. What percent of customers ordered more than once?
WITH per_customer AS (
  SELECT customer_unique_id, COUNT(*) AS orders
  FROM v_delivered_orders
  GROUP BY customer_unique_id
)
SELECT COUNT(*) AS customers,
       COUNT(*) FILTER (WHERE orders >= 2) AS repeat_customers,
       ROUND(100.0 * COUNT(*) FILTER (WHERE orders >= 2) / COUNT(*), 2) AS repeat_rate_pct
FROM per_customer;