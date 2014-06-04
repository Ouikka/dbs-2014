-- List all genre with no female artist, all genre that 
-- have no males artists and all genres that have no groups
--- <=> List all genre with no female artist OR no male artists OR no groups (?)

SELECT  g.*
FROM Genres g, Artist_Genre ag, artists a 
WHERE g.genreid = ag.genreid AND ag.artistid=a.artistid
GROUP BY g.GenreId, g.name
HAVING (count(CASE WHEN a.gender = 'Female' THEN 1 END)=0) 
OR (count(CASE WHEN a.gender = 'Male' THEN 1 END)=0) 
OR (count(CASE WHEN a.type = 'Group' THEN 1 END)=0)
