CREATE TRIGGER like_trigger AFTER INSERT ON news_like
    FOR EACH ROW EXECUTE PROCEDURE like_news();

CREATE TRIGGER unlike_trigger AFTER DELETE ON news_like
    FOR EACH ROW EXECUTE PROCEDURE unlike_news();
