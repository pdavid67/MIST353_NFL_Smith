-- Create database tables for NFL app.
-- Run this first, before InsertDataSmith.sql and DatabaseProgrammingObjectsSmith.sql.

-- USE MIST353_NFL_Smith;
-- GO

IF OBJECT_ID('Game', 'U') IS NOT NULL DROP TABLE Game;
IF OBJECT_ID('FanTeam', 'U') IS NOT NULL DROP TABLE FanTeam;
IF OBJECT_ID('NFLAdmin', 'U') IS NOT NULL DROP TABLE NFLAdmin;
IF OBJECT_ID('NFLFan', 'U') IS NOT NULL DROP TABLE NFLFan;
IF OBJECT_ID('AppUser', 'U') IS NOT NULL DROP TABLE AppUser;
IF OBJECT_ID('Stadium', 'U') IS NOT NULL DROP TABLE Stadium;
IF OBJECT_ID('Team', 'U') IS NOT NULL DROP TABLE Team;
IF OBJECT_ID('ConfrenceDivision', 'U') IS NOT NULL DROP TABLE ConfrenceDivision;
GO

CREATE TABLE ConfrenceDivision (
    ConfrenceDivisionID INT IDENTITY(1,1)
        CONSTRAINT PK_ConfrenceDivision PRIMARY KEY,
    Confrence NVARCHAR(50) NOT NULL
        CONSTRAINT CK_ConferenceNames CHECK (Confrence IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL
        CONSTRAINT CK_DivisionNames CHECK (Division IN ('East', 'North', 'South', 'West')),
    CONSTRAINT UK_ConferenceDivision UNIQUE (Confrence, Division)
);
GO

CREATE TABLE Team (
    TeamID INT IDENTITY(1,1)
        CONSTRAINT PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColors NVARCHAR(50) NOT NULL,
    ConfrenceDivisionID INT NOT NULL
        CONSTRAINT FK_Team_ConfrenceDivisionID
        FOREIGN KEY REFERENCES ConfrenceDivision(ConfrenceDivisionID)
);
GO

CREATE TABLE Stadium (
    StadiumID INT IDENTITY(1,1)
        CONSTRAINT PK_Stadium PRIMARY KEY,
    StadiumName NVARCHAR(100) NOT NULL,
    StadiumCityState NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE AppUser (
    AppUserID INT IDENTITY(1,1)
        CONSTRAINT PK_AppUserID PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_AppUser_Email UNIQUE,
    PasswordHash VARBINARY(200) NOT NULL,
    Phone NVARCHAR(50) NULL,
    UserRole NVARCHAR(50) NOT NULL
        CONSTRAINT CHK_UserRole CHECK (UserRole IN (N'NFLAdmin', N'NFLFan'))
);
GO

CREATE TABLE NFLFan (
    NFLFanID INT
        CONSTRAINT PK_NFLFanID PRIMARY KEY
        CONSTRAINT FK_NFLFan_AppUserID FOREIGN KEY REFERENCES AppUser(AppUserID)
);
GO

CREATE TABLE NFLAdmin (
    NFLAdminID INT
        CONSTRAINT PK_NFLAdminID PRIMARY KEY
        CONSTRAINT FK_NFLAdmin_AppUserID FOREIGN KEY REFERENCES AppUser(AppUserID)
);
GO

CREATE TABLE FanTeam (
    FanTeamID INT IDENTITY(1,1)
        CONSTRAINT PK_FanTeamID PRIMARY KEY,
    NFLFanID INT NOT NULL
        CONSTRAINT FK_FanTeam_NFLFanID FOREIGN KEY REFERENCES NFLFan(NFLFanID),
    TeamID INT NOT NULL
        CONSTRAINT FK_FanTeam_TeamID FOREIGN KEY REFERENCES Team(TeamID),
    PrimaryTeam BIT NOT NULL,
    CONSTRAINT UQ_FanTeam UNIQUE (NFLFanID, TeamID)
);
GO

CREATE TABLE Game (
    GameID INT IDENTITY(1,1)
        CONSTRAINT PK_GameID PRIMARY KEY,
    HomeTeamID INT NOT NULL
        CONSTRAINT FK_Game_HomeTeamID FOREIGN KEY REFERENCES Team(TeamID),
    AwayTeamID INT NOT NULL
        CONSTRAINT FK_Game_AwayTeamID FOREIGN KEY REFERENCES Team(TeamID),
    GameRound NVARCHAR(50) NOT NULL,
    GameDate DATE NOT NULL,
    GameTime TIME NOT NULL,
    StadiumID INT NOT NULL
        CONSTRAINT FK_Game_StadiumID FOREIGN KEY REFERENCES Stadium(StadiumID),
    NFLAdminID INT NOT NULL
        CONSTRAINT FK_Game_NFLAdminID FOREIGN KEY REFERENCES NFLAdmin(NFLAdminID),
    CONSTRAINT CK_Game_DifferentTeams CHECK (HomeTeamID <> AwayTeamID)
);
GO
