CREATE TABLE news (
  id SERIAL PRIMARY KEY,
  title VARCHAR (1000) NOT NULL,
  description VARCHAR,
  source INT NOT NULL,
  image_link VARCHAR (1000),
  pub_date TIMESTAMPTZ NOT NULL,
  feed_link VARCHAR (1000) UNIQUE NOT NULL,
  category_alias INT,
  CONSTRAINT fk_source
    FOREIGN KEY (source)
      REFERENCES source (id)
        ON UPDATE CASCADE,
  CONSTRAINT fk_category_alias
    FOREIGN KEY (category_alias)
      REFERENCES category_alias (id)
        ON UPDATE CASCADE
      );
