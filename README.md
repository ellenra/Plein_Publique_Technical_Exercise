# Plein Publique Technical Exercise

This project sets up a small analytics stack to analyze e-commerce data. Data is imported into Supabase (Postgres), transformed with SQL views and can be visualized in a Looker Studio dashboard or any other analytics tool.

### Assumptions

- SKUs are unique and map to one product_id
- Discounts are applied directly to net_sales
- Net sales include discounts and shipping fees
- Each line_id is unique per order
- Returns are matched to order lines using (line_id, order_id)
- Quantities and unit prices are non-negative, sizes XS-XL


# Running Queries

1. Open the SQL editor in Supabase.
2. Run the `schema/schema.sql` file to create tables, load data, and build views.
3. Run the `sql/v_orders_enriched.sql` and `sql/v_returns_enriched.sql` files to create the normalized metric views.
4. Run the remaining SQL files in the sql/ folder to generate KPIs and perform data quality checks.

[Schema script](sql/)  
[SQL scripts](sql/)


# Views
Creating views makes it easier to analyze data without having to recalculate values every time you query (ask database to return certain data).

#### Orders enriched view
Combines orders with their items and calculates:
- Total cost of all items
- Shipping cost
- Total revenue for the order
- Number of items in the order

#### Returns enriched view
Combines return records with the corresponding order items. For each returned item it includes:
- Order, product and line info of the returned item
- Returned quantity and return reason
- Date when return was created
- Returned item unit price and total value of the return


# Schema Diagram
<img width="1157" height="771" alt="Screenshot from 2025-09-04 20-03-21" src="https://github.com/user-attachments/assets/e70f9f65-6c95-4ee7-baa2-24f07d9b13fc" />


# Dashboard

### Global Filters at the Top of the Dashboard

| Filter       | Type                 | Default       | Options                                      |
|:------------:|:------------------:|:------------:|:--------------------------------------------|
| Date Range   | Absolute or relative | Past 30 days | a week, a month, custom                      |
| Country      | Multiselect          | All countries | List of countries                             |
| Channel      | Multiselect          | All channels | Online, POS, Marketplace                      |
| Category     | Multiselect          | All categories | Product categories                             |


### Important KPI Scorecards

<img width="871" height="177" alt="Screenshot from 2025-09-04 20-26-20" src="https://github.com/user-attachments/assets/2b52fe6f-16ab-4647-80e8-e32105fb7ebe" />


### Return Diagrams

- Line diagram showing returned units and total amount of returns (€) over the chosen timeframe


### Size Distribution / Top SKUs Block Diagrams

<img width="401" height="415" alt="Screenshot from 2025-09-04 20-36-20" src="https://github.com/user-attachments/assets/0b6b42ee-68ae-4992-9ce8-d9008813c3ce" />
