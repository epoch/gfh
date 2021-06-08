create database goodfoodhunting;

\c goodfoodhunting

CREATE TABLE dishes (
  id SERIAL PRIMARY KEY,
  name TEXT,
  image_url TEXT
);


CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT,
  password_digest TEXT
);


ALTER TABLE dishes ADD COLUMN user_id INTEGER;