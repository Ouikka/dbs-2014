SELECT R.name
FROM Recordings R 
INNER JOIN (SELECT T.recordingID as record,COUNT(*) as c
			FROM Track_artist Ta,Tracks T,Artists A
			WHERE a.name="Metallica" and a.artistID=Ta.artistID and T.trackID=Ta.trackID
			GROUP BY T.recordingID
			ORDER BY c DESC
			LIMIT 25)
ON R.recordingID=record
 