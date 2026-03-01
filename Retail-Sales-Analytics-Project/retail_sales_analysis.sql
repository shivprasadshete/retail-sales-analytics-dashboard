use retail_analytics_2_0;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    cost_price DECIMAL(10,2),
    selling_price DECIMAL(10,2)
);

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    store_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

USE retail_analytics;

SELECT COUNT(*) FROM orders;
USE retail_analytics_2_0;

SHOW TABLES;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM stores;

SELECT SUM(o.quantity * o.price) AS total_revenue
FROM orders o;

SELECT 
    SUM(o.quantity * o.price) AS total_revenue,
    SUM((p.selling_price - p.cost_price) * o.quantity) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id;

SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(quantity * price) AS revenue
FROM orders
GROUP BY month
ORDER BY month;

SELECT 
    p.product_name,
    SUM(o.quantity * o.price) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

SELECT 
    s.city,
    SUM(o.quantity * o.price) AS revenue
FROM orders o
JOIN stores s ON o.store_id = s.store_id
GROUP BY s.city
ORDER BY revenue DESC;

CREATE VIEW sales_report AS
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    c.city AS customer_city,
    p.product_name,
    p.category,
    s.city AS store_city,
    s.region,
    o.quantity,
    o.price,
    (o.quantity * o.price) AS revenue,
    (p.price - p.cost) * o.quantity AS profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
JOIN stores s ON o.store_id = s.store_id;