/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Miljo]
      ,[Bolag]
      ,[Gren]
      ,[Skatt]
      ,[Grunder]
      ,[FromDate]
      ,[PrStk]
      ,[PrProp]
      ,[UtbProp]
      ,[Delta]
      ,[EpsDelta]
      ,[RSaker]
      ,[EpsSkatt]
      ,[GMY]
      ,[AMyMan]
      ,[BMyMan]
      ,[CMyMan]
      ,[AMyKv]
      ,[BMyKv]
      ,[CMyKv]
      ,[ArsAvgift]
      ,[KurvNamn]
      ,[FodelseDatumFrom]
      ,[FodelseDatumTill]
  FROM [LABAN].[dbo].[Grunder]


SELECT *
FROM [LABAN].[dbo].[Grunder]
WHERE Grunder = 'PRES'
AND Miljo = 'P'
AND Gren = 'SL'
AND FromDate > '2013-12-31'
ORDER BY FromDate

DECLARE @sex as CHAR(1)
DECLARE @birth as DATE;
SET @sex = 'm'
SET @birth = '1966-09-05'
SELECT 
CASE WHEN @sex = 'm' THEN AMyMan ELSE AMyKv END a,
CASE WHEN @sex = 'm' THEN BMyMan ELSE BMyKv END b,
CASE WHEN @sex = 'm' THEN CMyMan ELSE CMyKv END c
FROM Grunder
WHERE Grunder = 'PRES'
AND Miljo = 'P'
AND Gren = 'SL'
AND FodelseDatumFrom <= @birth
AND FodelseDatumTill >= @birth
AND FromDate = '2014-04-30'
ORDER BY FromDate


SELECT *
FROM [Laban].[dbo].[NSSParametrar]
WHERE KurvNamn = 'TJP1'
AND FromDate =
(SELECT MAX(FromDate)
FROM [Laban].[dbo].[NSSParametrar]
WHERE KurvNamn IN ('TJP1')
AND FromDate <= '2015-07-01')

SELECT *
FROM NSSParametrar
WHERE KurvNamn = 'TJP1'
AND FromDate =
(SELECT MAX(FromDate)
FROM NSSParametrar
WHERE KurvNamn IN ('TJP1')
AND FromDate <= '2015-07-01')

SELECT * FROM NSSParametrar WHERE KurvNamn = 'TJP1' AND FromDate = (SELECT MAX(FromDate) FROM NSSParametrar WHERE KurvNamn IN ('TJP1') AND FromDate <= '2015-07-01')

SELECT * FROM NSSParametrar WHERE KurvNamn = ' TJP1 ' AND Grund = ' PRES ' AND FromDate = (SELECT MAX(FromDate) FROM NSSParametrar WHERE KurvNamn = ' TJP1 ' AND FromDate <= '2015-07-01')

SELECT * FROM NSSParametrar WHERE KurvNamn = 'TJP1' AND Grunder = 'PRES' AND FromDate = (SELECT MAX(FromDate) FROM NSSParametrar WHERE KurvNamn = 'TJP1' AND FromDate <= '2015-07-01')

SELECT * FROM NSSParametrar WHERE KurvNamn = 'TJP1' AND Grunder = 'PRES' AND FromDate = (SELECT MAX(FromDate) FROM NSSParametrar WHERE KurvNamn = 'TJP1' AND FromDate <= '2015-07-01')

SELECT * FROM NSSParametrar WHERE KurvNamn = 'TJP1' AND Grunder = 'PRES' AND FromDate = (SELECT MAX(FromDate) FROM NSSParametrar WHERE KurvNamn = 'TJP1' AND FromDate <= '2015-07-01')