Select  artistarea.areaname, artistarea.Type, count(*) "number" from
 (Select * from Artists arti INNER JOIN (
 SELECT  Area.name areaname, area.areaId 
 FROM  Areas area 
 WHERE  area.areaid = ( 
     SELECT  AreaId areafemale 
     FROM (  
      SELECT  AreaId , count(*) c 
      FROM  Artists  
      WHERE  (gender = 'Female') 
      GROUP BY  AreaId 
      ORDER BY  c DESC
     )  
     WHERE  ROWNUM <=1 
 )  
 ) toparea
 ON arti.areaid = toparea.areaid) artistarea
GROUP BY artistarea.Type , artistarea.areaname
