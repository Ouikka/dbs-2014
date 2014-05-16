SELECT a.artistID metallicaid, a.name
FROM Artists a, Areas l
WHERE name='Metallica' AND a.areaID=l.areaID AND l.name='United States' 
