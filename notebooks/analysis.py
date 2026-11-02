# analysis.py : Python analysis for the Olist project.
# Each "# %%" line starts a new cell in VS Code (Run Cell) or Jupyter.

# %% [Cell 1] Setup
import sys
from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Find the project root, whether you run the file, a cell, or from the notebooks/ folder
try:
    ROOT = Path(__file__).resolve().parent.parent
except NameError:  # running a cell in VS Code Interactive window
    ROOT = Path.cwd()
    if ROOT.name == "notebooks":
        ROOT = ROOT.parent
sys.path.append(str(ROOT / "notebooks"))

from db import run_query

OUT = ROOT / "output"
CHARTS = OUT / "charts"
CHARTS.mkdir(parents=True, exist_ok=True)

sns.set_theme(style="whitegrid", context="notebook")
BLUE, RED = "#2563eb", "#dc2626"

def q(name):
    """Run one of the .sql files from the sql/ folder."""
    return run_query((ROOT / "sql" / f"{name}.sql").read_text(encoding="utf-8"))

def save(name):
    plt.tight_layout()
    plt.savefig(CHARTS / f"{name}.png", dpi=150)
    plt.close()

# %% [Cell 2] Load the main table and look at it
orders = run_query("SELECT * FROM v_delivered_orders")
for col in ["purchase_date", "purchase_month", "estimated_date", "delivered_date"]:
    orders[col] = pd.to_datetime(orders[col])
print("Rows, columns:", orders.shape)
print(orders.dtypes)
print(orders.head())

# %% [Cell 3] Missing values (% per column)
print(orders.isna().mean().mul(100).round(2).sort_values(ascending=False))

# %% [Cell 4] Review score distribution
fig, ax = plt.subplots(figsize=(7, 4))
counts = orders["review_score"].value_counts(normalize=True).sort_index().mul(100)
sns.barplot(x=counts.index.astype(int), y=counts.values, color=BLUE, ax=ax)
for i, v in enumerate(counts.values):
    ax.text(i, v + 0.5, f"{v:.1f}%", ha="center")
ax.set_xlabel("Review score")
ax.set_ylabel("% of delivered orders")
ax.set_title("Most customers are happy, but 1-star reviews are a real tail")
save("01_review_score_distribution")

# %% [Cell 5] The key chart: lateness vs review score
buckets = q("q04_delay_vs_reviews")
fig, axes = plt.subplots(1, 2, figsize=(12, 4.5))
sns.barplot(data=buckets, x="delay_bucket", y="avg_review_score", color=BLUE, ax=axes[0])
axes[0].set_title("Average review score by delivery delay")
axes[0].set_xlabel("")
axes[0].set_ylabel("Average review score")
axes[0].set_ylim(1, 5)
sns.barplot(data=buckets, x="delay_bucket", y="one_or_two_star_pct", color=RED, ax=axes[1])
axes[1].set_title("% of 1-2 star reviews by delivery delay")
axes[1].set_xlabel("")
axes[1].set_ylabel("% of 1-2 star reviews")
for ax in axes:
    ax.tick_params(axis="x", rotation=25)
    for label in ax.get_xticklabels():
        label.set_ha("right")
save("02_delay_vs_reviews")

# %% [Cell 6] How strong is the relationship? (Spearman correlation)
pair = orders[["delay_days", "delivery_days", "review_score"]].dropna()
print(pair.corr(method="spearman").round(3))

# %% [Cell 7] Delivery days for each review score
fig, ax = plt.subplots(figsize=(7, 4.5))
sns.boxplot(data=pair, x="review_score", y="delivery_days", color=BLUE, showfliers=False, ax=ax)
ax.set_title("Lower review scores go with longer deliveries")
ax.set_xlabel("Review score")
ax.set_ylabel("Delivery days")
save("03_delivery_days_by_score")

# %% [Cell 8] Late % and delivery time by state
states = q("q03_delivery_by_state")
fig, ax = plt.subplots(figsize=(8, 5))
sns.barplot(data=states.sort_values("late_pct"), y="customer_state", x="late_pct", color=RED, ax=ax)
ax.set_title("Late delivery % by customer state")
ax.set_xlabel("% of orders delivered late")
ax.set_ylabel("")
save("04_late_pct_by_state")

# %% [Cell 9] Category revenue vs satisfaction
cats = q("q10_category_satisfaction")
fig, ax = plt.subplots(figsize=(9, 6))
ax.scatter(cats["revenue"], cats["avg_review_score"], s=cats["orders"] / 3, color=BLUE, alpha=0.6)
for _, r in cats.iterrows():
    ax.annotate(r["category"], (r["revenue"], r["avg_review_score"]), fontsize=8, xytext=(4, 4), textcoords="offset points")
ax.set_xlabel("Revenue")
ax.set_ylabel("Average review score")
ax.set_title("Category revenue vs customer satisfaction (bubble size = orders)")
save("05_category_revenue_vs_satisfaction")

# %% [Cell 10] RFM segments
rfm = q("q08_rfm_segments")
fig, axes = plt.subplots(1, 2, figsize=(12, 4.5))
sns.barplot(data=rfm, y="segment", x="customers", color=BLUE, ax=axes[0])
axes[0].set_title("Customers per segment")
axes[0].set_ylabel("")
sns.barplot(data=rfm, y="segment", x="total_spend", color=RED, ax=axes[1])
axes[1].set_title("Total spend per segment")
axes[1].set_ylabel("")
save("06_rfm_segments")

# %% [Cell 11] Cohort retention heatmap
cohort = q("q11_cohort_retention")
cohort["cohort_month"] = pd.to_datetime(cohort["cohort_month"])
table = cohort.pivot(index="cohort_month", columns="months_since_first", values="customers")
retention = table.div(table[0], axis=0).mul(100)
retention.index = retention.index.strftime("%Y-%m")
fig, ax = plt.subplots(figsize=(12, 7))
sns.heatmap(retention.loc[:, 1:12], cmap="Blues", annot=True, fmt=".1f", cbar_kws={"label": "% of cohort returning"}, ax=ax)
ax.set_title("Cohort retention: % of each first-order-month cohort that ordered again")
ax.grid(False)
ax.set_xlabel("Months since first order")
ax.set_ylabel("First-order month")
save("07_cohort_retention")

# %% [Cell 12] Monthly revenue trend
monthly = q("q01_monthly_revenue")
monthly["month"] = pd.to_datetime(monthly["month"])
fig, ax = plt.subplots(figsize=(10, 4.5))
ax.plot(monthly["month"], monthly["revenue"], marker="o", color=BLUE)
ax.set_title("Monthly revenue (delivered orders)")
ax.set_ylabel("Revenue")
ax.set_xlabel("")
save("08_monthly_revenue")

# %% [Cell 13] Headline numbers for your README (copy these into the README)
scored = orders.dropna(subset=["review_score"])
late = scored[scored["is_late"]]
on_time = scored[~scored["is_late"]]
bad = scored[scored["review_score"] <= 2]
print(f"Delivered orders analysed : {len(orders):,}")
print(f"Late orders : {orders['is_late'].mean() * 100:.1f}% of orders")
print(f"Avg review, on time / late : {on_time['review_score'].mean():.2f} / {late['review_score'].mean():.2f}")
print(f"1-2 star share, on time / late : {(on_time['review_score'] <= 2).mean() * 100:.1f}% / {(late['review_score'] <= 2).mean() * 100:.1f}%")
print(f"Late share of ALL 1-2 star reviews: {bad['is_late'].mean() * 100:.1f}%")
print(f"Spearman (delay_days vs score) : {pair['delay_days'].corr(pair['review_score'], method='spearman'):.3f}")

# %% [Cell 14] Export tables for Power BI
orders.to_csv(OUT / "fact_orders.csv", index=False)
run_query("SELECT * FROM v_item_detail").to_csv(OUT / "fact_items.csv", index=False)
buckets.to_csv(OUT / "agg_delay_buckets.csv", index=False)
rfm.to_csv(OUT / "agg_rfm_segments.csv", index=False)
cats.to_csv(OUT / "agg_category_satisfaction.csv", index=False)
q("q06_seller_pareto").to_csv(OUT / "agg_top_sellers.csv", index=False)
q("q09_payment_mix").to_csv(OUT / "agg_payment_mix.csv", index=False)
states.to_csv(OUT / "agg_state_delivery.csv", index=False)
retention_long = (retention.reset_index()
                  .melt(id_vars="cohort_month", var_name="months_since_first", value_name="retention_pct")
                  .dropna())
retention_long.to_csv(OUT / "agg_cohort_retention.csv", index=False)
print("Exported:", sorted(p.name for p in OUT.glob("*.csv")))