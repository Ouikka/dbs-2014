SELECT * 
FROM
(
SELECT  arti.name 
FROM  Artists arti 
INNER JOIN ( 
  SELECT   ArtistId, COUNT(DISTINCT ReleaseID) num 
  FROM   Track_Artist trackarti 
  INNER JOIN ( 
    SELECT  *  
    FROM  Tracks track 
    INNER JOIN ( 
      SELECT   mediums.MediumId, Mediums.ReleaseID 
      FROM   Mediums mediums
      INNER JOIN  Releases releases
      ON    mediums.ReleaseID = releases.ReleaseID
      ) media 
    ON  track.MediumID = media.MediumID
    ) track 
  ON   trackarti.TrackID = track.TrackID 
  GROUP BY  ArtistID
  ORDER BY  num DESC
  ) artiId 
ON   arti.ArtistId = artiId.ArtistId 
WHERE  arti.Type = 'Group'
)
WHERE  ROWNUM <=10 
