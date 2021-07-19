CREATE OR REPLACE FUNCTION like_news() RETURNS trigger AS
$$
BEGIN
  UPDATE news_feed SET like_count=like_count+1 WHERE id=NEW.news_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION unlike_news() RETURNS trigger AS
$$
BEGIN
  UPDATE news_feed SET like_count=like_count-1 WHERE id=OLD.news_id AND like_count > 0;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
