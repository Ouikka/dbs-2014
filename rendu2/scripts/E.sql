-- Print the name of a female artist associated with the most genres.
SELECT	name 
FROM 	Artists arti 
INNER JOIN (	
		SELECT 		arti.artistid, COUNT(DISTINCT genre.genreid) numb 
		FROM 		Artists arti  
		INNER JOIN 	Artist_Genre genre 
		ON 			arti.artistId = genre.artistId   
		WHERE 		arti.gender = 'Female' 
		GROUP BY 		arti.ArtistId 
		ORDER BY		numb DESC
	) artigenre 
ON 		arti.artistid = artigenre.artistid 
WHERE 	ROWNUM <=1  ;
