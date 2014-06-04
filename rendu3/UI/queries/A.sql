SELECT  arti.name 
FROM  Artists arti, Areas area 
WHERE arti.areaID=area.areaID AND area.name LIKE 'Switzerland'
