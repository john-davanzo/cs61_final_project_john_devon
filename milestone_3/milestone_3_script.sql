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
  release_date DATE NULL,
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

CREATE TABLE IF NOT EXISTS original_movie_data(
  movie_id INT NOT NULL);


LOAD DATA LOCAL INFILE './data.csv'
INTO TABLE original_movie_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

