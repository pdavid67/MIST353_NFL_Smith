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

IF OBJECT_ID('dbo.ScheduleGame', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ScheduleGame;
GO

IF OBJECT_ID('dbo.procValidateUser', 'P') IS NOT NULL
    DROP PROCEDURE dbo.procValidateUser;
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
