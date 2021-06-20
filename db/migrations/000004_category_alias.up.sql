CREATE TABLE category_alias (
  id SERIAL PRIMARY KEY,
  alias VARCHAR (255) NOT NULL,
  category INT,
  CONSTRAINT fk_category
    FOREIGN KEY (category)
      REFERENCES category (id)
        ON UPDATE CASCADE
);
CREATE UNIQUE INDEX unique_alias ON category_alias(alias);
