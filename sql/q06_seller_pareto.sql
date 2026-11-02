-- Q6. Seller concentration (Pareto): how much revenue do the top sellers bring, and how happy are their customers?
WITH seller_rev AS (
  SELECT i.seller_id,
         COUNT(DISTINCT i.order_id) AS orders,
         SUM(i.price) AS revenue
  FROM v_item_detail i
  GROUP BY i.seller_id
),
seller_quality AS (
  SELECT i.seller_id,
         ROUND(AVG(d.review_score), 2) AS avg_review_score,
         ROUND(100.0 * AVG(d.is_late::int), 1) AS late_pct
  FROM (SELECT DISTINCT order_id, seller_id FROM v_item_detail) i
  JOIN v_delivered_orders d ON d.order_id = i.order_id
  GROUP BY i.seller_id
)
SELECT r.seller_id,
       r.orders,
       ROUND(r.revenue, 2) AS revenue,
       ROUND(100.0 * r.revenue / SUM(r.revenue) OVER (), 2) AS revenue_share_pct,
       ROUND(100.0 * SUM(r.revenue) OVER (ORDER BY r.revenue DESC)
             / SUM(r.revenue) OVER (), 1) AS cumulative_share_pct,
       q.avg_review_score,
       q.late_pct
FROM seller_rev r
JOIN seller_quality q USING (seller_id)
ORDER BY r.revenue DESC
LIMIT 20;