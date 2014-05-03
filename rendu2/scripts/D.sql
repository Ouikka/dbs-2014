SELECT name 
FROM Artists arti 
INNER JOIN  (	SELECT ArtistId, COUNT(DISTINCT AlbumId) num 
				FROM track_artist trackarti 
				INNER JOIN  (	SELECT *  
								FROM Tracks track 
								INNER JOIN  (	SELECT mediums.mediumid, mediums.albumid 
												FROM Mediums 
												INNER JOIN Albums 
												ON mediums.albumid = albums.albumid			) medi 
								ON track.mediumid = medi.mediumid								) track 
				ON trackarti.trackid = track.trackid 
				GROUP BY ArtistId  
				ORDER BY num DESC																	) artiId 
ON arti.ArtistId = artiId.ArtistId 
WHERE ROWNUM <=10  ;
