# Pandas Task Guide (Section 3)
> Eng. Taher's task: *"Apply every function from the Section 3 file and notebook on a real dataset (e.g. Kaggle)."*

This notebook covers `Section+3_+Data+Mining.pdf`, `Section+3_Data+Mining_notebook.html`, and `missing_values.html` — applied on the **Wine** dataset (built into scikit-learn — no Kaggle download required).

## Required program
- **Anaconda** (Python 3.11+).
- Libraries: `pandas`, `numpy`, `matplotlib`, `scikit-learn` — all ship with Anaconda. If anything is missing:
  ```bash
  pip install pandas numpy matplotlib scikit-learn
  ```

## Open & run
1. **Anaconda Navigator → Launch Jupyter Notebook.**
2. Open `task_pandas.ipynb`.
3. `Kernel → Restart & Run All`. Each cell finishes in milliseconds.

## Swap in your own Kaggle dataset (optional)
- In **cell 2**, replace the `load_wine(...)` block with:
  ```python
  import pandas as pd
  data = pd.read_csv('path/to/your_kaggle_file.csv')
  data.to_csv('wine.csv', index=False)   # keep the rest of the notebook unchanged
  x = pd.read_csv('wine.csv')
  ```
- The rest of the notebook will still work as long as your dataset has at least one numeric column for the histogram/boxplot and one categorical column for `astype('category')`. You will also need to update the column names referenced in cells 18–24 (e.g. `alcohol`, `malic_acid`, `wine_class`).

## Functions demonstrated (every one in the lecture notebook)

| Section | Function | Purpose |
|---|---|---|
| Inspect | `.shape, .dtypes, .info(), .describe(), .columns, .head(), .tail(), .sample(n=…), .sample(frac=…)` | Quick look at the data |
| Select | `.loc[row]`, `.loc[:, col]`, `.iloc[r,c]`, `.iloc[:, c]` | Row/column access |
| Drop | `.drop([rows], axis=0)`, `.drop([cols], axis=1)` | Remove rows or columns |
| Filter / sort / rename | `.query('col==…')`, `.sort_values(by, ascending)`, `.rename(columns={old:new})` | Reshape |
| Categorical | `.astype('category')` | Convert dtype |
| Plots | `.hist()`, `.boxplot(column=…)` | Visualisation |
| Missing values | `.isnull()`, `.isnull().sum()`, `.dropna(how='any'\|'all')`, `.fillna(0\|dict\|.ffill()\|.bfill()\|.mean()\|.median()\|.mode())` | Handling NaN |
| Save | `.to_csv('out.csv', index=False)` | Persist cleaned data |

> **About `fillna(method='ffill')`**: pandas 2.1+ removed the `method` keyword in favour of dedicated `.ffill()` / `.bfill()` methods. The notebook shows both syntaxes (with a `try/except` fallback) so it runs on any version of pandas.

## Common errors

| Symptom | Fix |
|---|---|
| `ModuleNotFoundError: sklearn` | `pip install scikit-learn` (the package is `scikit-learn`, the import is `sklearn`). |
| `TypeError: NDFrame.fillna() got an unexpected keyword argument 'method'` | You're on pandas ≥ 2.1 — use `.ffill()` / `.bfill()` instead (already in the notebook). |
| Plots don't show | Add `%matplotlib inline` at the top of the notebook (Jupyter usually does this for you). |
| `KeyError: 'alcohol'` on a custom CSV | Your column names differ from Wine. Adjust the column names in cells 18–24. |

## Submission tips
- Run-all once before submission so all outputs appear in the saved file.
- Wine is a perfectly valid choice (it's a well-known UCI dataset). If your TA explicitly insists on a Kaggle dataset, swap the data loader as shown above and re-run.
