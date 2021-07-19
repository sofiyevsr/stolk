CREATE TRIGGER comment_trigger AFTER INSERT ON news_comment
    FOR EACH ROW EXECUTE PROCEDURE comment_news();

CREATE TRIGGER uncomment_trigger AFTER DELETE ON news_comment
    FOR EACH ROW EXECUTE PROCEDURE uncomment_news();
