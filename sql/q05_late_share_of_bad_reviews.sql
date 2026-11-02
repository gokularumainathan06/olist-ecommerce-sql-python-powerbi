-- Q5. Late orders are a small share of orders, but what share of the BAD reviews?
SELECT COUNT(*) FILTER (WHERE is_late) AS late_orders,
       ROUND(100.0 * COUNT(*) FILTER (WHERE is_late) / COUNT(*), 1) AS late_pct_of_orders,
       COUNT(*) FILTER (WHERE review_score <= 2) AS bad_reviews,
       ROUND(100.0 * COUNT(*) FILTER (WHERE review_score <= 2 AND is_late)
             / NULLIF(COUNT(*) FILTER (WHERE review_score <= 2), 0), 1) AS late_pct_of_bad_reviews
FROM v_delivered_orders
WHERE review_score IS NOT NULL;