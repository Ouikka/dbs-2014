SELECT medi.albumid, count(DISTINCT track.trackid)  
FROM Tracks track 
INNER JOIN  (	SELECT mediums.mediumid ,mediums.albumid 
				FROM Mediums 
				INNER JOIN Albums ON mediums.albumid = albums.albumid   ) medi 
ON track.mediumid = medi.mediumid 
GROUP BY medi.albumid ;
