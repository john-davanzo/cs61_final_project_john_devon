-- -----------------------------------------------------
-- Question: Which movie genres are most popular and where?
-- -----------------------------------------------------

SELECT c.country AS country_name, g.genre AS genre_name, AVG(o.popularity) AS average_popularity
FROM outcomes o
JOIN movie_genre mg ON o.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id AND g.genre NOT IN ("tv", "movie")
JOIN movie_country mc ON o.movie_id = mc.movie_id
JOIN countries c ON mc.country_id = c.country_id
GROUP BY g.genre, c.country
HAVING AVG(o.popularity) = (
    SELECT MAX(avg_pop)
    FROM (
        SELECT AVG(o2.popularity) AS avg_pop
        FROM outcomes o2
        JOIN movie_genre mg2 ON o2.movie_id = mg2.movie_id
        JOIN genres g2 ON mg2.genre_id = g2.genre_id AND g2.genre NOT IN ("tv", "movie")
        JOIN movie_country mc2 ON o2.movie_id = mc2.movie_id
        JOIN countries c2 ON mc2.country_id = c2.country_id
        WHERE c2.country = c.country
        GROUP BY g2.genre
    ) AS subquery
)
ORDER BY c.country;

-- -----------------------------------------------------
-- Question: Is there a correlation between budget and popularity?
-- -----------------------------------------------------

SELECT budget, popularity
FROM outcomes
where budget != 0;

-- -----------------------------------------------------
-- Question: Do movies with high spend usually have proportionately higher returns?
-- -----------------------------------------------------

SELECT budget, revenue
FROM outcomes
where budget != 0 and revenue != 0;

-- -----------------------------------------------------
-- Question: How did the Great Recession affect movie revenue in the United States?
-- -----------------------------------------------------

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