CREATE TABLE statuses (
  id INTEGER PRIMARY KEY NOT NULL,
  text VARCHAR(255) NOT NULL,
  cat_id INTEGER NOT NULL,

  FOREIGN KEY(cat_id) REFERENCES cat(id)
);

CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES house(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "26th and Guerrero"), (2, "Dolores and Market");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Devon", "Watts", 1),
  (2, "Matt", "Rubens", 1),
  (3, "Ned", "Ruggeri", 2),
  (4, "Catless", "Human", NULL);

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, "Curie", 1),
  (2, "Markov", 3),
  (3, "Breakfast", 1),
  (4, "Earl", 2),
  (5, "Haskell", 3),
  (6, "Stray Cat", NULL);

INSERT INTO
  statuses (id, text, cat_id) 
VALUES
  (1, "Curie loves string!", 1),
  (2, "Markov is mighty!", 2),
  (3, "Curie is cool!", 1);

