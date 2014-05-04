SELECT 	arti.name
FROM 	artists arti, areas area
WHERE 	arti.areaID=area.areaID AND area.name='Switzerland' ;
