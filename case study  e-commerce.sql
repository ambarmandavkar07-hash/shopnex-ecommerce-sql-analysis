create database casestudy;
use casestudy;
-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender CHAR(1),
    city VARCHAR(50),
    email VARCHAR(100)
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_qty INT
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    payment_mode VARCHAR(50),
    discount VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    orderdetail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
select * from OrderDetails;
-- Customers
INSERT INTO Customers VALUES
(1, 'Rohan Sharma', 'M', 'Mumbai', 'rohan@gmail.com'),
(2, 'Neha Verma', 'F', 'Delhi', 'neha.verma@yahoo.com'),
(3, 'Arjun Singh', 'M', 'Bangalore', 'arjun.singh@gmail.com'),
(4, 'Priya Nair', 'F', 'Kochi', 'priya.nair@gmail.com'),
(5, 'Ravi Patel', 'M', 'Ahmedabad', 'ravi.patel@hotmail.com');

-- Products
INSERT INTO Products VALUES
(101, 'Bluetooth Speaker', 'Electronics', 2499, 120),
(102, 'Smartwatch', 'Electronics', 4999, 80),
(103, 'Running Shoes', 'Fashion', 2999, 200),
(104, 'Backpack', 'Accessories', 1599, 150),
(105, 'Wireless Earbuds', 'Electronics', 3999, 90);

-- Orders
INSERT INTO Orders VALUES
(5001, 1, '2025-09-15', 6498, 'UPI', '10%'),
(5002, 2, '2025-09-18', 2999, 'Credit Card', '0%'),
(5003, 3, '2025-09-19', 7498, 'Debit Card', '5%'),
(5004, 4, '2025-09-21', 1599, 'COD', '0%'),
(5005, 1, '2025-09-25', 3999, 'UPI', '15%');

-- OrderDetails
INSERT INTO OrderDetails VALUES
(9001, 5001, 101, 2, 4998),
(9002, 5001, 104, 1, 1500),
(9003, 5002, 103, 1, 2999),
(9004, 5003, 102, 1, 4999),
(9005, 5003, 105, 1, 2499),
(9006, 5004, 104, 1, 1599),
(9007, 5005, 105, 1, 3999);

#1️ Customer Insights
#a) High-Value Customers (Multiple Purchases)
SELECT c.customer_name, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;
#	This tells you who spent the most and ordered multiple times ( Rohan Sharma).
#________________________________________
#b) Customers by City (Urban-heavy)
SELECT city, COUNT(customer_id) AS num_customers
FROM Customers
GROUP BY city
ORDER BY num_customers DESC;
#	Shows which cities contribute most of your customers.
#________________________________________
#c) Payment Mode Usage
SELECT payment_mode, COUNT(order_id) AS num_orders,
       ROUND((COUNT(order_id)*100.0)/(SELECT COUNT(*) FROM Orders),2) AS percentage
FROM Orders
GROUP BY payment_mode;
#	Gives the percentage of digital payments (UPI / Cards) vs COD.
#________________________________________
#2️ Product Insights
#a) Total Sales per Product
SELECT p.product_name, SUM(od.subtotal) AS total_sales
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;
#	Helps identify top revenue-generating products (Smartwatch, Earbuds).
#b) Steady-selling / low-cost items
SELECT p.product_name, SUM(od.quantity) AS total_units_sold
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC;
#	Shows products with consistent single-item sales (Backpack).
#________________________________________
#3️ Sales Insights
#a) Total Orders, Revenue, Avg. Order Value
-- Total Orders
SELECT COUNT(*) AS total_orders FROM Orders;

-- Total Revenue
SELECT SUM(total_amount) AS total_revenue FROM Orders;

-- Average Order Value
SELECT ROUND(AVG(total_amount),2) AS avg_order_value FROM Orders;

-- Repeat Purchase Rate
SELECT ROUND((COUNT(*)*100.0)/(SELECT COUNT(DISTINCT customer_id) FROM Orders),2) AS repeat_percentage
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;
#_______________________________________
#4️ Discount Effectiveness
SELECT discount, ROUND(AVG(total_amount),2) AS avg_order_value, COUNT(order_id) AS num_orders
FROM Orders
GROUP BY discount
ORDER BY discount;
#	Shows how discount levels impact average order value.
#5 Regional Insights
SELECT c.city, SUM(o.total_amount) AS city_revenue, COUNT(o.order_id) AS total_orders
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY city_revenue DESC;
#	Highlights top-performing cities and low-frequency regions.
#6 Inventory & Stock Health
SELECT product_name, stock_qty,
       CASE 
           WHEN stock_qty < 100 THEN ' Medium – Selling fast'
           WHEN stock_qty BETWEEN 100 AND 150 THEN ' Healthy'
           ELSE ' Very good'
       END AS risk_status
FROM Products;


