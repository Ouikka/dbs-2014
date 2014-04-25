SELECT a.name
FROM artists a, areas l
WHERE a.areaID=l.areaID AND l.name='Switzerland' ;

SELECT a.type, l.name, 
FROM Areas l, Artists a
GROUP BY a.areaID
