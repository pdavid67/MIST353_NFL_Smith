-- Stored procedures for NFL app.
-- Run after CreateTablesSmith.sql and InsertDataSmith.sql.

USE MIST353_NFL_Smith;
GO

IF OBJECT_ID('dbo.GetTeamsByConferenceDivision', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTeamsByConferenceDivision;
GO

IF OBJECT_ID('dbo.GetTeamsInSameConferenceDivisionAsSpecifiedTeam', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTeamsInSameConferenceDivisionAsSpecifiedTeam;
GO

IF OBJECT_ID('dbo.GetTeamsForSpecifiedFan', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTeamsForSpecifiedFan;
GO

IF OBJECT_ID('dbo.procGetTeamsWithLogosForSpecifiedFan', 'P') IS NOT NULL
    DROP PROCEDURE dbo.procGetTeamsWithLogosForSpecifiedFan;
GO

IF OBJECT_ID('dbo.procGetAllTeams', 'P') IS NOT NULL
    DROP PROCEDURE dbo.procGetAllTeams;
GO

IF OBJECT_ID('dbo.procGetAllStadiums', 'P') IS NOT NULL
    DROP PROCEDURE dbo.procGetAllStadiums;
GO

IF OBJECT_ID('dbo.procGetAllChangesMadeBySpecifiedAdmin', 'P') IS NOT NULL
    DROP PROCEDURE dbo.procGetAllChangesMadeBySpecifiedAdmin;
GO

IF OBJECT_ID('dbo.ScheduleGame', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ScheduleGame;
GO

IF OBJECT_ID('dbo.procValidateUser', 'P') IS NOT NULL
    DROP PROCEDURE dbo.procValidateUser;
GO

IF OBJECT_ID('dbo.trgTrackChangesOnSchedulingGame', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trgTrackChangesOnSchedulingGame;
GO

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

CREATE PROCEDURE dbo.procGetTeamsWithLogosForSpecifiedFan
    @NFLFanID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.TeamName,
        cd.Confrence AS Conference,
        cd.Division,
        t.TeamColors,
        ft.PrimaryTeam,
        t.TeamLogo
    FROM FanTeam ft
    INNER JOIN Team t
        ON ft.TeamID = t.TeamID
    INNER JOIN ConfrenceDivision cd
        ON t.ConfrenceDivisionID = cd.ConfrenceDivisionID
    WHERE ft.NFLFanID = @NFLFanID
    ORDER BY ft.PrimaryTeam DESC, t.TeamName;
END;
GO

CREATE PROCEDURE dbo.procGetAllTeams
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        TeamID,
        TeamName
    FROM Team
    ORDER BY TeamName;
END;
GO

CREATE PROCEDURE dbo.procGetAllStadiums
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        StadiumID,
        StadiumName
    FROM Stadium
    ORDER BY StadiumName;
END;
GO

CREATE PROCEDURE dbo.procGetAllChangesMadeBySpecifiedAdmin
    @NFLAdminID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        act.ChangeDateTime,
        act.ChangeType,
        act.ChangeDescription,
        g.GameRound,
        g.GameDate,
        g.GameTime,
        ht.TeamName AS HomeTeam,
        at.TeamName AS AwayTeam,
        s.StadiumName
    FROM AdminChangesTracker act
    INNER JOIN Game g
        ON act.GameID = g.GameID
    INNER JOIN Team ht
        ON g.HomeTeamID = ht.TeamID
    INNER JOIN Team at
        ON g.AwayTeamID = at.TeamID
    INNER JOIN Stadium s
        ON g.StadiumID = s.StadiumID
    WHERE act.NFLAdminID = @NFLAdminID
    ORDER BY act.ChangeDateTime DESC;
END;
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

    IF NOT EXISTS (SELECT 1 FROM NFLAdmin WHERE NFLAdminID = @NFLAdminID)
    BEGIN
        RAISERROR('Only users with the NFLAdmin role can schedule games.', 16, 1);
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM Game
        WHERE GameDate = @GameDate
          AND GameTime = @GameTime
    )
    BEGIN
        SELECT
            CAST(0 AS BIT) AS Scheduled,
            'Game already scheduled for the specified date and time.' AS Message;
        RETURN;
    END;

    DECLARE @ScheduledGame TABLE (
        GameID INT,
        HomeTeamID INT,
        AwayTeamID INT,
        GameRound NVARCHAR(50),
        GameDate DATE,
        GameTime TIME,
        StadiumID INT,
        NFLAdminID INT
    );

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
    INTO @ScheduledGame
    VALUES (
        @HomeTeamID,
        @AwayTeamID,
        @GameRound,
        @GameDate,
        @GameTime,
        @StadiumID,
        @NFLAdminID
    );

    SELECT
        GameID,
        HomeTeamID,
        AwayTeamID,
        GameRound,
        GameDate,
        GameTime,
        StadiumID,
        NFLAdminID
    FROM @ScheduledGame;
END;
GO

CREATE TRIGGER dbo.trgTrackChangesOnSchedulingGame
ON dbo.Game
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AdminChangesTracker (
        NFLAdminID,
        GameID,
        ChangeType,
        ChangeDescription
    )
    SELECT
        i.NFLAdminID,
        i.GameID,
        'Schedule Game',
        CONCAT('Scheduled ', ht.TeamName, ' vs ', at.TeamName, ' on ', CONVERT(NVARCHAR(10), i.GameDate, 120), ' at ', CONVERT(NVARCHAR(8), i.GameTime, 108))
    FROM inserted i
    INNER JOIN Team ht
        ON i.HomeTeamID = ht.TeamID
    INNER JOIN Team at
        ON i.AwayTeamID = at.TeamID;
END;
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
