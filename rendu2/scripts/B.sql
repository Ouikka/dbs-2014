SELECT area.name 
FROM Areas area 
WHERE area.areaid = (	SELECT AreaId areafemale 
						FROM ( 	SELECT AreaId , count(*) c 
								FROM Artists  
								WHERE (gender = 'Male') 
								GROUP BY AreaId 
								ORDER BY c DESC 				)  
						WHERE ROWNUM <=1 							) ;  

