SELECT a.artistID, a.name, count(*) count
FROM Artists a, Track_artist t
WHERE a.type='Group' AND a.artistID=t.artistID
GROUP BY a.artistID
ORDER BY count DESC
LIMIT 10
