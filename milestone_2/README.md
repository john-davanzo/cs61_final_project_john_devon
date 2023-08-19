# Project Milestone 2 - Movie Analysis Database Build Plan
Below are the details of how we plan to implement our databse design in accordance with our preliminary ERD.

## Main Data

Our plan to import the data is to import the main CSV found on our project site to Workbench using the Import Wizard. 

## General Table Construction

Using the ERD feature on MySQLWorkbench we have already generated the following tables:


`movies`, `outcomes`, `directors`, `movie_keyword`, `keywords`, `movie_genre`, `genres`, `movie_company`, `companies`, `movie_country`, `countries`, `languages`

![](data/initial_erd.png)

[Link to mwb file](data/initial_erd.mwb)

## Specific Table Construction

Then, each of the tables will be constructed using the `ALTER TABLE` command to add each of the attributes. Then we will use the `INSERT INTO` command to insert values into the tables from the main movies table. Certain of the tables will require extra parsing/data cleaning to create, like the countries and companies tables. 

### `movies` table

* `movie_id` is an existing variable in the table that we will grab from the original CSV.
* `title` is an existing variable in the table that we will grab from the original CSV.
* `overview` is an existing variable in the table that we will grab from the original CSV.
* `director_id` is a foreign key which references the `directors` table.
* `language_id` is a foreign key which references the `languages` table.
* `runtime` is an existing variable in the table that we will grab from the original CSV.
* `release_date` is an existing variable in the table that we will grab from the original CSV.

### `outcomes` table

* `movie_id` is a foreign key which references the ‘movies’ table.
* `budget` is an existing variable in the table that we will grab from the original CSV.
* `revenue` is an existing variable in the table that we will grab from the original CSV.
* `popularity` is an existing variable in the table that we will grab from the original CSV.
* `vote_average` is an existing variable in the table that we will grab from the original CSV.
* `vote_count` is an existing variable in the table that we will grab from the original CSV.

### `directors` table

* `director_id` is generated with auto increment. Each director will automatically be assigned an id.
* `director` is a variable from the existing table that we will grab from the original CSV. We will use the `DISTINCT` keyword to avoid duplicate records for directors who may have been involved in more than one movie in the database.

### `movie_keyword` table

* `movie_id`  is a foreign key which references the `movies` table.
* `keyword_id` is a foreign key which references the `keywords` table.

### `keywords` table

* `keyword_id` is generated with auto increment. Each keyword will automatically be assigned an id.
* `keyword` is an attribute present in the original data. In the original data, keywords are listed one after another, separated by spaces. We plan to split the text by spaces to generate a list of keywords, and then put `DISTINCT` keywords into this table.

### `movie_genre` table

* `movie_id`  is a foreign key which references the `movies` table.
* `genre_id` is a foreign key which references the `genres` table.

### `genres` table

* `genre_id` is generated with auto increment. Each genre will automatically be assigned an id.
* `genre` is an attribute present in the original data. In the original data, genres are listed one after another, separated by spaces. We plan to split the text by spaces to generate a list of genres, and then place each `DISTINCT` genre in this table

#### NOTE:
The two fields `production_companies` and `production_countries` from the original movies table contain JSON text, which we will need to parse to create the `movie_company`, `companies`, `movie_country`, and `countries` tables. These fields contain ids for the `companies` and `countries`, as well as their names.

### `movie_company` table

* `movie_id` is a foreign key which references the `movies` table.
* `company_id` is a foreign key which references the `companies` table.


### `companies` table

* `company_id` is a foreign key which references the `companies` table. It will be grabbed from the `production_company` field in the original CSV.
* `company` is the name of the company, grabbed from the `production_company` field in the original CSV.


### `movie_country` table

* `movie_id` is a foreign key which references the `movies` table.
* `country_id` is a foreign key which references the `countries` table.

### `countries` table

* `country_id` is the primary key grabbed from the `production_company` field in the original CSV.
* `country` is the name of the country and is also grabbed from `production_company` field in the original CSV.

### `languages` table

* `language_id` is created through auto-increment when languages are inserted.
* `language` is the name of the language.
