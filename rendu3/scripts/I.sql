-- American metal group Metallica is asking its fans to choose the 
-- setlist for its upcoming concert in Switzerland. 
-- Assuming that the Metallica fans will choose the songs 
-- that have appeared on the highest
-- number of mediums, list the top 25 songs.

SELECT R.*
FROM Track_artist ta,Tracks t, Artists a, Recordings r
WHERE a.name="Metallica" AND a.artistID=ta.artistID 
AND t.trackID=ta.trackID AND t.recordingId=r.recordingId
GROUP BY t.recordingID
ORDER BY COUNT(DISTINCT t.mediumid) DESC
LIMIT 25
 

