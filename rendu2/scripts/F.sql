SELECT AreaId 
FROM  (	SELECT city.areaid, count(CASE WHEN arti.gender = 'Female' THEN 1 END) AS females, count(CASE WHEN arti.gender = 'Male' THEN 1 END) AS males  
		FROM Artists arti  
		INNER JOIN Areas city 
		ON city.areaid = arti.areaId   
		WHERE city.type = 'City' 
		GROUP BY city.areaId ) areamalefemale 
WHERE areamalefemale.Females > areamalefemale.Males