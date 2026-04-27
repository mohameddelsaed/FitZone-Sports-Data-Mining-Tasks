# Project Overview — *FitZone Sports — Data Mining Tasks*

## 1. What is this project about?

This repository is the **complete coursework submission** for the *Data Mining* course offered by the **Information Systems department, Faculty of Computers and Information, Mansoura University** (Spring 2026). The course is taught jointly by:

- **Dr. Aya Nabil** — Excel + SQL (business-system / database track).
- **Eng. Taher Eladly** — Python (data-mining algorithms track).

The course brief asks the student to deliver an **end-to-end management system for a small product-based business** plus three **data-mining notebooks** that demonstrate the algorithms taught in lectures. Every deliverable from the lectures (Sections 1–7) and every assignment from the WhatsApp brief is implemented here, executed, and documented.

This single project therefore plays two roles simultaneously:

1. **An applied case study** — a fictitious sports-equipment retail shop, **FitZone Sports**, whose operations are tracked in Excel, then re-modelled as a relational database in SQL.
2. **A data-mining lab notebook** — three Jupyter notebooks that take public datasets and run the lecture's algorithms (Pandas pipelines, Apriori / FP-Growth, Decision Tree / KNN / Naive Bayes) over them.

## 2. The business domain (one consistent story across all 6 deliverables)

To make the project coherent, every deliverable describes the **same** small sports-equipment shop located in Mansoura with online delivery to Cairo and Alexandria:

```
                     ┌────────────────┐
                     │  Suppliers      │
                     │ (Adidas Egypt,  │
                     │  Nike ME,       │
                     │  Decathlon,     │
                     │  FitnessPro,    │
                     │  Garmin, Trek …)│
                     └───────┬─────────┘
                             │   Purchases
                             ▼
                     ┌────────────────┐         ┌─────────────┐
                     │   Product       │◄─────── │  Inventory  │
                     │ (Football, Gym, │   stock │   updates   │
                     │  Swimming,      │         └─────────────┘
                     │  Running,       │
                     │  Cycling)       │
                     └───────┬─────────┘
                             │   Sales
                             ▼
                     ┌────────────────┐
                     │   Customers     │
                     │ (Mansoura,      │
                     │  Cairo, Alex)   │
                     └────────────────┘
                             ▲
              Operating expenses (rent, salaries, utilities,
              marketing, maintenance, cleaning, office)
                             ▲
                             └── feeds the Dashboard KPIs
```

There are exactly **5 business entities** mirrored across Excel and SQL:

| Entity | What it represents |
|---|---|
| **Product** | The catalogue — every SKU the shop can sell, with unit price and stock level. |
| **Sales** | One row per sale transaction. Each row links a `Product` to a `Customer`. |
| **Customers** | The customer database. `Total_Purchases` aggregates all their sales. |
| **Purchases** | Inbound supplier orders that replenish `Product` stock. |
| **Expenses** | Every overhead cost (rent, salaries, utilities, marketing, etc.). |

Every formula in the workbook, every CHECK in the SQL script, and every chart on the dashboard refers back to those five entities.

## 3. Architecture / data flow

```
                ┌──────────────────────────────────────────────┐
                │        FitZoneSystem.xlsx (Excel)            │
                │                                               │
   user types ─►│  Product / Sales / Customers / Purchases     │──► live formulas
   numbers      │  / Expenses                                  │    re-compute
                │                                               │    Analysis,
                │                                               │    WhatIf,
                │                                               │    Pivots,
                │                                               │    Dashboard
                └──────────────────────┬───────────────────────┘
                                       │  same data modelled relationally
                                       ▼
                ┌──────────────────────────────────────────────┐
                │        fitzone_db.sql (MySQL Workbench)      │
                │                                               │
                │  CREATE DATABASE → 5 tables with PK/FK/CHECK │
                │  → INSERT sample rows                         │
                │  → 10 SELECT/JOIN/AGGREGATE queries           │
                └──────────────────────────────────────────────┘

                ┌──────────────────────────────────────────────┐
                │      Python data-mining notebooks            │
                │                                               │
                │  Wine / FitZone-Sports baskets (built-in)     │
                │   ↓ Pandas (clean / filter / impute / plot)  │
                │   ↓ mlxtend (Apriori → FP-Growth → rules)    │
                │   ↓ scikit-learn (DT, KNN, NB) + metrics     │
                └──────────────────────────────────────────────┘
```

The **Excel workbook is the source of truth** for the business numbers; the **SQL script proves the same model can be normalised** into a relational schema; the **Python notebooks are independent labs** that teach the data-mining algorithms on canonical public datasets (so each algorithm's behaviour can be compared with textbook reference values).

## 4. Implementation walk-through

### 4.1 Excel — `excel_business_system/FitZoneSystem.xlsx`

> Solves **Tasks 1 & 2** of Dr. Aya's track.

10 sheets, **all formulas live** (no hard-coded numbers in computed columns):

| Sheet | Role | Key formulas |
|------|------|-------------|
| **Product** | Catalogue (10 SKUs across Football/Gym/Swimming/Running/Cycling) | `Stock_Value = D*E`, `Stock_Status = IF(E<10,"Reorder","Sufficient")` |
| **Sales** | 20 sale transactions | `Total_Sale = D*E`, `Category = VLOOKUP(B, Product, 3)`, `Customer_City = INDEX(Customers!C, MATCH(C, Customers!A, 0))`, `Unit_Cost = AVERAGEIF(Purchases…)`, `Profit = F-(D*M)`, `Margin = N/F` |
| **Customers** | 6 customers | `Total_Purchases = SUMIF(Sales!C, A, Sales!F)`, `Loyalty = IF(E>10000,"Loyal","Regular")`, `Rank = RANK(E, $E$2:$E$10, 0)` |
| **Purchases** | 12 supplier orders | `Total_Cost = D*E`, `Order_Type = IF(F>10000,"Bulk","Normal")`, `Category = VLOOKUP(C, Product, 3)` |
| **Expenses** | 15 monthly costs | `Flag = IF(C>2000,"Check","OK")`, `After_Cut_10pct = IF(G="No", C*0.9, C)` |
| **Analysis** | Supplier summary, remaining stock per product, **Top-5 customers via INDEX/MATCH on RANK** | `=SUMIF(Purchases!B, "Adidas Egypt", Purchases!F)`, `=AVERAGEIF(...)` |
| **WhatIf** | 5 scenario tables | `Stock × 0.8`, `+5/+10/+15 % unit price`, `+3 customers in Cairo`, `FitnessPro Imports cost +10 %`, `cut 10 % non-essentials` |
| **GoalSeek** | Step-by-step instructions for 5 manual Goal Seek runs (Loyal threshold, profit target 1500, ≤ 50 000 purchase, ≤ 70 000 expenses, Stock_Value = 60 000 without changing qty) | n/a (UI workflow) |
| **Pivots** | SUMIFS / SUMPRODUCT equivalents of the required PivotTables + 3 charts (column / pie / line) | `=SUMIFS(Sales!F, Sales!I, "Football")`, `=SUMPRODUCT((MONTH(Sales!G)=m)*(Sales!B=pid)*Sales!F)` |
| **Dashboard** | 6 KPI cards (Total Revenue, Total Profit, Avg Profit Margin, Total Expenses, Total Stock Value, Total Remaining Stock) + 3 charts | All KPIs via `SUM` / `SUMPRODUCT` |

Why these design choices?

- **Cross-sheet lookups via `VLOOKUP` + `INDEX/MATCH`** demonstrate both the older (VLOOKUP) and the more flexible (INDEX/MATCH) lookup patterns the lecture explicitly asked for.
- **Conditional formatting** on `Stock_Status`, `Loyalty`, and `Flag` columns highlights anomalies visually so the dashboard reader spots problems instantly.
- **What-If scenarios** are implemented with formula-driven copies of the source columns rather than Excel's *Scenario Manager*, because formula sheets re-calculate live as you edit input cells (a smoother demo for the dashboard).
- **Goal Seek** can only be invoked through Excel's UI; therefore the `GoalSeek` sheet documents the exact "Set cell / To value / By changing cell" mapping and the student must run each scenario manually and screenshot the dialog.

### 4.2 SQL — `sql_database/fitzone_db.sql`

> Solves **Task 3** of Dr. Aya's track.

The same business is modelled as a **third-normal-form relational schema**:

```
Product (Product_ID PK, Product_Name, Category, Unit_Price ≥0, Stock_Quantity ≥0)
   ↑                            ↑
   │ FK                         │ FK
   │                            │
Sales (Sale_ID PK,              Purchases (Purchase_ID PK,
       Product_ID FK,                       Supplier_Name,
       Customer_ID FK,                      Product_ID FK,
       Quantity ≥0,                         Quantity ≥0,
       Unit_Price ≥0,                       Unit_Cost ≥0,
       Total_Sale ≥0,                       Total_Cost ≥0,
       Sale_Date)                           Purchase_Date)
   │
   │ FK
   ▼
Customers (Customer_ID PK, Customer_Name, City,
           Contact_Number, Total_Purchases default 0)

Expenses (Expense_ID PK, Expense_Type, Amount ≥0, Date, Notes)
```

Implementation choices:

- Every numeric column has a **`CHECK ≥ 0`** constraint so that `Total_Sale = -100` is rejected at the database level — defensive programming, not just a UI rule.
- **Foreign keys** are declared inline (in `CREATE TABLE`) *and* re-declared as commented-out `ALTER TABLE` statements at the bottom, because the lecture explicitly listed both forms as required.
- The script is **idempotent**: it begins with `DROP DATABASE IF EXISTS`, so re-running it always starts from a clean state.
- A bonus **correlated UPDATE** at the end re-syncs `Customers.Total_Purchases` from the `Sales` table so the column is consistent with the truth source.

The 10 required SELECT queries (low-stock products, sales by date, customers by city, expenses > 2000, three JOINs, stock value, total revenue, total expenses) are all included.

### 4.3 Python notebook — `section1_python_basics/section1_basics.ipynb`

> Section 1 fundamentals + the 3 lecture assignments.

Three short functions:

1. **`assignment_1(name, dept, degree)`** — bucket a numeric degree into one of five categorical grades (`Excellent / Very Good / Good / Pass / Fail`).
2. **`bmi_status(name, weight, height_cm)`** — converts cm to m, computes BMI = `kg / m²`, then buckets into `UNDERWEIGHT / NORMAL WEIGHT / OVERWEIGHT / OBESE`. (Especially relevant to FitZone Sports — it's exactly the calculation an in-store fitness coach would run.)
3. **DataFrame quick exercises** on the small 5×3 table from the slide deck (`df.shape[0]`, `df.sample`, `df.sort_values`, `df.query`, `df.tail`).

The notebook's purpose is to prove the student understands the language constructs (variables, conditions, loops, functions, pandas selection) **before** moving on to the algorithm-heavy sections.

### 4.4 Pandas pipeline — `task_pandas/task_pandas.ipynb`

> Solves **PY-A** ("apply every Pandas function from Section 3 on a real dataset").

Pipeline structure:

```
load_wine() ──► save to CSV ──► reload via pd.read_csv  (proves the I/O loop)
                                          │
                                          ├── shape / dtypes / info / describe / columns
                                          ├── head / tail / sample(n) / sample(frac)
                                          ├── loc / iloc selectors
                                          ├── drop rows / drop columns
                                          ├── query / sort_values / rename
                                          ├── astype('category')
                                          ├── hist() / boxplot()
                                          │
                                          ▼
                          inject ~10% random NaNs ──► ALL fill strategies:
                                          ├── isnull / dropna(how='any') / dropna(how='all')
                                          ├── fillna(0)            (constant)
                                          ├── fillna({col: val})    (per-column)
                                          ├── ffill() / bfill()     (modern API)
                                          ├── fillna(method='ffill') in try/except (legacy slide syntax)
                                          ├── fillna(df.mean()) / fillna(df.median())
                                          └── fillna(df.mode().iloc[0])
                                          │
                                          ▼
                          to_csv("wine_cleaned.csv") — proof of round-trip
```

The Wine dataset (178 × 13 + 3 classes) is large enough to make the missing-value imputation interesting (mean imputation actually shifts the distribution slightly) yet small enough to run end-to-end in milliseconds.

### 4.5 Frequent itemsets — `task_apriori_fpgrowth/task_apriori.ipynb`

> Solves **PY-B**.

The notebook ships with a hand-crafted **FitZone Sports market-basket dataset** of 25 transactions over 14 distinct items. Items belong to recognisable customer personas — Footballer, Runner, Cyclist, Swimmer, Gym-Goer — so Apriori and FP-Growth surface clear cross-sell rules.

Algorithm flow:

```
transactions (list of lists)
     │
     ▼
TransactionEncoder ──► one-hot DataFrame
     │
     ├── apriori   (min_support = 0.15)  ──► frequent itemsets
     ├── fpgrowth  (min_support = 0.15)  ──► same itemsets (asserted equal)
     │
     ▼
association_rules (metric = confidence, min_threshold = 0.6)
     │
     └── ranked by lift, filtered (antecedent_len, confidence > 0.7, lift > 1)
```

Concrete rules surfaced (sample):

- `{Football Ball} → {Football Cleats}` — high confidence, lift > 1
- `{Running Shoes} → {GPS Watch}` — runners pair with watches
- `{Mountain Bike} → {Cycling Helmet}` — cyclists also buy helmets
- `{Swim Goggles} → {Swimsuit}` — classic swimming pairing

These are the kinds of insights FitZone could use for shelf placement, cross-sell campaigns, and persona-based landing pages.

### 4.6 Classification — `task_classification/task_classification.ipynb`

> Solves **PY-C**.

Pipeline:

```
load_wine() ──► EDA (class balance, missing-value check, describe)
     │
     ▼
train_test_split(stratify=y, 70/30) + StandardScaler (for KNN only)
     │
     ▼
For each model in {DecisionTreeClassifier(entropy), KNN(k=5), GaussianNB}:
     ├── fit on training data
     ├── predict on test data
     ├── confusion_matrix + classification_report (precision / recall / F1)
     └── ConfusionMatrixDisplay (matplotlib)
     │
     ▼
Bar chart comparison of accuracy / precision / recall / F1 across the 3 models
     │
     ▼
plot_tree(DecisionTree) — visual interpretability
     │
     ▼
Hand-solved confusion matrix from `knn+naive+bayes+confusion.pdf` Task 1 verified
in code (TP=3, TN=4, FP=2, FN=1 → accuracy 0.70, recall 0.75, precision 0.60, F1 0.667)
```

Wine was chosen because:

- Three classes (cultivars 0/1/2) make the macro-averaging code path the relevant one.
- 13 features with very different scales (`proline` ≈ 750 vs `malic_acid` < 6) make feature scaling for KNN a *visible* and necessary step.
- Features are approximately Gaussian within each class, giving Naive Bayes a fair chance.

In a typical run, all three models reach ≥ 0.90 accuracy.

## 5. How to use this repo

1. Read `README.md` for setup and the tasks-to-files map.
2. Open the matching `GUIDE.md` next to whatever deliverable you want to run.
3. Each `GUIDE.md` lists prerequisites, run instructions, common errors and submission tips.

The single-file deep-dive lives in `docs/FitZone_Sports_Full_Guide.md` — that's the document to read if you want to understand every formula, every table, every cell of code, and every algorithm in one continuous narrative.
