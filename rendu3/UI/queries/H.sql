SELECT artistID FROM (
SELECT areaID FROM (
SELECT areaID, COUNT(*) ac
FROM Artists 
GROUP BY areaID )
WHERE ac >= 30 JOIN

select a.areaid
from artists a, areas l, track_artist ta
where a.areaid=l.areaid AND a.artistid=ta.artistid
group by a.areaid
having count(distinct a.artistid)>30

select a.*, count(CASE WHEN a.gender = 'Female' THEN 1 END) AS females, count(CASE WHEN a.gender = 'Male' THEN 1 END) AS males, count(CASE WHEN a.type = 'Group' THEN 1 END) as groups
from artists a, track_artist ta
where a.artistid=ta.artistid AND a.areaid IN (
select areaid
from artists a
group by areaid
having count(*)>30 )
group by areaid

with loc as (
select areaid
from artists
group by areaid
having count(*)>30 ) 

select *, MAX ( numtrack ) from (
select a.*, count(distinct trackid) as numtrack
from artists a, track_artist ta, loc 
where a.type<>'Group' AND a.gender='Female' AND a.areaid = loc.areaid 
AND a.artistid=ta.artistid 
group by a.artistid )
group by areaid
UNION
select *, MAX ( numtrack ) from (
select a.*, count(distinct trackid) as numtrack
from artists a, track_artist ta, loc 
where a.type<>'Group' AND a.gender='Male' AND a.areaid = loc.areaid 
AND a.artistid=ta.artistid 
group by a.artistid )
group by areaid
UNION
select *, MAX ( numtrack ) from (
select a.*, count(distinct trackid) as numtrack
from artists a, track_artist ta, loc 
where a.type='Group' AND a.areaid AND a.areaid = loc.areaid  
AND a.artistid=ta.artistid 
group by a.artistid )
group by areaid

with loc as (
select areaid
from artists
group by areaid
having count(*)>30 ) 
select a.* from loc, artists a where a.areaid = loc.areaid
