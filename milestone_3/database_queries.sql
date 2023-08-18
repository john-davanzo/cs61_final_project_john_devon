-- -----------------------------------------------------
-- Question: Which movie genres are most popular and where?
-- -----------------------------------------------------
SELECT c.country AS country_name, g.genre AS genre_name, AVG(o.popularity) AS average_popularity
FROM outcomes o
JOIN movie_genre mg ON o.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id AND g.genre NOT IN ("tv", "movie")
JOIN movie_country mc ON o.movie_id = mc.movie_id
JOIN countries c ON mc.country_id = c.country_id
WHERE c.country <> ''
GROUP BY g.genre, c.country
ORDER BY c.country, AVG(o.popularity) DESC;

-- -----------------------------------------------------
-- Question: Is there a correlation between budget and popularity? --> Devon answered this one
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Question: Do movies with high spend usually have proportionately higher returns? --> Use same method that Devon used for this one
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Our original query was how did the Covid pandemic impact movie revenue in different countries?
-- However, our data does not contain data on movies released after 2017
-- Instead, we will compare movie revenues in the U.S. directly before and during the 2008 crisis
-- -----------------------------------------------------
-- For the purposes of this analysis, we consider movies released in 2006 and 2007 'pre-recession'
-- and movies released in 2008 as 'during-recession'
-- To avoid issues of the time value of money, we adjust for 1.4% yearly devaluation of the USD

SELECT AVG(revenue) * 1.014 AS average_pre_recession_movie_revenue
FROM movies as m
JOIN movie_country mc ON m.movie_id = mc.movie_id
JOIN outcomes o ON m.movie_id = o.movie_id
WHERE country_id = 'US'
AND release_date BETWEEN '2006-01-01' AND '2008-01-01';

SELECT AVG(revenue) AS average_recession_movie_revenue
FROM movies as m
JOIN movie_country mc ON m.movie_id = mc.movie_id
JOIN outcomes o ON m.movie_id = o.movie_id
WHERE country_id = 'US'
AND release_date BETWEEN '2008-01-01' AND '2009-01-01';








