CREATE MATERIALIZED VIEW analytics_by_category AS
SELECT c.id, c.name, 
COUNT(DISTINCT(l.id))::INTEGER as like_count, 
COUNT(DISTINCT(co.id))::INTEGER as comment_count, 
COUNT(DISTINCT(n.id))::INTEGER as news_count, 
COUNT(DISTINCT(r.id))::INTEGER as read_count
FROM news_category as c
LEFT JOIN news_category_alias as ca ON ca.category_id = c.id
LEFT JOIN news_feed as n ON ca.id = n.category_alias_id
LEFT JOIN news_comment as co on n.id = co.news_id
LEFT JOIN news_like as l on n.id = l.news_id
LEFT JOIN news_read_history as r on n.id = r.news_id
WHERE n.created_at > CURRENT_DATE - INTERVAl '7' DAY
GROUP BY c.id
ORDER BY c.id
WITH DATA
