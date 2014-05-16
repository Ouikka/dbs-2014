SELECT name "Area name" FROM (
SELECT l.name, count(CASE WHEN a.gender = 'Female' THEN 1 
			WHEN a.gender = 'Male' THEN -1 END) c
FROM Areas l, Artists a
WHERE  l.areaID=a.areaID
GROUP BY l.areaID
) WHERE c>0
