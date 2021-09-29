CREATE OR REPLACE FUNCTION read_news() RETURNS trigger AS
$$
BEGIN
  UPDATE news_feed SET read_count=read_count+1 WHERE id=NEW.news_id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
