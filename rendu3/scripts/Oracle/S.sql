--List the release which is associated with the most mediums. If there are more than one such release, list all such releases.
-- Problem with max in oracle, need to be combined with a GROUP BY


  Select ArtistId, totalrelease/numberoftopsong hitability
  From (
    Select ArtistId, SUM(ReleaseperSong) totalrelease, count(*) numberoftopsong
    from (
      -- now, filter all the song that aren't in the "TOP10" of an "hit artist", in case of tie (ie, the 10th and 11th rang have the same number of release), we decided to keep the both
      Select ArtistId,RecordingId,ReleaseperSong , songrank 
      FROM (
        -- Rank the top song per artist, and filter all the non "hit artist"
        Select  ArtistId,RecordingId,ReleaseperSong ,rank() over (PARTITION BY ArtistId order by  ReleaseperSong desc) songrank
        From(
          Select DISTINCT ArtistId,RecordingId,ReleaseperSong , 
          COUNT(DISTINCT RecordingId) OVER ( PARTITION BY ArtistId  ) numberoftopsong 
          from (
            -- Return all the song that appears in at least 10 recordings
            Select ArtistId,  tra.trackId ,tr.mediumId,  med.releaseId, tr.recordingId, COUNT(DISTINCT tr.mediumId) OVER ( PARTITION BY tr.recordingId  ) releasepersong
            From Track_Artist tra , Tracks tr,  Mediums med
            where tra.trackId = tr.trackId AND tr.mediumId = med.mediumId
            )
          where releasepersong >= 2
        )
        where numberoftopsong >= 1
      ) 
      where songrank <= 2
  ) GROUP BY ArtistId
)
ORDER BY hitability DESC
