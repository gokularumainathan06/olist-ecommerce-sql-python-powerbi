-- 02_load_data.sql : loads the CSV files into the tables
-- Run from the PROJECT ROOT folder so the relative paths below work.
-- (\copy is a psql command, so it must stay on ONE line each.)
 
\copy customers                   FROM 'data/raw/olist_customers_dataset.csv'          WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy sellers                     FROM 'data/raw/olist_sellers_dataset.csv'            WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy products                    FROM 'data/raw/olist_products_dataset.csv'           WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy product_category_translation FROM 'data/raw/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy orders                      FROM 'data/raw/olist_orders_dataset.csv'             WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy order_items                 FROM 'data/raw/olist_order_items_dataset.csv'        WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy order_payments              FROM 'data/raw/olist_order_payments_dataset.csv'     WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy order_reviews               FROM 'data/raw/olist_order_reviews_dataset.csv'      WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')