-- List the 10 groups with the highest number of tracks that appear 
-- on compilations. A compilation is a medium that contains tracks 
-- associated with more than one artist.

Select art.*
FROM Artists art
INNER JOIN  (
  Select ArtistId, count(*) counter
  From Track_Artist tracky
  INNER JOIN (
    Select tr.trackId
    From Tracks tr 
    INNER JOIN (
      Select DISTINCT tr.mediumId mediId
      From Tracks tr 
      INNER JOIN (
        Select TrackId
        From(
          SELECT TrackId, count(*) artistnumber
          FROM Track_Artist
          GROUP BY TrackId)
        where artistnumber > 1) trid
      ON trid.trackId = tr.trackId) medi
    ON medi.mediId = tr.mediumId) compilId
  ON tracky.trackId = compilId.trackId
  Group By ArtistId
  ORDER BY counter DESC) arti
ON art.artistId = arti.artistId
WHERE art."TYPE" = 'Group'
LIMIT 10

