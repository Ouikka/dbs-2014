

Select ArtistId, "NAME", gender, "TYPE", areaId
From (
  Select r.* ,  row_number() over (partition by areaId order by counter) as seqnum
  From (
    -- Count the number of tracks per areaId/Artists entry
    Select t.artistId , t."NAME", t.gender , t."TYPE", t.areaId, count(*) counter
    From Track_Artist tr
    INNER JOIN (
           Select * 
           From Artists
           where AreaId in (
              -- Return the Areas with the more than 10 Artists
             Select AreaId
             From (
                          Select AreaId, count(*) counter 
                          from Artists 
                          where "TYPE" = 'Group'
                          GROUP BY AreaId 
                          ORDER BY counter DESC 
                          
                          )
             where NOT  areaId IS NULL AND  counter > 0
            )
    )t
    ON tr.artistid = t.artistid
    Group by t.artistId , t."NAME", t.gender , t."TYPE", t.areaId
    ORDER BY t.areaId, counter DESC
    ) r
) 
where seqnum <= 5

select l.name, l.areaid, a.artistid, count(*) as numtrack
from artists a, track_artist ta, (
select *
from artists a, areas l
where a.type='Group' and a.areaid=l.areaid
group by a.areaid
having count(*)>10
) l
where a.areaid = l.areaid 
group by a.areaid, a.artistid
order by numtrack
limit 10

select areaid
from areas l, artists a, track_artist ta
where a.type='Group' and l.areaid=a.areaid and a.artistid=ta.artistid
group by areaid, artistid
having count(*)>10


select 
select areaid
from artists
where type = 'Group'
group by areaid
having count ( distinct artistid ) > 10

select a.artistid, count(DISTINCT ta.trackid) as numtrack
from artists a, track_artist ta
where a.artistid = ta.artistid AND a.gender='Male' AND a.type <> 'Group'
group by artistid
