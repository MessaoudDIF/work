if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Sys_DailyMaintenance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Sys_DailyMaintenance]
GO

CREATE PROCEDURE sp_Sys_DailyMaintenance
			(
			@CalcABC	bit = 1,
			@CalcAvg	bit = 1,
			@DelHold	bit = 1
			)
AS

/* ---------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		Deleta os holds antigos

		- Deleto PreInventoryMov
		- Deleto Invoice
		- Atualizo Model

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-200  Erro em Insiro em DailyMaintenanceReport
		-201  Erro em Calcular ABC dos modelos
		-202  Erro em Calcular ABC dos modelos por loja
		-203  Erro em Calcular ponto de pedido e criar auto-requisi��es
		-204  Erro em Calcular o saldo em estoque e o custo m�dio
		-205  Erro em Atualizar a �ltima data processada em DailyMaintenanceReport
		-206  Erro em Deleto PreInventoryMov
		-207  Erro em Atualizo Model
		-208  Erro em Altera o status do processamento ap�s a conclus�o


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	-----------------------	-----------------------	----------------------------------------------------------------------------------
	15 May	2000		Rodrigo Costa		Criacao;
	25 Jun	2001		Davi Gouveia		Log de Return Values;
	18 Aug	2004		Rodrigo Costa		Gravar error log;
	05 Jan	2007		Rodrigo Costa		Deletar hold com um cursor;
	09 Feb	2007		Maximiliano Muniz	Inclus�o de apenas um registro na tabela DailyMaintenanceReport;
	16 Feb	2007		Maximiliano Muniz	Chamada da SP de c�lculo de saldo de estoque e custo m�dio;
	06 Mar	2007		Rodrigo Costa		Criado parametros para executar as opcoes
	---------------------------------------------------------------------------------------------------------------------------------- */

DECLARE @IDPreSale	int
DECLARE @DelHoldDay	int
DECLARE @DelItemMonth	int
DECLARE @ErrorLevel 	int
DECLARE @SysError	int
DECLARE @Today		datetime
DECLARE @LastProcess	datetime
DECLARE	@IDDayMaint	int
DECLARE	@Date		DateTime

SET @ErrorLevel = 0

SELECT 	@DelHoldDay = Convert(Int, SrvValue) FROM Param (NOLOCK)  WHERE IDParam = 18
SELECT 	@DelItemMonth = Convert(Int, SrvValue) FROM Param (NOLOCK) WHERE IDParam = 17

-- Garanto que nao estao nulos
SELECT @DelHoldDay = IsNull(@DelHoldDay, 0) 
SELECT @DelItemMonth = IsNull(@DelItemMonth, 0)

-------------------------------------------------------------------------------------------------------------------------
-- Pego a �ltima data processada ou a primeira data a processar
SELECT @Today		= CONVERT(smalldatetime, CONVERT(varchar, GetDate(), 103), 103)
SELECT @LastProcess	= CONVERT(smalldatetime, CONVERT(varchar, MAX(Date), 103), 103) FROM DailyMaintenanceReport (NOLOCK) WHERE Maintenance = 'DailyMaintenance'

IF @LastProcess = @Today
	RETURN
ELSE
BEGIN
	IF @LastProcess > 0
		SET @LastProcess = DateAdd(DAY, 1, @LastProcess)
	ELSE
	BEGIN
		----------------------------------------------------------------------------------------------------------
		-- Se ainda n�o processou nenhuma vez, insiro em DailyMaintenanceReport
		-- com a data da primeira movimenta��o do sitema
		SELECT @LastProcess = @Today

		exec sp_Sis_GetNextCode 'DailyMaintenanceReport.IDDailyMaintenanceReport', @IDDayMaint OUTPUT
		INSERT DailyMaintenanceReport 
			(
			IDDailyMaintenanceReport,
			Maintenance,
			[Date],
			LastMessage
			)
			VALUES
			(
			@IDDayMaint,
			'DailyMaintenance',
			@LastProcess,
			'Started'
			)
		
		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
			SET @ErrorLevel = -200
			GOTO ERRO
		END
	END
END



IF @CalcABC = 1
BEGIN
	-------------------------------------------------------------------------------------------------
	-- Calcular ABC dos modelos
	exec sp_Inv_CalcModelABC
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -201
	
		GOTO ERRO
	END
	
	-------------------------------------------------------------------------------------------------
	-- Calcular ABC dos modelos por loja
	exec sp_Inv_CalcStoreABC	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -202
	
		GOTO ERRO
	END
	
	-------------------------------------------------------------------------------------------------
	-- Calcular ponto de pedido e criar auto-requisi��es
	exec sp_PO_CalcOrderPointSimple
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -203
	
		GOTO ERRO
	END
END



IF @CalcAvg = 1
BEGIN
	-------------------------------------------------------------------------------------------------
	-- Calcular o saldo em estoque e o custo m�dio
	exec sp_Inv_CalcBalance
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -204
	
		GOTO ERRO
	END
END

BEGIN TRANSACTION

-----------------------------------------------------------------------------------------------------------------
-- Atualizar a �ltima data processada em DailyMaintenanceReport
UPDATE DailyMaintenanceReport SET [Date] = @Today, LastMessage = 'Started' WHERE Maintenance = 'DailyMaintenance'

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -205
	GOTO ERRO
END



IF @DelHold = 1
BEGIN

	IF @DelHoldDay > 0
	BEGIN
	
	/* ------------------------------------------------------------------------------------ */
	/*	Deletar movimenta�ao de cancelamento com base na movimenta��o anterior		*/
	/* ------------------------------------------------------------------------------------ */ 
	--Declara��o do Cursor de HoldDel_Cursor
	DECLARE HoldDel_Cursor CURSOR STATIC FOR 
		SELECT
			IDPreSale
		FROM
			Invoice (NOLOCK) 
		WHERE
			Invoice.IDInvoice IS NULL
			AND
			DateAdd(dd, @DelHoldDay, IsNull(EstimatedPay, Invoice.PreSaleDate)) < GetDate()
			AND
			Layaway <> 1
	
	OPEN HoldDel_Cursor
	
	--Inicializa��o de PreInv_Cursor
	FETCH NEXT FROM HoldDel_Cursor INTO
	            @IDPreSale
	
	--Enquanto tem registros
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Deletar os items
		EXEC sp_PreSale_Remove @IDPreSale, 0
	
		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
		            SET @ErrorLevel = -206
		            GOTO ERRO
		END
	
	
		FETCH NEXT FROM HoldDel_Cursor INTO
	                        @IDPreSale
	END
	
	--fechamento do cursor
	CLOSE HoldDel_Cursor
	--Destrui��o do cursor
	DEALLOCATE HoldDel_Cursor
	
	END
	
	IF @DelItemMonth > 0
	BEGIN

		SELECT
			M.IDModel
		INTO 
			#ModelToDelete
		FROM
			Model M (NOLOCK)
			JOIN (SELECT MAX(IDInventoryMov) as IDInv, I.ModelID
			FROM InventoryMov I (NOLOCK)
			WHERE DateAdd(mm, @DelItemMonth, I.MovDate) < GetDate()
			AND I.InventMovTypeID IN (1,2)
			GROUP BY I.ModelID
			) I ON (M.IDModel = I.ModelID)
		WHERE
			M.Desativado = 0
			AND
			M.TotQtyOnHand = 0
	
		/*
	  	INSERT 	InventoryMov (InventMovTypeID, DocumentID, StoreID, ModelID, MovDate, Qty)
	        SELECT  20, 1, 1, IDModel, GetDate(), 0
		FROM	#ModelToDelete
		*/
	
		-- Atualizo Model
		UPDATE
			Model
		SET
			Desativado = 1
		FROM
			#ModelToDelete MTD
		WHERE
			Model.IDModel = MTD.IDModel
	
		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
			SET @ErrorLevel = -207
			GOTO ERRO
		END
	
		DROP TABLE #ModelToDelete
	END
END

-------------------------------------------------------------------------------------------------
-- Altera o status do processamento ap�s a conclus�o
UPDATE DailyMaintenanceReport SET LastMessage = 'Finished' WHERE Maintenance = 'DailyMaintenance'

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -208

	GOTO ERRO
END

OK:
	COMMIT TRANSACTION
	RETURN 0

ERRO:
	ROLLBACK TRANSACTION
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'System', 'Error: sp_DailyMaintenance', @ErrorLevelStr

	RETURN @ErrorLevel
GO
