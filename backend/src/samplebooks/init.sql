-- Sample Queries to Create this Books table and insert some values
CREATE TABLE books (
  id SERIAL PRIMARY KEY,
  author VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL
);

INSERT INTO books (author, title)
VALUES  ('Meg Jay', 'The Defining Decade');
