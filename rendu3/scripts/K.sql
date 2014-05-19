-- For each of the 10 genres with the most artists, list the most popular female artist. Most popular <=> with the most tracks recorded
Select ArtistId, "NAME", AreaId Gender ,"TYPE", GenreId
  from (
  -- Seqnum is used to keep only ONE artist per genre
  Select r.* , row_number() over (partition by genreId order by artistId) as seqnum
  from (
  -- Max counter is used to keep the artists with the most tracks for every genreId
    Select t.* , max(counter) over (partition by genreId) as maxcounter 
    from ( 
    -- Return , for each selected genre, all artists with their number of recorded tracks ("counter")
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
				    WHERE 	ROWNUM <=4)
			) genreids
			ON genreids.genreid = Artist_Genre.genreid ) artigenre 
		ON artigenre.artistId = Artists.ArtistId 
		where Artists.gender = 'Female' ) artilist 
	    ON Track_Artist.artistid = artilist.artistid 
	    
	    GROUP BY  artilist.ArtistId, artilist."NAME", artilist.AreaId, artilist.gender, artilist."TYPE" , genreid
	    ORDER BY genreid, counter DESC ) t
    ) r
    where counter = maxcounter   
  )  
where seqnum = 1
  
 
