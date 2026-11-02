-- Q8. RFM customer segmentation (Recency, Frequency, Monetary)
-- Most customers order only once, so Frequency is used as a simple rule instead of quintiles.
WITH snapshot AS (
  SELECT MAX(purchase_date) + 1 AS snapshot_date FROM v_delivered_orders
),
customer_stats AS (
  SELECT d.customer_unique_id,
         (SELECT snapshot_date FROM snapshot) - MAX(d.purchase_date) AS recency_days,
         COUNT(*) AS frequency,
         SUM(d.items_value) AS monetary
  FROM v_delivered_orders d
  GROUP BY d.customer_unique_id
),
scored AS (
  SELECT *,
         NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,  -- 4 = most recent
         NTILE(4) OVER (ORDER BY monetary) AS m_score            -- 4 = biggest spenders
  FROM customer_stats
),
segmented AS (
  SELECT *,
         CASE WHEN frequency >= 2 AND r_score >= 3 THEN 'Loyal repeat buyers'
              WHEN frequency >= 2 THEN 'Repeat buyers, going quiet'
              WHEN r_score = 4 AND m_score >= 3 THEN 'New high-value'
              WHEN r_score = 4 THEN 'New customers'
              WHEN m_score = 4 THEN 'At-risk big spenders'
              WHEN r_score <= 2 THEN 'Lost one-time buyers'
              ELSE 'One-time buyers' END AS segment
  FROM scored
)
SELECT segment,
       COUNT(*) AS customers,
       ROUND(AVG(recency_days), 0) AS avg_recency_days,
       ROUND(AVG(frequency), 2) AS avg_orders,
       ROUND(AVG(monetary), 2) AS avg_spend,
       ROUND(SUM(monetary), 2) AS total_spend
FROM segmented
GROUP BY segment
ORDER BY total_spend DESC;