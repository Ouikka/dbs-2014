-- List the top 10 releases with the most collaborations, i.e., releases where one artist is performing all
-- songs and the highest number of different guest artists contribute to the album.

Select * 
	  FROM (
	  -- Filter the compilation (where an artist is credited for ALL the tracks of the release), then order them by number of guests
	  Select DISTINCT ReleaseId, guestsnumbers
	  FROM (
		    Select DISTINCT ReleaseId, tra.trackId, ArtistId , trackperRelease , tracksperArtist, guestsnumbers
		    From (
			-- Used to Return the number of distincts tracks per release, useful to determine if an artists is credited for all the tracks
			Select ReleaseId, TrackId, COUNT(DISTINCT trackId) OVER ( PARTITION BY mediums.releaseId  ) trackperRelease    
		    	From Tracks , Mediums
		   	 where tracks.mediumId = mediums.mediumId) trrl , 
		    -- Used to return, for each tuple release/artist the number of tracks in wich this artist is credited
		    -- Return also the number of differents artists credited in each release
		    (Select DISTINCT med.releaseId rlId , tr.trackId , trart.artistId , 
		    COUNT(DISTINCT tr.trackId) OVER ( PARTITION BY med.releaseId, trart.artistId  ) tracksperArtist ,  
		    COUNT(DISTINCT trart.artistId) OVER ( PARTITION BY med.releaseId) guestsnumbers
		    from mediums med, releases rel , tracks tr , Track_Artist trart 
		    where med.releaseId = rel.releaseId AND med.mediumId = tr.mediumId AND  tr.trackId = trart.trackId
		    ORDER by med.releaseId, trart.artistId DESC ) tra
		    
		    where trrl.releaseId = tra.rlId
		    )
	   Where tracksperArtist = trackperRelease
	   ORDER BY guestsnumbers DESC )
where ROWNUM <= 10

