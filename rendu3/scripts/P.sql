-- List the most popular genre among the groups wich are associated with at least 3 genres
Select Genres.genreId, Genres.name 
from Genres 
	Inner Join (
		Select GenreId, count(*) genrecounter 
		from Artist_Genre artigenre 
		Inner Join (
			Select ArtistId 
			From (
				Select arti.ArtistId, count(*) numbgenre 
				from Artist_genre 
				INNER JOIN (
					Select artistId 
					from Artists 
					where type = 'Group') arti 
				on Artist_genre.artistId = arti.artistId  
				GROUP BY arti.ArtistId) artistgenrecount  
			where numbgenre > 2 ) artithree 
		ON artithree.artistId = artigenre.artistId 
		Group By GenreId 
		Order by genrecounter Desc) genreordered 
	On genreordered.genreid = Genres.genreId 
WHERE 	ROWNUM <=1  ;
