if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Inv_CalcBalance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Inv_CalcBalance]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Inv_CalcBalanceT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Inv_CalcBalanceT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Inv_CalcModelBalance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Inv_CalcModelBalance]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Inv_CalcModelBalanceT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Inv_CalcModelBalanceT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Inv_CalcModelStoreBalance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Inv_CalcModelStoreBalance]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Inv_CalcModelStoreBalanceT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Inv_CalcModelStoreBalanceT]
GO

CREATE  PROCEDURE sp_Inv_CalcBalance
AS
/* -----------------------------------------------------------------------------------------------------------
	SUMARIO

		Calculo dinamico de saldo de quantidade e valor em estoque
		por Maximiliano Muniz em 17 de Outubro de 2006.

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em Se ainda n�o processou nenhuma vez, insiro em DailyMaintenanceReport com a data da primeira movimenta��o do sitema
		-202  Erro em Atualizar a �ltima data processada em DailyMaintenanceReport
		-203  Erro em Calcular o saldo pelo estoque total
		-204  Erro em Calcular o saldo pelo estoque por loja
		-205  Erro em Altera o status do processamento ap�s a conclus�o

	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	-----------------------	-----------------------	------------------------------------------------------
	17 Oct	2006		Maximiliano Muniz	Criacao;
	14 May	2007		Maximiliano Muniz	Adicionado "exec" da nova SP para c�lculo por loja;
	------------------------------------------------------------------------------------------------------ */

DECLARE @ErrorLevel	int
DECLARE @SysError	int
DECLARE @IDDayMaint	int
DECLARE @LastProcess	datetime
DECLARE @Today		datetime
DECLARE @MovDate	datetime

SET @ErrorLevel = 0
SET @LastProcess = 0

--------------------------------------------------------------------------------------------------------------
-- Pego a �ltima data processada ou a primeira data a processar
SELECT @Today	= CONVERT(smalldatetime, CONVERT(varchar, GetDate(), 103), 103)
SELECT @LastProcess	= CONVERT(smalldatetime, CONVERT(varchar, MAX(Date), 103), 103) FROM DailyMaintenanceReport (NOLOCK)  WHERE Maintenance = 'CalcInventoryBalance'

IF @LastProcess = @Today
	RETURN
ELSE
BEGIN
	IF @LastProcess > 0
		SET @LastProcess = DateAdd(DAY, 1, @LastProcess)
	ELSE
	BEGIN
		----------------------------------------------------------------------------------------------
		-- Se ainda n�o processou nenhuma vez, insiro em DailyMaintenanceReport
		-- com a data da primeira movimenta��o do sitema
		SELECT @LastProcess = CONVERT(smalldatetime, CONVERT(varchar, MIN(MovDate), 103), 103) FROM InventoryMov (NOLOCK)

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
			'CalcInventoryBalance',
			@LastProcess,
			'Started'
			)
		
		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
			SET @ErrorLevel = -201
			GOTO ERRO
		END
	END
END

--------------------------------------------------------------------------------------------------------------
-- Ser�o processadas todas as datas que possuem movimenta��o, a partir da �ltima data processada
DECLARE MOVDATE_CUR CURSOR FOR 
SELECT
	CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103)
FROM
	InventoryMov (NOLOCK)
WHERE
	CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103) >= @LastProcess
GROUP BY
	CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103)
ORDER BY
	CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103)

OPEN MOVDATE_CUR

FETCH NEXT FROM MOVDATE_CUR INTO
	@MovDate

WHILE @@FETCH_STATUS = 0
BEGIN
	------------------------------------------------------------------------------------------------------
	-- Atualizar a �ltima data processada em DailyMaintenanceReport
	UPDATE DailyMaintenanceReport SET LastMessage = 'Started' WHERE Maintenance = 'CalcInventoryBalance'
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -202
		GOTO ERRO
	END

	------------------------------------------------------------------------------------------------------
	-- Calculo do saldo pelo estoque total
	exec sp_Inv_CalcModelBalance @MovDate
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -203
		GOTO ERRO
	END
	
	------------------------------------------------------------------------------------------------------
	-- Calculo do saldo pelo estoque por loja
	exec sp_Inv_CalcModelStoreBalance @MovDate
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -204
		GOTO ERRO
	END
	
	------------------------------------------------------------------------------------------------------
	-- Altera o status do processamento ap�s a conclus�o
	UPDATE DailyMaintenanceReport SET LastMessage = 'Finished' WHERE Maintenance = 'CalcInventoryBalance'
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -205
		GOTO ERRO
	END

	FETCH NEXT FROM MOVDATE_CUR INTO
		@MovDate
END

CLOSE MOVDATE_CUR
DEALLOCATE MOVDATE_CUR

OK:
	RETURN 0
ERRO:
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'System', 'Error: sp_Inv_CalcBalance', @ErrorLevelStr

	RETURN @ErrorLevel


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE  PROCEDURE sp_Inv_CalcBalanceT (@IDModel int, @ProcessDate datetime)
AS

DECLARE @ErrorLevel	int
DECLARE @SysError	int
DECLARE @MovDate	datetime

SET @ErrorLevel = 0
SET @ProcessDate = 0

--------------------------------------------------------------------------------------------------------------
-- Ser�o processadas todas as datas que possuem movimenta��o, a partir da �ltima data processada
DECLARE MOVDATE_CUR CURSOR FOR 
SELECT
	CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103)
FROM
	InventoryMov (NOLOCK)
WHERE
	ModelID = @IDModel
	AND CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103) >= @ProcessDate
GROUP BY
	CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103)
ORDER BY
	CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103)

OPEN MOVDATE_CUR

FETCH NEXT FROM MOVDATE_CUR INTO
	@MovDate

WHILE @@FETCH_STATUS = 0
BEGIN
	------------------------------------------------------------------------------------------------------
	-- Calculo do saldo pelo estoque total
	exec sp_Inv_CalcModelBalanceT @IDModel, @MovDate
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -203
		GOTO ERRO
	END
	
	------------------------------------------------------------------------------------------------------
	-- Calculo do saldo pelo estoque por loja
	exec sp_Inv_CalcModelStoreBalanceT @IDModel, @MovDate
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -204
		GOTO ERRO
	END

	FETCH NEXT FROM MOVDATE_CUR INTO
		@MovDate
END

CLOSE MOVDATE_CUR
DEALLOCATE MOVDATE_CUR

OK:
	RETURN 0
ERRO:
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'System', 'Error: sp_Inv_CalcBalance', @ErrorLevelStr

	RETURN @ErrorLevel





GO

CREATE PROCEDURE sp_Inv_CalcModelBalance (@ProcessDate datetime)
AS
/* -------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO
	1 - Deletar todos os saldos a partir da data a processar
	2 - Pegar a ultima linha de saldo imediatamente antes da data a processar
	3 - Fazer la�o com as movimenta��es a partir da data a processar
	4 - Atualizar quantidade e custo m�dio

	LOG DE MODIFICA��ES

	Data			Programador					Modifica��o
	----------------------- -----------------------------------------------	--------------------------------------------------------
	22 Sep	2006		Carlos Lima, Leonardo Riego e Max Muniz		Cria��o
    	-------------------------------------------------------------------------------------------------------------------------------- */

DECLARE @IDModel		int
DECLARE @MovQty			float
DECLARE @ModelQty		float
DECLARE @StoreQty		float
DECLARE @MovCost		money
DECLARE @AvgCostOut		money
DECLARE @ModelBalanceTotal	money
DECLARE @StoreBalanceTotal	money
DECLARE @LastAvgCost		money
DECLARE @NewAvgCost		money
DECLARE @HasMov			integer

DECLARE MODEL_CUR CURSOR FOR 
SELECT
	M.IDModel
FROM
	Model M (NOLOCK)
ORDER BY
	M.IDModel

OPEN MODEL_CUR

FETCH NEXT FROM MODEL_CUR INTO
	@IDModel

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Deleto os saldos a partir da data de processamento
	DELETE Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate >= @ProcessDate


	SELECT @HasMov = COUNT(*)
	FROM InventoryMov IM (NOLOCK)
	WHERE IM.ModelID = @IDModel AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate AND IM.InventMovTypeID IN (1, 2, 3, 4, 5, 11, 12, 19, 21, 22)


	IF @HasMov > 0
	BEGIN
		SET @ModelQty = 0
		SET @AvgCostOut = 0
		SET @ModelBalanceTotal = 0

		INSERT INTO Inv_ModelBalance (IDModel, BalanceDate, Qty, AvgCostOut, BalanceTotal)
		VALUES (@IDModel, @ProcessDate, @ModelQty, @AvgCostOut, @ModelBalanceTotal)


		-------------------------------------------------------------------------------------------------
		-- Pego os valores de quantidade e saldo do modelo, da �ltima data antes da data de processamento
		SELECT
			@ModelQty = MB.Qty,
			@AvgCostOut = MB.AvgCostOut,
			@ModelBalanceTotal = MB.BalanceTotal
		FROM
			Inv_ModelBalance MB (NOLOCK)
		WHERE
			MB.IDModel = @IDModel
			AND MB.BalanceDate = (	SELECT MAX(MB.BalanceDate)
						FROM Inv_ModelBalance MB
						WHERE MB.IDModel = @IDModel AND MB.BalanceDate < @ProcessDate
						GROUP BY MB.IDModel)


		----------------------------------------------------------------------
		-- Calculo o custo m�dio da �ltima data antes da data de processamento
		IF @ModelQty > 0
			SET @LastAvgCost = @ModelBalanceTotal / @ModelQty
		ELSE
			SET @LastAvgCost = 0


		-------------------------------------------------------------------------------------------------------
		-- Pego o total de quantidades de entrada, sem compras e importa��o. Esta quantidade ser� adicionada �
		-- quantidade total de estoque, sem afetar o custo m�dio.
		SET @MovQty = 0
		SELECT
			@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
		FROM
			InventoryMov IM (NOLOCK)
			JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
		WHERE
			IM.ModelID = @IDModel
			AND IMT.UpdateOnHand = 1
			AND (IMT.IDInventMovType in (4, 11, 19, 21) OR (IMT.IDInventMovType = 2 AND IM.Qty < 0))
			AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
		GROUP BY
			IM.ModelID


		-----------------------------------------------------
		-- Calculo a nova quantidade e valor total do estoque
		SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)
		IF @ModelQty > 0
		BEGIN
			SET @ModelBalanceTotal = @ModelBalanceTotal + (IsNull(@MovQty, 0) * @LastAvgCost)
			SET @AvgCostOut = @ModelBalanceTotal / @ModelQty
		END
		ELSE
			SET @ModelBalanceTotal = 0


		---------------------------------------------------------
		-- Pego a quantidade e o custo total comprado e importado
		SET @MovQty = 0
		SET @MovCost = 0
		SELECT
			@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)),
			@MovCost = SUM(IsNull(IM.CostPrice, 0) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)))
		FROM
			InventoryMov IM (NOLOCK)
			JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
		WHERE
			IM.ModelID = @IDModel
			AND IMT.UpdateOnHand = 1
			AND (IMT.IDInventMovType in (2, 5) AND IM.Qty > 0)
			AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
		GROUP BY
			IM.ModelID


		---------------------------------------------------------------------------------------------------
		-- Calculo a nova quantidade e valor total do estoque. Se a quantidade em estoque antes das compras
		-- for negativa, deve ser encontrado o custo m�dio das compras para achar o valor total de estoque
		-- com a diferen�a entre a quantidade anterior e a comprada.
		IF (@ModelQty + @MovQty) > 0
		BEGIN
			IF @ModelQty < 0
				SET @ModelBalanceTotal = (@MovCost / @MovQty) * (@ModelQty + @MovQty)
			ELSE
				SET @ModelBalanceTotal = @ModelBalanceTotal + @MovCost

			SET @AvgCostOut = @ModelBalanceTotal / (@ModelQty + @MovQty)
			SET @NewAvgCost = @ModelBalanceTotal / (@ModelQty + @MovQty)
		END
		ELSE
		BEGIN
			SET @ModelBalanceTotal = 0
			SET @NewAvgCost = 0
		END

		SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)


		------------------------------------------------------------------------------------------------
		-- Atualizo o saldo da data a processar calculando com base nas movimenta��es de entrada do dia.
		UPDATE
			Inv_ModelBalance
		SET
			Qty = @ModelQty,
			AvgCostOut = @AvgCostOut,
			BalanceTotal = @ModelBalanceTotal
		WHERE
			IDModel = @IDModel
			AND BalanceDate = @ProcessDate


		-------------------------------------------------------------------------------------------------------
		-- Pego o total de quantidades de sa�da. Esta quantidade ser� removida da quantidade total de estoque,
		-- sem afetar o custo m�dio, desde que n�o zere a quantidade.
		SET @MovQty = 0
		SELECT
			@NewAvgCost = SUM((CASE WHEN IsNull(IM.Qty, 0) > 0 THEN (CASE WHEN @NewAvgCost > 0 THEN @NewAvgCost ELSE @AvgCostOut END) ELSE ISNULL(EXAVG.AvgCostOut, @AvgCostOut) END) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))),
			@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
		FROM
			InventoryMov IM (NOLOCK)
			JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
			LEFT OUTER JOIN (SELECT ModelID, PreInventoryMovID, CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103) MovDate FROM InventoryMov  (NOLOCK) WHERE ModelID = @IDModel) EX ON (IM.ModelID = EX.ModelID AND IM.IDPreInvMovExchange = EX.PreInventoryMovID)
			LEFT OUTER JOIN (SELECT IDModel, BalanceDate, AvgCostOut FROM Inv_ModelBalance (NOLOCK) WHERE IDModel = @IDModel) EXAVG ON (IM.ModelID = EXAVG.IDModel AND CONVERT(smalldatetime, CONVERT(varchar, EX.MovDate, 103), 103) = EXAVG.BalanceDate)
		WHERE
			IM.ModelID = @IDModel
			AND IMT.UpdateOnHand = 0
			AND IMT.IDInventMovType in (1, 3, 12, 22)
			AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
		GROUP BY
			IM.ModelID

		IF @MovQty <> 0
		BEGIN
			SET @ModelQty = @ModelQty + @MovQty
			IF @ModelQty > 0
					SET @ModelBalanceTotal = @ModelBalanceTotal + @NewAvgCost
			ELSE
				SET @ModelBalanceTotal = 0

			UPDATE Inv_ModelBalance
			SET Qty = @ModelQty, AvgCostOut = (CASE WHEN @ModelQty > 0 THEN @ModelBalanceTotal / @ModelQty ELSE @AvgCostOut END), BalanceTotal = @ModelBalanceTotal
			WHERE IDModel = @IDModel AND BalanceDate = @ProcessDate
		END
	END

	FETCH NEXT FROM MODEL_CUR INTO
		@IDModel
END

CLOSE MODEL_CUR
DEALLOCATE MODEL_CUR

GO

CREATE PROCEDURE sp_Inv_CalcModelBalanceT (@IDModel int, @ProcessDate datetime)
AS
/* -------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO
	1 - Deletar todos os saldos a partir da data a processar
	2 - Pegar a ultima linha de saldo imediatamente antes da data a processar
	3 - Fazer la�o com as movimenta��es a partir da data a processar
	4 - Atualizar quantidade e custo m�dio

	LOG DE MODIFICA��ES

	Data			Programador					Modifica��o
	----------------------- -----------------------------------------------	--------------------------------------------------------
	28 Oct	2008		Max Muniz					Cria��o
    	-------------------------------------------------------------------------------------------------------------------------------- */

DECLARE @MovQty			float
DECLARE @ModelQty		float
DECLARE @StoreQty		float
DECLARE @MovCost		money
DECLARE @AvgCostOut		money
DECLARE @ModelBalanceTotal	money
DECLARE @StoreBalanceTotal	money
DECLARE @LastAvgCost		money
DECLARE @NewAvgCost		money
DECLARE @HasMov			integer

-- Deleto os saldos a partir da data de processamento
DELETE Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate >= @ProcessDate


SELECT @HasMov = COUNT(*)
FROM InventoryMov IM (NOLOCK)
WHERE IM.ModelID = @IDModel AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate AND IM.InventMovTypeID IN (1, 2, 3, 4, 5, 11, 12, 19, 21, 22)


IF @HasMov > 0
BEGIN
	SET @ModelQty = 0
	SET @AvgCostOut = 0
	SET @ModelBalanceTotal = 0

	INSERT INTO Inv_ModelBalance (IDModel, BalanceDate, Qty, AvgCostOut, BalanceTotal)
	VALUES (@IDModel, @ProcessDate, @ModelQty, @AvgCostOut, @ModelBalanceTotal)


	-------------------------------------------------------------------------------------------------
	-- Pego os valores de quantidade e saldo do modelo, da �ltima data antes da data de processamento
	SELECT
		@ModelQty = MB.Qty,
		@AvgCostOut = MB.AvgCostOut,
		@ModelBalanceTotal = MB.BalanceTotal
	FROM
		Inv_ModelBalance MB (NOLOCK)
	WHERE
		MB.IDModel = @IDModel
		AND MB.BalanceDate = (	SELECT MAX(MB.BalanceDate)
					FROM Inv_ModelBalance MB
					WHERE MB.IDModel = @IDModel AND MB.BalanceDate < @ProcessDate
					GROUP BY MB.IDModel)


	----------------------------------------------------------------------
	-- Calculo o custo m�dio da �ltima data antes da data de processamento
	IF @ModelQty > 0
		SET @LastAvgCost = @ModelBalanceTotal / @ModelQty
	ELSE
		SET @LastAvgCost = 0


	-------------------------------------------------------------------------------------------------------
	-- Pego o total de quantidades de entrada, sem compras e importa��o. Esta quantidade ser� adicionada �
	-- quantidade total de estoque, sem afetar o custo m�dio.
	SET @MovQty = 0
	SELECT
		@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
	FROM
		InventoryMov IM (NOLOCK)
		JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
	WHERE
		IM.ModelID = @IDModel
		AND IMT.UpdateOnHand = 1
		AND (IMT.IDInventMovType in (4, 11, 19, 21) OR (IMT.IDInventMovType = 2 AND IM.Qty < 0))
		AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
	GROUP BY
		IM.ModelID


	-----------------------------------------------------
	-- Calculo a nova quantidade e valor total do estoque
	SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)
	IF @ModelQty > 0
	BEGIN
		SET @ModelBalanceTotal = @ModelBalanceTotal + (IsNull(@MovQty, 0) * @LastAvgCost)
		SET @AvgCostOut = @ModelBalanceTotal / @ModelQty
	END
	ELSE
		SET @ModelBalanceTotal = 0


	---------------------------------------------------------
	-- Pego a quantidade e o custo total comprado e importado
	SET @MovQty = 0
	SET @MovCost = 0
	SELECT
		@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)),
		@MovCost = SUM(IsNull(IM.CostPrice, 0) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)))
	FROM
		InventoryMov IM (NOLOCK)
		JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
	WHERE
		IM.ModelID = @IDModel
		AND IMT.UpdateOnHand = 1
		AND (IMT.IDInventMovType in (2, 5) AND IM.Qty > 0)
		AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
	GROUP BY
		IM.ModelID


	---------------------------------------------------------------------------------------------------
	-- Calculo a nova quantidade e valor total do estoque. Se a quantidade em estoque antes das compras
	-- for negativa, deve ser encontrado o custo m�dio das compras para achar o valor total de estoque
	-- com a diferen�a entre a quantidade anterior e a comprada.
	IF (@ModelQty + @MovQty) > 0
	BEGIN
		IF @ModelQty < 0
			SET @ModelBalanceTotal = (@MovCost / @MovQty) * (@ModelQty + @MovQty)
		ELSE
			SET @ModelBalanceTotal = @ModelBalanceTotal + @MovCost

		SET @AvgCostOut = @ModelBalanceTotal / (@ModelQty + @MovQty)
		SET @NewAvgCost = @ModelBalanceTotal / (@ModelQty + @MovQty)
	END
	ELSE
	BEGIN
		SET @ModelBalanceTotal = 0
		SET @NewAvgCost = 0
	END

	SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)


	------------------------------------------------------------------------------------------------
	-- Atualizo o saldo da data a processar calculando com base nas movimenta��es de entrada do dia.
	UPDATE
		Inv_ModelBalance
	SET
		Qty = @ModelQty,
		AvgCostOut = @AvgCostOut,
		BalanceTotal = @ModelBalanceTotal
	WHERE
		IDModel = @IDModel
		AND BalanceDate = @ProcessDate


	-------------------------------------------------------------------------------------------------------
	-- Pego o total de quantidades de sa�da. Esta quantidade ser� removida da quantidade total de estoque,
	-- sem afetar o custo m�dio, desde que n�o zere a quantidade.
	SET @MovQty = 0
	SELECT
		@NewAvgCost = SUM((CASE WHEN IsNull(IM.Qty, 0) > 0 THEN (CASE WHEN @NewAvgCost > 0 THEN @NewAvgCost ELSE @AvgCostOut END) ELSE ISNULL(EXAVG.AvgCostOut, @AvgCostOut) END) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))),
		@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
	FROM
		InventoryMov IM (NOLOCK)
		JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
		LEFT OUTER JOIN (SELECT ModelID, PreInventoryMovID, CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103) MovDate FROM InventoryMov  (NOLOCK) WHERE ModelID = @IDModel) EX ON (IM.ModelID = EX.ModelID AND IM.IDPreInvMovExchange = EX.PreInventoryMovID)
		LEFT OUTER JOIN (SELECT IDModel, BalanceDate, AvgCostOut FROM Inv_ModelBalance (NOLOCK) WHERE IDModel = @IDModel) EXAVG ON (IM.ModelID = EXAVG.IDModel AND CONVERT(smalldatetime, CONVERT(varchar, EX.MovDate, 103), 103) = EXAVG.BalanceDate)
	WHERE
		IM.ModelID = @IDModel
		AND IMT.UpdateOnHand = 0
		AND IMT.IDInventMovType in (1, 3, 12, 22)
		AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
	GROUP BY
		IM.ModelID

	IF @MovQty <> 0
	BEGIN
		SET @ModelQty = @ModelQty + @MovQty
		IF @ModelQty > 0
				SET @ModelBalanceTotal = @ModelBalanceTotal + @NewAvgCost
		ELSE
			SET @ModelBalanceTotal = 0

		UPDATE Inv_ModelBalance
		SET Qty = @ModelQty, AvgCostOut = (CASE WHEN @ModelQty > 0 THEN @ModelBalanceTotal / @ModelQty ELSE @AvgCostOut END), BalanceTotal = @ModelBalanceTotal
		WHERE IDModel = @IDModel AND BalanceDate = @ProcessDate
	END
END

GO

CREATE PROCEDURE sp_Inv_CalcModelStoreBalance (@ProcessDate datetime)
AS
/* -------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO
	1 - Deletar todos os saldos a partir da data a processar
	2 - Pegar a ultima linha de saldo imediatamente antes da data a processar
	3 - Fazer la�o com as movimenta��es a partir da data a processar
	4 - Atualizar quantidade e custo m�dio

	LOG DE MODIFICA��ES

	Data			Programador					Modifica��o
	----------------------- -----------------------------------------------	--------------------------------------------------------
	14 May	2007		Maximiliano Muniz				Cria��o
    	-------------------------------------------------------------------------------------------------------------------------------- */

DECLARE @IDStore		int
DECLARE @IDModel		int
DECLARE @MovQty			float
DECLARE @ModelQty		float
DECLARE @StoreQty		float
DECLARE @MovCost		money
DECLARE @AvgCostOut		money
DECLARE @ModelBalanceTotal	money
DECLARE @StoreBalanceTotal	money
DECLARE @LastAvgCost		money
DECLARE @NewAvgCost		money
DECLARE @HasMov			int

DECLARE MODEL_CUR CURSOR FOR 
SELECT
	M.IDModel
FROM
	Model M
ORDER BY
	M.IDModel

OPEN MODEL_CUR

FETCH NEXT FROM MODEL_CUR INTO
	@IDModel

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE STORE_CUR CURSOR FOR 
	SELECT
		S.IDStore
	FROM
		Store S
	WHERE
		S.System = 0
		AND S.Hidden = 0
		AND S.Desativado = 0
	ORDER BY
		S.IDStore
	
	OPEN STORE_CUR
	
	FETCH NEXT FROM STORE_CUR INTO
		@IDStore

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Deleto os saldos a partir da data de processamento
		DELETE Inv_ModelStoreBalance WHERE IDStore = @IDStore AND IDModel = @IDModel AND BalanceDate >= @ProcessDate

		SELECT @HasMov = COUNT(*)
		FROM InventoryMov IM (NOLOCK)
		WHERE IM.StoreID = @IDStore AND IM.ModelID = @IDModel AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate AND IM.InventMovTypeID IN (1, 2, 3, 4, 5, 7, 8, 11, 12, 19, 21, 22)

		IF @HasMov > 0
		BEGIN
			SET @ModelQty = 0
			SET @AvgCostOut = 0
			SET @ModelBalanceTotal = 0

			INSERT INTO Inv_ModelStoreBalance (IDStore, IDModel, BalanceDate, Qty, AvgCostOut, BalanceTotal)
			VALUES (@IDStore, @IDModel, @ProcessDate, @ModelQty, @AvgCostOut, @ModelBalanceTotal)

			-------------------------------------------------------------------------------------------------
			-- Pego os valores de quantidade e saldo do modelo, da �ltima data antes da data de processamento
			SELECT
				@ModelQty = MB.Qty,
				@AvgCostOut = MB.AvgCostOut,
				@ModelBalanceTotal = MB.BalanceTotal
			FROM
				Inv_ModelStoreBalance MB (NOLOCK)
			WHERE
				MB.IDStore = @IDStore
				AND MB.IDModel = @IDModel
				AND MB.BalanceDate = (	SELECT MAX(MB.BalanceDate)
							FROM Inv_ModelStoreBalance MB (NOLOCK) 
							WHERE MB.IDStore = @IDStore AND MB.IDModel = @IDModel AND MB.BalanceDate < @ProcessDate
							GROUP BY MB.IDModel)

			----------------------------------------------------------------------
			-- Calculo o custo m�dio da �ltima data antes da data de processamento
			IF @ModelQty > 0
				SET @LastAvgCost = @ModelBalanceTotal / @ModelQty
			ELSE
				SET @LastAvgCost = 0

			---------------------------------------------------------------------------------------------------
			-- Pego o total de quantidades de entrada, sem compras, transfer�ncia e importa��o. Esta quantidade
			-- ser� adicionada � quantidade total de estoque, sem afetar o custo m�dio.
			SET @MovQty = 0
			SELECT
				@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
			FROM
				InventoryMov IM (NOLOCK) 
				JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
			WHERE
				IM.StoreID = @IDStore
				AND IM.ModelID = @IDModel
				AND IMT.UpdateOnHand = 1
				AND (IMT.IDInventMovType in (4, 11, 19, 21) OR (IMT.IDInventMovType = 2 AND IM.Qty < 0))
				AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate

			GROUP BY
				IM.ModelID

			-----------------------------------------------------
			-- Calculo a nova quantidade e valor total do estoque
			SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)
			IF @ModelQty > 0
			BEGIN
				SET @ModelBalanceTotal = @ModelBalanceTotal + (IsNull(@MovQty, 0) * @LastAvgCost)
				SET @AvgCostOut = @ModelBalanceTotal / @ModelQty
			END
			ELSE
				SET @ModelBalanceTotal = 0

			----------------------------------------------------------------------
			-- Pego a quantidade e o custo total comprado, transferido e importado
			SET @MovQty = 0
			SET @MovCost = 0
			SELECT
				@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)),
				@MovCost = SUM(IsNull(IM.CostPrice, 0) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)))
			FROM
				InventoryMov IM (NOLOCK) 
				JOIN InventoryMovType IMT (NOLOCK)  ON (IM.InventMovTypeID = IMT.IDInventMovType)
			WHERE
				IM.StoreID = @IDStore
				AND IM.ModelID = @IDModel
				AND IMT.UpdateOnHand = 1
				AND (IMT.IDInventMovType in (2, 5, 8) AND IM.Qty > 0)
				AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
			GROUP BY
				IM.ModelID

			---------------------------------------------------------------------------------------------------
			-- Calculo a nova quantidade e valor total do estoque. Se a quantidade em estoque antes das compras
			-- for negativa, deve ser encontrado o custo m�dio das compras para achar o valor total de estoque
			-- com a diferen�a entre a quantidade anterior e a comprada.
			IF (@ModelQty + @MovQty) > 0
			BEGIN
				IF @ModelQty < 0
					SET @ModelBalanceTotal = (@MovCost / @MovQty) * (@ModelQty + @MovQty)
				ELSE
					SET @ModelBalanceTotal = @ModelBalanceTotal + @MovCost
	
				SET @AvgCostOut = @ModelBalanceTotal / (@ModelQty + @MovQty)
				SET @NewAvgCost = @ModelBalanceTotal / (@ModelQty + @MovQty)
			END
			ELSE
			BEGIN
				SET @ModelBalanceTotal = 0
				SET @NewAvgCost = 0
			END

			SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)

			------------------------------------------------------------------------------------------------
			-- Atualizo o saldo da data a processar calculando com base nas movimenta��es de entrada do dia.
			UPDATE
				Inv_ModelStoreBalance
			SET
				Qty = @ModelQty,
				AvgCostOut = (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate)),
				BalanceTotal = @ModelQty * (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate))
			WHERE
				IDStore = @IDStore
				AND IDModel = @IDModel
				AND BalanceDate = @ProcessDate

			-------------------------------------------------------------------------------------------------------
			-- Pego o total de quantidades de sa�da. Esta quantidade ser� removida da quantidade total de estoque,
			-- sem afetar o custo m�dio, desde que n�o zere a quantidade.
			SET @MovQty = 0
			SELECT
				@NewAvgCost = SUM((CASE WHEN IsNull(IM.Qty, 0) > 0 THEN (CASE WHEN @NewAvgCost > 0 THEN @NewAvgCost ELSE @AvgCostOut END) ELSE ISNULL(EXAVG.AvgCostOut, @AvgCostOut) END) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))),
				@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
			FROM
				InventoryMov IM (NOLOCK) 
				JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
				LEFT OUTER JOIN (SELECT ModelID, PreInventoryMovID, CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103) MovDate FROM InventoryMov (NOLOCK) WHERE StoreID = @IDStore AND ModelID = @IDModel) EX ON (IM.ModelID = EX.ModelID AND IM.IDPreInvMovExchange = EX.PreInventoryMovID)
				LEFT OUTER JOIN (SELECT IDModel, BalanceDate, AvgCostOut FROM Inv_ModelStoreBalance (NOLOCK) WHERE IDStore = @IDStore AND IDModel = @IDModel) EXAVG ON (IM.ModelID = EXAVG.IDModel AND CONVERT(smalldatetime, CONVERT(varchar, EX.MovDate, 103), 103) = EXAVG.BalanceDate)
			WHERE
				IM.StoreID = @IDStore
				AND IM.ModelID = @IDModel
				AND IMT.UpdateOnHand = 0
				AND IMT.IDInventMovType in (1, 3, 7, 12, 22)
				AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
			GROUP BY
				IM.ModelID

			IF @MovQty <> 0
			BEGIN
				SET @ModelQty = @ModelQty + @MovQty
				IF @ModelQty > 0
						SET @ModelBalanceTotal = @ModelBalanceTotal + @NewAvgCost
				ELSE
					SET @ModelBalanceTotal = 0
	
				UPDATE Inv_ModelStoreBalance
				SET Qty = @ModelQty, AvgCostOut = (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate)), BalanceTotal = @ModelQty * (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate))
				WHERE IDStore = @IDStore AND IDModel = @IDModel AND BalanceDate = @ProcessDate
			END
		END

		FETCH NEXT FROM STORE_CUR INTO
			@IDStore
	END

	CLOSE STORE_CUR
	DEALLOCATE STORE_CUR

	FETCH NEXT FROM MODEL_CUR INTO
		@IDModel
END

CLOSE MODEL_CUR
DEALLOCATE MODEL_CUR

GO

CREATE PROCEDURE sp_Inv_CalcModelStoreBalanceT (@IDModel int, @ProcessDate datetime)
AS
/* -------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO
	1 - Deletar todos os saldos a partir da data a processar
	2 - Pegar a ultima linha de saldo imediatamente antes da data a processar
	3 - Fazer la�o com as movimenta��es a partir da data a processar
	4 - Atualizar quantidade e custo m�dio

	LOG DE MODIFICA��ES

	Data			Programador					Modifica��o
	----------------------- -----------------------------------------------	--------------------------------------------------------
	14 May	2007		Maximiliano Muniz				Cria��o
    	-------------------------------------------------------------------------------------------------------------------------------- */

DECLARE @IDStore		int
DECLARE @MovQty			float
DECLARE @ModelQty		float
DECLARE @StoreQty		float
DECLARE @MovCost		money
DECLARE @AvgCostOut		money
DECLARE @ModelBalanceTotal	money
DECLARE @StoreBalanceTotal	money
DECLARE @LastAvgCost		money
DECLARE @NewAvgCost		money
DECLARE @HasMov			int

DECLARE MODEL_CUR CURSOR FOR 
SELECT
	M.IDModel
FROM
	Model M
WHERE
	M.IDModel = @IDModel
ORDER BY
	M.IDModel

OPEN MODEL_CUR

FETCH NEXT FROM MODEL_CUR INTO
	@IDModel

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE STORE_CUR CURSOR FOR 
	SELECT
		S.IDStore
	FROM
		Store S
	WHERE
		S.System = 0
		AND S.Hidden = 0
		AND S.Desativado = 0
	ORDER BY
		S.IDStore
	
	OPEN STORE_CUR
	
	FETCH NEXT FROM STORE_CUR INTO
		@IDStore

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Deleto os saldos a partir da data de processamento
		DELETE Inv_ModelStoreBalance WHERE IDStore = @IDStore AND IDModel = @IDModel AND BalanceDate >= @ProcessDate

		SELECT @HasMov = COUNT(*)
		FROM InventoryMov IM (NOLOCK)
		WHERE IM.StoreID = @IDStore AND IM.ModelID = @IDModel AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate AND IM.InventMovTypeID IN (1, 2, 3, 4, 5, 7, 8, 11, 12, 19, 21, 22)

		IF @HasMov > 0
		BEGIN
			SET @ModelQty = 0
			SET @AvgCostOut = 0
			SET @ModelBalanceTotal = 0

			INSERT INTO Inv_ModelStoreBalance (IDStore, IDModel, BalanceDate, Qty, AvgCostOut, BalanceTotal)
			VALUES (@IDStore, @IDModel, @ProcessDate, @ModelQty, @AvgCostOut, @ModelBalanceTotal)

			-------------------------------------------------------------------------------------------------
			-- Pego os valores de quantidade e saldo do modelo, da �ltima data antes da data de processamento
			SELECT
				@ModelQty = MB.Qty,
				@AvgCostOut = MB.AvgCostOut,
				@ModelBalanceTotal = MB.BalanceTotal
			FROM
				Inv_ModelStoreBalance MB (NOLOCK)
			WHERE
				MB.IDStore = @IDStore
				AND MB.IDModel = @IDModel
				AND MB.BalanceDate = (	SELECT MAX(MB.BalanceDate)
							FROM Inv_ModelStoreBalance MB (NOLOCK) 
							WHERE MB.IDStore = @IDStore AND MB.IDModel = @IDModel AND MB.BalanceDate < @ProcessDate
							GROUP BY MB.IDModel)
			--PRINT 'Loja = ' + cast(@IDStore as varchar) + 'Data processo = ' + cast(@ProcessDate as varchar) + ' Qtd anterior = ' + cast(@ModelQty as varchar)
			----------------------------------------------------------------------
			-- Calculo o custo m�dio da �ltima data antes da data de processamento
			IF @ModelQty > 0
				SET @LastAvgCost = @ModelBalanceTotal / @ModelQty
			ELSE
				SET @LastAvgCost = 0

			---------------------------------------------------------------------------------------------------
			-- Pego o total de quantidades de entrada, sem compras, transfer�ncia e importa��o. Esta quantidade
			-- ser� adicionada � quantidade total de estoque, sem afetar o custo m�dio.
			SET @MovQty = 0
			SELECT
				@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
			FROM
				InventoryMov IM (NOLOCK) 
				JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
			WHERE
				IM.StoreID = @IDStore
				AND IM.ModelID = @IDModel
				AND IMT.UpdateOnHand = 1
				AND (IMT.IDInventMovType in (4, 11, 19, 21) OR (IMT.IDInventMovType = 2 AND IM.Qty < 0))
				AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate

			GROUP BY
				IM.ModelID

			--PRINT 'Loja = ' + cast(@IDStore as varchar) + 'Qtd sem compras, etc = ' + cast(@MovQty as varchar)
			-----------------------------------------------------
			-- Calculo a nova quantidade e valor total do estoque
			SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)
			IF @ModelQty > 0
			BEGIN
				SET @ModelBalanceTotal = @ModelBalanceTotal + (IsNull(@MovQty, 0) * @LastAvgCost)
				SET @AvgCostOut = @ModelBalanceTotal / @ModelQty
			END
			ELSE
				SET @ModelBalanceTotal = 0

			----------------------------------------------------------------------
			-- Pego a quantidade e o custo total comprado, transferido e importado
			SET @MovQty = 0
			SET @MovCost = 0
			SELECT
				@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)),
				@MovCost = SUM(IsNull(IM.CostPrice, 0) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0)))
			FROM
				InventoryMov IM (NOLOCK) 
				JOIN InventoryMovType IMT (NOLOCK)  ON (IM.InventMovTypeID = IMT.IDInventMovType)
			WHERE
				IM.StoreID = @IDStore
				AND IM.ModelID = @IDModel
				AND IMT.UpdateOnHand = 1
				AND (IMT.IDInventMovType in (2, 5, 8) AND IM.Qty > 0)
				AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
			GROUP BY
				IM.ModelID

			--PRINT 'Loja = ' + cast(@IDStore as varchar) + 'Qtd compras, etc = ' + cast(@MovQty as varchar)
			---------------------------------------------------------------------------------------------------
			-- Calculo a nova quantidade e valor total do estoque. Se a quantidade em estoque antes das compras
			-- for negativa, deve ser encontrado o custo m�dio das compras para achar o valor total de estoque
			-- com a diferen�a entre a quantidade anterior e a comprada.
			IF (@ModelQty + @MovQty) > 0
			BEGIN
				IF @ModelQty < 0
					SET @ModelBalanceTotal = (@MovCost / @MovQty) * (@ModelQty + @MovQty)
				ELSE
					SET @ModelBalanceTotal = @ModelBalanceTotal + @MovCost
	
				SET @AvgCostOut = @ModelBalanceTotal / (@ModelQty + @MovQty)
				SET @NewAvgCost = @ModelBalanceTotal / (@ModelQty + @MovQty)
			END
			ELSE
			BEGIN
				SET @ModelBalanceTotal = 0
				SET @NewAvgCost = 0
			END

			--PRINT 'Loja = ' + cast(@IDStore as varchar) + 'Qtd anterior = ' + cast(@ModelQty as varchar) + ' Qtd para somar = ' + cast(@MovQty as varchar)
			SET @ModelQty = IsNull(@ModelQty, 0) + IsNull(@MovQty, 0)

			------------------------------------------------------------------------------------------------
			-- Atualizo o saldo da data a processar calculando com base nas movimenta��es de entrada do dia.
			UPDATE
				Inv_ModelStoreBalance
			SET
				Qty = @ModelQty,
				AvgCostOut = (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate)),
				BalanceTotal = @ModelQty * (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate))
			WHERE
				IDStore = @IDStore
				AND IDModel = @IDModel
				AND BalanceDate = @ProcessDate

			-------------------------------------------------------------------------------------------------------
			-- Pego o total de quantidades de sa�da. Esta quantidade ser� removida da quantidade total de estoque,
			-- sem afetar o custo m�dio, desde que n�o zere a quantidade.
			SET @MovQty = 0
			SELECT
				@NewAvgCost = SUM((CASE WHEN IsNull(IM.Qty, 0) > 0 THEN (CASE WHEN @NewAvgCost > 0 THEN @NewAvgCost ELSE @AvgCostOut END) ELSE ISNULL(EXAVG.AvgCostOut, @AvgCostOut) END) * ((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))),
				@MovQty = SUM((2*IMT.UpdateOnHand-1) * IsNull(IM.Qty, 0))
			FROM
				InventoryMov IM (NOLOCK) 
				JOIN InventoryMovType IMT (NOLOCK) ON (IM.InventMovTypeID = IMT.IDInventMovType)
				LEFT OUTER JOIN (SELECT ModelID, PreInventoryMovID, CONVERT(smalldatetime, CONVERT(varchar, MovDate, 103), 103) MovDate FROM InventoryMov (NOLOCK) WHERE StoreID = @IDStore AND ModelID = @IDModel) EX ON (IM.ModelID = EX.ModelID AND IM.IDPreInvMovExchange = EX.PreInventoryMovID)
				LEFT OUTER JOIN (SELECT IDModel, BalanceDate, AvgCostOut FROM Inv_ModelStoreBalance (NOLOCK) WHERE IDStore = @IDStore AND IDModel = @IDModel) EXAVG ON (IM.ModelID = EXAVG.IDModel AND CONVERT(smalldatetime, CONVERT(varchar, EX.MovDate, 103), 103) = EXAVG.BalanceDate)
			WHERE
				IM.StoreID = @IDStore
				AND IM.ModelID = @IDModel
				AND IMT.UpdateOnHand = 0
				AND IMT.IDInventMovType in (1, 3, 7, 12, 22)
				AND CONVERT(smalldatetime, CONVERT(varchar, IM.MovDate, 103), 103) = @ProcessDate
			GROUP BY
				IM.ModelID

			IF @MovQty <> 0
			BEGIN
				SET @ModelQty = @ModelQty + @MovQty
				IF @ModelQty > 0
						SET @ModelBalanceTotal = @ModelBalanceTotal + @NewAvgCost
				ELSE
					SET @ModelBalanceTotal = 0
	
				UPDATE Inv_ModelStoreBalance
				SET Qty = @ModelQty, AvgCostOut = (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate)), BalanceTotal = @ModelQty * (SELECT AvgCostOut FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate = (SELECT MAX(BalanceDate) FROM Inv_ModelBalance WHERE IDModel = @IDModel AND BalanceDate <= @ProcessDate))
				WHERE IDStore = @IDStore AND IDModel = @IDModel AND BalanceDate = @ProcessDate
			END
		END

		FETCH NEXT FROM STORE_CUR INTO
			@IDStore
	END

	CLOSE STORE_CUR
	DEALLOCATE STORE_CUR

	FETCH NEXT FROM MODEL_CUR INTO
		@IDModel
END

CLOSE MODEL_CUR
DEALLOCATE MODEL_CUR


GO