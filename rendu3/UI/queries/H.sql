SELECT artistID FROM (
SELECT areaID FROM (
SELECT areaID, COUNT(*) ac
FROM Artists 
GROUP BY areaID )
WHERE ac >= 30 JOIN

