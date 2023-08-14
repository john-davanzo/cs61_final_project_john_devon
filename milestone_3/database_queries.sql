-- -----------------------------------------------------
-- Query: Which movie genres are most popular?
-- -----------------------------------------------------
SELECT genre, AVG(popularity) AS average_popularity
FROM outcomes o
JOIN movie_genre mg ON o.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id and g.genre not in ("tv", "movie")
GROUP BY genre
ORDER BY AVG(popularity) DESC;


