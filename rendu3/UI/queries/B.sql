Select  artistarea.areaname, artistarea.Type, count(*) "number" from
 (Select * from Artists arti INNER JOIN (
 SELECT  Area.name areaname, area.areaId 
 FROM  Areas area 
 WHERE  area.areaid = ( 
     SELECT  AreaId areafemale 
     FROM (  
      SELECT  AreaId , count(*) c 
      FROM  Artists  
      WHERE  (gender = 'Male') 
      GROUP BY  AreaId 
      ORDER BY  c DESC
     )  
     WHERE  ROWNUM <=1 
 )  
 ) toparea
 ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname

select areaid, max(females), males,  groups from (
select a.areaid, count(CASE WHEN a.gender = 'Female' THEN 1 END) as females, count(CASE WHEN a.gender = 'Male' THEN 1 END) as males, count(CASE WHEN a.type = 'Group' THEN 1 END) as groups
from artists a
where a.areaid is not 'NULL'
group by a.areaid
)
