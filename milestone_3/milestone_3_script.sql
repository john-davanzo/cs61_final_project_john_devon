-- RESET SEQUENCE
DROP TABLE movie_genre;
DROP TABLE outcomes;
DROP TABLE movie_keyword;
DROP TABLE movie_company;
DROP TABLE movie_country;
DROP TABLE movies;
DROP TABLE languages;
DROP TABLE genres;


-- Creating the schema and tables...


CREATE SCHEMA IF NOT EXISTS movies;
USE movies;

-- -----------------------------------------------------
-- `directors` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS directors (
  director_id INT NOT NULL AUTO_INCREMENT,
  director VARCHAR(45) NULL,
  PRIMARY KEY (director_id));


-- -----------------------------------------------------
-- `languages` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS languages (
  language_id INT NOT NULL AUTO_INCREMENT,
  language VARCHAR(45) NULL,
  PRIMARY KEY (language_id));


-- -----------------------------------------------------
-- `movies` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movies (
  movie_id INT NOT NULL,
  title VARCHAR(100) NULL,
  overview LONGTEXT NULL,
  director_id INT NULL,
  language_id INT NULL,
  runtime FLOAT NULL,
  release_date VARCHAR(50) NULL,
  PRIMARY KEY (movie_id),
  FOREIGN KEY (director_id) REFERENCES directors(director_id),
  FOREIGN KEY (language_id) REFERENCES languages(language_id));


-- -----------------------------------------------------
-- `genres` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS genres (
  genre_id INT NOT NULL AUTO_INCREMENT,
  genre VARCHAR(45) NULL,
  PRIMARY KEY (genre_id));


-- -----------------------------------------------------
-- `movie_genre` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_genre (
  movie_id INT NOT NULL,
  genre_id INT NOT NULL,
  PRIMARY KEY (movie_id, genre_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id));


-- -----------------------------------------------------
-- `outcomes` table
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
-- `keywords` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS keywords (
  keyword_id INT NOT NULL AUTO_INCREMENT,
  keyword VARCHAR(45) NULL,
  PRIMARY KEY (keyword_id));


-- -----------------------------------------------------
-- `movie_keyword` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_keyword (
  movie_id INT NOT NULL,
  keyword_id INT NOT NULL,
  PRIMARY KEY (movie_id, keyword_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (keyword_id) REFERENCES keywords(keyword_id));


-- -----------------------------------------------------
-- `companies` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS companies (
  company_id INT NOT NULL,
  company VARCHAR(100) NULL,
  PRIMARY KEY (company_id));


-- -----------------------------------------------------
-- `movie_company` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_company (
  movie_id INT NOT NULL,
  company_id INT NOT NULL,
  PRIMARY KEY (movie_id, company_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (company_id) REFERENCES companies(company_id));


-- -----------------------------------------------------
-- `countries` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS countries (
  country_id VARCHAR(10) NOT NULL,
  country VARCHAR(100) NULL,
  PRIMARY KEY (country_id));


-- -----------------------------------------------------
-- `movie_country` table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS movie_country (
  movie_id INT NOT NULL,
  country_id VARCHAR(10) NOT NULL,
  PRIMARY KEY (movie_id, country_id),
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (country_id) REFERENCES countries(country_id));
  
  
SET GLOBAL local_infile = 1;



DROP TABLE data_1;
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
  
LOAD DATA LOCAL INFILE '/Users/johndavanzo/Documents/GitHub/cs61_final_project_john_devon/data/data_final/data_1.csv'
INTO TABLE data_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- DROP TABLE data_2;
CREATE TABLE IF NOT EXISTS data_2(
  index_ INT,
  production_companies JSON,
  production_countries JSON);
  
LOAD DATA LOCAL INFILE '/Users/johndavanzo/Documents/GitHub/cs61_final_project_john_devon/data/data_final/Sheet 2-Table 1.csv'
INTO TABLE data_2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


INSERT INTO languages (language)
SELECT DISTINCT original_language
FROM data_1;

INSERT INTO directors (director)
SELECT DISTINCT director
FROM data_1;

INSERT INTO movies (movie_id, title, overview, runtime, release_date)
SELECT index_, title, overview, runtime, release_date
FROM data_1;

-- Update 'genres' column to lowercase and replace "science fiction" with "science_fiction"
UPDATE data_1
SET genres = REPLACE(LOWER(genres), 'science fiction', 'science_fiction');


DROP TABLE genres;
DROP TABLE movie_genre;


-- Insert distinct genres into the 'genres' table
INSERT INTO genres (genre)
SELECT DISTINCT SUBSTRING_INDEX(SUBSTRING_INDEX(m.genres, ' ', n.n), ' ', -1) AS genre
FROM data_1 m
JOIN (
  SELECT 1 AS n UNION ALL
  SELECT 2 UNION ALL
  SELECT 3 UNION ALL
  SELECT 4 UNION ALL
  SELECT 5 -- Add more numbers as needed
) n
ON CHAR_LENGTH(m.genres)
    -CHAR_LENGTH(REPLACE(m.genres, ' ', '')) >= n.n - 1
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(m.genres, ' ', n.n), ' ', -1)) <> ''
ORDER BY genre;



-- Insert distinct keywords into the 'keywords' table
INSERT INTO keywords (keyword)
SELECT DISTINCT SUBSTRING_INDEX(SUBSTRING_INDEX(m.keywords, ' ', n.n), ' ', -1) AS keyword
FROM data_1 m
JOIN (
  SELECT 1 AS n UNION ALL
  SELECT 2 UNION ALL
  SELECT 3 UNION ALL
  SELECT 4 UNION ALL
  SELECT 5 -- Add more numbers as needed
) n
ON CHAR_LENGTH(m.keywords)
    -CHAR_LENGTH(REPLACE(m.keywords, ' ', '')) >= n.n - 1
WHERE TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(m.keywords, ' ', n.n), ' ', -1)) <> ''
ORDER BY keyword;











