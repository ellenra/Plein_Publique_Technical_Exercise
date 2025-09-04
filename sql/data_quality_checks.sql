-- Data Quality Checks

-- 1. Negative prices in orders

SELECT *
FROM order_items
WHERE unit_price < 0;


-- 2. Orders with missing info
SELECT *
FROM orders
WHERE customer_id IS NULL;

SELECT *
FROM order_items
WHERE product_id IS NULL;


-- 3. Check for identical rows

SELECT *, COUNT(*) AS cnt
FROM order_items
GROUP BY order_id, line_id, product_id, sku, title, size, unit_price, quantity
HAVING COUNT(*) > 1;


-- 4. Duplicate values check (SKUs)

SELECT sku, COUNT(*)
FROM products
GROUP BY sku
HAVING COUNT(*) > 1;
