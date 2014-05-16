SELECT mediumid FROM (
SELECT mediumid, MAX(c) FROM (
SELECT t.mediumid, COUNT( *) c
FROM  Tracks t
GROUP BY t.mediumid ) )
