-- List the 5 titles that are associated with the most different songs 
-- (recordings) along with the number of songs that share such title.

SELECT name, count(*) numsongs
FROM recordings
GROUP BY name
ORDER BY numsongs DESC
LIMIT 5
