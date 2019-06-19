declare @dimjunk table (Junkkey int identity(1,1),Nkey Int, SourceName varchar(200), PassWordHash varchar(200),PassWordSalt varchar(200), Runby varchar(200), 
				ThumbNailPhoto varchar(100), ThumbNailPhotoFileName varchar(100), Status varchar(200), OnlineOrderFlag varchar(200), ShipMethod varchar(100), 
				CreditCardApprovalCode varchar(100), Comment varchar(200))

Insert INTO @dimjunk (NKey, SourceName , PassWordHash , PassWordSalt , Runby , ThumbNailPhoto,ThumbNailPhotoFileName , Status , OnlineOrderFlag , ShipMethod ,
							CreditCardApprovalCode , Comment )
/*the first row has to be a null handling row to record null values but that has contextual meaning*/
select * from (
select -1 Nkey, 'NA' SourceName , 'NA' PassWordHash ,'NA' PassWordSalt, 'NA' Runby, 'NA' ThumbNailPhoto,'NA' ThumbNailPhotoFileName , 
			'NA' Status, 'NA' OnlineOrderFlag, 'NA' ShipMethod,	'NA' CreditCardApprovalCode , 'NA' Comment 
) x


; WITH Nkey
 AS
 (SELECT 1 AS Nkey
 UNION
 SELECT 2 AS Nkey
 )
 ,
  SourceName
 AS
 (SELECT 'MS' AS SourceName
 UNION
 SELECT 'SP' AS SourceName
 )
  ,
 PassWordHash
  AS
 (SELECT 'Null' AS PassWordHash)
 
 ,
 PassWordSalt
  AS
 (SELECT 'Null' AS PassWordSalt)
 ,

 Runby
  AS
 (SELECT 'AyNi' AS  Runby)

 ,

 ThumbNailPhoto
  AS
 (SELECT 'Null' AS ThumbNailPhoto)

  ,

 ThumbNailPhotoFileName
  AS
 (SELECT 'Null' AS  ThumbNailPhotoFileName)

  ,

 Status
  AS
 (SELECT '1' AS Status
 UNION
 SELECT '2' AS Status
 UNION
  SELECT '3' AS Status
 UNION
 SELECT '4' AS Status
 UNION
 SELECT '5' AS Status)
  ,
  
   OnlineOrderFlag
  AS
 (SELECT '1' AS  OnlineOrderFlag
 UNION
 SELECT '0' AS  OnlineOrderFlag
 )
 ,

  ShipMethod
  AS
 (SELECT 'CargoTransport' AS  ShipMethod)
 ,

 CreditCardApprovalCode
  AS
 (SELECT 'Null' AS  CreditCardApprovalCode)
 ,

 Comment
  AS
 (SELECT 'Null' AS Comment)
 Insert INTO @dimjunk (NKey, SourceName , PassWordHash,PassWordSalt , Runby , ThumbNailPhoto,ThumbNailPhotoFileName , Status , OnlineOrderFlag , ShipMethod ,
							CreditCardApprovalCode , Comment)

 SELECT * FROM NKey
 CROSS JOIN SourceName 
 CROSS JOIN PassWordHash
 Cross Join PassWordSalt
 CROSS JOIN Runby
 Cross Join ThumbNailPhoto
 CROSS JOIN ThumbNailPhotoFileName
 Cross Join Status
 Cross Join OnlineOrderFlag
 CROSS JOIN ShipMethod
 Cross Join CreditCardApprovalCode
 Cross Join Comment
 
 select * into dimJunk1 from @dimjunk


select * from dimJunk1