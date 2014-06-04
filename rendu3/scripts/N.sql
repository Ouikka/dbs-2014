-- List the top 10 releases with the most collaborations, i.e., 
-- releases where one artist is performing all songs and the highest 
-- number of different guest artists contribute to the album.

-- for each release with at least 2 artists, counts number of 
-- contributing artists and the number of tracks
WITH releaseinfo AS ( 
SELECT  m.releaseid, 
COUNT ( DISTINCT ( ta.artistid ) )  AS numart,
COUNT ( DISTINCT (t.trackid) ) AS numtrack
FROM track_artist ta, tracks t, mediums m
WHERE ta.trackid = t.trackid AND t.mediumid=m.mediumid
GROUP BY m.releaseid
HAVING numart>1
)

-- displays top 10 of collaborations

SELECT r.*, numart FROM (
-- lists compilations by countTing tracks per artist for each release
-- if an artist contributes to all tracks, then it is a compilation
-- they are then ordered by the number of contributors
SELECT DISTINCT m.releaseid, numart
FROM releaseinfo, mediums m, tracks t, track_artist ta 
WHERE  m.releaseid = releaseinfo.releaseid 
	AND t.mediumid = m.mediumid AND ta.trackid=t.trackid
GROUP BY m.releaseid, ta.artistid
HAVING COUNT ( ta.trackid ) = numtrack
ORDER BY numart DESC
LIMIT 10 ) AS top, releases r

WHERE r.releaseid = top.releaseid
