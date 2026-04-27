# Classification Task Guide (Sections 6 & 7)
> Eng. Taher's task: *"Select a dataset from Kaggle to build three classification models. Implement Decision Tree, KNN, and Naive Bayes. Assess each model using a Confusion Matrix, Accuracy, Precision and Recall."*

This notebook also contains the **hand-solved confusion matrix** Task 1 from `knn+naive+bayes+confusion.pdf` (the small actual/predicted table at the end of the PDF).

## Required program
- **Anaconda** (Python 3.11+).
- Libraries (all ship with Anaconda):
  ```bash
  pip install pandas numpy matplotlib scikit-learn
  ```

## Open & run
1. **Anaconda Navigator → Launch Jupyter Notebook.**
2. Open `task_classification.ipynb`.
3. `Kernel → Restart & Run All` — finishes in < 10 seconds.

---

## What the notebook does

1. **Loads Wine** (built into sklearn — no Kaggle download required).
2. **Quick EDA** — shape, class balance, missing-value check, `describe()`.
3. **Train / test split** (70 / 30, stratified) and **feature scaling** (StandardScaler) for KNN.
4. **Trains three classifiers**:
   - `DecisionTreeClassifier(criterion='entropy')`
   - `KNeighborsClassifier(n_neighbors=5)` on scaled features
   - `GaussianNB()`
5. For each model: prints **confusion matrix**, full `classification_report` (precision/recall/F1), and renders a `ConfusionMatrixDisplay` with matplotlib.
6. **Compares** all three models in a single bar chart of Accuracy / Precision / Recall / F1.
7. **Visualises the Decision Tree** with `plot_tree`.
8. **Solves the hand exercise** from the PDF:
   - Counts: TP=3, TN=4, FP=2, FN=1.
   - Verifies: Accuracy=0.70, Recall=0.75, Precision=0.60, F1=0.667.

---

## Concepts (cheat sheet)

### Confusion matrix
```
                Pred Pos     Pred Neg
Actual Pos       TP           FN
Actual Neg       FP           TN
```
- **Accuracy**  = (TP + TN) / (TP + TN + FP + FN)
- **Precision** = TP / (TP + FP)
- **Recall**    = TP / (TP + FN)
- **F1**        = 2 · Precision · Recall / (Precision + Recall)
- **P** (positives) = TP + FN
- **N** (negatives) = TN + FP

### Decision Tree
- **Root** — first split. **Internal** — decision tests. **Leaf** — class label.
- Picks the attribute with the highest **Information Gain** (= entropy reduction).
- `H(S) = − Σ p_i log₂ p_i`. Lower is better.

### KNN
- New point ← majority class among its `K` nearest training neighbours (Euclidean distance by default).
- **Always scale features first** — Euclidean distance is dominated by large-scale columns. (This is critical on Wine because `proline` is in the hundreds while `malic_acid` is below 6.)

### Naive Bayes
- Bayes: `P(c|x) = P(x|c) · P(c) / P(x)`.
- "Naive" = assumes features are conditionally independent given the class.
- `GaussianNB` for continuous features; `MultinomialNB` for word counts; `BernoulliNB` for binary features.

---

## Switch to a Kaggle dataset (optional)

In **cell 2**, replace the `load_wine(...)` block with a CSV loader and set `target` to your label column:

```python
import pandas as pd
df = pd.read_csv('heart.csv')
target = 'HeartDisease'      # change to your label column
```

The rest of the notebook auto-adapts (it encodes string columns, scales for KNN, picks `binary` / `macro` averaging based on the number of classes).

---

## Common errors

| Symptom | Fix |
|---|---|
| `ValueError: y contains previously unseen labels` | Use `stratify=y` in `train_test_split` so every class appears in both train and test sets. |
| `KNN` accuracy much worse than DT and NB | Forgot to pass the **scaled** features (`X_tr_s`, `X_te_s`). |
| Decision Tree memory error on a wide dataset | Add `max_depth=…` or `min_samples_leaf=…`. |
| `ConvergenceWarning` from KNN | Some duplicate rows; harmless on Wine. |

---

## Submission tips
- Re-run the whole notebook before submitting (so all outputs appear).
- Take screenshots of: each confusion matrix, the bar-chart comparison, the Decision Tree, and the hand-solved exercise output. TAs sometimes want them in PDF form — `File → Download as → PDF`.
- If you swap to a Kaggle dataset, paste the dataset URL and date in the first markdown cell.
