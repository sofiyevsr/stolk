CREATE MATERIALIZED VIEW analytics_by_overall AS
SELECT COUNT(n.id)::INTEGER as news_count,
(SELECT COUNT(u.id) as user_count from base_user as u),
CURRENT_TIMESTAMP as last_update
FROM news_feed as n
WITH DATA
