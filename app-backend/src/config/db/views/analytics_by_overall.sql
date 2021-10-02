CREATE MATERIALIZED VIEW analytics_by_overall AS
SELECT COUNT(DISTINCT(n.id))::INTEGER as news_count,
COUNT(DISTINCT(u.id))::INTEGER as user_count
FROM news_feed as n
LEFT JOIN base_user as u on true
WITH DATA
