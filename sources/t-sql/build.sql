CREATE TABLE Trades 
    (
    [TradeId]      INT           IDENTITY(1,1) PRIMARY KEY,
     [Value]        DECIMAL(30,4) NOT NULL,
     [ClientSector] VARCHAR(10)   NOT NULL CHECK (ClientSector IN ( 'Public',  'Private')),
     [Category]     VARCHAR  (10)           CHECK (Category     IN ( 'LOWRISK', 'MEDIUMRISK', 'HIGHRISK', 'UNKNOWN')),     
    );

CREATE TRIGGER dbo.Trades_Updated ON dbo.Trades FOR INSERT, UPDATE AS 
BEGIN
  DECLARE @result       VARCHAR(30)
  DECLARE @TradeId      INT
  DECLARE @Value        FLOAT
  DECLARE @ClientSector VARCHAR(10)
  
  DECLARE trade CURSOR FOR SELECT [TradeId],[Value],[ClientSector] FROM INSERTED

  OPEN trade
  FETCH NEXT FROM trade INTO @TradeId, @Value, @ClientSector    
  WHILE @@FETCH_STATUS = 0  
  BEGIN
    SET @result = dbo.RulesApply(@Value, @ClientSector)
    UPDATE Trades SET Category = @result WHERE TradeId = @TradeId
    FETCH NEXT FROM trade INTO @TradeId, @Value, @ClientSector
  END
  CLOSE trade
END;


CREATE FUNCTION dbo.RulesApply(
    @Value        FLOAT,
    @ClientSector VARCHAR(10)
)
RETURNS VARCHAR(200)
AS 
BEGIN
  DECLARE @result      VARCHAR (30)

  SET @result = dbo.RuleLowRisk(@Value, @ClientSector)
  IF NOT @result IS NULL
    RETURN @result
  
  SET @result = dbo.RuleMediumRisk(@Value, @ClientSector)
  IF NOT @result IS NULL
    RETURN @result
  
  SET @result = dbo.RuleHighRisk(@Value, @ClientSector)
  IF NOT @result IS NULL
    RETURN @result
    
  RETURN 'UNKNOWN'
END;


CREATE FUNCTION dbo.RuleLowRisk(
    @Value        FLOAT,
    @ClientSector VARCHAR(10)
)
RETURNS VARCHAR(30)
AS 
BEGIN
    IF @Value < 1000000 AND @ClientSector = 'Public' 
      RETURN 'LOWRISK'
      
    RETURN NULL
END;


CREATE FUNCTION dbo.RuleMediumRisk(
    @Value        FLOAT,
    @ClientSector VARCHAR(10)
)
RETURNS VARCHAR(30)
AS 
BEGIN
    IF @Value >= 1000000 AND @ClientSector = 'Public' 
      RETURN 'MEDIUMRISK'
      
    RETURN NULL
END;


CREATE FUNCTION dbo.RuleHighRisk(
    @Value        FLOAT,
    @ClientSector VARCHAR(10)
)
RETURNS VARCHAR(30)
AS 
BEGIN
    IF @Value > 1000000 AND @ClientSector = 'Private' 
      RETURN 'HIGHRISK'
      
    RETURN NULL
END;



    
INSERT INTO Trades
    ([Value], [ClientSector])
VALUES
    ( 2000000, 'Private'),
    (  400000, 'Public' ),
    (  500000, 'Public' ),
    ( 3000000, 'Public' );


