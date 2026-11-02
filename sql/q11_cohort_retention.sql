-- Q11. Cohort table: customers grouped by first purchase month, and how many came back in later months
WITH first_order AS (
  SELECT customer_unique_id, MIN(purchase_month) AS cohort_month
  FROM v_delivered_orders
  GROUP BY customer_unique_id
),
activity AS (
  SELECT DISTINCT d.customer_unique_id, f.cohort_month, d.purchase_month
  FROM v_delivered_orders d
  JOIN first_order f USING (customer_unique_id)
)
SELECT cohort_month,
       (EXTRACT(YEAR FROM age(purchase_month, cohort_month)) * 12
        + EXTRACT(MONTH FROM age(purchase_month, cohort_month)))::int AS months_since_first,
       COUNT(DISTINCT customer_unique_id) AS customers
FROM activity
WHERE cohort_month BETWEEN '2017-01-01' AND '2018-08-01'
GROUP BY cohort_month, months_since_first
ORDER BY cohort_month, months_since_first;