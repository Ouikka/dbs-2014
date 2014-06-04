-- The concert hit index is a measure of probability that the artist 
-- can attract enough fans to fill a football
-- stadium. We define the “hit artist” as one that has more than 10 songs 
-- that appear on more than 100
-- mediums and measure "hit ability" as the average number of mediums that 
-- a top 10 song appears on.
-- List all “hit artists” according to their "hit ability".

-- lists all hitsongs ( which appear on at least 100 mediums )
WITH hitsongs AS (
SELECT a.artistid, recordingid, c FROM (
SELECT a.artistid, t.recordingid, COUNT ( DISTINCT t.mediumid ) AS c
FROM tracks t
WHERE a.artistid=ta.artistid AND ta.trackid=t.trackid
GROUP BY a.artistid, t.recordingid
HAVING c > 100  ), track_artist ta, 

SELECT a.*
FROM  artists a, 

-- selects hitartists
( SELECT artistid 
FROM hitsongs 
GROUP BY artistid 
HAVING COUNT(DISTINCT recordingid) > 10 ) AS  hitartist ,
( SELECT artistid, AVG(c) AS ha 
FROM hitsongs 
GROUP BY artistid 
ORDER BY c 
LIMIT 10 ) AS hitability

WHERE a.artistid = hitartist.artistid AND a.artistid = hitability.artistid  
