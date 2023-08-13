# COSC 61 Final Project - Movie Analysis Database Build Plan
Below are the details of how we imported and prepared our data as well as how we built our database.

## Pre Importation
Before importing the data to MySQL workbench, we filtered out fields from the original dataset that we did not plan on using in our database for the sake of simplicity. We also decomposed the data into two files, `data_1` and `data_2`. `data_1` contained the general attributes (`index`, `budget`, `keywords`, `original_language`, `overview`, `popularity`, `release_data`, `revenue`, `runtime`, `title`, `vote_average`, `vote_count`, `director`) while `data_2` contained only the fields in json format (`production_companies`, `production_countries`) in addition to `index`, allowing for more careful and nuanced inspection and decomposition of the json text.

## Import Method
We were unable to utilize the Table Import Wizard built into MySQLWorkbench because of the inconsistent nature of the formatting of our original data. Instead, we manually set the parameters for inport using the `LOAD DATA LOCAL INFILE` command in SQL. 
## Import Code
The general syntax for how we loaded our data is as follows:
```
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'pathname/data_file.csv'
INTO TABLE table_to_load_data_into
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```
## Decomposition After Importation
* Handling JSON text in `production_companies` and `production_countries` fields
    * Given the inconsistent nature of the JSON text, we decided to write a script to decompose the JSON text as a varchar object. The general syntax for the script we wrote is as follows:

    ```
    CREATE TABLE extracted_data (
    movie_id INT,
    variable_name VARCHAR(255),
    variable_id INT
    );

    INSERT INTO extracted_data (movie_id, variable_name, variable_id)
    SELECT index_,
    SUBSTRING(
        original_attribute,
        position('name": "' IN original_attribute) + 8,
        position('"' IN SUBSTRING(original_attribute, position('name": "' IN original_attribue) + 8)) - 1
    ) AS variable_name,
    CAST(
        SUBSTRING(
            original_attribute,
            position('"id": ' IN original_attribute) + 6,
            position('}' IN SUBSTRING(original_attribute, position('"id": ' IN original_attribute) + 6)) - 1
        ) AS DOUBLE
    ) AS variable_id
    FROM data_2;
    ```
* Handling multi-valued varchar attributes in `keywords` and `genres` fields
    * The `keywords` and `genres` fields were multivalued varchar attributes, where each was listed in each record as a series of keywords and genres separated by spaces. This necessitated a script to parse each of the fields and convert them into long form. The general syntax for the script we wrote is as follows:
    ```
    CREATE TABLE keyword_long (
    movie_id INT,
    variable_long VARCHAR(255)
    );
    -- Step 2: Populate the new table with separate genre records
    INSERT INTO variable_long (movie_id, variables_long)
    SELECT
        index_,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(variables, ' ', n.n), ' ', -1)) AS variables_long
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
    ```

## General Cleaning
*  Cleaned the `genres` field so that 'science fiction' is read as 'science_fiction' rather than 'science' and 'fiction'
* Removed the quotaiton marks from the `country_name` field


