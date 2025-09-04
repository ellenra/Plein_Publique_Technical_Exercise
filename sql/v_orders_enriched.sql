-- Orders enriched view

CREATE OR REPLACE VIEW v_orders_enriched AS
SELECT
    o.id,
    o.customer_id,
    o.order_created_at,
    o.channel,
    o.country,
    COALESCE(SUM(oi.unit_price * oi.quantity), 0) AS items_total, 
    COALESCE(o.shipping_amount, 0) AS shipping_amount,
    (COALESCE(SUM(oi.unit_price * oi.quantity), 0) + COALESCE(o.shipping_amount, 0)) AS net_sales,

    COUNT(oi.order_id) AS item_count

FROM orders AS o
LEFT JOIN order_items AS oi ON o.id = oi.order_id
GROUP BY 
    o.id, 
    o.customer_id, 
    o.order_created_at, 
    o.channel, 
    o.country, 
    o.shipping_amount;
