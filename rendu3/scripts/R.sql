-- List the top 10 artists according to their track-to-release ratio. 
-- This ratio is computed by dividing the number of tracks an artist is associated 
-- with by the number of releases this artist has contributed a track to.

SELECT a.*, count(DISTINCT t.trackid)/count(DISTINCT r.releaseid) AS ratio
FROM artists a, track_artist ta, tracks t, mediums m, releases r
WHERE a.artistid=ta.artistid AND ta.trackid=t.trackid 
	AND t.mediumid=m.mediumid AND m.releaseid=r.releaseid
GROUP BY a.artistid
ORDER BY ratio DESC
LIMIT 10
