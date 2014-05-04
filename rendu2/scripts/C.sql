SELECT	* 
FROM (
	SELECT 	Name 	
	FROM 	Artists arti 
	INNER JOIN (	
			SELECT 	ArtistId
			FROM (	
					SELECT ArtistId  , count(*) numb 
					FROM 	TRACK_ARTIST 
					GROUP BY 	ArtistId
					ORDER BY 	numb DESC )
		 ) artiId 
	ON 		arti.ArtistId = artiId.ArtistId 
	WHERE 	arti.Type = "GROUP"
)
WHERE 	ROWNUM <=10  ;
