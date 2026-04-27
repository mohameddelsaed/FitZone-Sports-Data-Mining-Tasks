# FitZone Sports — Data Mining Course, Full Step-by-Step Guide

**For:** Mohamed Elsaeed (CS / Information Systems, Mansoura — Dr. Aya Nabil & Eng. Taher Eladly, 2026)
**Scope:** Everything from installing tools → Sections 1–7 → all 4 graded Tasks (Excel project, Excel advanced + What-If + Goal Seek + Dashboard, SQL database, Python notebook on a real dataset, Apriori/FP-Growth, and the 3-model classification project).
**Business:** **FitZone Sports** — a sports-equipment retail shop in Mansoura with online delivery to Cairo and Alexandria. 5 product categories: **Football, Gym, Swimming, Running, Cycling**.
**How to use:** Read top-down. Every section has *Concept → Code/Formula → Exactly what to deliver*. All code blocks are tested and runnable in Jupyter.

---

## 0. Course at a glance (what your professors actually want)

You have **two tracks** running in parallel:

1. **Business-system project (Excel + SQL)** — supervised by **Dr. Aya Nabil**.
   You are building a small management system for FitZone Sports. Each task adds a layer to the same project (Excel formulas → Excel advanced → SQL).

2. **Python data-mining track** — supervised by **Eng. Taher Eladly**.
   Sections 1–7 teach you Python, Pandas, missing-value handling, frequent itemsets, and classification. The deliverables here are notebook-based tasks on real public datasets.

| # | Task (from the WhatsApp dump) | Tool | Deliverable |
|---|---|---|---|
| **T1** | 5 business tables + basic formulas (SUM, AVERAGE, IF, SUMIF, COUNTIF) | Excel | `FitZoneSystem.xlsx` |
| **T2** | VLOOKUP / INDEX-MATCH, What-If, Goal Seek, Pivot Tables/Charts, Dashboard | Excel | Same workbook, more sheets |
| **T3** | Create DB + tables + FK + INSERT + queries + JOINs + aggregates | SQL (MySQL / SSMS) | `fitzone_db.sql` script |
| **PY-A** | Apply every function from the Section-3 notebook on a real dataset | Jupyter | `task_pandas.ipynb` |
| **PY-B** | Apriori + FP-Growth + Association Rules on a transactions dataset | Jupyter (`mlxtend`) | `task_apriori.ipynb` |
| **PY-C** | Build **Decision Tree, KNN, Naive Bayes**, evaluate with Confusion Matrix / Accuracy / Precision / Recall | Jupyter (`scikit-learn`) | `task_classification.ipynb` |

> Section 4 is missing from the materials — it is normally **Data Preprocessing / Cleaning** but the same content is covered inside Section 3's `missing_values.html`, so nothing is missing in practice.

---

## 1. Environment setup (one-time, ≈ 20 min)

### 1.1 Install Anaconda (recommended)
1. Go to <https://www.anaconda.com/download> and grab the **Windows 64-bit Python 3.11 installer**.
2. Run the installer with defaults.
3. After install you have **Anaconda Navigator**, **Jupyter Notebook**, **Spyder**, and the `conda` / `pip` package managers.

### 1.2 First launch
Open **Anaconda Navigator → Launch Jupyter Notebook**. A browser tab opens at `http://localhost:8888/`. Click **New → Python 3 (ipykernel)** to create a fresh notebook.

### 1.3 Install the libraries you'll need (run once in any notebook cell)
```python
!pip install pandas numpy scipy matplotlib seaborn scikit-learn statsmodels mlxtend openpyxl
```
- **pandas / numpy / scipy** — data + math
- **matplotlib / seaborn** — plots
- **scikit-learn** — KNN, Decision Tree, Naive Bayes, metrics
- **mlxtend** — Apriori & FP-Growth
- **openpyxl** — read/write `.xlsx`

### 1.4 Install Microsoft Excel & MySQL
- **Excel** — any version 2016+. Goal Seek lives in `Data → What-If Analysis → Goal Seek`.
- **MySQL Workbench 8.x** (free, <https://dev.mysql.com/downloads/workbench/>). During install pick **Full**, set a root password you'll remember, and let it create a local server on `localhost:3306`. If you prefer SQL Server, use **SSMS**; the syntax in this guide is ANSI-standard and works in both.

---

## 2. The FitZone Sports business — one consistent story

5 entities mirrored across Excel and SQL:

| Entity | What it represents |
|---|---|
| **Product** | The catalogue — every SKU FitZone can sell, with unit price and stock level. Categories: Football, Gym, Swimming, Running, Cycling. |
| **Sales** | One row per sale transaction. Each row links a `Product` to a `Customer`. |
| **Customers** | The customer database. `Total_Purchases` aggregates all their sales. |
| **Purchases** | Inbound supplier orders that replenish `Product` stock. Suppliers include Adidas Egypt, Nike ME, Decathlon Egypt, FitnessPro Imports, Garmin Distributor, Trek Bicycles. |
| **Expenses** | Every overhead cost (rent, salaries, utilities, marketing, maintenance, cleaning, office). |

Every formula in the workbook, every CHECK in the SQL script, and every chart on the dashboard refers back to those five entities.

---

## 3. Section 1 — Python fundamentals (3 assignments)

Implemented in [`section1_python_basics/section1_basics.ipynb`](../section1_python_basics/section1_basics.ipynb). Concise summary:

- **Assignment 1 — grade calculator.** Buckets a numeric degree into one of five categorical grades.

  ```python
  def assignment_1(name, dept, degree):
      if   degree >= 85: grade = "Excellent"
      elif degree >= 75: grade = "Very Good"
      elif degree >= 65: grade = "Good"
      elif degree >= 50: grade = "Pass"
      else:              grade = "Fail"
      return f"Hello {name}, your department is {dept} and your degree is {grade}!"
  ```

- **Assignment 2 — BMI.** Highly relevant to FitZone's customers — it's exactly the calculation an in-store fitness coach runs.

  ```python
  def bmi_status(name, weight_kg, height_cm):
      bmi = weight_kg / (height_cm/100) ** 2
      if   bmi <= 18.5:                  status = "UNDERWEIGHT"
      elif 18.5 < bmi <= 24.9:           status = "NORMAL WEIGHT"
      elif 24.9 < bmi <= 29.9:           status = "OVERWEIGHT"
      else:                              status = "OBESE"
      return f"{name}, your BMI value is {bmi:.2f} and you are: {status}"
  ```

- **Assignment 3 — DataFrame ops** on the small 5×3 table from the slides:
  `df.shape`, `df.sample(frac=0.5)`, `df.sort_values('col1', ascending=False)`, `df.query('col2 >= 7')`, `df.tail(3)`.

---

## 4. Excel deliverable — `FitZoneSystem.xlsx`

> Solves Tasks 1 & 2.

### 4.1 The 5 base tables (Task 1)

| Sheet | Columns | Key formulas |
|------|---------|--------------|
| **Product** | ID, Name, Category, Unit_Price, Stock_Quantity | `Stock_Value = D2*E2`, `Stock_Status = IF(E2<10,"Reorder","Sufficient")`, `Avg_Product_Price = AVERAGE($D$2:$D$11)` |
| **Sales** | Sale_ID, Product_ID, Customer_ID, Quantity_Sold, Unit_Price, Total_Sale, Sale_Date, Sale_Flag, Category_Lookup, Stock_Lookup, Customer_Contact_Lookup, Customer_City_Lookup, Unit_Cost_Lookup, Profit_Per_Sale, Profit_Margin | `Total_Sale = D*E`, `Sale_Flag = IF(F>5000,"High","Normal")`, `Category = VLOOKUP(B, Product!A:E, 3, FALSE)`, `Customer_City = INDEX(Customers!C, MATCH(C, Customers!A, 0))`, `Unit_Cost = AVERAGEIF(Purchases!C, B, Purchases!E)`, `Profit = F-(D*M)`, `Margin = N/F` |
| **Customers** | ID, Name, City, Contact_Number, Total_Purchases, Loyalty, Customer_Rank | `Total_Purchases = SUMIF(Sales!C, A, Sales!F)`, `Loyalty = IF(E>10000,"Loyal","Regular")`, `Rank = RANK(E, $E$2:$E$10, 0)` |
| **Purchases** | ID, Supplier_Name, Product_ID, Quantity_Purchased, Unit_Cost, Total_Cost, Purchase_Date, Order_Type, Category_Lookup | `Total_Cost = D*E`, `Order_Type = IF(F>10000,"Bulk","Normal")`, `Category = VLOOKUP(C, Product!A:E, 3, FALSE)` |
| **Expenses** | ID, Type, Amount, Date, Notes, Flag, Essential, After_Cut_10pct | `Flag = IF(C>2000,"Check","OK")`, `After_Cut_10pct = IF(G="No", C*0.9, C)` |

### 4.2 Analysis sheet (Task 2 Part 1)

- **Supplier summary**: `=SUMIF(Purchases!$B$2:$B$50, "Adidas Egypt", Purchases!$F$2:$F$50)`, `=AVERAGEIF(...)` for each supplier.
- **Remaining stock per product**: `Initial - Sold` = `=C13-D13` per row.
- **Top-5 customers**: combines `RANK` (in `Customers`) with `INDEX/MATCH` to pull names ordered by total purchases.

### 4.3 What-If sheet (Task 2 Part 2)

5 scenarios — each duplicates the source column with a formula adjustment:

1. **Stock × 0.8** (20% loss simulation).
2. **Unit price +5 / +10 / +15 %** to study revenue elasticity.
3. **+3 customers in Cairo** — sketches the impact of expansion.
4. **FitnessPro Imports cost +10 %** — the largest supplier; shows margin pressure on treadmill / dumbbell products.
5. **Cut 10% of non-essential expenses** — uses the `After_Cut_10pct` column from Expenses.

### 4.4 Goal Seek sheet (Task 2 Part 3)

5 manual scenarios. Goal Seek can only be invoked through the Excel UI (`Data → What-If Analysis → Goal Seek`):

| # | Goal | Set cell | To value | By changing |
|---|------|----------|----------|-------------|
| 1 | Make Customer 1 *Loyal* | `Customers!E2` | `10001` | a chosen `Sales!F<row>` for that customer |
| 2 | Profit_Per_Sale = 1500 | `Sales!N5` | `1500` | `Sales!E5` |
| 3 | Purchase total ≤ 50 000 | `Purchases!F2` | `50000` | `Purchases!E2` |
| 4 | Total expenses ≤ 70 000 | `GoalSeek!B11` (= SUM(Expenses!C)) | `70000` | `Expenses!C9` (Marketing-Feb) |
| 5 | Stock_Value of product 1 = 60 000 | `Product!F2` | `60000` | `Product!D2` |

### 4.5 Pivots sheet (Task 2 Part 4)

Built with `SUMIFS` and `SUMPRODUCT` rather than real Pivot Tables (so the numbers stay live as you change the source data):

- **Profit per Category**: `=SUMIFS(Sales!F, Sales!I, "Football")` etc. for all 5 categories.
- **Monthly sales per product**: `=SUMPRODUCT((Sales!B=pid) * (MONTH(Sales!G)=m) * Sales!F)` for products 1..10 across months 1..6.
- **Total Purchases per Category**: `=SUMIFS(Purchases!F, Purchases!I, "Football")`.

To create *real* PivotTable objects: `Insert → PivotTable` from any cell in `Sales`, then drag fields from the Pivot pane.

### 4.6 Dashboard (Task 2 Part 5)

6 KPI cards driven entirely by formulas:

- Total Revenue = `SUM(Sales!F2:F50)`
- Total Profit = `SUM(Sales!N2:N50)`
- Avg Profit Margin = `IFERROR(SUM(Sales!N)/SUM(Sales!F), 0)`
- Total Expenses = `SUM(Expenses!C2:C50)`
- Total Stock Value = `SUMPRODUCT(Product!D2:D11, Product!E2:E11)`
- Total Remaining Stock = `SUM(Analysis!E13:E22)`

3 charts: column chart of profit per category, pie chart of profit share by category, line chart of monthly expenses trend.

---

## 5. SQL deliverable — `fitzone_db.sql`

> Solves Task 3.

The same business is modelled as a **third-normal-form relational schema**:

```sql
DROP DATABASE IF EXISTS FitZone_DB;
CREATE DATABASE FitZone_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE FitZone_DB;

CREATE TABLE Product (
    Product_ID      INT             PRIMARY KEY,
    Product_Name    VARCHAR(100)    NOT NULL,
    Category        VARCHAR(50),
    Unit_Price      DECIMAL(10,2)   NOT NULL CHECK (Unit_Price     >= 0),
    Stock_Quantity  INT             NOT NULL CHECK (Stock_Quantity >= 0)
);

CREATE TABLE Customers (
    Customer_ID     INT            PRIMARY KEY,
    Customer_Name   VARCHAR(100)   NOT NULL,
    City            VARCHAR(50),
    Contact_Number  VARCHAR(20),
    Total_Purchases DECIMAL(12,2)  DEFAULT 0
);

CREATE TABLE Sales (
    Sale_ID       INT           PRIMARY KEY,
    Product_ID    INT           NOT NULL,
    Customer_ID   INT           NOT NULL,
    Quantity_Sold INT           NOT NULL CHECK (Quantity_Sold >= 0),
    Unit_Price    DECIMAL(10,2) NOT NULL CHECK (Unit_Price    >= 0),
    Total_Sale    DECIMAL(12,2) NOT NULL CHECK (Total_Sale    >= 0),
    Sale_Date     DATE          NOT NULL,
    CONSTRAINT fk_sales_product
        FOREIGN KEY (Product_ID)  REFERENCES Product(Product_ID),
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

CREATE TABLE Purchases (
    Purchase_ID         INT           PRIMARY KEY,
    Supplier_Name       VARCHAR(100)  NOT NULL,
    Product_ID          INT           NOT NULL,
    Quantity_Purchased  INT           NOT NULL CHECK (Quantity_Purchased >= 0),
    Unit_Cost           DECIMAL(10,2) NOT NULL CHECK (Unit_Cost          >= 0),
    Total_Cost          DECIMAL(12,2) NOT NULL CHECK (Total_Cost         >= 0),
    Purchase_Date       DATE          NOT NULL,
    CONSTRAINT fk_purchases_product
        FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

CREATE TABLE Expenses (
    Expense_ID    INT           PRIMARY KEY,
    Expense_Type  VARCHAR(50)   NOT NULL,
    Amount        DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Date          DATE          NOT NULL,
    Notes         VARCHAR(200)
);
```

Every numeric column has a **`CHECK ≥ 0`** constraint so that `Total_Sale = -100` is rejected at the database level — defensive programming, not just a UI rule.

### 5.1 Sample data (excerpt)

10 products, 6 customers, 10 sales, 8 purchases, 10 expenses. All inserted via `INSERT … VALUES` blocks. `Total_Sale` and `Total_Cost` are computed inline (`Quantity * Unit_Price`) so the data stays consistent with the constraints.

### 5.2 The 10 required queries (Task 4)

```sql
-- 13. Low-stock products
SELECT * FROM Product WHERE Stock_Quantity < 10;

-- 14. Sales between two dates
SELECT * FROM Sales WHERE Sale_Date BETWEEN '2026-01-01' AND '2026-03-31';

-- 15. Customers from a specific city
SELECT * FROM Customers WHERE City = 'Mansoura';

-- 16. High-amount expenses
SELECT * FROM Expenses WHERE Amount > 2000;

-- 17. JOIN — Product details + Sales
SELECT p.Product_Name, s.Quantity_Sold, s.Total_Sale, s.Sale_Date
  FROM Sales s JOIN Product p ON s.Product_ID = p.Product_ID;

-- 18. JOIN — Customer total purchases
SELECT c.Customer_Name, SUM(s.Total_Sale) AS Total_Purchases
  FROM Sales s JOIN Customers c ON s.Customer_ID = c.Customer_ID
 GROUP BY c.Customer_Name
 ORDER BY Total_Purchases DESC;

-- 19. JOIN — Purchases with product names
SELECT pu.Supplier_Name, p.Product_Name, pu.Total_Cost
  FROM Purchases pu JOIN Product p ON pu.Product_ID = p.Product_ID;

-- 20. Stock value per product
SELECT Product_Name, (Unit_Price * Stock_Quantity) AS Stock_Value
  FROM Product
 ORDER BY Stock_Value DESC;

-- 21. Total revenue
SELECT SUM(Total_Sale) AS Total_Revenue FROM Sales;

-- 22. Total expenses
SELECT SUM(Amount) AS Total_Expenses FROM Expenses;
```

Bonus: a correlated `UPDATE` at the end re-syncs `Customers.Total_Purchases` from the `Sales` table.

---

## 6. Pandas pipeline — `task_pandas.ipynb` (Section 3)

> Solves PY-A.

Implemented on the **Wine** dataset (built into scikit-learn — 178 × 13 features, 3 classes).

### 6.1 Loading and inspecting

```python
from sklearn.datasets import load_wine
import pandas as pd
wine = load_wine(as_frame=True)
data = wine.frame.rename(columns={"target": "wine_class_code"})
data["wine_class"] = data["wine_class_code"].map({0:"class_0",1:"class_1",2:"class_2"})
data = data.drop(columns=["wine_class_code"])
data.to_csv("wine.csv", index=False)
x = pd.read_csv("wine.csv")          # proves the read_csv pipeline works
```

Then cycle through every inspection method from the lecture: `.shape`, `.dtypes`, `.info()`, `.describe()`, `.describe(include=['O'])`, `.columns`, `.head()`, `.tail()`, `.sample(n=5)`, `.sample(frac=0.05)`.

### 6.2 Selection, drop, filter

```python
x.loc[1]                                  # row by label
x.loc[:, "wine_class"]                    # column by label
x.iloc[:, -1]                             # column by position
x.iloc[0:5, 0:3]                          # block by position
x.drop([1, 4], axis=0)                    # drop rows
x.drop(["ash", "magnesium"], axis=1)      # drop columns
x.query('wine_class == "class_1"')        # filter
x.sort_values(by="alcohol", ascending=True)
x.rename(columns={"alcohol": "alc_pct"})
x["wine_class"].astype("category")
```

### 6.3 Plots

```python
x["alcohol"].hist()
x.boxplot(column="malic_acid")
```

### 6.4 Missing-value handling

Inject ~10% NaNs deliberately, then run *every* fill strategy:

```python
m.dropna(how="any")                       # drop rows with ANY NaN
m.dropna(how="all")                       # drop rows where ALL are NaN
m.fillna(0)                               # constant
m.fillna({"alcohol": 0, "malic_acid": 0}) # per-column dict
m.ffill()                                 # forward-fill (modern API)
m.bfill()                                 # backward-fill
m.fillna(method="ffill")                  # legacy slide syntax (try/except guard)
m.fillna(m.mean(numeric_only=True))       # mean imputation
m.fillna(m.median(numeric_only=True))     # median imputation
m.fillna(m.mode().iloc[0])                # mode imputation
```

End with `cleaned.to_csv("wine_cleaned.csv")` — closes the I/O loop.

---

## 7. Apriori + FP-Growth — `task_apriori.ipynb` (Section 5)

> Solves PY-B.

Run on a **FitZone Sports market-basket dataset** of 25 transactions over 14 distinct items. Items belong to recognisable customer personas:

- **Football customers** → Football Ball + Football Cleats + Sports Socks
- **Runners** → Running Shoes + GPS Watch + Sports Socks
- **Gym-goers** → Yoga Mat + Dumbbell Set + Treadmill + Water Bottle
- **Swimmers** → Swim Goggles + Swimsuit + Swim Cap
- **Cyclists** → Mountain Bike + Cycling Helmet + GPS Watch

### 7.1 The pipeline

```python
import pandas as pd
from mlxtend.preprocessing     import TransactionEncoder
from mlxtend.frequent_patterns import apriori, fpgrowth, association_rules

te = TransactionEncoder()
df = pd.DataFrame(te.fit(transactions).transform(transactions),
                  columns=te.columns_)

freq_ap = apriori(df, min_support=0.15, use_colnames=True)
freq_fp = fpgrowth(df, min_support=0.15, use_colnames=True)
assert {frozenset(s) for s in freq_ap.itemsets} == \
       {frozenset(s) for s in freq_fp.itemsets}    # algorithms agree

rules = association_rules(freq_ap, metric="confidence", min_threshold=0.6)
```

### 7.2 Interpretation

The strongest rules surfaced (sample):

- `{Football Ball} → {Football Cleats}` — high confidence, lift > 1
- `{Running Shoes} → {GPS Watch}` — runners pair shoes with a tracking watch
- `{Mountain Bike} → {Cycling Helmet}` — cyclists buy helmets with bikes
- `{Swim Goggles} → {Swimsuit}` — classic swimming pairing

**Operational uses for FitZone**:

1. Place complementary products side by side in-store.
2. Build cross-sell promos (`buy A, get C 10% off`).
3. Persona-based landing pages (Footballer, Runner, Cyclist, Swimmer, Gym-Goer).

---

## 8. Classification — `task_classification.ipynb` (Sections 6 & 7)

> Solves PY-C. Run on the **Wine** dataset (178 × 13 + 3 classes).

### 8.1 Train / test split + scaling

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing   import StandardScaler

X_tr, X_te, y_tr, y_te = train_test_split(
    X, y, test_size=0.30, stratify=y, random_state=42)

scaler = StandardScaler()
X_tr_s = scaler.fit_transform(X_tr)
X_te_s = scaler.transform(X_te)
```

KNN gets the **scaled** matrices because Euclidean distance is dominated by features with large magnitudes (e.g. `proline` ≈ 750 vs `malic_acid` < 6).

### 8.2 Three models

```python
from sklearn.tree         import DecisionTreeClassifier
from sklearn.neighbors    import KNeighborsClassifier
from sklearn.naive_bayes  import GaussianNB

models = {
    'Decision Tree': (DecisionTreeClassifier(criterion='entropy', random_state=42), X_tr,   X_te),
    'KNN (k=5)'    : (KNeighborsClassifier(n_neighbors=5),                          X_tr_s, X_te_s),
    'Naive Bayes'  : (GaussianNB(),                                                 X_tr,   X_te),
}
```

For each model we print the **confusion matrix**, the full `classification_report` (precision / recall / F1), and render a `ConfusionMatrixDisplay`.

### 8.3 Hand-solved confusion matrix (from `knn+naive+bayes+confusion.pdf`)

Given a 10-row actual/predicted table:

- TP = 3, TN = 4, FP = 2, FN = 1.
- Accuracy = (TP+TN)/10 = 0.70
- Recall = TP/(TP+FN) = 0.75
- Precision = TP/(TP+FP) = 0.60
- F1 = 2·P·R / (P+R) = 0.6667

The notebook verifies all four values numerically.

### 8.4 Why these algorithms?

| Algorithm | Strength | Caveat |
|-----------|----------|--------|
| Decision Tree | Most interpretable — every prediction traces back to IF-THEN rules. | Can overfit; control with `max_depth`. |
| KNN | No training step; great for low-dimensional clean data. | **Must** scale features. |
| Naive Bayes | Fastest; works well when features are roughly Gaussian within each class. | Assumes feature independence. |

In a typical run on Wine, all three reach ≥ 0.90 accuracy.

---

## 9. Submission checklist

- [ ] `FitZoneSystem.xlsx` (rename to include your full name if your TA requests it).
- [ ] `fitzone_db.sql` + a screenshot of the schema diagram (`Database → Reverse Engineer…`).
- [ ] `section1_basics.ipynb`
- [ ] `task_pandas.ipynb`
- [ ] `task_apriori.ipynb`
- [ ] `task_classification.ipynb`

Before submitting any notebook:

1. `Kernel → Restart & Run All` — make sure every cell still ends with a green check.
2. Edit the **first markdown cell** of each notebook to reflect your *exact* group / section / submission date if your TA asks for those fields.
3. Optional but nice: export each notebook to PDF (`File → Download as → PDF` in Jupyter, or `jupyter nbconvert --to pdf <name>.ipynb`).

---

## 10. References

- `Section+1_Data+Mining.pdf` — Python fundamentals & Pandas basics
- `Section+2_Data+Mining.pdf` — Importing data
- `Section+3_+Data+Mining.pdf` + `Section+3_Data+Mining_notebook.html` — Pandas manipulation
- `missing_values.html` — Handling NaN
- `Section+5_Data+Mining_Frequent-Itemset.pdf` — frequent itemsets
- `Section+6_Data+Mining_Classification.pdf` — Decision Trees
- `Section+7_+Classification_part+2.pdf` + `knn+naive+bayes+confusion.pdf` — KNN, Naive Bayes, confusion matrix
- WhatsApp chat dump — task statements, due dates, submission rules

Per-deliverable `GUIDE.md` files in each subfolder repeat the run/submit instructions so you don't have to scroll back here.
