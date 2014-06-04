-- List the release which is associated with the most mediums. 
-- If there are more than one such release, list all such releases.
-- Problem with max in oracle, need to be combined with a GROUP BY

-- find max number of mediums for a release
WITH max AS (
SELECT COUNT(*) c
FROM mediums
GROUP BY releaseid
ORDER BY c DESC
LIMIT 1 ) 

-- selects all releases with max number of mediums
SELECT r.*, COUNT(distinct m.mediumid) as nummedium
FROM releases r, mediums m, max
WHERE r.releaseid=m.releaseid
GROUP BY r.releaseid
HAVING nummedium = max.c
