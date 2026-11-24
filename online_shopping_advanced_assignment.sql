-- Online Shopping Platform — Advanced SQL Assignment
-- Database dialect: MySQL 8.0+

-- Database setup
CREATE DATABASE IF NOT EXISTS online_shopping_advanced;
USE online_shopping_advanced;

-- Required schema
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    CONSTRAINT chk_orders_quantity CHECK (quantity > 0),
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id) REFERENCES Customers (customer_id),
    CONSTRAINT fk_orders_products
        FOREIGN KEY (product_id) REFERENCES Products (product_id)
);

-- Sample data: 10 customers
INSERT IGNORE INTO Customers (customer_id, customer_name, city, email) VALUES
    (1, 'Aarav Mehta', 'Mumbai', 'aarav.mehta@example.com'),
    (2, 'Priya Shah', 'Pune', 'priya.shah@example.com'),
    (3, 'Rohan Iyer', 'Bengaluru', 'rohan.iyer@example.com'),
    (4, 'Ananya Rao', 'Hyderabad', 'ananya.rao@example.com'),
    (5, 'Kabir Khan', 'Delhi', 'kabir.khan@example.com'),
    (6, 'Meera Nair', 'Kochi', 'meera.nair@example.com'),
    (7, 'Ishaan Das', 'Kolkata', 'ishaan.das@example.com'),
    (8, 'Sara Thomas', 'Chennai', 'sara.thomas@example.com'),
    (9, 'Dev Patel', 'Ahmedabad', 'dev.patel@example.com'),
    (10, 'Tara Bose', 'Jaipur', 'tara.bose@example.com');

-- Sample data: 12 products across several categories
-- created_date supports the date-range optimization in Task 20.
INSERT IGNORE INTO Products (product_id, product_name, category, price, created_date) VALUES
    (1, 'Smartphone X', 'Electronics', 45999.00, '2024-01-15'),
    (2, 'Wireless Headphones', 'Electronics', 7999.00, '2024-03-02'),
    (3, 'Bluetooth Speaker', 'Electronics', 3499.00, '2023-08-20'),
    (4, 'Laptop Pro', 'Electronics', 78999.00, '2024-06-11'),
    (5, 'SQL for Analysts', 'Books', 899.00, '2023-02-10'),
    (6, 'Clean Code Guide', 'Books', 1299.00, '2024-02-22'),
    (7, 'Desk Organizer', 'Home', 1499.00, '2022-10-04'),
    (8, 'Ceramic Coffee Set', 'Home', 2299.00, '2024-09-08'),
    (9, 'Trail Running Shoes', 'Sports', 6499.00, '2023-05-17'),
    (10, 'Yoga Mat Plus', 'Sports', 1899.00, '2024-04-28'),
    (11, 'Fitness Watch', 'Electronics', 11999.00, '2024-11-12'),
    (12, 'Everyday Backpack', 'Accessories', 2799.00, '2025-01-05');

-- Sample data: 24 orders
INSERT IGNORE INTO Orders (order_id, customer_id, product_id, quantity, order_date) VALUES
    (1, 1, 1, 1, '2025-01-05'),
    (2, 1, 5, 2, '2025-01-06'),
    (3, 2, 2, 1, '2025-01-08'),
    (4, 2, 8, 1, '2025-01-09'),
    (5, 3, 4, 1, '2025-01-10'),
    (6, 3, 9, 2, '2025-01-12'),
    (7, 4, 6, 3, '2025-01-13'),
    (8, 4, 10, 1, '2025-01-15'),
    (9, 5, 11, 1, '2025-01-16'),
    (10, 5, 3, 2, '2025-01-18'),
    (11, 6, 7, 1, '2025-01-19'),
    (12, 6, 12, 1, '2025-01-21'),
    (13, 7, 1, 1, '2025-01-22'),
    (14, 7, 2, 2, '2025-01-24'),
    (15, 8, 4, 1, '2025-01-25'),
    (16, 8, 5, 1, '2025-01-27'),
    (17, 9, 8, 2, '2025-01-28'),
    (18, 9, 9, 1, '2025-01-30'),
    (19, 1, 11, 1, '2025-02-01'),
    (20, 2, 6, 1, '2025-02-02'),
    (21, 3, 3, 1, '2025-02-03'),
    (22, 4, 12, 2, '2025-02-04'),
    (23, 5, 10, 1, '2025-02-05'),
    (24, 7, 7, 2, '2025-02-06');

-- Section 1: Advanced Joins

-- Task 1: Display each customer along with the products they ordered.
SELECT c.customer_id, c.customer_name, p.product_id, p.product_name,
       o.quantity, o.order_date
FROM Customers AS c
INNER JOIN Orders AS o ON o.customer_id = c.customer_id
INNER JOIN Products AS p ON p.product_id = o.product_id
ORDER BY c.customer_id, o.order_date, o.order_id;

-- Task 2: Display all possible combinations of customers and products.
SELECT c.customer_id, c.customer_name, p.product_id, p.product_name
FROM Customers AS c
CROSS JOIN Products AS p
ORDER BY c.customer_id, p.product_id;

-- Task 3: Display all customers and their orders, including customers with no orders.
SELECT c.customer_id, c.customer_name, o.order_id, o.product_id,
       o.quantity, o.order_date
FROM Customers AS c
LEFT JOIN Orders AS o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_id;

-- Section 2: Subqueries

-- Task 4: Find products priced above the average product price.
SELECT product_id, product_name, category, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;

-- Task 5: Display customers whose total purchase amount exceeds the average
-- purchase amount per customer. Customers with no orders count as zero.
SELECT c.customer_id, c.customer_name, COALESCE(spend.total_purchase_amount, 0) AS total_purchase_amount
FROM Customers AS c
LEFT JOIN (
    SELECT o.customer_id, SUM(p.price * o.quantity) AS total_purchase_amount
    FROM Orders AS o
    INNER JOIN Products AS p ON p.product_id = o.product_id
    GROUP BY o.customer_id
) AS spend ON spend.customer_id = c.customer_id
WHERE COALESCE(spend.total_purchase_amount, 0) > (
    SELECT AVG(customer_totals.total_purchase_amount)
    FROM (
        SELECT c2.customer_id,
               COALESCE(SUM(p2.price * o2.quantity), 0) AS total_purchase_amount
        FROM Customers AS c2
        LEFT JOIN Orders AS o2 ON o2.customer_id = c2.customer_id
        LEFT JOIN Products AS p2 ON p2.product_id = o2.product_id
        GROUP BY c2.customer_id
    ) AS customer_totals
)
ORDER BY total_purchase_amount DESC;

-- Task 6: Find the highest-priced product in each category using a correlated subquery.
SELECT p.product_id, p.product_name, p.category, p.price
FROM Products AS p
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM Products AS p2
    WHERE p2.category = p.category
)
ORDER BY p.category, p.product_id;

-- Section 3: Set Operations

-- Task 7: Combine products from two categories using UNION.
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics'
UNION
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Books'
ORDER BY category, product_id;

-- Task 8: MySQL alternatives for INTERSECT and EXCEPT using joins.
-- INTERSECT alternative: products that are Electronics and cost more than 1000.
SELECT p.product_id, p.product_name, p.category, p.price
FROM Products AS p
INNER JOIN (
    SELECT product_id FROM Products WHERE category = 'Electronics'
) AS electronics ON electronics.product_id = p.product_id
INNER JOIN (
    SELECT product_id FROM Products WHERE price > 1000
) AS above_1000 ON above_1000.product_id = p.product_id
ORDER BY p.product_id;

-- EXCEPT alternative: Electronics products that do not cost more than 1000.
SELECT p.product_id, p.product_name, p.category, p.price
FROM Products AS p
LEFT JOIN (
    SELECT product_id FROM Products WHERE price > 1000
) AS above_1000 ON above_1000.product_id = p.product_id
WHERE p.category = 'Electronics'
  AND above_1000.product_id IS NULL
ORDER BY p.product_id;

-- Section 4: Window Functions

-- Task 9: Rank products by price within each category.
SELECT product_id, product_name, category, price,
       RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank
FROM Products
ORDER BY category, price_rank, product_id;

-- Task 10: Display the previous product price and running total within each category.
SELECT product_id, product_name, category, price,
       LAG(price) OVER (
           PARTITION BY category
           ORDER BY created_date, product_id
       ) AS previous_product_price,
       SUM(price) OVER (
           PARTITION BY category
           ORDER BY created_date, product_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_category_price_total
FROM Products
ORDER BY category, created_date, product_id;

-- Section 5: Common Table Expressions (CTEs)

-- Task 11: Display customers whose total purchase amount is above the average
-- purchase amount across all customers, including customers with no orders.
WITH customer_spend AS (
    SELECT c.customer_id, c.customer_name,
           COALESCE(SUM(p.price * o.quantity), 0) AS total_purchase_amount
    FROM Customers AS c
    LEFT JOIN Orders AS o ON o.customer_id = c.customer_id
    LEFT JOIN Products AS p ON p.product_id = o.product_id
    GROUP BY c.customer_id, c.customer_name
),
average_spend AS (
    SELECT AVG(total_purchase_amount) AS average_customer_purchase_amount
    FROM customer_spend
)
SELECT cs.customer_id, cs.customer_name, cs.total_purchase_amount
FROM customer_spend AS cs
CROSS JOIN average_spend AS av
WHERE cs.total_purchase_amount > av.average_customer_purchase_amount
ORDER BY cs.total_purchase_amount DESC;

-- Task 12: Use a recursive CTE to generate the numbers 1 through 10.
WITH RECURSIVE number_sequence (number_value) AS (
    SELECT 1
    UNION ALL
    SELECT number_value + 1
    FROM number_sequence
    WHERE number_value < 10
)
SELECT number_value
FROM number_sequence;

-- Section 6: Views

-- Task 13: Create and query a view for products priced above ₹1,000.
CREATE OR REPLACE VIEW Products_Above_1000 AS
SELECT product_id, product_name, category, price, created_date
FROM Products
WHERE price > 1000;

SELECT product_id, product_name, category, price, created_date
FROM Products_Above_1000
ORDER BY price DESC;

-- Section 7: Indexes and Query Performance

-- Task 14: Create an index on the Products.category column.
CREATE INDEX idx_products_category ON Products (category);

-- Task 15: Use EXPLAIN to analyze a category-filtered product query.
EXPLAIN
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics';

-- Section 8: Stored Procedures and Functions

-- Task 16: Create and call a procedure to retrieve products by category.
DROP PROCEDURE IF EXISTS GetProductsByCategory;
DELIMITER $$
CREATE PROCEDURE GetProductsByCategory(IN requested_category VARCHAR(50))
BEGIN
    SELECT product_id, product_name, category, price
    FROM Products
    WHERE category = requested_category
    ORDER BY product_name;
END$$
DELIMITER ;

CALL GetProductsByCategory('Electronics');

-- Task 17: Create and call a function to calculate an order's total (price × quantity).
DROP FUNCTION IF EXISTS CalculateOrderTotal;
DELIMITER $$
CREATE FUNCTION CalculateOrderTotal(requested_order_id INT)
RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE calculated_total DECIMAL(12, 2);

    SELECT COALESCE(SUM(p.price * o.quantity), 0)
    INTO calculated_total
    FROM Orders AS o
    INNER JOIN Products AS p ON p.product_id = o.product_id
    WHERE o.order_id = requested_order_id;

    RETURN calculated_total;
END$$
DELIMITER ;

SELECT 1 AS order_id, CalculateOrderTotal(1) AS order_total;

-- Section 9: Transactions

-- Task 18: Demonstrate a committed price update and a separate rolled-back update.
START TRANSACTION;
UPDATE Products
SET price = 46999.00
WHERE product_id = 1;
SELECT product_id, product_name, price
FROM Products
WHERE product_id = 1;
COMMIT;

-- This temporary price change is undone by ROLLBACK.
START TRANSACTION;
UPDATE Products
SET price = 1.00
WHERE product_id = 1;
SELECT product_id, product_name, price
FROM Products
WHERE product_id = 1;
ROLLBACK;

-- Confirm the committed price remains after the rollback.
SELECT product_id, product_name, price
FROM Products
WHERE product_id = 1;

-- Section 10: SQL Triggers

-- Task 19: Create an audit table and trigger for newly inserted orders.
CREATE TABLE IF NOT EXISTS Order_Audit (
    audit_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    action_type VARCHAR(10) NOT NULL,
    audited_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_orders_after_insert;
DELIMITER $$
CREATE TRIGGER trg_orders_after_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO Order_Audit (
        order_id, customer_id, product_id, quantity, order_date, action_type
    )
    VALUES (
        NEW.order_id, NEW.customer_id, NEW.product_id,
        NEW.quantity, NEW.order_date, 'INSERT'
    );
END$$
DELIMITER ;

-- Demonstrate the trigger, then display the audit record it created.
INSERT INTO Orders (order_id, customer_id, product_id, quantity, order_date)
VALUES (25, 10, 5, 1, '2025-02-07');

SELECT audit_id, order_id, customer_id, product_id, quantity, order_date,
       action_type, audited_at
FROM Order_Audit
WHERE order_id = 25;

-- Section 11: Performance Tuning

-- Task 20: Select only required columns, omit unnecessary DISTINCT, and use
-- an index-friendly half-open date range instead of YEAR(created_date) = 2024.
-- The composite index supports the equality category predicate and date range.
CREATE INDEX idx_products_category_created_date
    ON Products (category, created_date);

-- Original anti-pattern:
-- SELECT DISTINCT *
-- FROM Products
-- WHERE YEAR(created_date) = 2024
--   AND category = 'Electronics';

-- Optimized equivalent:
SELECT product_id, product_name, category, price, created_date
FROM Products
WHERE category = 'Electronics'
  AND created_date >= '2024-01-01'
  AND created_date < '2025-01-01'
ORDER BY created_date, product_id;
