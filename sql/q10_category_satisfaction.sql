-- Q10. Which categories make customers unhappy? (categories with at least 100 delivered orders)
SELECT i.category,
       COUNT(DISTINCT i.order_id) AS orders,
       ROUND(SUM(i.price), 2) AS revenue,
       ROUND(AVG(d.review_score), 2) AS avg_review_score,
       ROUND(100.0 * AVG((d.review_score <= 2)::int), 1) AS bad_review_pct,
       ROUND(100.0 * AVG(d.is_late::int), 1) AS late_pct
FROM v_item_detail i
JOIN v_delivered_orders d ON d.order_id = i.order_id
WHERE d.review_score IS NOT NULL
GROUP BY i.category
HAVING COUNT(DISTINCT i.order_id) >= 100
ORDER BY avg_review_score;