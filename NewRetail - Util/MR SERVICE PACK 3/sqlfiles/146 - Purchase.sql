if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Purchase_AtuPurchaseSubTotal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Purchase_AtuPurchaseSubTotal]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Purchase_CriaPagamento]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Purchase_CriaPagamento]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Purchase_CriaPagamentoComImposto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Purchase_CriaPagamentoComImposto]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Purchase_Do]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Purchase_Do]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Purchase_RemoveItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Purchase_RemoveItem]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_Fin_CriaLacamento_Disburse]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Fin_CriaLacamento_Disburse]
GO

CREATE PROCEDURE sp_Fin_CriaLacamento_Disburse
	(
	@IDLancamentoParent 	int,
	@Total			money,
	@NumDuplicata		varchar(20),
	@IDLancamentoTipo	int
	)
AS

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Atualizo as informacoes dos lancamentos

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em incluo o lancamento Disbursement


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	13 May	2002		Rodrigo Costa		Criacao
	21 Oct	2003		Andr� Bogado		Chamada a sp_Sis_GetNextCode
							Declara��o de Fin_Lancamento_Cursor
	18 Aug 2004		Rodrigo Costa		Gravar error log
	24 Dez 2004		Rodrigo Costa		Novo parametro @IDLancamentoTipo
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @ErrorLevel			int
DECLARE @SysError			int
DECLARE @IDLancamento 		int
DECLARE @Pagando 			bit 
DECLARE @DataLancamento 		smalldatetime 
DECLARE @IDUsuarioLancamento 	int 
DECLARE @Previsao 			bit 
DECLARE @Situacao 			int 
DECLARE @IDPessoaTipo 		int 
DECLARE @IDPessoa 			int 
DECLARE @IDEmpresa 			int 
DECLARE @DataVencimento 		smalldatetime 
DECLARE @DataEmissao 		datetime 
DECLARE @IDDocumentoTipo 		int 
DECLARE @ValorNominal 		money 
DECLARE @NumDocumento 		varchar(20)
DECLARE @IDPurchase 		int 
DECLARE @IDMoeda 			int 
DECLARE @IDMoedaCotacao 		int 
DECLARE @LancamentoType 		int 

SET @ErrorLevel = 0

	--Lancamento Disbursement
	--Declara��o do Cursor de Fin_Lancamento

DECLARE Fin_Lancamento_Cursor CURSOR FOR

	SELECT
		LP.Pagando,
		@IDLancamentoTipo,
		LP.DataLancamento,
		LP.IDUsuarioLancamento,
		LP.Previsao,
		LP.Situacao,
		LP.IDPessoaTipo,
		LP.IDPessoa,
		LP.IDEmpresa,
		LP.DataVencimento,
		LP.DataEmissao,
		LP.IDDocumentoTipo,
		@Total,
		LP.NumDocumento,
		LP.IDPurchase,
		LP.IDMoeda,
		LP.IDMoedaCotacao,
		2, -- Lancamento Tipo Desdrobramento
		LP.IDLancamento,
		@NumDuplicata
	FROM
		Fin_Lancamento LP
	WHERE
		LP.IDLancamento = @IDLancamentoParent
OPEN Fin_Lancamento_Cursor

--Inicializa��o de Fin_Lancamento_Cursor
FETCH NEXT FROM Fin_Lancamento_Cursor INTO
	@Pagando,
	@IDLancamentoTipo,
	@DataLancamento,
	@IDUsuarioLancamento,
	@Previsao,
	@Situacao,
	@IDPessoaTipo,
	@IDPessoa,
	@IDEmpresa,
	@DataVencimento,
	@DataEmissao,
	@IDDocumentoTipo,
	@ValorNominal,
	@NumDocumento,
	@IDPurchase,
	@IDMoeda,
	@IDMoedaCotacao,
	@LancamentoType,
	@IDLancamentoParent,
	@NumDuplicata

--Enquanto tem registros
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC sp_Sis_GetNextCode 'Fin_Lancamento.IDLancamento', @IDLancamento OUTPUT
	INSERT Fin_Lancamento
		(
		IDLancamento,
		Pagando,
		IDLancamentoTipo,
		DataLancamento,
		IDUsuarioLancamento,
		Previsao,
		Situacao,
		IDPessoaTipo,
		IDPessoa,
		IDEmpresa,
		DataVencimento,
		DataEmissao,
		IDDocumentoTipo,
		ValorNominal,
		NumDocumento,
		IDPurchase,
		IDMoeda,
		IDMoedaCotacao,
		LancamentoType,
		IDLancamentoParent,
		NumeroDuplicata
		)
	VALUES 
		(
		@IDLancamento,
		@Pagando,
		@IDLancamentoTipo,
		@DataLancamento,
		@IDUsuarioLancamento,
		@Previsao,
		@Situacao,
		@IDPessoaTipo,
		@IDPessoa,
		@IDEmpresa,
		@DataVencimento,
		@DataEmissao,
		@IDDocumentoTipo,
		@ValorNominal,
		@NumDocumento,
		@IDPurchase,
		@IDMoeda,
		@IDMoedaCotacao,
		@LancamentoType,
		@IDLancamentoParent,
		@NumDuplicata	
		)

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		CLOSE Fin_Lancamento_Cursor
		DEALLOCATE Fin_Lancamento_Cursor
		SET @ErrorLevel = -201
		GOTO ERRO
	END

	FETCH NEXT FROM Fin_Lancamento_Cursor INTO
		@Pagando,
		@IDLancamentoTipo,
		@DataLancamento,
		@IDUsuarioLancamento,
		@Previsao,
		@Situacao,
		@IDPessoaTipo,
		@IDPessoa,
		@IDEmpresa,
		@DataVencimento,
		@DataEmissao,
		@IDDocumentoTipo,
		@ValorNominal,
		@NumDocumento,
		@IDPurchase,
		@IDMoeda,
		@IDMoedaCotacao,
		@LancamentoType,
		@IDLancamentoParent,
		@NumDuplicata
END
--fechamento do cursor
CLOSE Fin_Lancamento_Cursor
--Destrui��o do cursor
DEALLOCATE Fin_Lancamento_Cursor

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -201
		GOTO ERRO
	END


OK:
	RETURN 0
ERRO:
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'OfficeManager', 'Error: sp_Fin_CriaLacamento_Disburse', @ErrorLevelStr

	RETURN @ErrorLevel
GO

CREATE PROCEDURE sp_Purchase_CriaPagamento
	(
	@IDPurchase	int
	)
AS

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Atualizo as informacoes dos lancamentos

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em update os lancamentos anteriores
		-202  Erro em incluo o lancamento Parent
		-203  Erro Preenchando valores default
		-204  Erro em incluo o lancamento Disbursement SubTotal
		-205  Erro em incluo o lancamento Disbursement Freight


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	15 May  2000		Eduardo Costa		Criacao;
	26 June 2001		Davi Gouveia		Log de Return Values
	13 May	2002		Rodrigo Costa		Inserir Lancamentos com Disbursements
	28 Oct	2003		Rodrigo Costa		Create sp_GetNexCode
	18 Aug 2004		Rodrigo Costa		Gravar error log
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @ErrorLevel			int
DECLARE @SysError			int
DECLARE @IDLancamentoParent 	int
DECLARE @SubTotal			money
DECLARE @Freight			money
DECLARE @CriaDisbur			int

--Declara��o de vari�veis para o Cursor de Fin_Lancamento
DECLARE @Pagando 			bit 
DECLARE @IDLancamentoTipo 		int 
DECLARE @DataLancamento 		smalldatetime 
DECLARE @IDUsuarioLancamento 	int 
DECLARE @Previsao 			bit 
DECLARE @Situacao 			int 
DECLARE @IDPessoaTipo 		int 
DECLARE @IDPessoa 			int 
DECLARE @IDEmpresa 			int 
DECLARE @DataVencimento 		smalldatetime 
DECLARE @DataEmissao 		datetime 
DECLARE @IDDocumentoTipo 		int 
DECLARE @ValorNominal 		money 
DECLARE @NumDocumento 		varchar(20)
DECLARE @IDMoeda 			int 
DECLARE @IDMoedaCotacao 		int 
DECLARE @LancamentoType 		int 
DECLARE @IDLancamento		int


SET @ErrorLevel = 0
SET @CriaDisbur = 0

IF EXISTS (SELECT IDLancamento FROM Fin_Lancamento WHERE IDPurchase = @IDPurchase)
BEGIN
	-- Atualizo as informacoes do Lancamento Parent
	UPDATE
		L
	SET
		L.DataVencimento = P.DocumentDate,
		L.DataEmissao = P.DocumentDate,
		L.NumDocumento = P.DocumentNumber,
		L.ValorNominal = IsNull(PT.SubTotal, 0) + IsNull(P.Freight,0) + IsNull(P.OtherCharges, 0), 
		L.IDPessoa = P.IDFornecedor,
		L.DataLancamento =IsNull(P.DateFinalReceiving, P.DatePreReceiving),
		L.IDUsuarioLancamento = IsNull(P.IDUserFinalReceiving, P.IDUserPreReceiving)
	FROM
		Fin_Lancamento L
		JOIN Pur_Purchase P ON (L.IDPurchase = P.IDPurchase)
		JOIN Pur_PurchaseTotal PT ON (PT.IDPurchase = P.IDPurchase)
	WHERE
		P.IDPurchase = @IDPurchase
		AND
		L.LancamentoType <> 2 -- Diferente de LancamentoFilho


	-- Atualizo as informacoes do Lancamento Filho
	UPDATE
		L
	SET
		L.DataVencimento = P.DocumentDate,
		L.DataEmissao = P.DocumentDate,
		L.NumDocumento = P.DocumentNumber,
		L.ValorNominal = IsNull(PT.SubTotal, 0), 
		L.IDPessoa = P.IDFornecedor,
		L.DataLancamento =IsNull(P.DateFinalReceiving, P.DatePreReceiving),
		L.IDUsuarioLancamento = IsNull(P.IDUserFinalReceiving, P.IDUserPreReceiving)
	FROM
		Fin_Lancamento L
		JOIN Pur_Purchase P ON (L.IDPurchase = P.IDPurchase)
		JOIN Pur_PurchaseTotal PT ON (PT.IDPurchase = P.IDPurchase)
	WHERE
		P.IDPurchase = @IDPurchase
		AND
		L.LancamentoType = 2 -- Lancamento Filho primeira parcela
		AND
		L.NumeroDuplicata = '1/2'


	-- Atualizo as informacoes do Lancamento Filho
	UPDATE
		L
	SET
		L.DataVencimento = P.DocumentDate,
		L.DataEmissao = P.DocumentDate,
		L.NumDocumento = P.DocumentNumber,
		L.ValorNominal = IsNull(P.Freight,0) + IsNull(P.OtherCharges, 0), 
		L.IDPessoa = P.IDFornecedor,
		L.DataLancamento =IsNull(P.DateFinalReceiving, P.DatePreReceiving),
		L.IDUsuarioLancamento = IsNull(P.IDUserFinalReceiving, P.IDUserPreReceiving)
	FROM
		Fin_Lancamento L
		JOIN Pur_Purchase P ON (L.IDPurchase = P.IDPurchase)
		JOIN Pur_PurchaseTotal PT ON (PT.IDPurchase = P.IDPurchase)
	WHERE
		P.IDPurchase = @IDPurchase
		AND
		L.LancamentoType = 2 -- Lancamento Filho segunda parcela
		AND
		L.NumeroDuplicata = '2/2'

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -201
		GOTO ERRO
	END
END
ELSE
BEGIN
	-- Incluo o lancamento parent
	--Declara��o do Cursor de Fin_Lancamento
	DECLARE Fin_Lancamento_Cursor CURSOR FOR
	
		SELECT
			1,
			7,  -- Cost of Good ## Davi
			IsNull(P.DateFinalReceiving, P.DatePreReceiving),
			IsNull(P.IDUserFinalReceiving, P.IDUserPreReceiving),
			1,  -- Nao approvado
			1,  -- Aberto
			2,  -- Vendor
			P.IDFornecedor,
			S.IDEmpresa,
			P.DocumentDueDate,
			P.DocumentDate,
			1002,  -- Vendor Invoice
			IsNull(PT.SubTotal, 0) + IsNull(P.Freight, 0) + IsNull(P.OtherCharges, 0),
			P.DocumentNumber,
			P.IDPurchase,
			4, -- Dollar
			6, -- Cotacao Default - Dollar
			1  -- Lancamento Parent
		FROM
			Pur_Purchase P
			JOIN Pur_PurchaseTotal PT ON (PT.IDPurchase = P.IDPurchase)
			JOIN Store S ON (P.IDStore = S.IDStore)
		WHERE
			P.IDPurchase = @IDPurchase
			AND
			DocumentType = 'Invoice'
	
	
	OPEN Fin_Lancamento_Cursor
	
	--Inicializa��o de Fin_Lancamento_Cursor
	FETCH NEXT FROM Fin_Lancamento_Cursor INTO
		@Pagando,
		@IDLancamentoTipo,
		@DataLancamento,
		@IDUsuarioLancamento,
		@Previsao,
		@Situacao,
		@IDPessoaTipo,
		@IDPessoa,
		@IDEmpresa,
		@DataVencimento,
		@DataEmissao,
		@IDDocumentoTipo,
		@ValorNominal,
		@NumDocumento,
		@IDPurchase,
		@IDMoeda,
		@IDMoedaCotacao,
		@LancamentoType
	--Enquanto tem registros
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC sp_Sis_GetNextCode 'Fin_Lancamento.IDLancamento', @IDLancamento OUTPUT
		INSERT Fin_Lancamento(
			IDLancamento,
			Pagando,
			IDLancamentoTipo,
			DataLancamento,
			IDUsuarioLancamento,
			Previsao,
			Situacao,
			IDPessoaTipo,
			IDPessoa,
			IDEmpresa,
			DataVencimento,
			DataEmissao,
			IDDocumentoTipo,
			ValorNominal,
			NumDocumento,
			IDPurchase,
			IDMoeda,
			IDMoedaCotacao,
			LancamentoType
			)
		VALUES 
			(
			@IDLancamento,
			@Pagando,
			@IDLancamentoTipo,
			@DataLancamento,
			@IDUsuarioLancamento,
			@Previsao,
			@Situacao,
			@IDPessoaTipo,
			@IDPessoa,
			@IDEmpresa,
			@DataVencimento,
			@DataEmissao,
			@IDDocumentoTipo,
			@ValorNominal,
			@NumDocumento,
			@IDPurchase,
			@IDMoeda,
			@IDMoedaCotacao,
			@LancamentoType	
			)

		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
			CLOSE Fin_Lancamento_Cursor
			DEALLOCATE Fin_Lancamento_Cursor
			SET @ErrorLevel = -202
			GOTO ERRO
		END
	
		FETCH NEXT FROM Fin_Lancamento_Cursor INTO
			@Pagando,
			@IDLancamentoTipo,
			@DataLancamento,
			@IDUsuarioLancamento,
			@Previsao,
			@Situacao,
			@IDPessoaTipo,
			@IDPessoa,
			@IDEmpresa,
			@DataVencimento,
			@DataEmissao,
			@IDDocumentoTipo,
			@ValorNominal,
			@NumDocumento,
			@IDPurchase,
			@IDMoeda,
			@IDMoedaCotacao,
			@LancamentoType
	END
	--fechamento do cursor
	CLOSE Fin_Lancamento_Cursor
	--Destrui��o do cursor
	DEALLOCATE Fin_Lancamento_Cursor

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -202
		GOTO ERRO
	END


	--Pega o IDLancamento do Pararent e os Valores para criar os disbursement
	SELECT 
		@IDLancamentoParent = @IDLancamento,
		@SubTotal = IsNull(PT.SubTotal, 0),
		@Freight = IsNull(P.Freight, 0) + IsNull(P.OtherCharges, 0),
		@CriaDisbur = 1,
		@IDLancamentoTipo = 7 -- Cost of Good ## Davi
	FROM
		Pur_Purchase P
		JOIN Pur_PurchaseTotal PT ON (PT.IDPurchase = P.IDPurchase)
	WHERE
		P.IDPurchase = @IDPurchase
		AND
		P.DocumentType = 'Invoice'
	
	SET @SysError = @@ERROR

	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -203
		GOTO ERRO
	END


	IF (@CriaDisbur = 1)
	BEGIN
		--Cria desdobramento do Sub Total
		EXEC sp_Fin_CriaLacamento_Disburse @IDLancamentoParent, @SubTotal, '1/2', @IDLancamentoTipo
		
		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
			SET @ErrorLevel = -204
			GOTO ERRO
		END

		--Cria desdobramento do Freight
		EXEC sp_Fin_CriaLacamento_Disburse @IDLancamentoParent, @Freight, '2/2', @IDLancamentoTipo

		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
			SET @ErrorLevel = -205
			GOTO ERRO
		END
	END

END

OK:
	RETURN 0
ERRO:
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_Purchase_CriaPagamento', @ErrorLevelStr

	RETURN @ErrorLevel
GO

CREATE PROCEDURE sp_Purchase_CriaPagamentoComImposto
	(
	@IDPurchase	int
	)
AS

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Deletar os lancamentos se precisar
		- Inserir as informacoes dos lancamentos
		- Inserir os desdobramentos nos lancamentos

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em Deletar os lancamentos anteriores
		-202  Erro em incluo o lancamento Parent
		-203  Erro Preenchando valores default
		-204  Erro em incluo o lancamento Disbursement SubTotal
		-205  Erro em incluo o lancamento Disbursement Freight
		-206  Erro em incluo os lancamentos Disbursement Impostos


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	24 Dez  2004		Rodrigo Costa		Criacao;
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @ErrorLevel			int
DECLARE @SysError			int
DECLARE @IDLancamentoParent 		int
DECLARE @SubTotal			money
DECLARE @Freight			money
DECLARE @CriaDisbur			int

--Declara��o de vari�veis para o Cursor de Fin_Lancamento
DECLARE @Pagando 			bit 
DECLARE @IDLancamentoTipo 		int 
DECLARE @DataLancamento 		smalldatetime 
DECLARE @IDUsuarioLancamento 		int 
DECLARE @Previsao 			bit 
DECLARE @Situacao 			int 
DECLARE @IDPessoaTipo 			int 
DECLARE @IDPessoa 			int 
DECLARE @IDEmpresa 			int 
DECLARE @DataVencimento 		smalldatetime 
DECLARE @DataEmissao 			datetime 
DECLARE @IDDocumentoTipo 		int 
DECLARE @ValorNominal 			money 
DECLARE @NumDocumento 			varchar(20)
DECLARE @IDMoeda 			int 
DECLARE @IDMoedaCotacao 		int 
DECLARE @LancamentoType 		int 
DECLARE @IDLancamento			int
DECLARE @TotalDesdobramento		int
DECLARE @NumDesdobramento		varchar(10)
DECLARE @CountImposto			int


SET @ErrorLevel = 0
SET @CriaDisbur = 0

-- Deleto os Lancamentos Filhos
DELETE 
FROM 
	Fin_Lancamento  
WHERE
	IDPurchase = @IDPurchase

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -201
	GOTO ERRO
END

-- Incluo o lancamento parent
--Declara��o do Cursor de Fin_Lancamento
DECLARE Fin_Lancamento_Cursor CURSOR FOR
	
	SELECT
		1,
		7,  -- Cost of Good ## Davi
		IsNull(P.DateFinalReceiving, P.DatePreReceiving),
		IsNull(P.IDUserFinalReceiving, P.IDUserPreReceiving),
		1,  -- Nao approvado
		1,  -- Aberto
		2,  -- Vendor
		P.IDFornecedor,
		S.IDEmpresa,
		P.DocumentDueDate,
		P.DocumentDate,
		1002,  -- Vendor Invoice
		IsNull(PT.SubTotal, 0) + IsNull(P.Freight, 0) + IsNull(P.OtherCharges, 0),
		P.DocumentNumber,
		P.IDPurchase,
		4, -- Dollar
		6, -- Cotacao Default - Dollar
		1  -- Lancamento Parent
	FROM
		Pur_Purchase P
		JOIN Pur_PurchaseTotal PT ON (PT.IDPurchase = P.IDPurchase)
		JOIN Store S ON (P.IDStore = S.IDStore)
	WHERE
		P.IDPurchase = @IDPurchase
		AND
		DocumentType = 'Invoice'
	
	
OPEN Fin_Lancamento_Cursor
	
--Inicializa��o de Fin_Lancamento_Cursor
FETCH NEXT FROM Fin_Lancamento_Cursor INTO
	@Pagando,
	@IDLancamentoTipo,
	@DataLancamento,
	@IDUsuarioLancamento,
	@Previsao,
	@Situacao,
	@IDPessoaTipo,
	@IDPessoa,
	@IDEmpresa,
	@DataVencimento,
	@DataEmissao,
	@IDDocumentoTipo,
	@ValorNominal,
	@NumDocumento,
	@IDPurchase,
	@IDMoeda,
	@IDMoedaCotacao,
	@LancamentoType
--Enquanto tem registros
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC sp_Sis_GetNextCode 'Fin_Lancamento.IDLancamento', @IDLancamento OUTPUT
	INSERT Fin_Lancamento(
		IDLancamento,
		Pagando,
		IDLancamentoTipo,
		DataLancamento,
		IDUsuarioLancamento,
		Previsao,
		Situacao,
		IDPessoaTipo,
		IDPessoa,
		IDEmpresa,
		DataVencimento,
		DataEmissao,
		IDDocumentoTipo,
		ValorNominal,
		NumDocumento,
		IDPurchase,
		IDMoeda,
		IDMoedaCotacao,
		LancamentoType
		)
	VALUES 
		(
		@IDLancamento,
		@Pagando,
		@IDLancamentoTipo,
		@DataLancamento,
		@IDUsuarioLancamento,
		@Previsao,
		@Situacao,
		@IDPessoaTipo,
		@IDPessoa,
		@IDEmpresa,
		@DataVencimento,
		@DataEmissao,
		@IDDocumentoTipo,
		@ValorNominal,
		@NumDocumento,
		@IDPurchase,
		@IDMoeda,
		@IDMoedaCotacao,
		@LancamentoType	
		)

		SET @SysError = @@ERROR
		IF @SysError <> 0
			BEGIN
				CLOSE Fin_Lancamento_Cursor
				DEALLOCATE Fin_Lancamento_Cursor
				SET @ErrorLevel = -202
				GOTO ERRO
			END
	
FETCH NEXT FROM Fin_Lancamento_Cursor INTO
		@Pagando,
		@IDLancamentoTipo,
		@DataLancamento,
		@IDUsuarioLancamento,
		@Previsao,
		@Situacao,
		@IDPessoaTipo,
		@IDPessoa,
		@IDEmpresa,
		@DataVencimento,
		@DataEmissao,
		@IDDocumentoTipo,
		@ValorNominal,
		@NumDocumento,
		@IDPurchase,
		@IDMoeda,
		@IDMoedaCotacao,
		@LancamentoType
END
--fechamento do cursor
CLOSE Fin_Lancamento_Cursor
--Destrui��o do cursor
DEALLOCATE Fin_Lancamento_Cursor


--Pega o IDLancamento do Pararent e os Valores para criar os disbursement frete
SELECT 
	@IDLancamentoParent = @IDLancamento,
	@SubTotal = IsNull(PT.SubTotal, 0),
	@Freight = IsNull(P.Freight, 0) + IsNull(P.OtherCharges, 0),
	@CriaDisbur = 1,
	@IDLancamentoTipo = 7 -- Cost of Good ## Davi
FROM
	Pur_Purchase P
	JOIN Pur_PurchaseTotal PT ON (PT.IDPurchase = P.IDPurchase)
WHERE
	P.IDPurchase = @IDPurchase
	AND
	P.DocumentType = 'Invoice'
	
SET @SysError = @@ERROR

IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -203
	GOTO ERRO
END


IF (@CriaDisbur = 1)
BEGIN
	--Contar total de parcelas
	--@TotalDesdobramento
	SELECT 
		COUNT (*)
	FROM 
		Pur_PurchaseItemTax PIT
	WHERE
		PIT.IDPurchase = @IDPurchase
	GROUP BY
		PIT.IDVendorTax 
 
	SET  @TotalDesdobramento =  @@ROWCOUNT

	--Cria desdobramento do Sub Total
	SET @NumDesdobramento = '1/'+Convert(VarChar(10),@TotalDesdobramento)
	EXEC sp_Fin_CriaLacamento_Disburse @IDLancamentoParent, @SubTotal, @NumDesdobramento, @IDLancamentoTipo
	
	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -204
		GOTO ERRO
	END

	--Cria desdobramento do Freight
	SET @NumDesdobramento = '2/'+Convert(VarChar(10),@TotalDesdobramento)
	EXEC sp_Fin_CriaLacamento_Disburse @IDLancamentoParent, @Freight, @NumDesdobramento, @IDLancamentoTipo

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		SET @ErrorLevel = -205
		GOTO ERRO
	END
	
	--Setar o contador para os desdobramentos de impostos
	SET @CountImposto = 3

	--Cursor para impostos
	--Declara��o do Cursor de Purchase_ItemTax_Cursor
	DECLARE Purchase_ItemTax_Cursor CURSOR FOR
		
		SELECT 
			CT.IDLancamentoTipo,
			SUM(ABS(IsNull(PIT.TaxValue,0))) as Value
		FROM 
			Pur_PurchaseItemTax PIT
			LEFT OUTER JOIN VendorTax VT ON (VT.IDVendorTax = PIT.IDVendorTax)
			LEFT OUTER JOIN TaxCategory CT ON (CT.IDTaxCategory = VT.IDTaxCategory)
		WHERE
			PIT.IDPurchase = @IDPurchase
		GROUP BY
			CT.IDLancamentoTipo,
			PIT.IDVendorTax 		
		
	OPEN Purchase_ItemTax_Cursor
		
	--Inicializa��o de Purchase_ItemTax_Cursor
	FETCH NEXT FROM Purchase_ItemTax_Cursor INTO
		@IDLancamentoTipo,
		@ValorNominal
	--Enquanto tem registros
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Cria desdobramento dos impostos
		
		SET @NumDesdobramento = Convert(VarChar(10),@CountImposto)+'/'+Convert(VarChar(10),@TotalDesdobramento)
		EXEC sp_Fin_CriaLacamento_Disburse @IDLancamentoParent, @ValorNominal, @NumDesdobramento, @IDLancamentoTipo
	
		SET @SysError = @@ERROR
		IF @SysError <> 0
		BEGIN
			SET @ErrorLevel = -206
			GOTO ERRO
		END
		
		--Incrementar o desdobramento
		SET @CountImposto = @CountImposto + 1

	FETCH NEXT FROM Purchase_ItemTax_Cursor INTO
			@IDLancamentoTipo,
			@ValorNominal
	END
	--fechamento do cursor
	CLOSE Purchase_ItemTax_Cursor
	--Destrui��o do cursor
	DEALLOCATE Purchase_ItemTax_Cursor

END

OK:
	RETURN 0
ERRO:
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_Purchase_CriaPagamentoComImposto', @ErrorLevelStr

	RETURN @ErrorLevel
GO

CREATE PROCEDURE sp_Purchase_AtuPurchaseSubTotal
	(
	@IDPurchase	int,
	@TaxInCost	bit
	)
AS

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Teste se ja existe a tabela de SubTotal
		- Atualizo o SubTotal do Purchase

	OBS
		Devido a um BUG do BDE, tenho que guardar o total do purchase em uma tabela separada,
		espero um dia, quando o bug for resolvido, voltar ao c�digo original e remover a tabela desnecessaria.

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em Teste se o purchase ja esta na tabela
		-202  Erro em Atualizo o SubTotal


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	04 dezembro 2000	Eduardo Costa		Cria��o;
	26 June 2001		Davi Gouveia		Log de Return Values
	18 Aug 2004		Rodrigo Costa		Gravar error log
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @ErrorLevel	int
DECLARE @SysError	int

SET @ErrorLevel = 0

BEGIN TRAN


------------------------------------------------------------------------------
-- Teste se o purchase ja esta na tabela

IF NOT EXISTS (SELECT SubTotal FROM Pur_PurchaseTotal WHERE IDPurchase = @IDPurchase)
	INSERT Pur_PurchaseTotal (IDPurchase, SubTotal) VALUES (@IDPurchase, 0)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -201
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Atualizo o SubTotal
IF (@TaxInCost=1)
BEGIN
	UPDATE
		P
	SET
		P.SubTotal = PT.SubTotal
	FROM
		Pur_PurchaseTotal P -- Quando o bug for resolvido trocar a tabela e remover o codigo acima
		JOIN (
	
			SELECT
				PPI.IDPurchase,
				SUM(IsNull(PPI.CostPrice * PPI.Qty, 0)) as SubTotal
			FROM
				Pur_PurchaseItem PPI
			WHERE
				PPI.IDPurchase = @IDPurchase
			GROUP BY
				PPI.IDPurchase
	
		) as PT ON (P.IDPurchase = PT.IDPurchase)


	UPDATE
		P
	SET
		P.Freight = PT.Freight,
		P.OtherCharges = PT.Other
	FROM
		Pur_Purchase P -- Quando o bug for resolvido trocar a tabela e remover o codigo acima
		JOIN (
			SELECT
				PPI.IDPurchase,
				SUM(IsNull(PPI.FreightCost, 0)) as Freight,
				SUM(IsNull(PPI.OtherCost, 0)) as Other
			FROM
				Pur_PurchaseItem PPI
			WHERE
				PPI.IDPurchase = @IDPurchase
			GROUP BY
				PPI.IDPurchase
		) as PT ON (P.IDPurchase = PT.IDPurchase)

END
ELSE
BEGIN
	UPDATE
		P
	SET
		P.SubTotal = PT.SubTotal
	FROM
		Pur_PurchaseTotal P -- Quando o bug for resolvido trocar a tabela e remover o codigo acima
		JOIN (
	
			SELECT
				PPI.IDPurchase,
				SUM(IsNull(PPI.NewCostPrice * PPI.Qty, 0)) as SubTotal
			FROM
				Pur_PurchaseItem PPI
			WHERE
				PPI.IDPurchase = @IDPurchase
			GROUP BY
				PPI.IDPurchase
	
		) as PT ON (P.IDPurchase = PT.IDPurchase)
END

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -202
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
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_Purchase_AtuPurchaseSubTotal', @ErrorLevelStr

	RETURN @ErrorLevel
GO

CREATE PROCEDURE sp_Purchase_RemoveItem
		(
 		@IDPurchase	 	 int,
		@IDPurchaseItem	 int,
		@TaxInCost		 bit
		)
AS 

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Atualizo o QtyOnPrePurchase no Inventory ### Rodrigo
		- Atualizo o QrtArrived no PreInvMov ## Rodrigo

		- Deleto os PurchaseItemSerial
		- Deleto o PurchaseItem
		- Call sp_Purchase_AtuPurchaseSubTotal

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em Deleto AsQty o item no Pur_PurchaseQtyPrePurchase
		-202  Erro em Deleto AsQty o item no Pur_PurchaseQtyOrder
		-203  Erro em Deleto os PurchaseItemSerial
		-204  Erro em Deleto o PurchaseItem
		-205  Erro em Call sp_Purchase_AtuPurchaseSubTotal
		-206  Erro em Deletarl Pur_PurchaseItemTax


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	04 dezembro 2000	Eduardo Costa		Cria��o;
	18 dez 200		Rodrigo Costa		Atualizacao;
	26 June 2001		Davi Gouveia		Log de Return Values
	18 Aug 2004		Rodrigo Costa		Gravar error log
	14 Dez 2004		Rodrigo Costa		Deletar os Pur_PurchaseItemTax
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @ErrorLevel	int
DECLARE @SysError	int

SET @ErrorLevel = 0

BEGIN TRAN


---------------------------------------------------------------------------- ##Rodrigo
-- Deleto AsQty o item no Pur_PurchaseQtyPrePurchase

DELETE
	PUQ
FROM
	Pur_PurchaseQtyPrePurchase PUQ
WHERE
	PUQ.IDModel = (
			SELECT
				PUI.IDModel
			FROM
				Pur_PurchaseItem PUI
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
	Pur_PurchaseQtyOrder PUQ
WHERE
	PUQ.IDModel = (
			SELECT
				PUI.IDModel
			FROM
				Pur_PurchaseItem PUI
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
	Pur_PurchaseItemSerial PIS
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
	Pur_PurchaseItemTax PIT
WHERE
	PIT.IDPurchaseItem = @IDPurchaseItem

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -206
	GOTO ERRO
END

------------------------------------------------------------------------------
-- Deleto o PurchaseItem

DELETE
	PPI
FROM
	Pur_PurchaseItem PPI
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

CREATE PROCEDURE sp_Purchase_Do
	(
	@IDPurchase	int,
	@Date 		DateTime,
	@TaxInCost	Bit
	)
AS

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO
		
		- Deleto os InventoryMov
		- Incluo no Inventario os barcodes que ainda nao existam
		- Altero o Category no Model quando diferente
		- Incluo o InventoryMov se necessario
		- Se necessario crio os lancamentos no contas a pagar

		- Deleto as Qty do Pur_PurchaseQtyPreSale ##Rodrigo
		- Incluo as Qty do Pur_PurchaseQtyPreSale ##Rodrigo
		- Incluo os serial Numbers no inventory

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok
		-201  Erro em Deleto as Qty do Pur_PurchaseQtyPreSale
		-202  Erro em Deleto as Qty do Pur_PurchaseQtyOrder
		-203  Erro em Deleto os PreInventoryMov
		-204  Erro em Deleto os InventoryMov
		-205  Erro em Incluo no Inventario os barcodes que ainda nao exitam
		-206  Erro em Atualizo a informa��o de category
		-207  Erro em Atualizar a TBL de Model com os valores se for Final
		-208  Erro em Incluo o InventoryMov se necessario
		-209  Erro em Insiro as Qty do Pur_PurchaseQtyPrePurchase se for PreReceiving para atualizar o qtyOnPreReceive na TBL Inventory
		-210  Erro em Insiro as Qty do Pur_PurchaseQtyOrder - Atualizar as qty no PO
		-211  Erro em Atualiza o total do PO
		-212  Erro em Crio os Serial Numbers no inventory se for final
		-213  Erro em Delete os Serail Numbers do Purchase
		-214  Erro em Deleto o Term do Fin >>> Os termos so serao deletados se o Purchase Type for do typo Invoice
		-215  Erro em Crio os lancamentos no contas a pagar, se necessario
		-216  Erro em Incluio novamente o Term do Fin >>> Os termos so serao incluidos se o Purchase Type for do typo Invoice
		-217  Erro em Deletetar o InventoryMovTax


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	04 dezembro 	2000	Eduardo Costa		Cria��o;
	18 dezembro 	2000	Rodrigo Costa		Complemento;
	06 junho        	2001	Davi Gouveia		Variavel @ErrorLevel/Lista de Return_Values
	07 junho        	2001	Rodrigo Costa		Insert no Fin_LancamentoTerm
	07 dezembro 	2001	Rodrigo Costa		Nao pode deletar p PreInventoryMov, pois os item nao sao salvos la.
	13 May	        	2002	Rodrigo Costa		Criacao Lancamento Termo para os Disbursements 
	29 Oct		2003	Rodrigo Costa		Criado Cuersor para InvMov, Pur_PurchaseQtyPrePurchase, Pur_PurchaseQtyOrder_Cursor;
							Chamado da sp_GetNextCode;
	13 Feb		2004	Rodrigo Costa		Deletar o InventoryMovTax da Compra
	18 Aug		2004	Rodrigo Costa		Gravar error log
	14 Dez		2004	Rodrigo Costa		Cricao do campo @TaxInCost para incluir o preco do item
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @IDPO 			int
DECLARE @ErrorLevel 			int
DECLARE @SysError			int

--Declara��o de vari�veis para o Cursor de InventoryMov
DECLARE @StoreID 			int 
DECLARE @IDPessoa 			int 
DECLARE @InventMovTypeID 		int 
DECLARE @DocumentID 		int 
DECLARE @ModelID 			int 
DECLARE @Qty 			int 
DECLARE @CostPrice 			money 
DECLARE @SalePrice 			money 
DECLARE @BarCodeID 			char(20)
DECLARE @MovDate 			smalldatetime 
DECLARE @IDUser 			int 
DECLARE @IDInventoryMov		int

--Declara��o de vari�veis para o Cursor de Pur_PurchaseQtyPrePurchase
DECLARE @IDModel 			int 
DECLARE @IDStore 			int 
DECLARE @IDPurchaseQtyPreSale	int

--Declara��o de vari�veis para o Cursor de Pur_PurchaseQtyOrder
DECLARE @IDPOItem 			int 
DECLARE @IDPurchaseQtyOrder	int

BEGIN TRAN


-----------------------------------------------------------
-- Deleto as Qty do Pur_PurchaseQtyPreSale
DELETE
	PQP
FROM
	Pur_PurchaseQtyPrePurchase PQP
WHERE
	PQP.IDPurchase = @IDPurchase

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -201
	GOTO ERRO
END

-----------------------------------------------------------
-- Deleto as Qty do Pur_PurchaseQtyOrder
DELETE
	PQP
FROM
	Pur_PurchaseQtyOrder PQP
WHERE
	PQP.IDPurchase = @IDPurchase

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -202
	GOTO ERRO
END



------------------------------------------------------------------------------
-- Deleto os PreInventoryMov
/*
DELETE
	PIM
FROM
	PreInventoryMov PIM
WHERE
	PIM.DocumentID = @IDPurchase
	AND
	PIM.InventMovTypeID = 2

IF @@ERROR <> 0
BEGIN
	SET @ErrorLevel = -203
	GOTO ERRO
END
*/

------------------------------------------------------------------------------
-- Deleto os InventoryMovTax

DELETE
	IMT
FROM
	InventoryMovTax IMT
WHERE
	IMT.IDInventoryMov IN (	SELECT IDInventoryMov
			       	FROM InventoryMov IM
				WHERE IM.DocumentID = @IDPurchase AND
				IM.InventMovTypeID = 2
				)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -217
	GOTO ERRO
END

------------------------------------------------------------------------------
-- Deleto os InventoryMov

DELETE
	IM
FROM
	InventoryMov IM
WHERE
	IM.DocumentID = @IDPurchase
	AND
	IM.InventMovTypeID = 2

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -204
	GOTO ERRO
END

------------------------------------------------------------------------------
-- Incluo no Inventario os barcodes que ainda nao exitam

INSERT
	BarCode (IDBarCode, IDModel, Data)
SELECT

	PPI.BarCode,
	PPI.IDModel,
	@Date
FROM
	Pur_PurchaseItem PPI
	LEFT OUTER JOIN BarCode BC ON (PPI.BarCode = BC.IDBarCode)
WHERE
	BC.IDModel IS Null
	AND
	PPI.BarCode IS NOT NULL
	AND
	PPI.IDPurchase = @IDPurchase

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -205
	GOTO ERRO
END



------------------------------------------------------------------------------
-- Atualizo a informa��o de category

UPDATE
	M
SET
	M.GroupID = PPI.IDGroup
FROM
	Model M
	JOIN Pur_PurchaseItem PPI ON (M.IDModel = PPI.IDModel)
WHERE
	M.GroupID <> PPI.IDGroup

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -206
	GOTO ERRO
END


--------------------------------------------------------------------------------------------------
---Atualizar a TBL de Model com os valores se for Final
---Imposto nao esta incluido no Custo do produto
IF (@TaxInCost=1)
BEGIN
	UPDATE
		Model
	SET
		Model.Desativado     	= 0,
		Model.SellingPrice   	= IsNull(PUI.NewSalePrice,Model.SellingPrice),
		Model.SuggRetail     	= IsNull(PUI.NewSuggRetail,Model.SuggRetail),
		Model.LastCost       	= IsNull(Model.VendorCost,0),
		Model.VendorCost     	= IsNull(PUI.NewCostPrice,0),
		Model.DateLastCost   	= @Date,
		Model.OtherCost		= PUI.OtherCost,
		Model.FreightCost    	= PUI.FreightCost,
		Model.AvgCost  		= ROUND(IsNull(	(
	
						SELECT 	(
								CASE WHEN	PUI.Qty + SUM(IsNull(Inv.QtyOnHand,0)) = 0 THEN 0
								ELSE		(
											(
											(PUI.NewCostPrice * PUI.Qty) + 
											( IsNull(Model.FinalCost,0) * SUM(IsNull(Inv.QtyOnHand,0)))
											)
											/
						       			               	(
											PUI.Qty + SUM(IsNull(Inv.QtyOnHand,0))
											)
										)
								END
							)
	
						FROM	
							Inventory Inv
							JOIN Model ON (Inv.ModelId = Model.IDModel)
						WHERE
							Inv.ModelID = PUI.IDModel
						GROUP BY  
							Model.FinalCost 
	
						), PUI.NewCostPrice ),2)
	FROM
		Pur_Purchase PU
		JOIN Pur_PurchaseItem PUI ON (PU.IDPurchase = PUI.IDPurchase)
		JOIN Pur_PurchaseTotal PUT ON (PU.IDPurchase = PUT.IDPurchase)
	WHERE
		PU.IDPurchase = @IDPurchase
		AND
		DateFinalReceiving IS NOT NULL
		AND
		Model.IDModel = PUI.IDModel
END
ELSE
BEGIN

	UPDATE
		Model
	SET
		Model.Desativado	= 0,
		Model.SellingPrice 	= IsNull(PUI.NewSalePrice,0),
		Model.SuggRetail 	= IsNull(PUI.NewSuggRetail,0),
		Model.LastCost		= IsNull(Model.VendorCost,0),
		Model.VendorCost	= IsNull(PUI.NewCostPrice,0),
		Model.DateLastCost	= @Date,
	
		Model.OtherCost 	= ROUND(
					CASE	WHEN 	PUT.SubTotal = 0 THEN 0
						ELSE	( IsNull((PU.OtherCharges / PUT.SubTotal)  * (PUI.NewCostPrice)  , 0 ) )
					END
	
				      	,2),
	
	
		Model.FreightCost 	= ROUND(
					  CASE	WHEN 	PUT.SubTotal = 0 THEN 0
						ELSE	( IsNull(	(PU.Freight / PUT.SubTotal)  * (PUI.NewCostPrice) , 0 ) )
					  END
				      	,2),
	
		Model.AvgCost  		= ROUND(IsNull(	(
	
						SELECT 	(
								CASE WHEN	PUI.Qty + SUM(IsNull(Inv.QtyOnHand,0)) = 0 THEN 0
								ELSE		(
											(
											(PUI.NewCostPrice * PUI.Qty) + 
											( IsNull(Model.FinalCost,0) * SUM(IsNull(Inv.QtyOnHand,0)))
											)
											/
						       			               	(
											PUI.Qty + SUM(IsNull(Inv.QtyOnHand,0))
											)
										)
								END
							)
	
						FROM	
							Inventory Inv
							JOIN Model ON (Inv.ModelId = Model.IDModel)
						WHERE
							Inv.ModelID = PUI.IDModel
						GROUP BY  
							Model.FinalCost 
	
						), PUI.NewCostPrice ),2)
	FROM
		Pur_Purchase PU
		JOIN Pur_PurchaseItem PUI ON (PU.IDPurchase = PUI.IDPurchase)
		JOIN Pur_PurchaseTotal PUT ON (PU.IDPurchase = PUT.IDPurchase)
	WHERE
		PU.IDPurchase = @IDPurchase
		AND
		DateFinalReceiving IS NOT NULL
		AND
		Model.IDModel = PUI.IDModel

END


SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -207
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Incluo o InventoryMov se necessario
--Declara��o do Cursor de InventoryMov
DECLARE InventoryMov_Cursor CURSOR FOR

SELECT
	PP.IDStore,
	PP.IDFornecedor,
	2, -- Compra
	PP.IDPurchase,
	PPI.IDModel,
	PPI.Qty,
	PPI.NewCostPrice,
	PPI.NewSalePrice,
	PPI.BarCode,
	PP.DateFinalReceiving,
	PP.IDUserFinalReceiving
FROM
	Pur_Purchase PP
	JOIN Pur_PurchaseItem PPI ON (PP.IDPurchase = PPI.IDPurchase)
WHERE
	PP.IDPurchase = @IDPurchase
	AND
	DateFinalReceiving IS NOT NULL

OPEN InventoryMov_Cursor

--Inicializa��o de InventoryMov_Cursor
FETCH NEXT FROM InventoryMov_Cursor INTO
	@StoreID,
	@IDPessoa,
	@InventMovTypeID,
	@DocumentID,
	@ModelID,
	@Qty,
	@CostPrice,
	@SalePrice,
	@BarCodeID,
	@MovDate,
	@IDUser
--Enquanto tem registros
WHILE
@@FETCH_STATUS = 0
BEGIN
	EXEC sp_Sis_GetNextCode'InventoryMov.IDInventoryMov', @IDInventoryMov OUTPUT

	INSERT InventoryMov
		(
		IDInventoryMov,
		StoreID,
		IDPessoa,
		InventMovTypeID,
		DocumentID,
		ModelID,
		Qty,
		CostPrice,
		SalePrice,
		BarCodeID,
		MovDate,
		IDUser
		)
	VALUES
		(
		@IDInventoryMov,
		@StoreID,
		@IDPessoa,
		@InventMovTypeID,
		@DocumentID,
		@ModelID,
		@Qty,
		@CostPrice,
		@SalePrice,
		@BarCodeID,
		@MovDate,
		@IDUser
		)

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		CLOSE InventoryMov_Cursor
		DEALLOCATE InventoryMov_Cursor
		SET @ErrorLevel = -208
		GOTO ERRO
	END

	FETCH NEXT FROM InventoryMov_Cursor INTO
		@StoreID,
		@IDPessoa,
		@InventMovTypeID,
		@DocumentID,
		@ModelID,
		@Qty,
		@CostPrice,
		@SalePrice,
		@BarCodeID,
		@MovDate,
		@IDUser
END
--fechamento do cursor
CLOSE InventoryMov_Cursor
--Destrui��o do cursor
DEALLOCATE InventoryMov_Cursor

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -208
	GOTO ERRO
END


-----------------------------------------------------------
-- Insiro as Qty do Pur_PurchaseQtyPrePurchase se for PreReceiving para atualizar o qtyOnPreReceive na TBL Inventory
--Declara��o do Cursor de Pur_PurchaseQtyPrePurchase
DECLARE Pur_PurchaseQtyPrePurchase_Cursor CURSOR FOR

SELECT
	PUI.IDModel,
	PU.IDStore,
	SUM(PUI.Qty)
FROM
	Pur_Purchase PU
	JOIN Pur_PurchaseItem PUI ON (PU.IDPurchase = PUI.IDPurchase)
WHERE
	PU.IDPurchase = @IDPurchase
	AND
	PU.DateFinalReceiving IS NULL
GROUP BY
	PUI.IDModel,
	PU.IDStore,
	PUI.IDPOItem


OPEN Pur_PurchaseQtyPrePurchase_Cursor

--Inicializa��o de Pur_PurchaseQtyPrePurchase_Cursor
FETCH NEXT FROM Pur_PurchaseQtyPrePurchase_Cursor INTO
	@IDModel,
	@IDStore,
	@Qty
--Enquanto tem registros
WHILE
@@FETCH_STATUS = 0
BEGIN
	EXEC sp_Sis_GetNextCode'Pur_PurchaseQtyPrePurchase.IDPurchaseQtyPreSale', @IDPurchaseQtyPreSale OUTPUT
	INSERT Pur_PurchaseQtyPrePurchase
		(
		IDPurchaseQtyPreSale,
		IDPurchase,
		IDModel,
		IDStore,
		Qty
		)
	VALUES
		(
		@IDPurchaseQtyPreSale,
		@IDPurchase,
		@IDModel,
		@IDStore,
		@Qty
		)

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		CLOSE Pur_PurchaseQtyPrePurchase_Cursor
		DEALLOCATE Pur_PurchaseQtyPrePurchase_Cursor
		SET @ErrorLevel = -209
		GOTO ERRO
	END

	FETCH NEXT FROM Pur_PurchaseQtyPrePurchase_Cursor INTO
		@IDModel,
		@IDStore,
		@Qty
END
--fechamento do cursor
CLOSE Pur_PurchaseQtyPrePurchase_Cursor
--Destrui��o do cursor
DEALLOCATE Pur_PurchaseQtyPrePurchase_Cursor


SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -209
	GOTO ERRO
END


-----------------------------------------------------------
-- Insiro as Qty do Pur_PurchaseQtyOrder - Atualizar as qty no PO
--Declara��o do Cursor de Pur_PurchaseQtyOrder

DECLARE Pur_PurchaseQtyOrder_Cursor CURSOR FOR

SELECT
	PUI.IDModel,
	PU.IDStore,
	PUI.IDPOItem,
	SUM(PUI.Qty)
FROM
	Pur_Purchase PU
	JOIN Pur_PurchaseItem PUI ON (PU.IDPurchase = PUI.IDPurchase)
WHERE
	PU.IDPurchase = @IDPurchase
GROUP BY
	PUI.IDModel,
	PU.IDStore,
	PUI.IDPOItem

OPEN Pur_PurchaseQtyOrder_Cursor

--Inicializa��o de Pur_PurchaseQtyOrder_Cursor
FETCH NEXT FROM Pur_PurchaseQtyOrder_Cursor INTO
	@IDModel,
	@IDStore,
	@IDPOItem,
	@Qty
--Enquanto tem registros
WHILE
@@FETCH_STATUS = 0
BEGIN
	EXEC sp_Sis_GetNextCode'Pur_PurchaseQtyOrder.IDPurchaseQtyOrder', @IDPurchaseQtyOrder OUTPUT
	INSERT Pur_PurchaseQtyOrder
		(
		IDPurchaseQtyOrder,
		IDPurchase,
		IDModel,
		IDStore,
		IDPOItem,
		Qty
		)
	VALUES
		(
		@IDPurchaseQtyOrder,
		@IDPurchase,
		@IDModel,
		@IDStore,
		@IDPOItem,
		@Qty
		)

	SET @SysError = @@ERROR
	IF @SysError <> 0
	BEGIN
		CLOSE Pur_PurchaseQtyOrder_Cursor
		DEALLOCATE Pur_PurchaseQtyOrder_Cursor
		SET @ErrorLevel = -210
		GOTO ERRO
	END

	FETCH NEXT FROM Pur_PurchaseQtyOrder_Cursor INTO
		@IDModel,
		@IDStore,
		@IDPOItem,
		@Qty
END
--fechamento do cursor
CLOSE Pur_PurchaseQtyOrder_Cursor
--Destrui��o do cursor
DEALLOCATE Pur_PurchaseQtyOrder_Cursor


SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -210
	GOTO ERRO
END

------------------------------------------------------------------------------
-- Atualiza o total do PO

SELECT
	@IDPO = PIM.DocumentID
FROM
	PreInventoryMov PIM
	JOIN Pur_PurchaseQtyOrder PQO ON (PIM.IDPreInventoryMov = PQO.IDPOItem)

EXEC sp_PO_AtuPOTotal @IDPO

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -211
	GOTO ERRO
END

------------------------------------------------------------------------------
-- Crio os Serial Numbers no inventory se for final
INSERT
	InventorySerial
	(
	StoreID,
	ModelID,
	Serial
	)
SELECT
	PU.IDStore,
	PUI.IDModel,
	PIS.SerialNumber
FROM
	Pur_Purchase PU
	JOIN Pur_PurchaseItemSerial PIS ON (PU.IDPurchase = PIS.IDPurchase)
	JOIN Pur_PurchaseItem PUI ON (PU.IDPurchase = PUI.IDPurchase)
WHERE
	PIS.IDPurchase = @IDPurchase
	AND
	PU.DateFinalReceiving IS NOT NULL

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -212
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Delete os Serail Numbers do Purchase
DELETE
	PIS
FROM
	Pur_PurchaseItemSerial PIS
	JOIN Pur_Purchase PU ON (PU.IDPurchase = PIS.IDPurchase)
WHERE
	PIS.IDPurchase = @IDPurchase
	AND
	PU.DateFinalReceiving IS NOT NULL

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -213
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Deleto o Term do Fin >>> Os termos so serao deletados se o Purchase Type for do typo Invoice


DELETE
	Fin_LancamentoTerm
WHERE
	IDLancamento IN (SELECT L.IDLancamento FROM Fin_Lancamento L WHERE L.IDPurchase = @IDPurchase)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -214
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Crio os lancamentos no contas a pagar, se necessario
IF (@TaxInCost=1)
	EXEC sp_Purchase_CriaPagamentoComImposto @IDPurchase
ELSE
	EXEC sp_Purchase_CriaPagamento @IDPurchase


SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -215
	GOTO ERRO
END


------------------------------------------------------------------------------
-- Incluio novamente o Term do Fin >>> Os termos so serao incluidos se o Purchase Type for do typo Invoice

INSERT
	Fin_LancamentoTerm (IDLancamento, DueDateShift, Discount)
SELECT
	L.IDLancamento, PT.DueDateShift, PT.Discount
FROM
	Pur_PurchaseTerm PT
	JOIN Fin_Lancamento L ON (L.IDPurchase = PT.IDPurchase)
WHERE
	L.IDPurchase = @IDPurchase

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -216
	GOTO ERRO
END


OK:
	COMMIT TRAN
	RETURN 0
ERRO:
	ROLLBACK TRAN

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_Purchase_Do', @ErrorLevelStr

	RETURN @ErrorLevel
GO
