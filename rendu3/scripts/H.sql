-- For each area that hAS more than 30 artists, list the male artist, 
-- the female artist and the group with the most tracks recorded.

-- areas with at least 30 artists
WITH loc AS (
SELECT areaid
FROM artists
GROUP BY areaid
having COUNT(*)>30 ) 

-- female artist in area with most tracks
SELECT *, MAX ( numtrack ) FROM (
SELECT a.*, COUNT(distinct trackid) AS numtrack
FROM artists a, track_artist ta, loc 
WHERE a.type<>'Group' AND a.gender='Female' AND a.areaid = loc.areaid 
AND a.artistid=ta.artistid 
GROUP BY a.artistid )
GROUP BY areaid

UNION

-- male artist in area with most tracks
SELECT *, MAX ( numtrack ) FROM (
SELECT a.*, COUNT(distinct trackid) AS numtrack
FROM artists a, track_artist ta, loc 
WHERE a.type<>'Group' AND a.gender='Male' AND a.areaid = loc.areaid 
AND a.artistid=ta.artistid 
GROUP BY a.artistid )
GROUP BY areaid

UNION

-- group in area with most tracks
SELECT *, MAX ( numtrack ) FROM (
SELECT a.*, COUNT(distinct trackid) AS numtrack
FROM artists a, track_artist ta, loc 
WHERE a.type='Group' AND a.areaid AND a.areaid = loc.areaid  
AND a.artistid=ta.artistid 
GROUP BY a.artistid )
GROUP BY areaid
