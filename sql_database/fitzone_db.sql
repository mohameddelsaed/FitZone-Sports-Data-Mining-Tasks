-- =====================================================================
-- FitZone_DB  --  Data Mining Course / Database Task
-- Business : FitZone Sports  (sports-equipment retail shop, Mansoura)
-- Tested   : MySQL 8 / MariaDB 10  (also runs on SQL Server with minimal change)
-- =====================================================================

-- ---------------------------------------------------------------------
-- TASK 1 : Create the database
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS FitZone_DB;
CREATE DATABASE FitZone_DB
       CHARACTER SET utf8mb4
       COLLATE utf8mb4_unicode_ci;
USE FitZone_DB;

-- ---------------------------------------------------------------------
-- TASK 1 : Tables  (PK / CHECK constraints inline)
-- ---------------------------------------------------------------------

-- 2. Product
CREATE TABLE Product (
    Product_ID      INT             PRIMARY KEY,
    Product_Name    VARCHAR(100)    NOT NULL,
    Category        VARCHAR(50),
    Unit_Price      DECIMAL(10,2)   NOT NULL CHECK (Unit_Price     >= 0),
    Stock_Quantity  INT             NOT NULL CHECK (Stock_Quantity >= 0)
);

-- 3. Customers
CREATE TABLE Customers (
    Customer_ID      INT            PRIMARY KEY,
    Customer_Name    VARCHAR(100)   NOT NULL,
    City             VARCHAR(50),
    Contact_Number   VARCHAR(20),
    Total_Purchases  DECIMAL(12,2)  DEFAULT 0
);

-- 4. Sales (FK + CHECK)
CREATE TABLE Sales (
    Sale_ID         INT            PRIMARY KEY,
    Product_ID      INT            NOT NULL,
    Customer_ID     INT            NOT NULL,
    Quantity_Sold   INT            NOT NULL CHECK (Quantity_Sold >= 0),
    Unit_Price      DECIMAL(10,2)  NOT NULL CHECK (Unit_Price    >= 0),
    Total_Sale      DECIMAL(12,2)  NOT NULL CHECK (Total_Sale    >= 0),
    Sale_Date       DATE           NOT NULL,
    CONSTRAINT fk_sales_product
        FOREIGN KEY (Product_ID)  REFERENCES Product(Product_ID),
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

-- 5. Purchases
CREATE TABLE Purchases (
    Purchase_ID         INT            PRIMARY KEY,
    Supplier_Name       VARCHAR(100)   NOT NULL,
    Product_ID          INT            NOT NULL,
    Quantity_Purchased  INT            NOT NULL CHECK (Quantity_Purchased >= 0),
    Unit_Cost           DECIMAL(10,2)  NOT NULL CHECK (Unit_Cost          >= 0),
    Total_Cost          DECIMAL(12,2)  NOT NULL CHECK (Total_Cost         >= 0),
    Purchase_Date       DATE           NOT NULL,
    CONSTRAINT fk_purchases_product
        FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);

-- 6. Expenses
CREATE TABLE Expenses (
    Expense_ID    INT            PRIMARY KEY,
    Expense_Type  VARCHAR(50),
    Amount        DECIMAL(12,2)  NOT NULL CHECK (Amount >= 0),
    Date          DATE,
    Notes         VARCHAR(255)
);

-- ---------------------------------------------------------------------
-- TASK 2 : Foreign-key relationships
-- (Inline FKs above already enforce these.  The explicit ALTER TABLE
--  statements 7-9 below are kept as documentation because the assignment
--  brief explicitly asks for both forms.)
-- ---------------------------------------------------------------------
-- 7. Sales(Product_ID)  -> Product(Product_ID)
-- ALTER TABLE Sales
--     ADD CONSTRAINT fk_sales_product
--     FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID);
--
-- 8. Sales(Customer_ID) -> Customers(Customer_ID)
-- ALTER TABLE Sales
--     ADD CONSTRAINT fk_sales_customer
--     FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID);
--
-- 9. Purchases(Product_ID) -> Product(Product_ID)
-- ALTER TABLE Purchases
--     ADD CONSTRAINT fk_purchases_product
--     FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID);

-- ---------------------------------------------------------------------
-- TASK 3 : Insert sample data
-- ---------------------------------------------------------------------
INSERT INTO Product VALUES
 (1,  'Adidas Football Ball',    'Football',  800,    120),
 (2,  'Nike Football Cleats',    'Football',  2500,   45),
 (3,  'Dumbbell Set 20 kg',      'Gym',       1800,   30),
 (4,  'Treadmill Pro X',         'Gym',       28000,  6),
 (5,  'Yoga Mat Premium',        'Gym',       450,    200),
 (6,  'Speedo Swim Goggles',     'Swimming',  650,    150),
 (7,  'Arena Swimsuit (Men)',    'Swimming',  1200,   8),
 (8,  'Garmin GPS Watch',        'Running',   8500,   25),
 (9,  'Asics Running Shoes',     'Running',   3200,   60),
 (10, 'Trek Mountain Bike',      'Cycling',   18000,  9);

INSERT INTO Customers (Customer_ID, Customer_Name, City, Contact_Number) VALUES
 (1, 'Mohamed Elsaeed', 'Mansoura',   '01000000001'),
 (2, 'Ahmed Hassan',    'Cairo',      '01000000002'),
 (3, 'Omar Mostafa',    'Mansoura',   '01000000003'),
 (4, 'Yasmin Adel',     'Alexandria', '01000000004'),
 (5, 'Karim Said',      'Cairo',      '01000000005'),
 (6, 'Nada Tarek',      'Mansoura',   '01000000006');

-- 12. Insert sales records (Total_Sale = Quantity_Sold * Unit_Price)
INSERT INTO Sales (Sale_ID, Product_ID, Customer_ID,
                   Quantity_Sold, Unit_Price, Total_Sale, Sale_Date) VALUES
 (101, 4,  1,  1, 28000, 1*28000,  '2026-01-05'),
 (102, 9,  2,  3, 3200,  3*3200,   '2026-01-08'),
 (103, 8,  3,  1, 8500,  1*8500,   '2026-01-12'),
 (104, 1,  1, 10, 800,   10*800,   '2026-02-03'),
 (105, 5,  4, 25, 450,   25*450,   '2026-02-09'),
 (106, 10, 5,  1, 18000, 1*18000,  '2026-02-18'),
 (107, 6,  2,  6, 650,   6*650,    '2026-03-01'),
 (108, 2,  3,  2, 2500,  2*2500,   '2026-03-07'),
 (109, 3,  6,  4, 1800,  4*1800,   '2026-03-15'),
 (110, 7,  4,  1, 1200,  1*1200,   '2026-03-22');

INSERT INTO Purchases (Purchase_ID, Supplier_Name, Product_ID,
                       Quantity_Purchased, Unit_Cost, Total_Cost,
                       Purchase_Date) VALUES
 (201, 'Adidas Egypt',         1, 300, 500,   300*500,    '2025-12-01'),
 (202, 'Nike ME',               2, 100, 1800,  100*1800,   '2025-12-05'),
 (203, 'FitnessPro Imports',    3,  80, 1300,  80*1300,    '2025-12-10'),
 (204, 'FitnessPro Imports',    4,  10, 22000, 10*22000,   '2025-12-15'),
 (205, 'Decathlon Egypt',       5, 500, 280,   500*280,    '2025-12-18'),
 (206, 'Decathlon Egypt',       6, 400, 400,   400*400,    '2025-12-22'),
 (207, 'Garmin Distributor',    8,  40, 6500,  40*6500,    '2026-01-05'),
 (208, 'Trek Bicycles',         10, 15, 14000, 15*14000,   '2026-01-12');

INSERT INTO Expenses (Expense_ID, Expense_Type, Amount, Date, Notes) VALUES
 (301, 'Rent',         12000, '2026-01-01', 'Shop monthly rent'),
 (302, 'Salaries',     22000, '2026-01-05', 'Monthly payroll'),
 (303, 'Electricity',   3000, '2026-01-10', 'Utility'),
 (304, 'Marketing',     3500, '2026-01-15', 'Facebook ads'),
 (305, 'Cleaning',       800, '2026-01-20', 'Cleaning service'),
 (306, 'Rent',         12000, '2026-02-01', 'Shop monthly rent'),
 (307, 'Salaries',     22000, '2026-02-05', 'Monthly payroll'),
 (308, 'Marketing',     5500, '2026-02-15', 'Google ads (high)'),
 (309, 'Maintenance',   2200, '2026-02-22', 'Treadmill servicing'),
 (310, 'Rent',         12000, '2026-03-01', 'Shop monthly rent');

-- =====================================================================
-- TASK 4 : Queries
-- =====================================================================

-- 13. Products with low stock
SELECT * FROM Product WHERE Stock_Quantity < 10;

-- 14. Sales between two dates
SELECT * FROM Sales
 WHERE Sale_Date BETWEEN '2026-01-01' AND '2026-03-31';

-- 15. Customers from a specific city
SELECT * FROM Customers WHERE City = 'Mansoura';

-- 16. Expenses where Amount > 2000
SELECT * FROM Expenses WHERE Amount > 2000;

-- 17. JOIN  - Product details + Sales
SELECT p.Product_Name,
       s.Quantity_Sold,
       s.Total_Sale,
       s.Sale_Date
  FROM Sales   s
  JOIN Product p ON s.Product_ID = p.Product_ID;

-- 18. JOIN  - Customer total purchases
SELECT c.Customer_Name,
       SUM(s.Total_Sale) AS Total_Purchases
  FROM Sales     s
  JOIN Customers c ON s.Customer_ID = c.Customer_ID
 GROUP BY c.Customer_Name
 ORDER BY Total_Purchases DESC;

-- 19. JOIN  - Purchases with product names
SELECT pu.Supplier_Name,
       p.Product_Name,
       pu.Total_Cost
  FROM Purchases pu
  JOIN Product   p ON pu.Product_ID = p.Product_ID;

-- 20. Stock value per product
SELECT Product_Name,
       (Unit_Price * Stock_Quantity) AS Stock_Value
  FROM Product
 ORDER BY Stock_Value DESC;

-- 21. Total revenue (SUM of Total_Sale)
SELECT SUM(Total_Sale) AS Total_Revenue FROM Sales;

-- 22. Total expenses (SUM of Amount)
SELECT SUM(Amount)     AS Total_Expenses FROM Expenses;

-- ---------------------------------------------------------------------
-- Bonus: keep Customers.Total_Purchases in sync with Sales (optional)
-- ---------------------------------------------------------------------
UPDATE Customers c
   SET Total_Purchases = (
        SELECT IFNULL(SUM(s.Total_Sale),0)
          FROM Sales s
         WHERE s.Customer_ID = c.Customer_ID);
