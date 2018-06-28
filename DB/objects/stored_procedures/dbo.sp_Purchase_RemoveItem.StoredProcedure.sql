SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sp_Purchase_RemoveItem]
		(
 		@IDPurchase		int,
		@IDPurchaseItem		int,
		@TaxInCost		bit
		)
AS 

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Obtenho o ID do PO
		- Atualizo o QtyOnPrePurchase no Inventory ### Rodrigo
		- Atualizo o QrtArrived no PreInvMov ## Rodrigo

		- Deleto os PurchaseItemSerial
		- Atualizao o Avg Cost no Model
		- Deleto o PurchaseItem
		- Call sp_Purchase_AtuPurchaseSubTotal
		- Deleto Pur_PurchaseItemTax
		- Deleto Pur_PurchaseItemTaxRet
		- Atualizo Total do PO
		- Atualizo condi��o de fechamento do PO
		- Movimentar quantidade de lote

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em Deleto AsQty o item no Pur_PurchaseQtyPrePurchase
		-202  Erro em Deleto AsQty o item no Pur_PurchaseQtyOrder
		-203  Erro em Deleto os PurchaseItemSerial
		-204  Erro em Deleto o PurchaseItem
		-205  Erro em Call sp_Purchase_AtuPurchaseSubTotal
		-206  Erro em Deletar Pur_PurchaseItemTax
		-207  Erro em Deletar Pur_PurchaseItemTaxRet
		-208  Obtenho o ID do PO
		-209  Atualizo Total do PO
		-210  Atualizo condi��o de fechamento do PO
		-211 Atualizao o Custo Medio
		-212 Erro ao desvincular Purchase do PO.
		-213 Erro ao remover quantidade de Lote

	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	04 Dec	2000		Eduardo Costa		Cria��o;
	18 Dec	2000		Rodrigo Costa		Atualizacao;
	26 Jun	2001		Davi Gouveia		Log de Return Values
	18 Aug	2004		Rodrigo Costa		Gravar error log
	14 Dec	2004		Rodrigo Costa		Deletar os Pur_PurchaseItemTax
	11 Mar	2005		Carlos Lima		Deletar os Pur_PurchaseItemTaxRet
	01 Dec	2005		Carlos Lima		Verificar a Condi��o de fechamento do PO e atualizar
	07 Dec	2005		Rodrigo Costa		Atualizar o AvgCost no Model
	11 Jan	2006		Rodrigo Costa		Remover o Custo Medio
	20 Jul	2006		Leonardo Riego		Caso Purchase nao possua mais itens do PO desvincular o Purchase do PO.
	31 Mar	2009		Rodrigo Costa		Movimentar quantidade de lote
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @ErrorLevel	int
DECLARE @SysError	int
DECLARE @IDPO	int
DECLARE @HavePOItens	int

SET @ErrorLevel = 0

BEGIN TRAN



---------------------------------------------------------------------------- ##Carlos
-- Obtenho o ID do PO

SELECT
	@IDPO = IDPO
FROM
	Pur_Purchase (NOLOCK) 
WHERE
	IDPurchase = @IDPurchase

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -208
	GOTO ERRO
END

---------------------------------------------------------------------------- ##Rodrigo
-- Deleto AsQty o item no Pur_PurchaseQtyPrePurchase

DELETE
	PUQ
FROM
	Pur_PurchaseQtyPrePurchase PUQ (NOLOCK) 
WHERE
	PUQ.IDModel = (
			SELECT
				PUI.IDModel
			FROM
				Pur_PurchaseItem PUI (NOLOCK) 
			WHERE
				PUI.IDPurchaseItem = @IDPurchaseItem
				AND
				PUI.IDPurchase = @IDPurchase
		)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -201
	GOTO ERRO
END


---------------------------------------------------------------------------- ##Rodrigo
-- Deleto AsQty o item no Pur_PurchaseQtyOrder

DELETE
	PUQ
FROM
	Pur_PurchaseQtyOrder PUQ (NOLOCK) 
WHERE
	PUQ.IDModel = (
			SELECT
				PUI.IDModel
			FROM
				Pur_PurchaseItem PUI (NOLOCK) 
			WHERE
				PUI.IDPurchaseItem = @IDPurchaseItem
				AND
				PUI.IDPurchase = @IDPurchase
		)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -202
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Deleto os PurchaseItemSerial

DELETE
	PIS
FROM
	Pur_PurchaseItemSerial PIS (NOLOCK) 
WHERE
	PIS.IDPurchaseItem = @IDPurchaseItem

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -203
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Deleto os PurchaseItemTax

DELETE
	PIT
FROM
	Pur_PurchaseItemTax PIT (NOLOCK) 
WHERE
	PIT.IDPurchaseItem = @IDPurchaseItem

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -206
	GOTO ERRO
END

------------------------------------------------------------------------------
-- Deleto os PurchaseItemTaxRet

DELETE
	PIT
FROM
	Pur_PurchaseItemTaxRet PIT (NOLOCK) 
WHERE
	PIT.IDPurchaseItem = @IDPurchaseItem

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -207
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Atualizo Quantidade Lote
UPDATE
	L
SET
	L.Qty = (L.Qty - PPI.Qty)
FROM
	Pur_PurchaseItem PPI (NOLOCK)
	JOIN Pur_Purchase P (NOLOCK) ON (P.IDPurchase = PPI.IDPurchase)
	JOIN Inv_StoreModelLot L (NOLOCK) ON (L.IDModel = PPI.IDModel AND L.IDStore = P.IDStore AND L.IDLote = PPI.IDLote)
WHERE
	PPI.IDPurchaseItem = @IDPurchaseItem
	AND
	PPI.IDLote IS NOT NULL

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -213
	GOTO ERRO
END

------------------------------------------------------------------------------
-- Deleto o PurchaseItem
DELETE
	PPI
FROM
	Pur_PurchaseItem PPI (NOLOCK) 
WHERE
	PPI.IDPurchaseItem = @IDPurchaseItem

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -204
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Call sp_Purchase_AtuPurchaseSubTotal

EXEC sp_Purchase_AtuPurchaseSubTotal  @IDPurchase, @TaxInCost

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -205
	GOTO ERRO
END



IF @IDPO IS NOT NULL
BEGIN
------------------------------------------------------------------------------
-- Call sp_PO_AtuPOTotal

	EXEC sp_PO_AtuPOTotal @IDPO
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -209
		GOTO ERRO
	END

------------------------------------------------------------------------------
-- Call sp_PO_CalcTotalQty
	
	EXEC sp_PO_CalcTotalQty @IDPO
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -210
		GOTO ERRO
	END
------------------------------------------------------------------------------
-- Caso Purchase nao possua mais itens do PO desvincular o Purchase do PO.
	
	SELECT 
		@HavePOItens = COUNT(IDPurchaseItem)
	FROM
		Pur_Purchase PP (NOLOCK) 
		JOIN PreInventoryMov PIM (NOLOCK) ON(PIM.DocumentID = PP.IDPO)
		JOIN Pur_PurchaseItem PPI (NOLOCK) ON (PPI.IDPOItem = PIM.IDPreInventoryMov AND PPI.IDPurchase = PP.IDPurchase)
	WHERE
		PP.IDPurchase = @IDPurchase 

	IF @HavePOItens = 0
	BEGIN
		UPDATE
			Pur_Purchase
		SET
			IDPO = NULL
		WHERE
			IDPurchase = @IDPurchase 		
	END
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -212
		GOTO ERRO
	END
END


OK:
	COMMIT TRAN 
	RETURN 0
ERRO:
	ROLLBACK TRAN
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_Purchase_RemoveItem', @ErrorLevelStr

	RETURN @ErrorLevel
GO
