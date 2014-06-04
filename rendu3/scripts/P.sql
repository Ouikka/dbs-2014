-- List the most popular genre among the groups wich are associated with at least 3 genres

SELECT Genres.genreId, Genres.name 
FROM Genres 
	INNER JOIN (
		SELECT GenreId, COUNT(*) genreCOUNTer 
		FROM Artist_Genre artigenre 
		INNER JOIN (
			SELECT ArtistId 
			FROM (
				SELECT arti.ArtistId, COUNT(*) numbgenre 
				FROM Artist_genre 
				INNER JOIN (
					SELECT artistId 
					FROM Artists 
					WHERE type = 'Group') arti 
				ON Artist_genre.artistId = arti.artistId  
				GROUP BY arti.ArtistId) artistgenreCOUNT  
			WHERE numbgenre > 2 ) artithree 
		ON artithree.artistId = artigenre.artistId 
		GROUP BY GenreId 
		ORDER BY genreCOUNTer Desc) genreordered 
	ON genreordered.genreid = Genres.genreId 
LIMIT 1
