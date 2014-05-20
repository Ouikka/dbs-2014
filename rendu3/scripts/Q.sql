-- List the 5 titles that are associated with the most different songs (recordings) along with the number of songs that share such title.

Select *
From (
	Select DISTINCT "NAME" , COUNT(DISTINCT RecordingId) OVER ( PARTITION BY "NAME"  ) numberofsongs
	From Recordings
	ORDER BY numberofsongs DESC
) 
where ROWNUM <= 5
