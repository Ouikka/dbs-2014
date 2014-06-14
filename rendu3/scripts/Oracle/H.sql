-- For each area that has more than 30 artists, list the male artist, 
-- the female artist and the group with the most tracks recorded.

SELECT art.artistId, MAX ( trackCount ) 
FROM ( 
	SELECT artistId, COUNT(*) trackCount
