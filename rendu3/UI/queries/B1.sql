SELECT fem.name, fem.c fc, mal.c mc, grp.c gc
FROM (
SELECT l.areaID , l.name, COUNT(*) c
FROM Areas l INNER JOIN Artists a ON a.areaID=l.areaID
WHERE a.type<>'Group' AND a.gender='Female') fem, (
SELECT l.areaID , COUNT(*) c
FROM Areas l INNER JOIN Artists a ON a.areaID=l.areaID
WHERE a.type<>'Group' AND a.gender='Male') mal,
(SELECT l.areaID , count(*) c
FROM Areas l INNER JOIN Artists a ON a.areaID=l.areaID
WHERE a.type='Group'
GROUP BY l.areaID, a.type ) grp
WHERE fem.areaID = mal.areaID AND fem.areaID=grp.areaID 
