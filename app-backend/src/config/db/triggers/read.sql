CREATE TRIGGER read_trigger AFTER INSERT ON news_read_history
    FOR EACH ROW EXECUTE PROCEDURE read_news();
