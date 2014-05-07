SELECT 	AreaId 
FROM (	
	SELECT 		city.AreaID, 
				count(CASE WHEN arti.Gender = 'Female' THEN 1 END) AS Females, 
				count(CASE WHEN arti.Gender = 'Male' THEN 1 END) AS Males  
	FROM 		Artists arti  
	INNER JOIN	Areas city 
	ON 			city.AreaID = arti.AreaID   
	WHERE 		city.Type = 'City' 
	GROUP BY 		city.AreaID 
) areamalefemale 
WHERE 	areamalefemale.Females > areamalefemale.Males
