 -- -----------------------------------------------------
-- This script is meant to be run in its entirety. 
-- Running the entire script will fully reset and rebuild the database
-- -----------------------------------------------------
-- RESET SEQUENCE
-- -----------------------------------------------------
DROP TABLE IF EXISTS movie_genre;
DROP TABLE IF EXISTS outcomes;
DROP TABLE IF EXISTS movie_keyword;
DROP TABLE IF EXISTS movie_company;
DROP TABLE IF EXISTS movie_country;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS directors;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS keywords;
DROP TABLE IF EXISTS genre_temp;
DROP TABLE IF EXISTS genre_long;
DROP TABLE IF EXISTS keyword_long;
DROP TABLE IF EXISTS keyword_temp;
DROP TABLE IF EXISTS extracted_company_data;
DROP TABLE IF EXISTS extracted_country_data;
-- -----------------------------------------------------
-- Creating and selecting the schema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS movies;
USE movies;
-- -----------------------------------------------------
-- Creating the `directors` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS directors (
  director_id INT NOT NULL AUTO_INCREMENT,
  director VARCHAR(500) NULL,
  PRIMARY KEY (director_id));
-- -----------------------------------------------------
-- Creating the `languages` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS languages (
  language_id INT NOT NULL AUTO_INCREMENT,
  language VARCHAR(45) NULL,
  PRIMARY KEY (language_id));
-- -----------------------------------------------------
-- Creating the `movies` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movies (
  movie_id INT NOT NULL,
  title VARCHAR(100) NULL,
  overview LONGTEXT NULL,
  director_id INT NULL,
  director varchar(500) NULL,
  language_id INT NULL,
  language_ varchar(100) NULL,
  runtime FLOAT NULL,
  release_date VARCHAR(50) NULL,
  PRIMARY KEY (movie_id),
  FOREIGN KEY (director_id) REFERENCES directors(director_id),
  FOREIGN KEY (language_id) REFERENCES languages(language_id));
-- -----------------------------------------------------
-- Creating the `genres` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS genres (
  genre_id INT NOT NULL AUTO_INCREMENT,
  genre VARCHAR(45) NULL,
  PRIMARY KEY (genre_id));
-- -----------------------------------------------------
-- Creating the `movie_genre` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_genre (
  movie_id INT NOT NULL,
  genre_id INT NOT NULL,
  PRIMARY KEY (movie_id, genre_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id));
-- -----------------------------------------------------
-- Creating the `outcomes` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS outcomes (
  movie_id INT NOT NULL,
  budget INT NULL,
  revenue INT NULL,
  popularity DOUBLE NULL,
  vote_avg DECIMAL NULL,
  vote_count INT NULL,
  PRIMARY KEY (movie_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id));
-- -----------------------------------------------------
-- Creating the `keywords` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS keywords (
  keyword_id INT NOT NULL AUTO_INCREMENT,
  keyword VARCHAR(45) NULL,
  PRIMARY KEY (keyword_id));
-- -----------------------------------------------------
-- Creating the `movie_keyword` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_keyword (
  movie_id INT NOT NULL,
  keyword_id INT NOT NULL,
  PRIMARY KEY (movie_id, keyword_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (keyword_id) REFERENCES keywords(keyword_id));
-- -----------------------------------------------------
-- Creating the `companies` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS companies (
  company_id INT NOT NULL,
  company VARCHAR(100) NULL,
  PRIMARY KEY (company_id));
-- -----------------------------------------------------
-- Creating the `movie_company` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_company (
  movie_id INT NOT NULL,
  company_id INT NOT NULL,
  PRIMARY KEY (movie_id, company_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (company_id) REFERENCES companies(company_id));
-- -----------------------------------------------------
-- Creating the `countries` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS countries (
  country_id VARCHAR(10) NOT NULL,
  country VARCHAR(100) NULL,
  PRIMARY KEY (country_id));
-- -----------------------------------------------------
-- Creating the `movie_country` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_country (
  movie_id INT NOT NULL,
  country_id VARCHAR(10) NOT NULL,
  PRIMARY KEY (movie_id, country_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (country_id) REFERENCES countries(country_id));
-- -----------------------------------------------------
-- Creating tables to load in cleaned data
-- -----------------------------------------------------
-- data_1
DROP TABLE IF EXISTS data_1;
CREATE TABLE IF NOT EXISTS data_1(
  index_ INT,
  budget INT,
  genres varchar(200),
  keywords varchar(200),
  original_language varchar(200),
  overview longtext,
  popularity double,
  release_date varchar(50),
  revenue INT,
  runtime double,
  title varchar(200),
  vote_average double,
  vote_count int,
  director varchar(200));
-- data_2
DROP TABLE IF EXISTS data_2;
CREATE TABLE IF NOT EXISTS data_2(
   index_ INT,
   production_companies varchar(1000),
   production_countries varchar(1000));
-- -----------------------------------------------------
-- Loading in the data
-- -----------------------------------------------------
-- data_1
SET GLOBAL local_infile = 1;
-- NOTE*** WE PROBABLY WANT TO FIGURE OUT HOW TO MAKE THIS THE RELATIVE PATH INSTEAD OF ABSOLUTE
LOAD DATA LOCAL INFILE 'C:/Users/devon/Documents/GitHub/cs61_final_project_john_devon/data/data_1.csv'
-- LOAD DATA LOCAL INFILE '/Users/johndavanzo/Documents/GitHub/cs61_final_project_john_devon/data/data_1.csv'
INTO TABLE data_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- data_2
LOAD DATA LOCAL INFILE 'C:/Users/devon/Documents/GitHub/cs61_final_project_john_devon/data/data_2.csv'
-- LOAD DATA LOCAL INFILE '/Users/johndavanzo/Documents/GitHub/cs61_final_project_john_devon/data/data_2.csv'
-- LOAD DATA LOCAL INFILE '../data/data_2.csv'
INTO TABLE data_2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- -----------------------------------------------------
-- Filling the 'langauges' table
-- -----------------------------------------------------
INSERT INTO languages (language)
SELECT DISTINCT original_language
FROM data_1;
-- -----------------------------------------------------
-- Filling the 'movies' table
-- -----------------------------------------------------
INSERT INTO movies (movie_id, title, overview, runtime, release_date, director, language_)
SELECT index_, title, overview, runtime, release_date, director, original_language
FROM data_1;
-- -----------------------------------------------------
-- Cleaing up; 'genres' column to lowercase and replacing "science fiction" with "science_fiction"
-- -----------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

UPDATE data_1
SET genres = REPLACE(LOWER(genres), 'science fiction', 'science_fiction');
-- -----------------------------------------------------
-- Filling the 'directors' table
-- -----------------------------------------------------
INSERT INTO directors (director)
SELECT DISTINCT director
FROM data_1
ORDER BY director;
-- -----------------------------------------------------
-- Parsing the genre attribute into long form
-- -----------------------------------------------------
-- Step 1: Create the new table
CREATE TABLE genre_long (
    movie_id INT,
    genres_long VARCHAR(255)
);
-- Step 2: Populate the new table with separate genre records
INSERT INTO genre_long (movie_id, genres_long)
SELECT
    index_,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ' ', n.n), ' ', -1)) AS genres_long
FROM data_1
JOIN (
  SELECT 1 AS n UNION ALL
  SELECT 2 UNION ALL
  SELECT 3 UNION ALL
  SELECT 4 UNION ALL
  SELECT 5 -- Add more numbers as needed
) n
ON CHAR_LENGTH(genres) - CHAR_LENGTH(REPLACE(genres, ' ', '')) >= n.n - 1
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genres, ' ', n.n), ' ', -1)) <> '';
-- -----------------------------------------------------
-- Inserting distinct genres into the 'genre' table
-- -----------------------------------------------------
INSERT INTO genres (genre)
SELECT DISTINCT genres_long
FROM genre_long;
-- -----------------------------------------------------
-- Parsing the keywords attribute into long form
-- -----------------------------------------------------
-- Step 1: Create the new table
CREATE TABLE keyword_long (
    movie_id INT,
    keywords_long VARCHAR(255)
);
-- Step 2: Populate the new table with separate genre records
INSERT INTO keyword_long (movie_id, keywords_long)
SELECT
    index_,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(keywords, ' ', n.n), ' ', -1)) AS keywords_long
FROM data_1
JOIN (
  SELECT 1 AS n UNION ALL
  SELECT 2 UNION ALL
  SELECT 3 UNION ALL
  SELECT 4 UNION ALL
  SELECT 5 -- Add more numbers as needed
) n
ON CHAR_LENGTH(keywords) - CHAR_LENGTH(REPLACE(keywords, ' ', '')) >= n.n - 1
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(keywords, ' ', n.n), ' ', -1)) <> '';
-- -----------------------------------------------------
-- Inserting distinct keywords into the 'keywords' table
-- -----------------------------------------------------
INSERT INTO keywords (keyword)
SELECT DISTINCT keywords_long
FROM keyword_long;
-- -----------------------------------------------------
-- Filling the 'outcomes' table
-- -----------------------------------------------------
INSERT INTO outcomes (movie_id, budget, revenue, popularity, vote_avg, vote_count)
SELECT index_, budget, revenue, popularity, vote_average, vote_count
FROM data_1;
-- -----------------------------------------------------
-- FIlling the 'movie_genre' table
-- -----------------------------------------------------
INSERT INTO movie_genre(movie_id, genre_id)
SELECT movie_id, genre_id
FROM genre_long
JOIN genres ON genre_long.genres_long = genres.genre;
DROP TABLE IF EXISTS genre_long;
-- -----------------------------------------------------
-- FIlling the 'movie_keyword' table
-- -----------------------------------------------------
INSERT INTO movie_keyword(movie_id, keyword_id)
SELECT DISTINCT movie_id, keyword_id
FROM keyword_long
JOIN keywords ON keyword_long.keywords_long = keywords.keyword;
DROP TABLE IF EXISTS keyword_long;
-- -----------------------------------------------------
-- Filling the remaining fields in 'movies' table
-- -----------------------------------------------------
UPDATE movies AS m
JOIN directors AS d ON m.director = d.director
SET m.director_id = d.director_id;

UPDATE movies AS m
JOIN languages AS l ON m.language_ = l.language
SET m.language_id = l.language_id;
-- -----------------------------------------------------
-- Dropping the now unecessary fields from 'movies' table
-- -----------------------------------------------------
ALTER TABLE movies
DROP COLUMN language_;

ALTER TABLE movies
DROP COLUMN director;
-- -----------------------------------------------------
-- Dropping the now unecessary original data
-- -----------------------------------------------------
DROP TABLE IF EXISTS data_1;
-- -----------------------------------------------------
-- Grabbing the company data from the original "json"
-- -----------------------------------------------------
-- Create a new table to store extracted data
CREATE TABLE extracted_company_data (
    movie_id INT,
    company_name VARCHAR(255),
    company_id INT
);
-- Insert extracted data into the new table
INSERT INTO extracted_company_data (movie_id, company_name, company_id)
SELECT
    index_,
    SUBSTRING(
        production_companies,
        position('name": "' IN production_companies) + 8,
        position('"' IN SUBSTRING(production_companies, position('name": "' IN production_companies) + 8)) - 1
    ) AS company_name,
    CAST(
        SUBSTRING(
            production_companies,
            position('"id": ' IN production_companies) + 6,
            position('}' IN SUBSTRING(production_companies, position('"id": ' IN production_companies) + 6)) - 1
        ) AS DOUBLE
    ) AS company_id
FROM data_2;
-- -----------------------------------------------------
-- Grabbing the country data from the original "json"
-- -----------------------------------------------------
-- Create a new table to store extracted data
CREATE TABLE extracted_country_data (
    movie_id INT,
    country_name VARCHAR(255),
    country_id VARCHAR(255)
);
-- Insert extracted data into the new table
INSERT INTO extracted_country_data (movie_id, country_id, country_name)
SELECT
    index_,
    SUBSTRING(
        production_countries,
        position('iso_3166_1": "' IN production_countries) + 14,
        position('"' IN SUBSTRING(production_countries, position('iso_3166_1": "' IN production_countries) + 14)) - 1
    ) AS country_name,
   
        SUBSTRING(
            production_countries,
            position('"name": ' IN production_countries) + 8,
            position('}' IN SUBSTRING(production_countries, position('"name": ' IN production_countries) + 8)) - 1
    ) AS country_id
FROM data_2;
-- -----------------------------------------------------
-- Stripping the country data of quotations
-- -----------------------------------------------------
UPDATE extracted_country_data
SET country_name = SUBSTRING(country_name, 2, LENGTH(country_name) - 2)
WHERE country_name LIKE '"%"';

SET SQL_SAFE_UPDATES = 1;

-- -----------------------------------------------------
-- Filling the 'company' table with the extracted company data
-- -----------------------------------------------------
INSERT INTO companies (company, company_id)
SELECT DISTINCT company_name, company_id
FROM extracted_company_data;
-- -----------------------------------------------------
-- Filling the 'country' table with the extracted country data
-- -----------------------------------------------------
INSERT INTO countries (country, country_id)
SELECT DISTINCT country_name, country_id
FROM extracted_country_data;
-- -----------------------------------------------------
-- Filling the 'movie_company' table
-- -----------------------------------------------------
INSERT INTO movie_company (movie_id, company_id)
SELECT m.movie_id, company_id
FROM movies m 
JOIN extracted_company_data e ON m.movie_id = e.movie_id;
-- -----------------------------------------------------
-- Filling the 'movie_company' table
-- -----------------------------------------------------
INSERT INTO movie_country (movie_id, country_id)
SELECT m.movie_id, e.country_id
FROM movies m 
JOIN extracted_country_data e ON m.movie_id = e.movie_id;
-- -----------------------------------------------------
-- Cleaning up extraneous tables
-- -----------------------------------------------------
DROP TABLE IF EXISTS data_2;
DROP TABLE IF EXISTS extracted_company_data;
DROP TABLE IF EXISTS extracted_country_data;
-- -----------------------------------------------------
-- Database creation complete
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Delete empty data
-- -----------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

DELETE FROM movie_company WHERE company_id = 0;
DELETE FROM companies WHERE company = "";

DELETE FROM movie_country WHERE country_id = "";
DELETE FROM countries WHERE country = "";

SET SQL_SAFE_UPDATES = 1;

