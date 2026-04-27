# Excel — FitZone Sports Business System Guide
> Covers Excel **Task 1** (5 business tables + basic formulas) and **Task 2** (advanced formulas, What-If, Goal Seek, Pivot Tables, Dashboard).

## Required program
Microsoft Excel 2016 or newer (Microsoft 365 / Excel 2019 / 2021 / 2024 all work). The `Analysis ToolPak` add-in is **not** required for this workbook.

## Open the workbook
1. Double-click `FitZoneSystem.xlsx`.
2. Excel will recalculate every formula on first open. If it shows a *Protected View* or *Enable editing* banner, click **Enable editing**.
3. If a popup mentions "external links", choose **Don't update** — the only links are cross-sheet, not external.

---

## Sheets

| Sheet | What it contains | Task |
|------|------------------|------|
| `Product` | Product catalogue with `Stock_Value`, `Stock_Status` formulas | T1 |
| `Sales` | All sales transactions; uses VLOOKUP & INDEX-MATCH to pull category + customer info; computes profit & margin | T1 + T2 |
| `Customers` | Customer list with `Total_Purchases` (SUMIF), `Loyalty` (IF), `Customer_Rank` (RANK) | T1 + T2 |
| `Purchases` | Supplier orders with `Total_Cost`, `Order_Type`, category lookup | T1 |
| `Expenses` | Operating expenses with `Flag`, `Essential` tag, `After_Cut_10pct` | T1 |
| `Analysis` | Supplier summary (SUMIF / AVERAGEIF), remaining stock, Top-5 customers (INDEX/MATCH on RANK) | T2 Part 1 |
| `WhatIf` | 5 scenarios: stock drop, price change, +3 customers, supplier cost +10%, cut 10% non-essentials | T2 Part 2 |
| `GoalSeek` | Instructions for the 5 Goal Seek runs you must perform manually | T2 Part 3 |
| `Pivots` | SUMIFS/SUMPRODUCT equivalents of the required Pivot Tables + 3 charts | T2 Part 4 |
| `Dashboard` | KPI cards + 3 charts (column / pie / line) | T2 Part 5 |

---

## Formulas you'll find inside

### Task 1 (basic)
- `Product!F2  =D2*E2`                       (Stock_Value)
- `Product!H2  =IF(E2<10,"Reorder","Sufficient")`
- `Sales!F2    =D2*E2`                       (Total_Sale)
- `Customers!E2  =SUMIF(Sales!$C$2:$C$50,A2,Sales!$F$2:$F$50)`
- `Customers!F2  =IF(E2>10000,"Loyal","Regular")`
- `Purchases!F2  =D2*E2`                     (Total_Cost)
- `Purchases!H2  =IF(F2>10000,"Bulk","Normal")`
- `Expenses!F2   =IF(C2>2000,"Check","OK")`

### Task 2 (advanced)
- `Sales!I2  =VLOOKUP(B2,Product!$A$2:$E$11,3,FALSE)`              (Category)
- `Sales!K2  =INDEX(Customers!$D$2:$D$50,MATCH(C2,Customers!$A$2:$A$50,0))` (Phone)
- `Sales!M2  =IFERROR(AVERAGEIF(Purchases!$C$2:$C$50,B2,Purchases!$E$2:$E$50),0)` (Unit_Cost)
- `Sales!N2  =F2-(D2*M2)`                                          (Profit_Per_Sale)
- `Sales!O2  =IFERROR(N2/F2,0)`                                    (Profit_Margin %)
- `Customers!G2 =RANK(E2,$E$2:$E$10,0)`                            (rank by Total_Purchases)
- `Analysis B4 =SUMIF(Purchases!$B$2:$B$50,"Adidas Egypt",Purchases!$F$2:$F$50)`
- `Analysis E13 =C13-D13`                                          (Remaining_Stock)

---

## Goal Seek — the 5 scenarios you must run manually

Goal Seek can only be triggered from the Excel UI. Open the **`GoalSeek`** sheet for the exact mapping; the steps are always:

1. Select the **Set cell**.
2. `Data → What-If Analysis → Goal Seek…`.
3. Type the **To value** (target).
4. Click in **By changing cell** and select the input cell.
5. Click **OK** — Excel iterates and shows the new input value.

| # | Goal | Set cell | To value | By changing |
|---|------|----------|----------|-------------|
| 1 | Make Customer 1 *Loyal* | `Customers!E2` | `10001` | a chosen `Sales!F<row>` for that customer |
| 2 | Profit_Per_Sale = 1500 | `Sales!N5` | `1500` | `Sales!E5` |
| 3 | Purchase total ≤ 50 000 | `Purchases!F2` | `50000` | `Purchases!E2` |
| 4 | Total expenses ≤ 70 000 | `GoalSeek!B11` (= SUM of Expenses!C) | `70000` | `Expenses!C9` (Marketing-Feb) |
| 5 | Stock_Value of product 1 = 60 000 | `Product!F2` | `60000` | `Product!D2` |

Take a screenshot of each Goal Seek dialog before clicking OK — TAs frequently ask for them.

---

## Pivot Tables — turning the SUMIFS sheet into real Pivots
The `Pivots` sheet already computes every required summary using `SUMIFS / SUMPRODUCT`, so the **numbers** in your charts will match a real Pivot Table. To create real PivotTable objects (some TAs require this):

1. Click any cell in the `Sales` sheet.
2. `Insert → PivotTable → New Worksheet → OK`.
3. Drag fields from the right-hand panel:
   - Profit per Category: **Rows** = `Category_Lookup`, **Values** = `Sum of Total_Sale`, `Sum of Profit_Per_Sale`.
   - Monthly Sales per Product: **Rows** = `Sale_Date` (right-click → Group → Months), **Columns** = `Product_ID`, **Values** = `Sum of Total_Sale`.
   - Total Purchases per Category: **Rows** = `Category_Lookup` (in `Purchases`), **Values** = `Sum of Total_Cost`.
4. With the pivot still selected, `PivotTable Analyze → PivotChart` and pick the chart type (column / pie / line).

---

## Dashboard
Already built. To make it interactive:

1. Click any chart on the `Dashboard` sheet.
2. `PivotChart Analyze → Insert Slicer` → tick `Category` and `Sale_Date`.
3. Move the slicers anywhere on the dashboard. Now clicking a category or month will filter every chart at once.

---

## Common errors

| Symptom | Fix |
|---|---|
| `#N/A` in a VLOOKUP cell | The `Product_ID` you're looking up doesn't exist in the `Product` table. |
| `#REF!` | A row was deleted that the formula referenced. Press *Ctrl+Z* immediately. |
| Cross-sheet links warning every time you open the file | `File → Options → Trust Center → Trust Center Settings → External Content → Disable all` (only suppresses the prompt). |
| Numbers display as ###### | Column too narrow — double-click the column boundary to auto-fit. |

---

## Submission tips
- Rename the file to `Mohamed_Elsaeed_FitZoneSystem.xlsx` (or whatever convention your TA uses).
- After running Goal Seek, **don't** save — Goal Seek changes the input cell. Save a separate copy (`File → Save As → Goal_Seek_Run.xlsx`) for each run if your TA wants screenshots of all five.
- Print preview (`File → Print`) the `Dashboard` and check it fits on one A4 landscape page; adjust scaling if needed.
