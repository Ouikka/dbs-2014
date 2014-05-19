--For each area with more than 10 groups, list the 5 male artists that have recorded the highest number of tracks.

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
where seqnum <= 1
