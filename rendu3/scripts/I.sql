SELECT R.name
FROM Track_artist Ta,Tracks T,Artists A, Recordings R
WHERE a.name="Metallica" and a.artistID=Ta.artistID and T.trackID=Ta.trackID and T.recordingId=R.recordingId
GROUP BY T.recordingID
ORDER BY COUNT(*) DESC
LIMIT 25
 
