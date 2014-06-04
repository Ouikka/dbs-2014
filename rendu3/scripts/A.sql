-- Print the names of artists from Switzerland, i.e., 
-- artists whose area is Switzerland.
-- You should not include the names of the artists associated 
-- with individual cantons and towns in Switzerland.

SELECT	arti.name 
FROM  Artists arti, Areas area 
WHERE arti.areaID=area.areaID AND area.name LIKE 'Switzerland'
