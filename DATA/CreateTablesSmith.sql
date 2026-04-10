--create a database fir NFL app
--use master;

--CREATE DATABASE MIST353_NFL_RDB_Smith

--DROP database NFL_RDB_Smith;

IF OBJECT_ID('AdminUpdate', 'U') IS NOT NULL DROP TABLE AdminUpdate;
IF OBJECT_ID('FanTeam', 'U') IS NOT NULL DROP TABLE FanTeam;
IF OBJECT_ID('AppUser', 'U') IS NOT NULL DROP TABLE AppUser;
IF OBJECT_ID('Game', 'U') IS NOT NULL DROP TABLE Game;
IF OBJECT_ID('Stadium', 'U') IS NOT NULL DROP TABLE Stadium;
IF OBJECT_ID('Team', 'U') IS NOT NULL DROP TABLE Team;
IF OBJECT_ID('ConfrenceDivision', 'U') IS NOT NULL DROP TABLE ConfrenceDivision;

if OBJECT_ID('Team') IS NOT NULL
    DROP TABLE Team;

if OBJECT_ID('ConfrenceDivision') IS NOT NULL
    DROP TABLE ConfrenceDivision;



--create tables for first itteration

 CREATE TABLE Team (
    TeamID INT IDENTITY(1,1) CONSTRAINT PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColors NVARCHAR(50) NOT NULL
);

CREATE TABLE ConfrenceDivision (
    ConfrenceDivisionID INT IDENTITY(1,1) 
        CONSTRAINT PK_ConfrenceDivision PRIMARY KEY,
    Confrence NVARCHAR(50) NOT NULL 
        CONSTRAINT CK_ConferenceNames CHECK (Confrence IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL 
        CONSTRAINT CK_DivisionNames CHECK (Division IN ('East', 'North', 'South', 'West'))
    CONSTRAINT UK_ConferenceDivision UNIQUE (Confrence, Division)
);








-- create tables for second iteration
GO

create table AppUser (
    AppUserID int identity(1,1)
        CONSTRAINT PK_AppUserID PRIMARY KEY,
    FirstName NVARCHAR(50) not null,
    LastName NVARCHAR(50) not null,
    Email NVARCHAR(100) not null
        CONSTRAINT UQ_AppUser_Email UNIQUE,

    PasswordHash VARBINARY(200) not null,
    Phone NVARCHAR(50) null,
    UserRole NVARCHAR(50) not null
        CONSTRAINT CHK_UserRole CHECK (UserRole IN (N'NFLAdmin', N'NFLFan'))
);


GO

create table NFLFan(
    NFLFanID int
        CONSTRAINT PK_NFLFanID PRIMARY KEY
        CONSTRAINT FK_NFLFan_AppUserID FOREIGN KEY REFERENCES AppUser(AppUserID)

);

GO

create table NFLAdmin(
    NFLAdminID int
        CONSTRAINT PK_NFLAdminID PRIMARY KEY
        CONSTRAINT FK_NFLAdmin_AppUserID FOREIGN KEY REFERENCES AppUser(AppUserID)

);

GO

create table FanTeam(
    FanTeamID int identity(1,1)
        CONSTRAINT PK_FanTeamID PRIMARY KEY,
    NFLFanID int not null
        CONSTRAINT FK_FanTeam_NFLFanID FOREIGN KEY REFERENCES NFLFan(NFLFanID),
    TeamID int not null
        CONSTRAINT FK_FanTeam_TeamID 
            FOREIGN KEY REFERENCES Team(TeamID),
        CONSTRAINT UQ_FanTeam UNIQUE (NFLFanID, TeamID),
    PrimaryTeam BIT not null
);

GO


 