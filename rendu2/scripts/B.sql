-- Print the names of areas with the highest number male artists, 
-- female artists and groups. 
-- For each of these 3 areas, print the number of artists of 
-- each of the three types in the area.
SELECT 	area.name 
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
) ;  

