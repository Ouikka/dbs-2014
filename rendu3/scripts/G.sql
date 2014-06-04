-- List the mediums with the highest number of tracks.

-- number of tracks per medium
WITH numtrack AS (
SELECT mediumid, COUNT(*) AS c
FROM Tracks
GROUP BY mediumid ), 

-- maximum number of tracks in a medium
max AS ( SELECT MAX(c) m FROM numtrack )

-- select all medium with the max number of tracks
SELECT m.*
FROM Mediums m, numtrack, max
WHERE m.mediumid = numtrack.mediumid AND c = max.m


