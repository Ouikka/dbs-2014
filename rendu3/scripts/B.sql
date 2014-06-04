-- Print the names of areas with the highest number male artists, 
-- female artists and groups. 
-- For each of these 3 areas, print the number of artists of 
-- each of the three types in the area.

-- counts the number of male, female artists and groups in all areas
WITH counts AS (
SELECT a.areaid, 
count(CASE WHEN a.gender = 'Female' AND a.type <> 'Group' THEN 1 END) AS femnum,
count(CASE WHEN a.gender = 'Male' AND a.type <> 'Group' THEN 1 END) AS malnum,
count(CASE WHEN a.type = 'Group' THEN 1 END) AS grpnum
FROM Artists a
GROUP BY a.areaid )

-- Area with the most female artists
SELECT 'Female' AS areaType, l.*, max ( counts.femnum ) , counts.malnum, counts.grpnum 
FROM counts, Areas l
WHERE counts.areaid = l.areaid

UNION

-- Area with the most male artists
SELECT 'Male' AS areaType, l.*, counts.femnum , max ( counts.malnum ), counts.grpnum 
FROM counts, Areas l
WHERE counts.areaid = l.areaid

UNION

-- Area with the most groups
SELECT 'Group'AS areaType, l.*, counts.femnum , counts.malnum , max ( counts.grpnum )
FROM counts, Areas l
WHERE counts.areaid = l.areaid
