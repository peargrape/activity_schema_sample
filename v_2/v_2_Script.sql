
-- Count by customers and links
SELECT customer, link, COUNT(*) AS sequence_count
FROM (
    SELECT customer, link, "event",
           LEAD("event", 1) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_1,
           LEAD("event", 2) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_2,
           LEAD("event", 3) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_3
    FROM table_events te   
) subquery
WHERE "event" = 'link_clicked'
  AND next_event_1 = 'lead_generated'
  AND next_event_2 = 'cons_arranged'
  AND next_event_3 = 'payment_made'
GROUP BY 1, 2;

-- Count by link 
SELECT link, COUNT(*) AS sequence_count
FROM (
    SELECT link, "event",
           LEAD("event", 1) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_1,
           LEAD("event", 2) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_2,
           LEAD("event", 3) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_3
    FROM table_events te  
) subquery
WHERE "event" = 'link_clicked'
  AND next_event_1 = 'lead_generated'
  AND next_event_2 = 'cons_arranged'
  AND next_event_3 = 'payment_made'
GROUP BY 1;


-- Conversion
WITH cte AS (
SELECT link, COUNT(*) AS sequence_count
FROM (
    SELECT link, "event",
           LEAD("event", 1) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_1,
           LEAD("event", 2) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_2,
           LEAD("event", 3) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_event_3
    FROM table_events te  
) subquery
WHERE "event" = 'link_clicked'
  AND next_event_1 = 'lead_generated'
  AND next_event_2 = 'cons_arranged'
  AND next_event_3 = 'payment_made'
GROUP BY 1
),

clicks AS (
SELECT link, count(*) AS link_clicked_count
FROM table_events te
WHERE "event" = 'link_clicked'
GROUP BY te.link)

SELECT c.link, CAST(c.sequence_count AS decimal) / cl.link_clicked_count "conversion"
FROM cte c
INNER JOIN clicks cl 
ON c.link = cl.link
ORDER BY 2 DESC;


