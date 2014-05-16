SELECT l.name, a.name, COUNT(type='Group') FROM (
SELECT l.name, a.artistID, a.name, a.type, COUNT(*) c
FROM (SELECT l.name, a.artistID, a.name, a.type, COUNT(*) ac
FROM Areas l, Artists a
WHERE l.areaID = a.areaID
GROUP BY a.areaID) a , Track_artist ta
WHERE ac>=20 AND a.artistID = ta.artistID
GROUP BY a.artistID )n
