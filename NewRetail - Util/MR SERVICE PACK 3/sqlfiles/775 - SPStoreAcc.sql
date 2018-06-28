if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_PreSale_AddParcela]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PreSale_AddParcela]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_PreSale_AddStoreAccount]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PreSale_AddStoreAccount]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_PreSale_DeleteSingleDelayPayment]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PreSale_DeleteSingleDelayPayment]
GO

CREATE   PROCEDURE sp_PreSale_AddParcela
	(
	@IDStore		int,
	@IDUser			int,
	@IDCliente		int,
	@PreSaleID		int,
	@PreSaleDate		smalldatetime,
	@ExpirationDate		smalldatetime,
	@IDMeioPag		int,
	@Value			money,
	@Authorization		varchar(50),
	@IDCashRegMov		int,
	@Parcela		varchar(20),
	@IDBankCheck		int,
	@CheckNumber		varchar(20),
	@CustomerDocument	varchar(20),
	@CustomerName		varchar(80),
	@CustomerPhone		varchar(20),
	@OBS			varchar(255),
	@PaymentPlace		int,
	@IsPreDatado		bit
	) AS

/* ----------------------------------------------------------------------------------------------------------------------
	SUMARIO
		- Pega as constantes
		- Insere o lancamento
		- Update CashReg TotalSales
		- Incluir cr�dito para o Cliente

	TABELA DE ERROS PARA RETURN_VALUE
		 000 Ok
		-201 Erro em Pega as constantes
		-202 Erro em Insere o lancamento
		-203 Erro em Update CashReg TotalSales
		-204 Erro em Incluir cr�dito para o Cliente
		-205 Erro em Incluir em Sal_AccountCard
		-206 Erro em Incluir em Sal_StoreAccount

	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	----------------------- ----------------------- -----------------------------------------------------------------
	26 May	2000		Eduardo Costa		Suporte ao novo financeiro;
	27 Jun	2001		Davi Gouveia		Log de Return Values;
	28 Jul	2001		Rodrigo Costa		Atualizar o CashReg TotalSales;
	21 Oct	2003		Rodrigo Costa		Chamada a sp_Sis_GetNextCode para @IDLancamento; 
							Criado @IDLancamento;
	15 Oct	2004		Carlos Lima		Inclu�dos novos campos no Fin_Lancamento;
	27 Sep	2004		Carlos Lima		Inclu�dos novo campo no no Fin_Lancamento (PaymentPlace);
	09 Nov	2004		Carlos Lima		Inclus�o de Cr�dito;
	10 Nov	2004		Carlos Lima		Inclus�o do campo IDLancamento quando inclui Cr�dito;
	07 Jan	2005		Carlos Lima		Inclus�o do par�metro IsPredatado;
	23 Mar	2006		Carlos Lima		Suporte ao Gift Card ( Chamada para a procedure que inclui em Sal_AccountCard );
	16 May	2006		Maximiliano Muniz	Calcula da data de vencimento do Lancamento, com base no MeioPag;
	16 Jun	2006		Rodrigo Costa		Adicionado os parametros para ErrorHistory;
	02 May	2007		Maximiliano Muniz	Altera��o na query que pega as constantes;
	16 Jul	2007		Maximiliano Muniz	Pegar o IDCentroCusto do tipo de lan�amento;
	07 Apr	2008		Rodrigo Costa		Inserir no Store Account;
	--------------------------------------------------------------------------------------------------------------- */

DECLARE @IDCentroCusto		int
DECLARE @IDCentroCustoSug	int
DECLARE @HasCentroCusto		bit
DECLARE @IDContaCorrente	int
DECLARE @IDEmpresa		int
DECLARE @ErrorLevel		int
DECLARE @IDLancamento		int
DECLARE @Tipo			int
DECLARE @IDCustomerCredit	int
DECLARE @IDStoreAccount		int
DECLARE @DueDate		smalldatetime
DECLARE @SysError		int

SET @ErrorLevel = 0

-- Pega as constantes
SELECT
	@IDCentroCusto = S.IDCentroCusto,
	@IDEmpresa = S.IDEmpresa
FROM
	Store S (NOLOCK) 
WHERE
	S.IDStore = @IDStore

SELECT
	@HasCentroCusto = SugereCentroCusto,
	@IDCentroCustoSug = IDCentroCusto
FROM
	Fin_LancamentoTipo LT (NOLOCK) 
WHERE
	LT.IDLancamentoTipo = 2

IF @HasCentroCusto = 1
BEGIN
	SET @IDCentroCusto = @IDCentroCustoSug
END

SELECT
	@IDContaCorrente = IsNull(MPTS.IDContaCorrente, MP.IDContaCorrente)
FROM
	MeioPag MP (NOLOCK) 
	LEFT JOIN MeioPag MPB (NOLOCK) ON (MPB.IDMeioPag = MP.IDMeioPagBatch)
	LEFT JOIN MeioPagToStore MPTS (NOLOCK) ON (MPTS.IDMeioPag = MP.IDMeioPagBatch AND MPTS.IDStore = @IDStore)
WHERE
	MP.IDMeioPag = @IDMeioPag

SELECT
	@Tipo = Tipo,
	@DueDate = DateAdd(Day, IsNull(PrazoRecebimento, 0), @ExpirationDate)
FROM
	MeioPag (NOLOCK) 
WHERE
	IDMeioPag = @IDMeioPag

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
            SET @ErrorLevel = -201
            GOTO ERRO
END
 
-- Insere o lancamento
EXEC sp_Sis_GetNextCode 'Fin_Lancamento.IDLancamento', @IDLancamento OUTPUT
INSERT Fin_Lancamento (
		IDLancamento,
		IDLancamentoTipo,
		Pagando,
		Situacao,
		IDCentroCusto,
		IDContaCorrentePrevista,
		IDDocumentoTipo,
		NumDocumento,
		IDEmpresa,
		IDPreSale,
		IDPessoaTipo,
		IDPessoa,
		IDMoeda,
		IDMoedaCotacao,
		DataLancamento,
		DataVencimento,
		ValorNominal,
		IDQuitacaoMeioPrevisto,
		IDUsuarioLancamento,
		NumMeioQuitPrevisto,
		IDCashRegMov,
		NumDesdobramento,
		IDDesdobramentoTipo,
		IDBankCheck,
		CheckNumber,
		CustomerDocument,
		CustomerName,
		CustomerPhone,
		Historico,
		PaymentPlace,
		IsPreDatado)
VALUES (
		@IDLancamento,
		2, -- \\Receitas\Vendas
		0,
		1,
		@IDCentroCusto,
		@IDContaCorrente,
		1001, -- Sales Invoice
		Convert(varchar(50), @PreSaleID),
		@IDEmpresa,
		@PreSaleID,
		1, -- Sales Customer
		@IDCliente,
		4, -- Dollares
		6, -- CotacaoPadrao do Dollar
		@PreSaleDate,
		@DueDate,
		@Value,
		@IDMeioPag,
		@IDUser, --Usuario do financeiro
		@Authorization,
		@IDCashRegMov,
		@Parcela,
		1001,
		@IDBankCheck,
		@CheckNumber,
		@CustomerDocument,
		@CustomerName,
		@CustomerPhone,
		@OBS,
		@PaymentPlace,
		@IsPreDatado)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
            SET @ErrorLevel = -202
            GOTO ERRO
END

/*--------------------------------------------------------------------------------------------------------*/
/*                     Update Cash RegisterMovent se nao for Store Account                             */
/*--------------------------------------------------------------------------------------------------------*/
UPDATE
            CashRegMov
SET
            CashRegMov.TotalSales = IsNull(dbo.CashRegMov.TotalSales, 0) + ROUND(IsNull(@Value,0),2)
WHERE
            CashRegMov.IDCashRegMov = @IDCashRegMov 

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
            SET @ErrorLevel = -203
            GOTO ERRO
END

/*----------------------------------------------------------------*/
/*		Customer Credit		*/
/*----------------------------------------------------------------*/
IF (@Tipo = 5)  AND (@Value < 0)
BEGIN
	EXEC sp_PreSale_AddCustomerCredit @IDCliente, @IDUser, @IDStore, @PreSaleDate, NULL, @Value, @IDLancamento, @IDCustomerCredit OUTPUT

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
	            SET @ErrorLevel = -204
	            GOTO ERRO
	END
END

/*----------------------------------------------------------------*/
/*		Gift Card		*/
/*----------------------------------------------------------------*/
IF (@Tipo = 6)
BEGIN

	EXEC sp_Sal_AccountCard_AddAmount @CustomerDocument, @Value, @PreSaleID, @IDLancamento, @IDUser, 0, ''

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
	            SET @ErrorLevel = -205
	            GOTO ERRO
	END
END


/*----------------------------------------------------------------*/
/*		Store Account		*/
/*----------------------------------------------------------------*/
IF (@Tipo = 9)
BEGIN
	EXEC sp_PreSale_AddStoreAccount @IDCliente, @IDUser, @IDStore, @IDLancamento, @PreSaleDate, @Value, @IDStoreAccount OUTPUT

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
	            SET @ErrorLevel = -206
	            GOTO ERRO
	END
END

OK:
            RETURN 0
ERRO:
            PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(510)
	DECLARE @Params varchar(500)	

	SET @Params = ' [ @IDStore = ' + CAST(@IDStore AS VARCHAR) + 
			' @IDUser = ' + CAST(@IDUser AS VARCHAR) +  
			' @IDCliente = ' + CAST(@IDCliente AS VARCHAR) + 
			' @PreSaleID = '  + CAST(@PreSaleID AS VARCHAR) + 
			' @IDMeioPag = '  + CAST(@IDMeioPag AS VARCHAR) + 
			' @IDCashRegMov = '  + CAST(@IDCashRegMov AS VARCHAR) +
			' @IDBankCheck = '  + CAST(@IDBankCheck AS VARCHAR) + 
			' @Value = '  + CAST(@Value AS VARCHAR) +  ' ] '

	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR) + @Params
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_PreSale_AddParcela', @ErrorLevelStr

	RETURN @ErrorLevel


GO

CREATE  PROCEDURE sp_PreSale_AddStoreAccount
	(
	@IDPessoa		int,
	@IDUser			int,
	@IDStore		int,
	@IDLancamento		int,
	@TransDate		datetime,
	@Amount			money,
	@IDStoreAccount		int out
	)
AS

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 	
	SUMARIO

		- Inserir novo cr�dito para o cliente

	TABELA DE ERROS PARA RETURN_VALUE
		 000	Ok
		-201	Erro em - Inserir novo cr�dito para o cliente


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	07 Apr 2008		Rodrigo Costa		Criacao;
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @ErrorLevel	int 
DECLARE @SysError	int

SET @ErrorLevel = 0 

BEGIN TRAN

EXEC sp_Sis_GetNextCode 'Sal_StoreAccount.IDStoreAccount',  @IDStoreAccount output

INSERT Sal_StoreAccount
	(
	IDStoreAccount,
	IDPessoa,
	IDUser,
	IDStore,
	IDLancamento,
	TransactionDate,
	Amount,
	IsUsed,
	IsReceiving
	)
VALUES
	(
	@IDStoreAccount,
	@IDPessoa,
	@IDUser,
	@IDStore,
	@IDLancamento,
	@TransDate,
	ABS(ISNULL(@Amount, 0)),
	0,
	0
	)


SET @SysError = @@ERROR

IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -201
	GOTO ERRO
END


OK:
	COMMIT TRAN
	RETURN 0
ERRO:
	ROLLBACK TRAN
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(510)
	DECLARE @Params varchar(500)	
	SET @Params = ' [ @IDPessoa = ' + CAST(@IDPessoa AS VARCHAR) + 
			' @IDUser = ' + CAST(@IDUser AS VARCHAR) +  
			' @IDStore = ' + CAST(@IDStore AS VARCHAR) + 
			' @IDLancamento = '  + CAST(@IDLancamento AS VARCHAR) +  ' ] '
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR) + @Params


	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_PreSale_AddStoreAccount', @ErrorLevelStr

	RETURN @ErrorLevel


GO

CREATE  PROCEDURE sp_PreSale_DeleteSingleDelayPayment
			(
			@IDLancamento int,
			@IDUser int
			)
AS

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Update Cash RegisterMovent
		- Desquita o lancamento
		- Deleta o lancamento
		- Restaura Cr�dito do Cliente ou Cancela Cr�dito do Cliente
		- Restaura Cr�dito do Cartao ou Cancela Cr�dito do Cartao

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em Deleta os registros de ligacao
		-202  Erro em Deleta os registros de quitacao
		-203  Erro em Deleta os registros de lan�amento
		-204  Erro em Update Cash RegisterMovent
		-205  Erro em Restaura Cr�dito do Cliente
		-206  Erro em Cancela Cr�dito do Cliente
		-207  Erro em Restaura Cr�dito do Cartao
		-208  Erro em Cancela Cr�dito do Cartao
		-209  Erro em Cancela Store Account

	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	05 Oct  2004		Carlos Lima		Cria��o
	11 Nov 2004		Carlos Lima		Restaurar o Cr�dito do Cliente, caso a forma de
							pagamento for por Cr�dito de Cliente
	12 Nov 2004		Carlos Lima		Cancelar o Cr�dito do Cliente, caso a forma de
							pagamento for por Cr�dito de Cliente
	23 Mar	2006		Rodrigo Costa		Restaura e cancela o credito do cartao
	07 Apr	2008		Rodrigo Costa		Cancelar o Store Account
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */



BEGIN TRAN

DECLARE @ErrorLevel		int
DECLARE @SysError		int

DECLARE @IDPessoa		int
DECLARE @IDStore		int
DECLARE @CreditDate		datetime
DECLARE @ExpirationDate 	datetime
DECLARE @ValorNominal	money
DECLARE @IDCustomerCredit	int
DECLARE @Tipo		int
DECLARE @AccountNumber		varchar(20)

SET @ErrorLevel = 0


SELECT
	@IDPessoa 	= Fin_Lancamento.IDPessoa,
	@IDStore	= Invoice.IDStore,
	@ValorNominal	= Fin_Lancamento.ValorNominal,
	@Tipo		= MeioPag.Tipo,
	@CreditDate	= GETDATE()
FROM
	Invoice (NOLOCK) 
	INNER JOIN Fin_Lancamento (NOLOCK) ON (Invoice.IDPreSale = Fin_Lancamento.IDPreSale)
	INNER JOIN MeioPag (NOLOCK) ON (Fin_Lancamento.IDQuitacaoMeioPrevisto = MeioPag.IDMeioPag)
WHERE
	Fin_Lancamento.IDLancamento = @IDLancamento

SET @ExpirationDate = NULL


/*----------------------------------------------------------------*/
/*	Restaura Cr�dito do Cliente	*/
/*---------------------------------------------------------------*/

IF (@Tipo = 5) AND (@ValorNominal > 0)
BEGIN
	EXEC sp_PreSale_AddCustomerCredit @IDPessoa, @IDUser,  @IDStore, @CreditDate, @ExpirationDate, @ValorNominal, NULL, @IDCustomerCredit OUTPUT

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -205
		GOTO ERRO
	END
END

/*----------------------------------------------------------------*/
/*	Cancela Cr�dito do Cliente	*/
/*---------------------------------------------------------------*/


IF (@Tipo = 5) AND (@ValorNominal <= 0)
BEGIN
	UPDATE 	CustomerCredit 
	SET		IsUsed = 1,
			IDLancamento = NULL
	WHERE	IDLancamento = @IDLancamento

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -206
		GOTO ERRO
	END
END

/*----------------------------------------------------------------*/
/*	Restaura Cr�dito do Cartao	*/
/*---------------------------------------------------------------*/
IF (@Tipo = 6)
BEGIN
	SELECT
		@AccountNumber = AC.CardNumber
	FROM
		Sal_AccountCard AC (NOLOCK) 
		JOIN Sal_AccountCardMov ACM (NOLOCK) ON (AC.IDAccountCard = ACM.IDAccountCard)
	WHERE
		ACM.IDLancamento = @IDLancamento

	EXEC sp_Sal_AccountCard_AddAmount @AccountNumber, @ValorNominal, NULL, NULL, @IDUser, 1, ''

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -207
		GOTO ERRO
	END
END

/*----------------------------------------------------------------*/
/*	Cancela Cr�dito do Cartao	*/
/*---------------------------------------------------------------*/
IF (@Tipo = 6)
BEGIN
	UPDATE
		Sal_AccountCardMov
	SET
		IDLancamento = NULL
	WHERE
		IDLancamento = @IDLancamento

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -208
		GOTO ERRO
	END
END

/*----------------------------------------------------------------*/
/*	Cancela Store Account	*/
/*---------------------------------------------------------------*/
IF (@Tipo = 9)
BEGIN
	UPDATE
		Sal_StoreAccount
	SET
		IDLancamento = NULL,
		IsUsed = 1
	WHERE
		IDLancamento = @IDLancamento

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -209
		GOTO ERRO
	END
END


/*----------------------------------------------------------------------------------------------------------*/
/*		Update Cash RegisterMovent do dia se nao for Store Account     	  */
/*---------------------------------------------------------------------------------------------------------*/ 
IF (@Tipo <> 9)
BEGIN
	UPDATE
		CashRegMov	
	SET
		CashRegMov.TotalSales = IsNull(CashRegMov.TotalSales, 0) - Fin_Lancamento.ValorNominal
	FROM
		Fin_Lancamento (NOLOCK) 
	WHERE
		CashRegMov.IDCashRegMov = Fin_Lancamento.IDCashRegMov
		AND Fin_Lancamento.IDLancamento = @IDLancamento
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -204
		GOTO ERRO
	END
END

/*--------------------------------------------------------------------------------------------*/
/*	       Desquita o lancamento         			  */
/*--------------------------------------------------------------------------------------------*/

/*----------- Cria tabela com as quitacoes a serem deletadas ------------ */
SELECT
	Q.IDQuitacao
INTO
	#sp_PreSale_Remove_QuitToDelete
FROM
	Fin_Quitacao Q (NOLOCK) 
	JOIN Fin_LancQuit LQ (NOLOCK) ON (LQ.IDQuitacao = Q.IDQuitacao)
	JOIN Fin_Lancamento L (NOLOCK) ON (LQ.IDLancamento = L.IDLancamento)
WHERE
	L.IDLancamento = @IDLancamento

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -207
	GOTO ERRO
END

/*---------------- Deleta o registro de ligacao -------------------- */
DELETE
	LQ
FROM
	Fin_LancQuit LQ
	--JOIN Fin_Lancamento L ON (L.IDLancamento = LQ.IDLancamento)
	JOIN #sp_PreSale_Remove_QuitToDelete QTD ON (QTD.IDQuitacao = LQ.IDQuitacao)
--WHERE
--	L.IDLancamento = @IDLancamento

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -201
	GOTO ERRO
END

/*--------------- Deleta o registro de quitacao -----------------*/
DELETE
	Q
FROM
	Fin_Quitacao Q (NOLOCK) 
	JOIN #sp_PreSale_Remove_QuitToDelete QTD ON (QTD.IDQuitacao = Q.IDQuitacao)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -202
	GOTO ERRO
END

/*---------------- Deleta o registro de lan�amento --------------------*/
DELETE
	L
FROM 
	Fin_Lancamento L (NOLOCK)
WHERE
	L.IDLancamento = @IDLancamento


SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -203
	GOTO ERRO
END


OK:
	COMMIT TRAN
	RETURN 0
ERRO:
	ROLLBACK TRAN
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_PreSale_DeleteSingleDelayPayment', @ErrorLevelStr

	RETURN @ErrorLevel

GO
