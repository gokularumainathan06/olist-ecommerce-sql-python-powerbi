# Metric definitions
| Metric | Definition |
|---|---|
| Revenue | Sum of item price (freight excluded) for delivered orders |
| Order | One row in the orders table with status = delivered and a delivery date |
| Late order | Delivered date is later than the estimated delivery date |
| Delay days | Delivered date minus estimated date (negative = early) |
| Bad review | Review score of 1 or 2 |
| Repeat customer | customer_unique_id with 2 or more delivered orders |
| Analysis period | Jan 2017 to Aug 2018 (first and last months are incomplete) |