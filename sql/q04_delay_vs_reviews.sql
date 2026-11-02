-- Q4. THE KEY QUESTION: how does lateness change the review score?
SELECT CASE WHEN delay_days <= 0 THEN '1. On time or early'
            WHEN delay_days <= 3 THEN '2. 1-3 days late'
            WHEN delay_days <= 7 THEN '3. 4-7 days late'
            WHEN delay_days <= 14 THEN '4. 8-14 days late'
            ELSE '5. 15+ days late' END AS delay_bucket,
       COUNT(*) AS orders,
       ROUND(AVG(review_score), 2) AS avg_review_score,
       ROUND(100.0 * AVG((review_score = 1)::int), 1) AS one_star_pct,
       ROUND(100.0 * AVG((review_score <= 2)::int), 1) AS one_or_two_star_pct
FROM v_delivered_orders
WHERE review_score IS NOT NULL
GROUP BY 1
ORDER BY 1;