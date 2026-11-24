# Online Shopping — Advanced SQL Assignment

An advanced MySQL assignment for an online shopping platform. The SQL script creates and seeds a relational schema, then demonstrates joins, subqueries, set-operation alternatives, window functions, CTEs, views, indexes, stored programs, transactions, triggers, and query tuning.

## Database schema

- **Customers**: `customer_id` primary key, `customer_name`, `city`, unique `email`
- **Products**: `product_id` primary key, `product_name`, `category`, `price`, and `created_date` (added to support the date-filter optimization in Task 20)
- **Orders**: `order_id` primary key, customer and product foreign keys, `quantity`, and `order_date`
- **Order_Audit**: records inserted orders through the Task 19 trigger

The sample data has 10 customers, 12 products, and 24 orders. Each order row represents a customer's purchase of one product; order totals are calculated from the related product price and order quantity.

## Requirements

- MySQL 8.0 or newer (recursive CTEs and window functions are used)
- A MySQL client such as MySQL Workbench or the `mysql` command-line client

## Execute the script

Run the script against a MySQL server:

```bash
mysql -u your_username -p < online_shopping_advanced_assignment.sql
```

Or open `online_shopping_advanced_assignment.sql` in MySQL Workbench and execute it. The script creates and selects the `online_shopping_advanced` database. Run it on a fresh database: sample inserts and the category index use fixed IDs/names and are intended to be executed once.

The script calls the stored procedure and function, performs both a committed update and a rolled-back update, and inserts one demonstration order after creating the audit trigger. These statements make the requested examples observable in the result/output panes.

## Advanced SQL concepts covered

1. Inner, cross, and left joins
2. Scalar, aggregate, and correlated subqueries
3. MySQL `UNION` and `INNER JOIN`/`LEFT JOIN` alternatives to `INTERSECT` and `EXCEPT`
4. `RANK`, `LAG`, and a partitioned running total
5. Aggregate and recursive CTEs
6. A view with a query against it
7. Category index and `EXPLAIN`
8. Stored procedure and stored function
9. Transactions with both `COMMIT` and `ROLLBACK`
10. An order audit table populated by an `AFTER INSERT` trigger
11. Sargable date filtering, explicit columns, and removal of unnecessary `DISTINCT`

## Screenshot evidence

Capture successful execution in MySQL Workbench or another MySQL 8-compatible SQL client. Save the screenshots in `screenshots/` using these filenames:

- `task-1-advanced-join.png` — Task 1 customer/product join
- `task-4-subquery.png` — Task 4 products above the average price
- `task-9-window-function.png` — Task 9 product price ranking by category
- `task-11-cte.png` — Task 11 customer spending CTE
- `task-13-view.png` — Task 13 view creation and results
- `task-16-stored-procedure.png` — Task 16 procedure call and results
- `task-18-transaction.png` — Task 18 committed and rolled-back updates
- `task-19-trigger.png` — Task 19 trigger and audit row
- `task-15-explain.png` — Task 15 `EXPLAIN` output
