CREATE TABLE activity_table (
  activity_id varchar(50) PRIMARY KEY,
  ts timestamp,
  customer varchar(200),
  activity varchar(50),
  anonymous_customer_id varchar(200),
  feature_json json,
  revenue_impact decimal(5,2),
  link varchar(200)
);


SELECT * FROM activity_table ;


-- amount of sales for each customer (both anonymous and named ones)
WITH cte AS (
SELECT a.customer, count(1) AS sales_amount
FROM activity_table a
WHERE a.customer IS NOT NULL AND a.activity = 'sale'
GROUP BY 1
UNION ALL 
SELECT t.anonymous_customer_id AS customer, count(1)
FROM activity_table t
WHERE t.anonymous_customer_id IS NOT NULL AND t.activity = 'sale'
GROUP BY 1)

SELECT tt.customer, COALESCE(c.sales_amount, 0)
FROM (
  SELECT DISTINCT a.customer AS customer 
  FROM activity_table a
  WHERE a.customer IS NOT NULL 
  UNION ALL
  SELECT DISTINCT b.anonymous_customer_id
  FROM activity_table b
  WHERE b.anonymous_customer_id IS NOT null) tt
FULL OUTER JOIN cte c 
ON tt.customer = c.customer
--WHERE tt.customer IS NOT NULL 
GROUP BY 1, 2
ORDER BY 2 DESC;

-- select all the customers with sales and count amount of sales for each one 
SELECT DISTINCT a.customer, count(1) AS sales_amount
FROM activity_table a
WHERE a.customer IS NOT NULL AND a.activity = 'sale'
GROUP BY 1;

--amount of sales per user
WITH cte AS (
  SELECT act.customer, count(1) AS sales_amount
           FROM activity_table act
           WHERE act.customer IS NOT NULL AND act.activity = 'sale'
           GROUP BY 1)
SELECT a.customer, coalesce(b.sales_amount, 0) AS sales_amount
FROM activity_table a 
LEFT JOIN cte b
ON a.customer = b.customer
GROUP BY 1, 2
HAVING a.customer IS NOT NULL ;


-- average amount of clicks per one sale
SELECT CAST(count(1) AS decimal)/(SELECT count(1) FROM activity_table a WHERE a.activity = 'click') AS  "sales per click"
FROM activity_table aa
WHERE aa.activity = 'sale';



