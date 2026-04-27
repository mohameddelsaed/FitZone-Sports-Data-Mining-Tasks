# FitZone Sports — Data Mining Tasks

> Complete submission pack for the **Data Mining** course (Information Systems department, Mansoura, Spring 2026).
> Instructors: **Dr. Aya Nabil** (Excel / SQL track) and **Eng. Taher Eladly** (Python track).

This repo contains every deliverable required by the course, with line-by-line implementation guides so you (or anyone re-using this) can re-run, modify, or submit each piece.

> **New here?** Read **[PROJECT.md](PROJECT.md)** first — it explains *what* the project is about (a fictitious sports-equipment retail shop, **FitZone Sports**, with 5 product categories: Football, Gym, Swimming, Running, Cycling, plus 3 data-mining notebooks), *how* the data flows between the Excel workbook, the SQL database, and the Python notebooks, and *how* each deliverable is implemented (formulas, schema, algorithms).

---

## Repo layout

```
FitZone-Sports-Data-Mining-Tasks/
├── README.md                                  ← you are here
├── PROJECT.md                                 ← architecture, domain, and data-flow doc
├── docs/
│   └── FitZone_Sports_Full_Guide.md           ← the master walk-through of the entire
│                                                course (Sections 1–7 + every task,
│                                                formula, and code sample)
├── excel_business_system/
│   ├── FitZoneSystem.xlsx                     ← Excel Tasks 1 & 2 deliverable
│   └── GUIDE.md                               ← step-by-step Excel guide
├── sql_database/
│   ├── fitzone_db.sql                         ← SQL Task 3 deliverable
│   └── GUIDE.md                               ← step-by-step MySQL guide
├── section1_python_basics/
│   ├── section1_basics.ipynb                  ← Section 1 (3 assignments)
│   └── GUIDE.md
├── task_pandas/
│   ├── task_pandas.ipynb                      ← Section 3 task on Wine
│   └── GUIDE.md
├── task_apriori_fpgrowth/
│   ├── task_apriori.ipynb                     ← Section 5 task on FitZone-Sports
│   │                                            market-basket transactions
│   └── GUIDE.md
└── task_classification/
    ├── task_classification.ipynb              ← Sections 6 & 7 task on Wine
    └── GUIDE.md
```

Every notebook was **executed before commit**, so opening any `.ipynb` in GitHub already shows all outputs, tables, and plots.

---

## Tasks → deliverables map

| # | Task (from the WhatsApp brief) | Track | File |
|---|---|---|---|
| **T1** | 5 business tables with formulas (`SUM`, `AVERAGE`, `IF`, `SUMIF`, `COUNTIF`) | Excel | [`excel_business_system/FitZoneSystem.xlsx`](excel_business_system/FitZoneSystem.xlsx) |
| **T2** | VLOOKUP / INDEX-MATCH, What-If, Goal Seek, Pivot Tables / Charts, Dashboard | Excel | same workbook (sheets *Analysis, WhatIf, GoalSeek, Pivots, Dashboard*) |
| **T3** | DB + tables + FK + INSERT + 10 queries with JOINs / aggregates | SQL | [`sql_database/fitzone_db.sql`](sql_database/fitzone_db.sql) |
| **PY-A** | Apply every Pandas function from Section 3 on a real dataset | Python | [`task_pandas/task_pandas.ipynb`](task_pandas/task_pandas.ipynb) |
| **PY-B** | Apriori + FP-Growth + Association Rules on a transactions dataset | Python | [`task_apriori_fpgrowth/task_apriori.ipynb`](task_apriori_fpgrowth/task_apriori.ipynb) |
| **PY-C** | Decision Tree + KNN + Naive Bayes with Confusion Matrix evaluation | Python | [`task_classification/task_classification.ipynb`](task_classification/task_classification.ipynb) |
| Bonus | Section 1 Python assignments (Grade calc, BMI, DataFrame ops) | Python | [`section1_python_basics/section1_basics.ipynb`](section1_python_basics/section1_basics.ipynb) |

---

## One-time setup (≈ 20 min)

You need **three** programs:

1. **Microsoft Excel 2016+** — for `FitZoneSystem.xlsx`.
2. **MySQL Workbench 8.x** — for `fitzone_db.sql`. Download from <https://dev.mysql.com/downloads/workbench/>.
   *(SQL Server Management Studio also works — see `sql_database/GUIDE.md` for the conversion notes.)*
3. **Anaconda Distribution** (Python 3.11) — for the Jupyter notebooks. Download from <https://www.anaconda.com/download>.

After Anaconda is installed, open **Anaconda Prompt** and run once:

```bash
pip install pandas numpy matplotlib seaborn scikit-learn mlxtend openpyxl
```

That installs every library all four notebooks use.

---

## How to run each deliverable

### 1. Excel — `excel_business_system/FitZoneSystem.xlsx`
1. Double-click the file. It opens in Excel.
2. Excel will recalculate every formula on first open. Accept any prompt about "external links" — they're cross-sheet references, not external.
3. The `Dashboard` sheet shows live KPI cards + 3 charts.
4. To run the **5 Goal Seek scenarios**, open the `GoalSeek` sheet — it lists exact cells / target values / by-changing cells. Then `Data → What-If Analysis → Goal Seek`.
5. Real PivotTables can only be created inside Excel; the `Pivots` sheet has SUMIFS/SUMPRODUCT equivalents that match what a pivot would compute. To create a real pivot: click any cell in `Sales`, then `Insert → PivotTable`.

Full step-by-step in [`excel_business_system/GUIDE.md`](excel_business_system/GUIDE.md).

### 2. SQL — `sql_database/fitzone_db.sql`
1. Launch **MySQL Workbench** and connect to your local server.
2. `File → Open SQL Script…` → pick `fitzone_db.sql`.
3. Hit `Ctrl + Shift + Enter` (or *Query → Execute (All)*).
4. The script drops/creates `FitZone_DB`, builds 5 tables with constraints, inserts sample rows, and runs all 10 required SELECT queries. Switch to the *Result Grid* tab to see each query's output.

Full guide in [`sql_database/GUIDE.md`](sql_database/GUIDE.md), including the conversion notes for SSMS.

### 3. Notebooks (all four)
1. Open **Anaconda Navigator** → **Launch Jupyter Notebook**.
2. Browse to wherever you cloned this repo and click any `.ipynb`.
3. From the menu bar: `Kernel → Restart & Run All`.
4. Every cell executes top-to-bottom in seconds (Wine and the FitZone basket dataset are tiny).

Per-notebook guides:
- [`section1_python_basics/GUIDE.md`](section1_python_basics/GUIDE.md)
- [`task_pandas/GUIDE.md`](task_pandas/GUIDE.md)
- [`task_apriori_fpgrowth/GUIDE.md`](task_apriori_fpgrowth/GUIDE.md)
- [`task_classification/GUIDE.md`](task_classification/GUIDE.md)

---

## Cloning & contributing

```bash
git clone <your-fork-url>
cd FitZone-Sports-Data-Mining-Tasks
```

If you make changes to a notebook, please re-run all cells (`Kernel → Restart & Run All`) before committing so the diff stays clean.

---

## Submission checklist

- [ ] `FitZoneSystem.xlsx` (rename to include your full name if your TA requests it)
- [ ] `fitzone_db.sql` + a screenshot of the schema diagram (`Database → Reverse Engineer…`)
- [ ] `section1_basics.ipynb`
- [ ] `task_pandas.ipynb`
- [ ] `task_apriori.ipynb`
- [ ] `task_classification.ipynb`

Before submitting any notebook:
1. `Kernel → Restart & Run All` — make sure every cell still ends with a green check.
2. Edit the **first markdown cell** of each notebook to reflect your *exact* group / section / submission date if your TA asks for those fields.
3. Optional but nice: export each notebook to PDF (`File → Download as → PDF` in Jupyter, or `jupyter nbconvert --to pdf <name>.ipynb`).

---

## Source materials referenced

The slides and notebooks the lecturers shared, on which these deliverables are based:

- `Section+1_Data+Mining.pdf` — Python fundamentals & Pandas basics
- `Section+2_Data+Mining.pdf` — Importing data
- `Section+3_+Data+Mining.pdf` + `Section+3_Data+Mining_notebook.html` — Pandas manipulation
- `missing_values.html` — Handling NaN
- `Section+5_Data+Mining_Frequent-Itemset.pdf` + the Apriori/FP-Growth notebook — frequent itemsets
- `Section+6_Data+Mining_Classification.pdf` — Decision Trees
- `Section+7_+Classification_part+2.pdf` + `knn+naive+bayes+confusion.pdf` — KNN, Naive Bayes, confusion matrix
- WhatsApp chat dump — task statements, due dates, submission rules

The full walk-through that synthesises all of these into one document lives at [`docs/FitZone_Sports_Full_Guide.md`](docs/FitZone_Sports_Full_Guide.md).

---

**Author:** Mohamed Elsaeed  ·  Information Systems, Mansoura  ·  2026
