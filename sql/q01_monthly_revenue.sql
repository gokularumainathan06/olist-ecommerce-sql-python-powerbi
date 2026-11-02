-- Q1. Monthly orders, revenue, average order value and month-on-month growth
-- Period is limited to Jan-2017 .. Aug-2018 because the first and last months of the dataset are incomplete.
WITH monthly AS (
  SELECT purchase_month AS month,
         COUNT(*) AS orders,
         SUM(items_value) AS revenue
  FROM v_delivered_orders
  WHERE purchase_month BETWEEN '2017-01-01' AND '2018-08-01'
  GROUP BY purchase_month
)
SELECT month,
       orders,
       ROUND(revenue, 2) AS revenue,
       ROUND(revenue / orders, 2) AS avg_order_value,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 1) AS revenue_mom_pct
FROM monthly
ORDER BY month;