# SQL — FitZone Sports Database Guide
> Covers **Task 3** of the Excel/SQL track: design a relational database for the FitZone Sports business, populate it, and run analytical queries.

## Required program
**MySQL Workbench 8.x** (free) — <https://dev.mysql.com/downloads/workbench/>. During installation pick **Full**, set a root password you'll remember, and let it create a local server on `localhost:3306`.

> **SQL Server Management Studio (SSMS)** also works — see the conversion notes at the bottom.

---

## Run the script (MySQL)

1. Launch **MySQL Workbench**, double-click your local instance to connect.
2. `File → Open SQL Script…` → pick `fitzone_db.sql`.
3. Press **Ctrl + Shift + Enter** (or *Query → Execute (All)*).
4. Look at the **Output** tab at the bottom — every statement should report a green check. The `SELECT` statements appear in the *Result Grid* one tab per query.

To re-run from scratch: just hit Ctrl+Shift+Enter again. The script begins with `DROP DATABASE IF EXISTS FitZone_DB; CREATE DATABASE …` so it always starts clean.

---

## What the script does (top-to-bottom)

1. **DROP + CREATE the database** `FitZone_DB` with `utf8mb4` collation.
2. **Create 5 tables** with primary keys + `CHECK` constraints + foreign keys:
   - `Product (Product_ID PK, Product_Name, Category, Unit_Price, Stock_Quantity)`
   - `Customers (Customer_ID PK, Customer_Name, City, Contact_Number, Total_Purchases)`
   - `Sales (Sale_ID PK, Product_ID FK→Product, Customer_ID FK→Customers, Quantity_Sold, Unit_Price, Total_Sale, Sale_Date)`
   - `Purchases (Purchase_ID PK, Supplier_Name, Product_ID FK→Product, Quantity_Purchased, Unit_Cost, Total_Cost, Purchase_Date)`
   - `Expenses (Expense_ID PK, Expense_Type, Amount, Date, Notes)`
3. **Insert sample data** — 10 sports products, 6 customers, 10 sales, 8 purchases, 10 expenses.
4. **Run the 10 required queries** (see next section).
5. (Bonus) **Update** `Customers.Total_Purchases` from a correlated subquery so the column matches the `Sales` table.

---

## The 10 queries (Task 4)

| # | Purpose | Query |
|---|---------|-------|
| 13 | Low-stock products | `SELECT * FROM Product WHERE Stock_Quantity < 10;` |
| 14 | Sales between two dates | `SELECT * FROM Sales WHERE Sale_Date BETWEEN '2026-01-01' AND '2026-03-31';` |
| 15 | Customers from a city | `SELECT * FROM Customers WHERE City = 'Mansoura';` |
| 16 | High-amount expenses | `SELECT * FROM Expenses WHERE Amount > 2000;` |
| 17 | JOIN Sales × Product | `SELECT p.Product_Name, s.Quantity_Sold, s.Total_Sale, s.Sale_Date FROM Sales s JOIN Product p ON s.Product_ID = p.Product_ID;` |
| 18 | JOIN Sales × Customers (totals) | `SELECT c.Customer_Name, SUM(s.Total_Sale) AS Total FROM Sales s JOIN Customers c ON s.Customer_ID = c.Customer_ID GROUP BY c.Customer_Name;` |
| 19 | JOIN Purchases × Product | `SELECT pu.Supplier_Name, p.Product_Name, pu.Total_Cost FROM Purchases pu JOIN Product p ON pu.Product_ID = p.Product_ID;` |
| 20 | Stock value per product | `SELECT Product_Name, (Unit_Price * Stock_Quantity) AS Stock_Value FROM Product;` |
| 21 | Total revenue | `SELECT SUM(Total_Sale) AS Total_Revenue FROM Sales;` |
| 22 | Total expenses | `SELECT SUM(Amount) AS Total_Expenses FROM Expenses;` |

---

## Verify it worked

After the script finishes, run any of these in a new query tab to confirm:

```sql
USE FitZone_DB;
SHOW TABLES;
SELECT COUNT(*) FROM Product;     -- expect 10
SELECT COUNT(*) FROM Customers;   -- expect 6
SELECT COUNT(*) FROM Sales;       -- expect 10
SELECT COUNT(*) FROM Purchases;   -- expect 8
SELECT COUNT(*) FROM Expenses;    -- expect 10
SELECT SUM(Total_Sale) FROM Sales;     -- expect 100650.00
SELECT SUM(Amount)     FROM Expenses;  -- expect  95000.00
```

To **export the schema diagram** (TAs often want this):

1. `Database → Reverse Engineer…`
2. Pick the connection → Next → tick `FitZone_DB` → Next → Execute.
3. Workbench draws the EER diagram. Right-click → *Export*. Saves a PNG/PDF.

---

## Convert to SQL Server (SSMS)

If you submit on SQL Server instead of MySQL, replace these lines:

```sql
-- MySQL line                                  -- SSMS replacement
DROP DATABASE IF EXISTS FitZone_DB;             IF DB_ID('FitZone_DB') IS NOT NULL DROP DATABASE FitZone_DB;
CREATE DATABASE FitZone_DB CHARACTER SET …;     CREATE DATABASE FitZone_DB;
USE FitZone_DB;                                 USE FitZone_DB;
IFNULL(SUM(s.Total_Sale),0)                     ISNULL(SUM(s.Total_Sale),0)
```

Everything else (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `INSERT`, `JOIN`, `GROUP BY`) is ANSI-standard and runs unchanged on both engines.

---

## Submission tips

- Save a screenshot of the **EER diagram** (the visual schema) — most TAs want this attached to the SQL file.
- If the TA wants the **output of all queries** captured in a single file, use `File → Export Resultset` after running each one, or run from the command line:

  ```bash
  mysql -u root -p FitZone_DB < fitzone_db.sql > query_output.txt
  ```

- Don't forget to **rename** the file to your name + section before submission, e.g. `Mohamed_Elsaeed_fitzone_db.sql`.
