--List the release which is associated with the most mediums. If there are more than one such release, list all such releases.
-- Problem with max in oracle, need to be combined with a GROUP BY
Select ReleaseId
From (
	Select ReleaseId, dense_rank() over (order by medperrel desc) r
	From (
		  Select DISTINCT ReleaseId, COUNT(DISTINCT MediumId) OVER ( PARTITION BY releaseId  ) medperrel 
		  From Mediums 
		  Order By medperrel DESC
	)tr )
where r = 1

