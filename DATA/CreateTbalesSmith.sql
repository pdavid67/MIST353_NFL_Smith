--create a database fir NFL app
--use master;

--CREATE DATABASE MIST353_NFL_RDB_Smith

--DROP database NFL_RDB_Smith;



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

CREATE TABLE Game (
    GameID INT IDENTITY(1,1) CONSTRAINT PK_Game PRIMARY KEY,
    GameDate DATE NOT NULL,
    GameStartTime TIME NOT NULL,
    GameEndTime TIME NOT NULL
);

CREATE TABLE Stadium (
    StadiumID INT IDENTITY(1,1) CONSTRAINT PK_Stadium PRIMARY KEY,
    StadiumName NVARCHAR(50) NOT NULL,
    StadiumCity NVARCHAR(50) NOT NULL,
    StadiumState NVARCHAR(50) NOT NULL,
    StadiumCapacity INT NOT NULL
);

CREATE TABLE AdminUpdate (
    AdminUpdateID INT IDENTITY(1,1) CONSTRAINT PK_AdminUpdate PRIMARY KEY,
    UpdateType NVARCHAR(50) NOT NULL,
    UpdateDateTime DATETIME NOT NULL,
    UpdatedValues NVARCHAR(255),
    OldScore INT
);
--check this
CREATE TABLE FanTeam (
    FanTeamID INT IDENTITY(1,1) CONSTRAINT PK_FanTeam PRIMARY KEY,
    PrimaryTeam BIT NOT NULL
);

CREATE TABLE AppUser (
    AppUserID INT IDENTITY(1,1) CONSTRAINT PK_AppUser PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    UserRole NVARCHAR(50) NOT NULL
);





 