-- Now we are going to check our table and make fixes if necessary:
SELECT *
FROM table_events t
WHERE t."event" = 'link_clicked'
AND t.link  IS NULL;

SELECT *
FROM table_events t
WHERE t."event" <> 'link_clicked'
AND t.link IS NOT NULL;

-- empty links are not null in fact, therefore, we make them null:
UPDATE table_events
SET link = NULL 
WHERE link NOT LIKE 'http%';

-- Now we check payments:
SELECT *
FROM table_events t
WHERE "event" = 'payment_made'
AND revenue_impact IS NULL;

SELECT *
FROM table_events t
WHERE "event" <> 'payment_made'
AND revenue_impact IS NOT NULL;

-- There are some non-empty revenue_impact values for events besides of payment_made.
-- We are goung to fix it:
UPDATE table_events
SET revenue_impact  = NULL 
WHERE "event" <> 'payment_made';


-- And, finally, we savetable in .csv format:
COPY table_events TO 'C:/Mike/Analytics/table_events.csv' DELIMITER ',' CSV HEADER;
