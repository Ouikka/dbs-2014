-- List the top 10 artists according to their track-to-release ratio. This ratio is computed by dividing the number of tracks an artist is associated with by the number of releases this artist has contributed a track to.


Select ArtistId
From (
	  Select ArtistId , tracknumber/releasenumber ratio
	  FROM (
	    Select DISTINCT ArtistId , COUNT(DISTINCT tra.TrackId) OVER ( PARTITION BY ArtistId  ) tracknumber ,  
            COUNT(DISTINCT rel.releaseId) OVER ( PARTITION BY ArtistId  ) releasenumber
	    From Track_Artist tra , Tracks tr,  Mediums med, Releases rel
	    where tra.trackId = tr.trackId AND tr.mediumId = med.mediumId AND rel.releaseId = med.releaseId
	    )
	  ORDER BY ratio DESC
) 
where ROWNUM <= 10
