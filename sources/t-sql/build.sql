

CREATE TABLE Trades 
    (
     [TradeId]      INT           IDENTITY(1,1) PRIMARY KEY,
     [Value]        DECIMAL(30,4) NOT NULL,
     [ClientSector] VARCHAR(10)   NOT NULL CHECK (ClientSector IN ( 'Public',  'Private')),
     [Category]     VARCHAR(10)            CHECK (Category     IN ( 'LOWRISK', 'MEDIUMRISK', 'HIGHRISK'))
    );

CREATE TABLE Rules 
    (
     [RuleId]       INT           IDENTITY(1,1) PRIMARY KEY,
     [Name]         VARCHAR(30)   NOT NULL, 
     [Function]     VARCHAR(30)   NOT NULL,
     [Description]  VARCHAR(200) 
    );

CREATE TABLE RulesApplications 
    (
     [RuleAppId]     INT           IDENTITY(1,1) PRIMARY KEY,
     [Name]          VARCHAR(30)   NOT NULL,
     [Description]   VARCHAR(200) 
    );

CREATE TABLE RulesScripts 
    (
     [RulesScriptId] INT           IDENTITY(1,1) PRIMARY KEY,
     [RuleAppId]     INT,
     [RuleId]        INT,
     [Order]         INT,
     [Enabled]       BIT NOT NULL  DEFAULT 0, 
    );
    
CREATE FUNCTION dbo.RuleLowRisk(
    @Value        FLOAT,
    @ClientSector VARCHAR(10)
)
RETURNS BIT
AS 
BEGIN
    IF @Value < 1000000 AND @ClientSector = 'Public' 
      RETURN 1
      
    RETURN 0
END;


-- SET IDENTITY_INSERT dbo.RulesApplications ON;
SET IDENTITY_INSERT dbo.Rules             ON;


INSERT INTO Rules
    ([RuleId], [Name], [Function], [Description])
VALUES
    ( 1, 'Low Risk', 'RuleLowRisk', 'Low Risk Calculation for Trades');


INSERT INTO RulesApplications
    ([Name], [Description])
VALUES
    ('Risk Categorization', 'Determine risk categorization');


INSERT INTO RulesScripts
    ([RuleAppId], [RuleId], [Order], [Enabled])
VALUES
    ( 1, 1, 1, 1);
    
    
INSERT INTO Trades
    ([Value], [ClientSector])
VALUES
    ( 2000000, 'Private'),
    (  400000, 'Public' ),
    (  500000, 'Public' ),
    ( 3000000, 'Public' );


