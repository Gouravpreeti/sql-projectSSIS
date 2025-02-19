DECLARE @storeid AS INT=0 ,@prodidfk AS VARCHAR(100),@barcode AS VARCHAR(100)
DECLARE @tbl_tmpl AS TABLE ( storeid int,prodidfk varchar(200),barcode  varchar(100))
INSERT INTO @tbl_tmpl (storeid ,prodidfk ,barcode  )
select T2.sno stkm_storeidfk, bar_prodidfk,bar_barcode from Tbl_Barcode_Master T1 , tbl_store_master T2
where bar_barcode not like '%C1' AND  bar_prodidfk in (128696)
and T2.sno  in (42,3)
SELECT * FROM @tbl_tmpl
DECLARE boxwiseAvbl_cursor  CURSOR FORWARD_ONLY FOR
SELECT storeid ,prodidfk ,barcode  FROM @tbl_tmpl
OPEN boxwiseAvbl_cursor
FETCH NEXT FROM boxwiseAvbl_cursor INTO @storeid,@prodidfk,@barcode
WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT @storeid,@prodidfk,@barcode
	IF EXISTS (SELECT 1 FROM [dbo].[Tbl_barcode_Stock_Master] WHERE stkbar_storeidfk=@storeid AND stkbar_barcode=@barcode and stkbar_prodidfk=@prodidfk)
	BEGIN
	SELECT 'UPDATE'
			
	END
	ELSE
	BEGIN
	--SELECT 'INsert'
				INSERT INTO [dbo].[Tbl_barcode_Stock_Master] (Stkbar_prodidfk,Stkbar_barcode,Stkbar_storeidfk,Stkbar_quantity,Stkbar_Available)
				SELECT @prodidfk,@barcode,@storeid,0,(select * from [dbo].[getstockcount_virtual_part_barcode](@prodidfk ,@barcode,@storeid,6611,'','CMP240003'))
	END
    FETCH NEXT FROM boxwiseAvbl_cursor INTO @storeid,@prodidfk,@barcode
END
CLOSE boxwiseAvbl_cursor;
DEALLOCATE boxwiseAvbl_cursor;


