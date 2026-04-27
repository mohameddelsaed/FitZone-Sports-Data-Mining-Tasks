# Section 1 — Python Basics Guide
> Covers Eng. Taher's first lecture (Section 1: Python fundamentals + Pandas basics). Implements the **3 assignments** from the slides.

## Required program
- **Anaconda** (Python 3.11+) — <https://www.anaconda.com/download>.
- All libraries used by this notebook ship with Anaconda — no extra install needed.

## Open the notebook
1. Open **Anaconda Navigator** → **Launch Jupyter Notebook**.
2. In the browser tab that opens, navigate to this folder and click `section1_basics.ipynb`.
3. From the menu: `Kernel → Restart & Run All`. Every cell executes in < 2 seconds.

---

## What's inside

| Cell group | Topic |
|---|---|
| 1 | Variables, comments, arithmetic operators |
| 2 | Comparison + logical operators, `if / elif / else` |
| 3 | `while` loop and `for` loop |
| 4 | Function definition and built-ins |
| 5 | **Assignment 1** — Grade calculator from a degree |
| 6 | **Assignment 2** — BMI calculator (relevant to FitZone customers) |
| 7 | **Assignment 3** — DataFrame operations on the sample table from the slides |

### Assignment 1 — grade boundaries
| Degree | Grade |
|--------|-------|
| ≥ 85 | Excellent |
| 75–84 | Very Good |
| 65–74 | Good |
| 50–64 | Pass |
| < 50 | Fail |

### Assignment 2 — BMI thresholds
| BMI | Status |
|-----|--------|
| ≤ 18.5 | UNDERWEIGHT |
| 18.5 – 24.9 | NORMAL WEIGHT |
| 24.9 – 29.9 | OVERWEIGHT |
| > 29.9 | OBESE |

### Assignment 3 — DataFrame
Uses the `col1 / col2 / col3` table from the slides and demonstrates:
- `df.shape[0]` → row count
- `df.sample(frac=0.5)` → random 50% of rows
- `df.sort_values('col1', ascending=False)` → sort DESC
- `df.query('col2 >= 7')` → filter
- `df.tail(3)` → "oldest 3 rows" (= last 3 rows)

---

## Common errors

| Symptom | Fix |
|---|---|
| `NameError: name 'pd' is not defined` | Run the import cell first (or `Kernel → Restart & Run All`). |
| `IndentationError` after editing | Mixed tabs/spaces. Re-indent with **4 spaces** only. |
| `EOFError: EOF when reading a line` if you uncommented the `input()` line | The kernel needs you to type into the input box. Either type a number and press Enter, or comment out `input()` again. |

---

## How to submit
1. `Kernel → Restart & Run All` and confirm a green check on every cell.
2. Edit the first markdown cell to put your name / section / date if your TA asks for that.
3. `File → Download as → Notebook (.ipynb)` (or PDF if the TA wants a PDF).
