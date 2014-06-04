-- For each area with more than 10 groups, list the 5 male artists 
-- that have recorded the highest number of tracks.

-- areas with more than 10 groups
WITH gareas AS (
SELECT areaid
FROM artists
WHERE type='Group'
GROUP BY areaid
having count(*) > 10 )

-- select artist with max number of tracks
-- ( I did not managed to get the 5 best using SQLite)
SELECT a.*, MAX ( numtrack ) AS numtrack
FROM ( 
-- counts tracks for male artists
SELECT a.artistid, count ( ta.trackid ) AS numtrack
FROM gareas, artists a, track_artist ta
WHERE gareas.areaid = a.areaid AND a.type <> 'Group' 
	AND a.gender = 'Male' AND a.artistid = ta.artistid
GROUP BY a.artistid
 ) AS m, artists a
WHERE m.artistid = a.artistid
GROUP BY areaid

SELECT a.*, 
FROM gareas l
