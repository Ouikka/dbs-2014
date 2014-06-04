SELECT a.name
FROM artists a, areas l
WHERE a.areaID=l.areaID AND l.name='Switzerland' ;

SELECT a.type, l.name, 
FROM Areas l, Artists a
GROUP BY a.areaID

# B

-- Print the names of areas with the highest number male artists, 
-- female artists and groups. 
-- For each of these 3 areas, print the number of artists of 
-- each of the three types in the area.

-- Area with the most male Artists
Select  artistarea.areaname, artistarea.Type, count(*) "number" from
	(Select * from Artists arti INNER JOIN (
	SELECT 	Area.name areaname, area.areaId 
	FROM 	Areas area 
	WHERE 	area.areaid = (	
					SELECT 	AreaId areafemale 
					FROM ( 	
						SELECT 	AreaId , count(*) c 
						FROM 	Artists  
						WHERE 	(gender = 'Male') 
						GROUP BY 	AreaId 
						ORDER BY 	c DESC
					)  
					LIMIT 1
	)  
	) toparea
	ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname
UNION
-- Area with the most female  Artists
Select  artistarea.areaname, artistarea.Type, count(*) "number" from
	(Select * from Artists arti INNER JOIN (
	SELECT 	Area.name areaname, area.areaId 
	FROM 	Areas area 
	WHERE 	area.areaid = (	
					SELECT 	AreaId areafemale 
					FROM ( 	
						SELECT 	AreaId , count(*) c 
						FROM 	Artists  
						WHERE 	(gender = 'Female') 
						GROUP BY 	AreaId 
						ORDER BY 	c DESC
					)  
					LIMIT 1
	)  
	) toparea
	ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname
UNION
-- Area with the most female Groups
Select  artistarea.areaname, artistarea.Type, count(*) "number" from
	(Select * from Artists arti INNER JOIN (
	SELECT 	Area.name areaname, area.areaId 
	FROM 	Areas area 
	WHERE 	area.areaid = (	
					SELECT 	AreaId areafemale, max(c) 
					FROM ( 	
						SELECT 	AreaId , count(*) c 
						FROM 	Artists  
						WHERE 	(gender = 'Female') and (type = 'Group')
						GROUP BY 	AreaId 
					)  
 
	)  
	) toparea
	ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname
;  


### N

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
