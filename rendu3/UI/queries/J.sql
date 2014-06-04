-- For each of the 10 genres with the most artist, list the female artist that has recorder the highest number of tracks
	Select artilist.ArtistId, artilist."NAME", artilist.AreaId, artilist.gender, artilist."TYPE" , count(*) counter , genreId
	from Track_Artist 
	INNER JOIN ( 
	      Select Artists.*  , genreid
	      from Artists 
	      INNER JOIN (
			Select ArtistId, genreids.genreid 
			from Artist_Genre 
			INNER JOIN (
				  Select GenreId 
				  from (
					Select *
					From (
						Select GenreId, count(*) counter 
						from Artist_GENRE 
						GROUP BY GenreId 
						ORDER BY counter DESC  )
					LIMIT 10)
			) genreids
			ON genreids.genreid = Artist_Genre.genreid
		      ) artigenre 
	      ON artigenre.artistId = Artists.ArtistId 
	      where Artists.gender = 'Female' ) artilist 
	ON Track_Artist.artistid = artilist.artistid 
	GROUP BY  artilist.ArtistId, artilist."NAME", artilist.AreaId, artilist.gender, artilist."TYPE" , genreid
	ORDER BY genreid, counter DESC 

select g.genreid, a.*, COUNT ( DISTINCT
from artists a, artist_genre ag, artist_track ta
where a.artistid = ag.artistid and a.gender='Female' and ta.artistid=ta.artistid and ag.genreid in (
select genreid
from artist_genre 
group by genreid
order by count(*)
limit 10 )
group by a.artistid
order by numtrack DESC
