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
					WHERE 	ROWNUM <=1 
	)  
	) toparea
	ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname
;  
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
					WHERE 	ROWNUM <=1 
	)  
	) toparea
	ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname
;  
-- Area with the most female Groups
Select  artistarea.areaname, artistarea.Type, count(*) "number" from
	(Select * from Artists arti INNER JOIN (
	SELECT 	Area.name areaname, area.areaId 
	FROM 	Areas area 
	WHERE 	area.areaid = (	
					SELECT 	AreaId areafemale 
					FROM ( 	
						SELECT 	AreaId , count(*) c 
						FROM 	Artists  
						WHERE 	(gender = 'Female') and (type = 'Group')
						GROUP BY 	AreaId 
						ORDER BY 	c DESC
					)  
					WHERE 	ROWNUM <=1 
	)  
	) toparea
	ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname
;  
