-- Net Sales by day / country

SELECT
    DATE(order_created_at) AS order_date,
    country,
    SUM(net_sales) AS net_sales,
    COUNT(*) as order_count
FROM v_orders_enriched
GROUP BY DATE(order_created_at), country
ORDER BY order_date, net_sales;


-- AOV by Channel

SELECT
    channel,
    SUM(net_sales) AS total_sales,
    COUNT(*) AS order_count,
    SUM(net_sales) / COUNT(*) AS aov
FROM v_orders_enriched
GROUP BY channel
ORDER BY aov DESC;


-- Return Rate (overall)

SELECT
    SUM(r.returned_quantity) AS total_returned_units,
    SUM(oi.quantity) AS total_sold_units,
    SUM(r.returned_quantity) / NULLIF(SUM(oi.quantity), 0) AS return_rate
FROM v_returns_enriched AS r
JOIN order_items AS oi
    ON r.order_id = oi.order_id
   AND r.line_id = oi.line_id;


-- Return Rate (per product)

SELECT
    oi.product_id AS product_id,
    SUM(COALESCE(r.returned_quantity, 0)) AS returned_units,
    SUM(oi.quantity) AS sold_units,
    SUM(COALESCE(r.returned_quantity, 0))::numeric / NULLIF(SUM(oi.quantity), 0) AS return_rate
FROM order_items AS oi
LEFT JOIN v_returns_enriched AS r
    ON oi.order_id = r.order_id
   AND oi.line_id = r.line_id
GROUP BY oi.product_id
ORDER BY return_rate DESC;


-- Top 10 SKUs by net sales

SELECT
    oi.sku,
    SUM(oi.unit_price * oi.quantity - COALESCE(r.returned_quantity, 0) * oi.unit_price) AS net_sales
FROM order_items AS oi
LEFT JOIN v_returns_enriched AS r
    ON oi.order_id = r.order_id
   AND oi.line_id = r.line_id
GROUP BY oi.sku
ORDER BY net_sales DESC
LIMIT 10;


-- Top 10 SKUs by return rate

SELECT
    oi.sku AS sku,
    SUM(COALESCE(r.returned_quantity, 0)) AS returned_units,
    SUM(oi.quantity) AS sold_units,
    SUM(COALESCE(r.returned_quantity, 0))::numeric / NULLIF(SUM(oi.quantity), 0) AS return_rate
FROM order_items AS oi
LEFT JOIN v_returns_enriched AS r
    ON oi.order_id = r.order_id
   AND oi.line_id = r.line_id
GROUP BY oi.sku
ORDER BY return_rate DESC
LIMIT 10;


-- Customer Mix: new vs. returned customers by month

WITH first_orders AS (
    SELECT
        customer_id,
        MIN(DATE(order_created_at)) AS first_order_date
    FROM v_orders_enriched
    GROUP BY customer_id
),
monthly_customers AS (
    SELECT
        DATE_TRUNC('month', o.order_created_at) AS order_month,
        CASE 
            WHEN DATE(o.order_created_at) = f.first_order_date THEN 'New'
            ELSE 'Returning'
        END AS customer_type,
        COUNT(DISTINCT o.customer_id) AS customer_count
    FROM v_orders_enriched AS o
    JOIN first_orders AS f
        ON o.customer_id = f.customer_id
    GROUP BY order_month, customer_type
)
SELECT
    order_month,
    SUM(CASE WHEN customer_type = 'New' THEN customer_count ELSE 0 END) AS new_customers,
    SUM(CASE WHEN customer_type = 'Returning' THEN customer_count ELSE 0 END) AS returning_customers
FROM monthly_customers
GROUP BY order_month
ORDER BY order_month;


-- Size Curve: units sold by size (XS-XL)

SELECT
    size,
    SUM(quantity) AS units_sold,
    SUM(quantity) * 100 / SUM(SUM(quantity)) OVER () AS percentage
FROM order_items
GROUP BY size
ORDER BY 
    CASE size
        WHEN 'XS' THEN 1
        WHEN 'S' THEN 2
        WHEN 'M' THEN 3
        WHEN 'L' THEN 4
        WHEN 'XL' THEN 5
        ELSE 6
    END;

