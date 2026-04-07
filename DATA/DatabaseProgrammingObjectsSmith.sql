-- 3 query


-- 1 for each ConfrenceDivision and team Tables, and 1 inner join query
/*
SELECT *
FROM Team;

SELECT *
FROM ConfrenceDivision;

SELECT
    t.TeamID,
    t.TeamName,
    t.TeamCityState,
    t.TeamColors,
    cd.Confrence,
    cd.Division
FROM Team t
INNER JOIN ConfrenceDivision cd
    ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID;

    SELECT * FROM ConfrenceDivision;


ALTER TABLE Team
ADD ConfrenceDivisionID INT;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Team';


SELECT * FROM ConfrenceDivision;

SELECT *
FROM Team
WHERE TeamName = 'Pittsburgh Steelers';

SELECT TeamName, ConfrenceDivisionID
FROM Team
WHERE TeamName = 'Pittsburgh Steelers';

SELECT TeamName, ConfrenceDivisionID
FROM Team
WHERE ConfrenceDivisionID = 2;

SELECT *
FROM ConfrenceDivision
WHERE ConfrenceDivisionID = 2;

SELECT TeamName, ConfrenceDivisionID FROM Team WHERE TeamName = 'Pittsburgh Steelers';
SELECT TeamName, ConfrenceDivisionID FROM Team WHERE ConfrenceDivisionID = 2;

INSERT INTO Team (TeamName, TeamCityState, TeamColors, ConfrenceDivisionID)
VALUES
('Baltimore Ravens', 'Baltimore, MD', 'Purple, Black, Gold', 2),
('Cincinnati Bengals', 'Cincinnati, OH', 'Black, Orange, White', 2),
('Cleveland Browns', 'Cleveland, OH', 'Brown, Orange, White', 2),
('Pittsburgh Steelers', 'Pittsburgh, PA', 'Black, Gold, White', 2);
GO

SELECT TeamName, ConfrenceDivisionID
FROM Team
WHERE TeamName = 'Pittsburgh Steelers';

SELECT TeamName, ConfrenceDivisionID
FROM Team
WHERE ConfrenceDivisionID = 2;