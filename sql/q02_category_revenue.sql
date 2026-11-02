-- Q2. Revenue by product category, with share of total and rank
SELECT category,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(price), 2) AS revenue,
       ROUND(100.0 * SUM(price) / SUM(SUM(price)) OVER (), 1) AS revenue_share_pct,
       RANK() OVER (ORDER BY SUM(price) DESC) AS revenue_rank
FROM v_item_detail
GROUP BY category
ORDER BY revenue DESC;