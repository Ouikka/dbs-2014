-- For each of the 10 genres with the most artist, list the female artist that has recorder the highest number of tracks
-- Retourne les genres ordonnés par nombre d'artistes

Select GenreId, count(*) counter from Artist_GENRE GROUP BY GenreId ORDER BY counter DESC 


-- Pour un genre fixé, retourne l'artiste féminin avec le plus de track
Select * from (Select artilist.ArtistId, artilist."NAME", artilist.AreaId, artilist.gender, artilist."TYPE" , count(*) counter from Track_Artist INNER JOIN (Select Artists.* from Artists INNER JOIN (Select * from Artist_Genre where GenreId = 5) artigenre ON artigenre.artistId = Artists.ArtistId where Artists.gender = 'Female') artilist ON Track_Artist.artistid = artilist.artistid GROUP BY  artilist.ArtistId, artilist."NAME", artilist.AreaId, artilist.gender, artilist."TYPE" ORDER BY counter DESC) WHERE ROWNUM <=1 
