CREATE MATERIALIZED VIEW analytics_by_source AS
SELECT s.id, s.name, 
COUNT(DISTINCT(l.id))::INTEGER as like_count,
COUNT(DISTINCT(co.id))::INTEGER as comment_count,
COUNT(DISTINCT(n.id))::INTEGER as news_count, 
COUNT(DISTINCT(r.id))::INTEGER as read_count,
COUNT(DISTINCT(f.id))::INTEGER as follow_count
FROM news_source as s
LEFT JOIN source_follow as f on s.id = f.source_id
LEFT JOIN news_feed as n ON s.id = n.source_id
LEFT JOIN news_comment as co on n.id = co.news_id
LEFT JOIN news_like as l on n.id = l.news_id
LEFT JOIN news_read_history as r on n.id = r.news_id
WHERE n.created_at > CURRENT_DATE - INTERVAl '7' DAY
GROUP BY s.id
ORDER BY s.id
wiTH DATA
