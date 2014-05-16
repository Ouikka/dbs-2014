SELECT name
FROM ( 
SELECT name, MAX(c)
FROM ( 
SELECT name, a.artistID, COUNT(g.genreID) c 
FROM Artists a, Artist_genre g
WHERE a.gender='Female' AND a.artistid=g.artistID
GROUP BY a.artistID )
)
