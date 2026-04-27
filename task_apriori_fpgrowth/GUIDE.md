# Apriori + FP-Growth Task Guide (Section 5)
> Eng. Taher's task: *"Select a sample transaction dataset and apply the Apriori and FP-Growth algorithms to identify frequent itemsets. Subsequently, derive the Association Rules from the generated frequent itemsets."*

## Required program
- **Anaconda** (Python 3.11+).
- One extra library is needed:
  ```bash
  pip install mlxtend
  ```
  (already installed if you ran the global setup from the top-level README).

## Open & run
1. **Anaconda Navigator → Launch Jupyter Notebook.**
2. Open `task_apriori.ipynb`.
3. `Kernel → Restart & Run All` — finishes in < 5 seconds.

---

## Concepts (cheat sheet)

- **Itemset** — any subset of items, e.g. `{Football Ball, Football Cleats}`.
- **Support(X)** = transactions containing X / total transactions.
- **Frequent itemset** = itemset with `support ≥ min_support`.
- **Association rule** `A → C` reads "customers who bought A also bought C".
- **Confidence(A→C)** = `support(A∪C) / support(A)` ∈ [0, 1].
- **Lift(A→C)** = `confidence(A→C) / support(C)`. `> 1` ⇒ positive correlation, `= 1` ⇒ independence.
- **Apriori** — generates candidates level by level (slow on big data).
- **FP-Growth** — uses an FP-tree, no candidate generation, much faster on large data.
  Both algorithms must return the **same** set of frequent itemsets given the same `min_support`.

---

## What the notebook does

1. Builds a 25-row FitZone Sports market-basket dataset (one row = one customer's basket on a single visit).
2. One-hot encodes it with `mlxtend.preprocessing.TransactionEncoder`.
3. Runs `apriori` with `min_support=0.15`, sorts by support, prints all frequent itemsets.
4. Runs `fpgrowth` with the same threshold, asserts the result is identical.
5. Generates association rules with `min_threshold=0.6` (confidence) and ranks by `lift`.
6. Filters rules by user-defined criteria (`antecedent_len`, `confidence > 0.7`, `lift > 1`).
7. Interprets the top rules in plain English with a FitZone-Sports operational angle (cross-sell bundles, shelf placement, persona-based landing pages).

---

## Switch to a Kaggle transactions dataset (optional)

The task says "sample transaction dataset" — the embedded one is fine. If you want a Kaggle one anyway:

```python
# Step 1 — download e.g. https://www.kaggle.com/datasets/heeraldedhia/groceries-dataset
import pandas as pd
raw = pd.read_csv('Groceries_dataset.csv')   # cols: Member_number, Date, itemDescription

# Step 2 — group items per (member, date) into a list-of-lists
transactions = (
    raw.groupby(['Member_number', 'Date'])['itemDescription']
       .apply(list)
       .tolist()
)

# Step 3 — replace the `transactions = [...]` list in cell 4 with the variable above.
# Step 4 — lower min_support (real-world data is sparse), e.g. 0.02.
```

The rest of the notebook is unchanged.

---

## Tuning `min_support`

| Dataset size | Suggested `min_support` |
|---|---|
| 25 small baskets (this notebook) | 0.10 – 0.20 |
| 1 000 baskets | 0.05 – 0.1 |
| 10 000+ baskets | 0.005 – 0.02 |

If your output table is empty, lower it. If it explodes into thousands of itemsets, raise it.

---

## Common errors

| Symptom | Fix |
|---|---|
| `ModuleNotFoundError: mlxtend` | `pip install mlxtend`, then **Kernel → Restart**. |
| `apriori` returns 0 rows | `min_support` is too high — try 0.1 or lower. |
| Rules table empty even with itemsets present | `min_threshold=0.7` (confidence) is too strict — try 0.4. |
| `frozenset` vs `set` confusion when filtering | mlxtend uses `frozenset`. Compare with `frozenset({'Football Ball','Football Cleats'})`. |

---

## Submission tips
- Add a markdown cell at the bottom interpreting the **top-3 rules by lift** in plain English. TAs love that.
- If you swap to a Kaggle dataset, mention the URL and the date you downloaded it in the first markdown cell.
- Don't forget to re-run all cells after any edit (`Kernel → Restart & Run All`) so outputs match the code.
