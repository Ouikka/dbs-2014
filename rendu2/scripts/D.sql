SELECT * 
FROM
(
SELECT 	arti.name 
FROM 	Artists arti 
INNER JOIN (	
		SELECT 		ArtistId, COUNT(DISTINCT AlbumID) num 
		FROM 		Track_Artist trackarti 
		INNER JOIN (	
				SELECT 	*  
				FROM 	Tracks track 
				INNER JOIN (	
						SELECT 		mediums.MediumId, Mediums.AlbumID 
						FROM 		Mediums mediums
						INNER JOIN 	Albums albums
						ON 			mediums.AlbumID = albums.AlbumID
					 ) media 
				ON 	track.MediumID = media.Medium
			 ) track 
		ON 		trackarti.TrackID = track.TrackID 
		GROUP BY 	ArtistID
		ORDER BY 	num DESC
	 ) artiId 
ON 		arti.ArtistId = artiId.ArtistId 
WHERE 	arti.Type = "Group"
)
WHERE 	ROWNUM <=10  ;
