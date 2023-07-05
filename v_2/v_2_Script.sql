
-- Count by customers and links
SELECT customer, link, COUNT(*) AS sequence_count
FROM (
    SELECT customer, link, activity,
           LEAD(activity, 1) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_activity_1,
           LEAD(activity, 2) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_activity_2,
           LEAD(activity, 3) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_activity_3
    FROM table_activity ta  
) subquery
WHERE activity = 'click'
  AND next_activity_1 = 'lead'
  AND next_activity_2 = 'consultation'
  AND next_activity_3 = 'sale'
GROUP BY 1, 2;

-- Count by link 
SELECT link, COUNT(*) AS sequence_count
FROM (
    SELECT link, activity,
           LEAD(activity, 1) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_activity_1,
           LEAD(activity, 2) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_activity_2,
           LEAD(activity, 3) OVER (PARTITION BY customer ORDER BY customer, ts) AS next_activity_3
    FROM table_activity ta  
) subquery
WHERE activity = 'click'
  AND next_activity_1 = 'lead'
  AND next_activity_2 = 'consultation'
  AND next_activity_3 = 'sale'
GROUP BY 1;