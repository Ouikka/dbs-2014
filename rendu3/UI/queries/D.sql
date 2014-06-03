SELECT a.artistID, a.name "group name", count(DISTINCT m.releaseID) "release count"
FROM Artists a, Track_artist ta, Tracks t, Mediums m
WHERE a.type="Group" AND a.artistID=ta.artistID AND t.trackID = ta.trackID AND m.mediumID=t.mediumID
GROUP BY a.artistID
ORDER BY "release count" DESC
LIMIT 10
