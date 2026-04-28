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
WHERE CfiedFan
(onfrenceDivisionID = 2;

create or alter proc procGetTeamsForSpecifiedFan
(
    @NFLFanID INT
)
AS
BEGIN
    SELECT t.TeamName, cd.Confrence, cd.Division
    FROM Team t
    INNER JOIN ConfrenceDivision cd
        ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
    INNER JOIN FanTeam ft
        ON t.TeamID = ft.TeamID
    WHERE ft.NFLFanID = @NFLFanID;
END;

-- execute procGetTeamsForSpecifiedFan @NFLFanID = 1;





/* =========================================
   1) DELETE OLD PROCEDURES IF THEY EXIST
   ========================================= */

IF OBJECT_ID('dbo.GetTeamsByConferenceDivision', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTeamsByConferenceDivision;
GO

IF OBJECT_ID('dbo.GetTeamsInSameConferenceDivisionAsSpecifiedTeam', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTeamsInSameConferenceDivisionAsSpecifiedTeam;
GO

IF OBJECT_ID('dbo.GetTeamsForSpecifiedFan', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTeamsForSpecifiedFan;
GO


/* =========================================
   2) RECREATE: GET TEAMS BY CONFERENCE/DIVISION
   ========================================= */
CREATE PROCEDURE dbo.GetTeamsByConferenceDivision
    @Confrence NVARCHAR(50),
    @Division NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.TeamID,
        t.TeamName,
        t.TeamCityState,
        t.TeamColors,
        cd.Confrence,
        cd.Division
    FROM Team t
    INNER JOIN ConfrenceDivision cd
        ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
    WHERE cd.Confrence = @Confrence
      AND cd.Division = @Division
    ORDER BY t.TeamName;
END;
GO


/* =========================================
   3) RECREATE: GET TEAMS IN SAME CONFERENCE/DIVISION
      AS A SPECIFIED TEAM
   ========================================= */
CREATE PROCEDURE dbo.GetTeamsInSameConferenceDivisionAsSpecifiedTeam
    @TeamName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ConfrenceDivisionID INT;

    SELECT @ConfrenceDivisionID = ConfrenceDivisionID
    FROM Team
    WHERE TeamName = @TeamName;

    SELECT
        t.TeamID,
        t.TeamName,
        t.TeamCityState,
        t.TeamColors,
        cd.Confrence,
        cd.Division
    FROM Team t
    INNER JOIN ConfrenceDivision cd
        ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
    WHERE t.ConfrenceDivisionID = @ConfrenceDivisionID
      AND t.TeamName <> @TeamName
    ORDER BY t.TeamName;
END;
GO


/* =========================================
   4) RECREATE: GET TEAMS FOR SPECIFIED FAN
      USES THE LOGGED-IN AppUserID AS @UserID
      NFLFanID MATCHES AppUserID THROUGH THE NFLFan TABLE
   ========================================= */
IF OBJECT_ID('dbo.GetTeamsForSpecifiedFan', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTeamsForSpecifiedFan;
GO

CREATE PROCEDURE dbo.GetTeamsForSpecifiedFan
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ft.FanTeamID,
        t.TeamID,
        t.TeamName,
        t.TeamCityState,
        t.TeamColors,
        cd.Confrence,
        cd.Division,
        ft.PrimaryTeam
    FROM FanTeam ft
    INNER JOIN Team t
        ON ft.TeamID = t.TeamID
    INNER JOIN ConfrenceDivision cd
        ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
    WHERE ft.NFLFanID = @UserID
    ORDER BY ft.PrimaryTeam DESC, t.TeamName;
END;
GO



EXEC dbo.GetTeamsForSpecifiedFan @UserID = 3;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FanTeam'
ORDER BY ORDINAL_POSITION;


SELECT name
FROM sys.procedures
ORDER BY name;



DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql + 'DROP PROCEDURE dbo.' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.procedures
WHERE schema_id = SCHEMA_ID('dbo');

EXEC sp_executesql @sql;



SELECT
    ft.FanTeamID,
    ft.NFLFanID,
    ft.TeamID,
    ft.PrimaryTeam,
    t.TeamName,
    cd.Confrence,
    cd.Division
FROM FanTeam ft
INNER JOIN Team t
    ON ft.TeamID = t.TeamID
INNER JOIN ConfrenceDivision cd
    ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
ORDER BY ft.FanTeamID;



SELECT *
FROM FanTeam
ORDER BY FanTeamID;


EXEC dbo.GetTeamsForSpecifiedFan @UserID = 3;





/* =========================================
   5) CREATE: SCHEDULE GAME
      USED BY POST /schedule_game/
   ========================================= */
IF OBJECT_ID('dbo.ScheduleGame', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ScheduleGame;
GO

CREATE PROCEDURE dbo.ScheduleGame
    @HomeTeamID INT,
    @AwayTeamID INT,
    @GameRound NVARCHAR(50),
    @GameDate DATE,
    @GameTime TIME,
    @StadiumID INT,
    @NFLAdminID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Game (
        HomeTeamID,
        AwayTeamID,
        GameRound,
        GameDate,
        GameTime,
        StadiumID,
        NFLAdminID
    )
    OUTPUT
        INSERTED.GameID,
        INSERTED.HomeTeamID,
        INSERTED.AwayTeamID,
        INSERTED.GameRound,
        INSERTED.GameDate,
        INSERTED.GameTime,
        INSERTED.StadiumID,
        INSERTED.NFLAdminID
    VALUES (
        @HomeTeamID,
        @AwayTeamID,
        @GameRound,
        @GameDate,
        @GameTime,
        @StadiumID,
        @NFLAdminID
    );
END;
GO



EXEC dbo.ScheduleGame
    @HomeTeamID = 1,
    @AwayTeamID = 2,
    @GameRound = 'Wild Card',
    @GameDate = '2026-01-10',
    @GameTime = '13:00',
    @StadiumID = 1,
    @NFLAdminID = 5;



IF OBJECT_ID('dbo.procValidateUser', 'P') IS NOT NULL
    DROP PROCEDURE dbo.procValidateUser;
GO

CREATE PROCEDURE dbo.procValidateUser
    @Email NVARCHAR(100),
    @PasswordHash VARBINARY(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        AppUserID,
        FirstName + ' ' + LastName AS FullName,
        UserRole
    FROM AppUser
    WHERE Email = @Email
      AND PasswordHash = @PasswordHash;
END;
GO




EXEC dbo.procValidateUser
    @Email = 'tom.brady@example.com',
    @PasswordHash = 0x01;
GO
