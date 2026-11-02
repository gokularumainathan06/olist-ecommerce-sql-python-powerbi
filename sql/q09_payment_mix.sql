-- Q9. Payment methods: share of payment value, average value, average instalments
SELECT payment_type,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(payment_value), 2) AS payment_value,
       ROUND(100.0 * SUM(payment_value) / SUM(SUM(payment_value)) OVER (), 1) AS value_share_pct,
       ROUND(AVG(payment_installments), 1) AS avg_installments
FROM order_payments
WHERE payment_type <> 'not_defined'
GROUP BY payment_type
ORDER BY payment_value DESC;