CREATE OR REPLACE FUNCTION comment_news() RETURNS trigger AS
$$
BEGIN
  UPDATE news_feed SET comment_count=comment_count+1 WHERE id=NEW.news_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION uncomment_news() RETURNS trigger AS
$$
BEGIN
  UPDATE news_feed SET comment_count=comment_count-1 WHERE id=NEW.news_id AND comment_count > 0;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
