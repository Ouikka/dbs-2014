SELECT track.mediumid 
FROM  Tracks track 
GROUP BY track.mediumid 
HAVING   COUNT (*) >= ALL (
      SELECT  COUNT(*) 
      FROM  Tracks track  
      GROUP BY  track.mediumid  
    )
