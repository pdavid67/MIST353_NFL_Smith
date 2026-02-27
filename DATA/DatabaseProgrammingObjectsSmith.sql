-- 3 query
-- 1 for each ConfrenceDivision and team Tables, and 1 inner join query


SELECT *
FROM ConferenceDivision;


SELECT *
FROM Team;


SELECT t.TeamID,
	t.TeamName,
	cd.ConferenceName,
	cd.DivisionName
FROM Team AS t
INNER JOIN ConferenceDivision AS cd
	ON t.DivisionID = cd.DivisionID;