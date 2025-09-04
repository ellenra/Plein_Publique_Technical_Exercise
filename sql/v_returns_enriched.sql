-- Returns enriched view

CREATE OR REPLACE VIEW v_returns_enriched AS
SELECT
    r.return_id,
    r.order_id,
    r.product_id,
    r.line_id,
    r.returned_quantity,
    r.return_reason,
    r.return_created_at,
    oi.unit_price,
    (r.returned_quantity * oi.unit_price) AS return_value
FROM returns AS r
JOIN order_items AS oi
    ON r.order_id = oi.order_id
    AND r.line_id = oi.line_id;
