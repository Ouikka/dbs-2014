-- List all cities which have more female than male artists.

SELECT name FROM (
SELECT l.name, 
COUNT(CASE WHEN a.gender = 'Female' THEN 1 
	WHEN a.gender = 'Male' THEN -1 END) maj
FROM Areas l, Artists a
WHERE l.areaID=a.areaID AND a.type <> 'Group' AND l.type='City'
GROUP BY l.areaID
) WHERE maj>0 -- majority of female artists
