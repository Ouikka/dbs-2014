-- List the names of 10 groups with the most recorded tracks.

SELECT a.name
FROM Artists a, Track_artist t
WHERE a.type='Group' AND a.artistID=t.artistID
GROUP BY a.artistID
ORDER BY count(*) DESC
LIMIT 10
