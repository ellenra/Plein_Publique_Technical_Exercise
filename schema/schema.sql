create table public.customers (
  id text not null,
  first_name text not null,
  last_name text not null,
  email text not null,
  country text null,
  created_at timestamp with time zone not null,
  marketing_opt_in boolean not null,
  constraint customers_pkey primary key (id),
  constraint customers_id_key unique (id)
) TABLESPACE pg_default;

create table public.inventory_snapshot (
  product_id text not null,
  sku text not null,
  on_hand bigint not null,
  on_order bigint not null,
  warehouse text null,
  id bigserial not null,
  constraint inventory_snapshot_pkey primary key (id),
  constraint inventory_snapshot_id_key unique (id),
  constraint inventory_snapshot_product_id_fkey foreign KEY (product_id) references products (id) on update CASCADE on delete set null
) TABLESPACE pg_default;

create table public.order_items (
  order_id text not null,
  line_id text not null,
  product_id text not null,
  sku text not null,
  title text not null,
  size text not null,
  unit_price double precision not null,
  quantity bigint not null,
  constraint order_items_pk primary key (line_id, order_id),
  constraint order_items_order_id_fkey foreign KEY (order_id) references orders (id) on update CASCADE on delete set null,
  constraint order_items_product_id_fkey foreign KEY (product_id) references products (id) on update CASCADE on delete set null
) TABLESPACE pg_default;

create table public.orders (
  id text not null,
  customer_id text not null,
  order_created_at timestamp with time zone not null,
  channel text not null,
  country text not null,
  payment_method text not null,
  discount_code text null,
  shipping_amount double precision not null,
  constraint orders_pkey primary key (id),
  constraint orders_id_key unique (id),
  constraint orders_customer_id_fkey foreign KEY (customer_id) references customers (id) on update RESTRICT on delete set null
) TABLESPACE pg_default;

create table public.products (
  id text not null,
  sku text not null,
  title text not null,
  category text not null,
  material text not null,
  color text not null,
  size text not null,
  price double precision not null,
  active boolean not null,
  constraint products_pkey primary key (id),
  constraint products_id_key unique (id)
) TABLESPACE pg_default;

create table public.returns (
  return_id text not null,
  order_id text not null,
  line_id text not null,
  product_id text not null,
  returned_quantity bigint not null,
  return_reason text not null,
  return_created_at timestamp with time zone not null,
  constraint returns_pkey primary key (return_id),
  constraint fk_returns_order_items foreign KEY (line_id, order_id) references order_items (line_id, order_id),
  constraint returns_order_id_fkey foreign KEY (order_id) references orders (id) on update CASCADE on delete CASCADE,
  constraint returns_product_id_fkey foreign KEY (product_id) references products (id) on update CASCADE on delete set null
) TABLESPACE pg_default;

