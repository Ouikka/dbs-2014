SELECT  g.genreid, g.name, g.count
FROM Genres g, Artist_Genre ag, artists a 
WHERE g.genreid = ag.genreid AND ag.artistid=a.artistid
GROUP BY g.GenreId
HAVING (count(CASE WHEN a.gender = 'Female' THEN 1 END)=0) OR (count(CASE WHEN a.gender = 'Male' THEN 1 END)=0) OR (count(CASE WHEN a.type = 'Group' THEN 1 END)=0)

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
