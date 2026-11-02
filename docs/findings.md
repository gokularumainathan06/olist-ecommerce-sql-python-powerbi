# Findings log

## Data quality (Step 10)
- DQ1: ...
- DQ2: ...

## SQL results
- Q1 revenue trend: Jan 2017 = 111,798.36 (750 orders); Aug 2018 = 838,576.64 (6,351 orders).
  Biggest jump = Feb 2017 (+109.5%, small base), biggest jump on a large base = Nov 2017 (+52.4%, Black Friday, 987,648.07).
  Biggest drop = Dec 2017 (-26.5%, post-Black Friday).
  Revenue peaked in May 2018 (977,544.69) and then flattened/dipped.

- Q2 category revenue: top 3 = health_beauty (1,233,131.72, __%), watches_gifts (1,165,898.98, __%), bed_bath_table (1,023,434.76, __%).
  Top 5 categories together hold __% of revenue (add the 5 shares).
  74 categories in total.

- Q3 delivery by state: 26 states with 50+ orders.
  Worst 3 (late %): AL 21.4% (24.5 days), MA 17.4% (21.6 days), SE 15.2% (21.5 days).
  Best 3: __, __, __ (fill from the bottom rows).
  RJ is a big state (12,350 orders) with 12.1% late; avg review lower in high-late states (AL 3.85, MA 3.83 vs MG 4.19).

- Q4 delay vs reviews: on-time orders (89,443) avg score 4.29, 1-star 6.6%, 1-2 star __%.
  8-14 days late (1,446 orders) avg score 1.67, 1-star 70.6%, 1-2 star __%.
  15+ days late (1,335 orders) avg score 1.72, 1-star 69.0%, 1-2 star __%.
  Even 1-3 days late drops the score to 3.29 (1-star jumps from 6.6% to 25.1%).

- Q5 late share of bad reviews: 6,381 late orders = 6.7% of reviewed delivered orders,
  but 32.5% of the 12,272 bad (1-2 star) reviews come from late orders.
  Late orders are ~5x over-represented among bad reviews (32.5 / 6.7).

- Q6 seller Pareto: top seller (4869f7a5) holds 1.72% of revenue; top 6 sellers hold 9.0%;
  top 20 sellers hold 21.3% of revenue. Revenue is spread across many sellers (not highly concentrated).
  Risky big seller: 7c67e144 (1.41% of revenue, avg review 3.50, late 9.1%).

- Q7 repeat customers: 93,350 unique customers, 2,801 ordered 2+ times = 3.00% repeat rate.
  97% are one-time buyers, so growth is driven by new customer acquisition, not retention.

- Q8 RFM: biggest segment by spend = At-risk big spenders (16,334 customers, 5,718,963.28 total, avg 350.13, last order ~300 days ago).
  Suggested action: win-back campaign (discount or reminder) targeted at this group first.
  Lost one-time buyers = largest group by count (34,485) but low avg spend (69.53).
  Loyal repeat buyers = only 1,543 customers.

- Q9 payment mix: credit_card is the top method with 78.3% of payment value (12,542,084.19), avg 3.5 installments.
  Boleto = 17.9%, voucher = 2.4%, debit_card = 1.4%.
  Order counts across types add up to more than total orders because some orders use more than one payment type.

- Q10 category satisfaction: 52 categories with 100+ orders.
  3 worst by avg score: office_furniture (3.52, 25.5% bad, 7.9% late, 1,244 orders),
  fixed_telephony (3.76, 23.0% bad, 3.6% late, 209 orders),
  fashion_male_clothing (3.76, 25.0% bad, 4.8% late, 105 orders).
  Lateness alone does not explain these (their late % is near or below the 6.7% average), so product-related issues likely matter too (hypothesis, not tested).
  The last two are small categories, so treat with caution.

- Q11 cohort retention: 207 rows (20 cohorts, Jan 2017 to Aug 2018).
  Jan 2017 cohort: month 0 = __ customers, month 1 = __ customers (__%).
  Typical return rate in months 1-6 is below __% (confirmed in the Step 30 heatmap).
  Consistent with the 3.00% overall repeat rate (Q7).
  
## Python results (headline numbers from Cell 13)

- Spearman correlation: delay_days vs review_score = -0.176; delivery_days vs review_score = -0.235.
  Both negative: longer delays and longer deliveries are associated with lower scores.
  The correlation is weak to moderate because most orders (93%) arrive on time; the effect is concentrated in the late group (see Q4 buckets).
  Association, not proof of cause.

## Python results (headline numbers from Cell 13)
- Delivered orders analysed: 96,470
- Late orders: 6.8% of delivered orders
- Avg review score, on time / late: 4.29 / 2.27
- 1-2 star share, on time / late: 9.3% / 62.4%
- Late share of ALL 1-2 star reviews: 32.5%
- Spearman (delay_days vs score): -0.176
## Business insights
1. ...

## Recommendations
1. ...