-- List the names of 10 groups with the most releases.
SELECT 	name 
FROM 	Artists arti 
INNER JOIN (	
		SELECT 		ArtistId, COUNT(DISTINCT releaseId) num 
		FROM 		track_artist trackarti 
		INNER JOIN (	
				SELECT 	*  
				FROM 	Tracks track 
				INNER JOIN (	
						SELECT 		mediums.mediumid, mediums.releaseid 
						FROM 		Mediums 
						INNER JOIN 	Releases 
						ON 			mediums.releaseid = releases.releaseid			
					 ) medi 
				ON 	track.mediumid = medi.medium	
			 ) track 
		ON 		trackarti.trackid = track.trackid 
		GROUP BY 	ArtistId  
		ORDER BY 	num DESC
	 ) artiId 
ON 		arti.ArtistId = artiId.ArtistId 
WHERE 	ROWNUM <=10  ;
