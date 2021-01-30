

CREATE TABLE Trades 
    (
     [TradeId]      INT         IDENTITY(1,1) PRIMARY KEY,
     [Value]        DECIMAL(30,4) NOT NULL,
     [ClientSector] VARCHAR(10)   NOT NULL CHECK (ClientSector IN ( 'Public',  'Private')),
     [Category]     VARCHAR(10)            CHECK (Category     IN ( 'LOWRISK', 'MEDIUMRISK', 'HIGHRISK')),
    )
;


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



INSERT INTO Trades
    ([Value], [ClientSector])
VALUES
    ( 2000000, 'Private'),
    (  400000, 'Public' ),
    (  500000, 'Public' ),
    ( 3000000, 'Public' )
;


