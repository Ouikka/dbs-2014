-- List all genre with no female artist, all genre that have no males artists and all genres that have no groups
--- <=> List all genre with no female artist OR no male artists OR no groups (?)


SELECT * 
FROM Genres g 
WHERE g.genreId NOT IN (
	SELECT GenreId FROM (
		SELECT  GenreId, 
			count(CASE WHEN arty.gender = 'Female' THEN 1 END) AS females, 
			count(CASE WHEN arty.gender = 'Male' THEN 1 END) AS males, 
		        count(CASE WHEN arty.type = 'Group' THEN 1 END) AS grps 
		FROM Artist_Genre 
		INNER JOIN Artists arty 
		ON  Artist_Genre.ArtistId = arty.ArtistId  
		GROUP BY GenreId ) 
	WHERE males > 0 AND females > 0 AND grps > 0)
