-- Create Database
CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS suppliers;

-- Create Tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    registration_date DATE,
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    parent_category_id INT
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    cost DECIMAL(10,2),
    stock_quantity INT,
    supplier_id INT,
    created_date DATE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    shipping_city VARCHAR(50),
    shipping_country VARCHAR(50),
    payment_method VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    line_total DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- Customers
INSERT INTO customers VALUES 
(1, 'Tamanna', 'AAA', 'tamanna.aaa@email.com', '123-456-7890', '2023-01-15', 'New York', 'USA'),
(2, 'Rahul', 'JJJ', 'rahul.jjj@email.com', '123-456-7891', '2023-02-20', 'London', 'UK'),
(3, 'Mike', 'Johnson', 'mike.johnson@email.com', '123-456-7892', '2023-03-10', 'Toronto', 'Canada'),
(4, 'Sarah', 'Wilson', 'sarah.wilson@email.com', '123-456-7893', '2023-04-05', 'Sydney', 'Australia'),
(5, 'David', 'Brown', 'david.brown@email.com', '123-456-7894', '2023-05-12', 'Berlin', 'Germany'),
(6, 'Emily', 'Davis', 'emily.davis@email.com', '123-456-7895', '2023-01-22', 'Paris', 'France'),
(7, 'Chris', 'Miller', 'chris.miller@email.com', '123-456-7896', '2023-02-18', 'Tokyo', 'Japan'),
(8, 'Lisa', 'Garcia', 'lisa.garcia@email.com', '123-456-7897', '2023-03-25', 'Madrid', 'Spain');

-- Categories
INSERT INTO categories VALUES
(1, 'Electronics', NULL),
(2, 'Clothing', NULL),
(3, 'Home & Garden', NULL),
(4, 'Smartphones', 1),
(5, 'Laptops', 1),
(6, 'Tablets', 1),
(7, 'Men Fashion', 2),
(8, 'Women Fashion', 2),
(9, 'Furniture', 3),
(10, 'Kitchen', 3);

-- Suppliers
INSERT INTO suppliers VALUES
(1, 'TechCorp Inc', 'contact@techcorp.com', 'USA'),
(2, 'FashionStyle Ltd', 'info@fashionstyle.com', 'China'),
(3, 'HomeEssentials Co', 'sales@homeessentials.com', 'Germany'),
(4, 'GadgetWorld', 'support@gadgetworld.com', 'Japan');

-- Products
INSERT INTO products VALUES
(1, 'iPhone 14 Pro', 4, 1099.99, 750.00, 50, 4, '2023-01-01'),
(2, 'Samsung Galaxy S23', 4, 899.99, 600.00, 75, 4, '2023-01-15'),
(3, 'MacBook Pro 16"', 5, 2399.99, 1600.00, 30, 1, '2023-02-01'),
(4, 'Dell XPS 15', 5, 1699.99, 1200.00, 40, 1, '2023-02-10'),
(5, 'iPad Air', 6, 749.99, 500.00, 60, 1, '2023-03-01'),
(6, 'Men Casual Shirt', 7, 45.99, 25.00, 200, 2, '2023-01-01'),
(7, 'Women Summer Dress', 8, 79.99, 40.00, 150, 2, '2023-01-01'),
(8, 'Leather Sofa', 9, 1299.99, 800.00, 20, 3, '2023-04-01'),
(9, 'Coffee Table', 9, 299.99, 180.00, 35, 3, '2023-04-15'),
(10, 'Blender', 10, 89.99, 50.00, 100, 3, '2023-05-01'),
(11, 'AirPods Pro', 1, 249.99, 150.00, 80, 1, '2023-03-15'),
(12, 'Smart Watch', 1, 349.99, 220.00, 45, 4, '2023-04-01');

-- Orders
INSERT INTO orders VALUES
(1, 2, '2023-06-01', 1149.98, 'Delivered', 'New York', 'USA', 'Credit Card'),
(2, 2, '2023-06-02', 2399.99, 'Delivered', 'London', 'UK', 'PayPal'),
(3, 1, '2023-06-05', 125.98, 'Delivered', 'New York', 'USA', 'Credit Card'),
(4, 3, '2023-06-08', 1749.98, 'Processing', 'Toronto', 'Canada', 'Credit Card'),
(5, 4, '2023-06-10', 79.99, 'Delivered', 'Sydney', 'Australia', 'PayPal'),
(6, 5, '2023-06-12', 1599.98, 'Shipped', 'Berlin', 'Germany', 'Bank Transfer'),
(7, 6, '2023-06-15', 349.99, 'Delivered', 'Paris', 'France', 'Credit Card'),
(8, 2, '2023-06-18', 199.98, 'Processing', 'London', 'UK', 'PayPal'),
(9, 7, '2023-06-20', 1299.99, 'Delivered', 'Tokyo', 'Japan', 'Credit Card'),
(10, 8, '2023-06-22', 389.98, 'Shipped', 'Madrid', 'Spain', 'PayPal'),
(11, 1, '2023-07-01', 249.99, 'Delivered', 'New York', 'USA', 'Credit Card'),
(12, 3, '2023-07-05', 899.99, 'Delivered', 'Toronto', 'Canada', 'Credit Card'),
(13, 5, '2023-07-08', 45.99, 'Delivered', 'Berlin', 'Germany', 'PayPal'),
(14, 2, '2023-07-10', 299.99, 'Processing', 'London', 'UK', 'PayPal'),
(15, 4, '2023-07-12', 749.99, 'Delivered', 'Sydney', 'Australia', 'Credit Card');

-- Order Items
INSERT INTO order_items VALUES
(1, 1, 6, 1, 1099.99, 1099.99),
(2, 1, 6, 1, 45.99, 45.99),
(3, 2, 3, 1, 2399.99, 2399.99),
(4, 3, 6, 2, 45.99, 91.98),
(5, 3, 10, 1, 89.99, 89.99),
(6, 4, 4, 1, 1699.99, 1699.99),
(7, 4, 11, 1, 249.99, 249.99),
(8, 5, 7, 1, 79.99, 79.99),
(9, 6, 2, 1, 899.99, 899.99),
(10, 6, 12, 1, 349.99, 349.99),
(11, 6, 6, 1, 45.99, 45.99),
(12, 7, 12, 1, 349.99, 349.99),
(13, 8, 9, 1, 299.99, 299.99),
(14, 9, 8, 1, 1299.99, 1299.99),
(15, 10, 10, 1, 89.99, 89.99),
(16, 10, 11, 1, 249.99, 249.99),
(17, 11, 11, 1, 249.99, 249.99),
(18, 12, 2, 1, 899.99, 899.99),
(19, 13, 6, 1, 45.99, 45.99),
(20, 14, 9, 1, 299.99, 299.99),
(21, 15, 5, 1, 749.99, 749.99);

-- ANALYTICAL QUERIES

-- Query 1: Sales Performance Overview
SELECT '=== SALES PERFORMANCE OVERVIEW ===' as '';
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(*) as total_orders,
    SUM(total_amount) as revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    MAX(total_amount) as largest_order
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Query 2: Top Customers by Spending
SELECT '=== TOP CUSTOMERS BY SPENDING ===' as '';
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.country,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    ROUND(AVG(o.total_amount), 2) as avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name, c.country
ORDER BY total_spent DESC
LIMIT 10;

-- Query 3: Product Performance Analysis
SELECT '=== TOP SELLING PRODUCTS ===' as '';
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity) as total_units_sold,
    SUM(oi.line_total) as total_revenue,
    ROUND(SUM(oi.line_total - (p.cost * oi.quantity)), 2) as total_profit,
    ROUND((SUM(oi.line_total - (p.cost * oi.quantity)) / SUM(oi.line_total)) * 100, 2) as profit_margin_percent
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 4: Category Performance
SELECT '=== SALES BY CATEGORY ===' as '';
SELECT 
    c.category_name,
    COUNT(DISTINCT o.order_id) as order_count,
    SUM(oi.quantity) as units_sold,
    ROUND(SUM(oi.line_total), 2) as revenue,
    ROUND(AVG(oi.line_total), 2) as avg_sale_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;

-- Query 5: Customer RFM Analysis
SELECT '=== CUSTOMER RFM ANALYSIS ===' as '';
WITH customer_rfm AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) as customer_name,
        DATEDIFF('2023-07-31', MAX(o.order_date)) as recency_days,
        COUNT(o.order_id) as frequency,
        SUM(o.total_amount) as monetary
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, customer_name
)
SELECT 
    customer_id,
    customer_name,
    recency_days,
    frequency,
    monetary,
    CASE 
        WHEN recency_days <= 30 THEN 'High'
        WHEN recency_days <= 90 THEN 'Medium'
        ELSE 'Low'
    END as recency_score,
    CASE 
        WHEN frequency >= 3 THEN 'High'
        WHEN frequency >= 2 THEN 'Medium'
        ELSE 'Low'
    END as frequency_score,
    CASE 
        WHEN monetary >= 1000 THEN 'High'
        WHEN monetary >= 200 THEN 'Medium'
        ELSE 'Low'
    END as monetary_score,
    CONCAT(
        CASE 
            WHEN recency_days <= 30 THEN 'H' WHEN recency_days <= 90 THEN 'M' ELSE 'L' END,
        CASE 
            WHEN frequency >= 3 THEN 'H' WHEN frequency >= 2 THEN 'M' ELSE 'L' END,
        CASE 
            WHEN monetary >= 1000 THEN 'H' WHEN monetary >= 200 THEN 'M' ELSE 'L' END
    ) as rfm_segment
FROM customer_rfm
ORDER BY monetary DESC;

-- Query 6: Geographic Analysis
SELECT '=== SALES BY GEOGRAPHY ===' as '';
SELECT 
    shipping_country,
    shipping_city,
    COUNT(*) as total_orders,
    ROUND(SUM(total_amount), 2) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM orders
GROUP BY shipping_country, shipping_city
ORDER BY total_revenue DESC;

-- Query 7: Payment Method Analysis
SELECT '=== PAYMENT METHOD ANALYSIS ===' as '';
SELECT 
    payment_method,
    COUNT(*) as transaction_count,
    ROUND(SUM(total_amount), 2) as total_volume,
    ROUND(AVG(total_amount), 2) as avg_transaction_value
FROM orders
GROUP BY payment_method
ORDER BY total_volume DESC;

-- Query 8: Monthly Growth Rate
SELECT '=== MONTHLY GROWTH ANALYSIS ===' as '';
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') as month,
        SUM(total_amount) as monthly_revenue
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT 
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY month) as previous_month_revenue,
    CASE 
        WHEN LAG(monthly_revenue) OVER (ORDER BY month) IS NOT NULL THEN
            ROUND(((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month)) / LAG(monthly_revenue) OVER (ORDER BY month)) * 100, 2)
        ELSE NULL
    END as growth_rate_percent
FROM monthly_sales
ORDER BY month;

-- Query 9: Inventory Health Check
SELECT '=== INVENTORY HEALTH CHECK ===' as '';
SELECT 
    p.product_name,
    c.category_name,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) as total_sold,
    ROUND(p.stock_quantity / NULLIF(COALESCE(SUM(oi.quantity), 0), 0) * 30, 2) as estimated_days_supply,
    CASE 
        WHEN p.stock_quantity < 20 THEN 'Low Stock'
        WHEN p.stock_quantity > 100 THEN 'Overstocked'
        ELSE 'Healthy'
    END as stock_status
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name, c.category_name, p.stock_quantity
ORDER BY estimated_days_supply DESC;

-- Query 10: Customer Acquisition Timeline
SELECT '=== CUSTOMER ACQUISITION TIMELINE ===' as '';
SELECT 
    DATE_FORMAT(registration_date, '%Y-%m') as registration_month,
    COUNT(*) as new_customers,
    SUM(CASE WHEN o.order_id IS NOT NULL THEN 1 ELSE 0 END) as activated_customers,
    ROUND(SUM(CASE WHEN o.order_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as activation_rate_percent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY DATE_FORMAT(registration_date, '%Y-%m')
ORDER BY registration_month;

-- Query 11: Order Status Distribution
SELECT '=== ORDER STATUS DISTRIBUTION ===' as '';
SELECT 
    status,
    COUNT(*) as order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) as percentage
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- Query 12: Supplier Performance
SELECT '=== SUPPLIER PERFORMANCE ===' as '';
SELECT 
    s.supplier_name,
    s.country,
    COUNT(p.product_id) as products_supplied,
    SUM(oi.quantity) as units_sold,
    ROUND(SUM(oi.line_total), 2) as generated_revenue
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY s.supplier_id, s.supplier_name, s.country
ORDER BY generated_revenue DESC;

-- BUSINESS INSIGHTS SUMMARY

SELECT '=== BUSINESS INSIGHTS SUMMARY ===' as '';
SELECT 
    (SELECT COUNT(*) FROM customers) as total_customers,
    (SELECT COUNT(*) FROM orders) as total_orders,
    (SELECT ROUND(SUM(total_amount), 2) FROM orders) as total_revenue,
    (SELECT ROUND(AVG(total_amount), 2) FROM orders) as avg_order_value,
    (SELECT COUNT(DISTINCT product_id) FROM order_items) as unique_products_sold,
    (SELECT ROUND(SUM(quantity)) FROM order_items) as total_units_sold,
    (SELECT COUNT(DISTINCT shipping_country) FROM orders) as countries_served;