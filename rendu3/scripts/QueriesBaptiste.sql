#####Q2#####
*/Renvois nom area ou max femmes
Select area.name From Areas area where area.areaid =  (Select AreaId areafemale from (SELECT AreaId , count(*) numb FROM Artists  where (gender = 'Male') GROUP BY AreaId ORDER BY numb DESC)  WHERE ROWNUM <=1 ) ;  

#####Q3#####
Renvois artistId ordonnés par nombre de tracks
Select ArtistId from (SELECT ArtistId  , count(*) numb FROM TRACK_ARTIST Group By ArtistId ORDER BY numb DESC );

#Reponse Q3
Select Name from Artists arti 
	INNER JOIN (Select ArtistId  from 
		(SELECT ArtistId  , count(*) numb FROM TRACK_ARTIST Group By ArtistId ORDER BY numb DESC ))
	 artiId ON arti.ArtistId = artiId.ArtistId 
WHERE ROWNUM <=10  ;

##### Q4 #####
#Reponse Q4
Select Name From Artists arti 
INNER JOIN (Select ArtistId, COUNT(DISTINCT AlbumId) num from track_artist trackarti 
	INNER JOIN (Select *  from Tracks track 
		INNER JOIN (Select mediums.mediumid ,mediums.albumid From Mediums 
			INNER JOIN Albums ON mediums.albumid = albums.albumid) medi 
		ON track.mediumid = medi.mediumid) track 
	ON trackarti.trackid = track.trackid GROUP BY ArtistId  ORDER BY num DESC) artiId 
ON arti.ArtistId = artiId.ArtistId 
WHERE ROWNUM <=10  ;
#A tester de maniere approfondie, test effectués en local avec une petite base de l'ordre de la dizaine d'entrée, possibilité que les inner join soient assez couteux...

##### Q5 #####
#Reponse Q5

Select name from Artists arti 
INNER JOIN (Select arti.artistid , COUNT(DISTINCT genre.genreid) numb From Artists arti  
	INNER JOIN Artist_Genre genre ON arti.artistId = genre.artistId   where arti.gender = 'Female' Group By arti.ArtistId ORDER BY numb DESC) artigenre 
ON arti.artistid = artigenre.artistid 
WHERE ROWNUM <=1  ;

##### Q6 #####

#WIP : retourne pour linstant les ID des zones ou plus de femmes , Oracle SQL ne semble guere apprecier les table.name, voir si ya une solution plus esthetique qu un select / projection supplementaire
Select AreaId from (
	Select city.areaid, count(case when arti.gender = 'Female' then 1 end) as females, count(case when arti.gender = 'Male' then 1 end) 		as males  
	From Artists arti  
		INNER JOIN Areas city ON city.areaid = arti.areaId   where city.type = 'City' GROUP BY city.areaId ) areamalefemale where 			areamalefemale.Females > areamalefemale.Males

##### Q7 #####
#WIP, voir Q6
Select medi.albumid, count(DISTINCT track.trackid)  from Tracks track 
		INNER JOIN (Select mediums.mediumid ,mediums.albumid From Mediums 
			INNER JOIN Albums ON mediums.albumid = albums.albumid) medi 
		ON track.mediumid = medi.mediumid GROUP BY medi.albumid;
