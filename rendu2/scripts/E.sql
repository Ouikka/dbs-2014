-- Print the name of a female artist associated with the most genres.
SELECT	name 
FROM 	Artists arti 
INNER JOIN (	
		SELECT 		arti.ArtistID, COUNT(DISTINCT genre.GenreID) numb 
		FROM 		Artists arti  
		INNER JOIN 	Artist_Genre genre 
		ON 			arti.ArtistID = genre.ArtistID
		WHERE 		arti.Gender = 'Female' 
		GROUP BY 		arti.ArtistId 
		ORDER BY		numb DESC
	) artigenre 
ON 		arti.artistid = artigenre.artistid 
WHERE 	ROWNUM <=1  ;
