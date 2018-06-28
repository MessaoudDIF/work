SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_CashRegister_Close]
		(
		@IDCashRegMov   	int,
		@IDUser		int,
		@IDUsuario		int,
		@Bill100		int,
		@Bill50			int,
		@Bill20	 		int,
		@Bill10 			int,
		@Bill5 			int,
		@Bill2 			int,
		@Bill1 			int,
		@Coin1 		int,
		@Coin050 		int,
 		@Coin025 		int,
		@Coin010 		int,
		@Coin005 		int,
		@Coin001 		int,	
		@TotalCash		money,
		@TotalCard		money,
		@TotalCardPre		money,
		@TotalCheck		money,
		@TotalOther 		money,
		@TotalDebit 		money,
		@FinalCount		money,
		@LogDocument		varchar(20),
		@Date			Datetime,
		@IDCashRegLog	int  output
		)
AS


/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO
		
		- Testa se o final deposit ja foi feito
		- Update Final Deposit no CashRegMov
		- Insere no CashRegLog
		- Quito os lancamento dos invoices

	TABELA DE ERROS PARA RETURN_VALUE
	
		 000  Ok
		-001  Se deposito final ja foi feito
		-201  Erro em Update Final Deposit no CashRegMov
		-202  Erro em Insere no CashRegLog
		-203  Erro em Quito os lancamento dos invoices


	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	15 May 2000		Rodrigo Costa		Criacao;
	22 Jun  2001		Davi Gouveia		Log de Return Values
	21 Oct	2003		Andr� Bogado		Chamada a sp_Sis_GetNextCode para @IDCashRegLog; 
							Removido SELECT @IDCashRegLog = @@IDENTITY;
	18 Aug 2004		Rodrigo Costa		Gravar error log
	28 Oct	2006		Rodrigo Costa		Criacao do parametro de Debito
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */


DECLARE @ErrorLevel 	int
DECLARE @SysError 	INT

SET @ErrorLevel = 0

/* Testa se o final deposit ja foi feito */
if EXISTS (SELECT IDCashRegLog FROM CashRegLog (NOLOCK) WHERE IDCashRegMov = @IDCashRegMov AND IDCashRegTipoLog = 4) 
   RETURN -1


/*	Update Final Deposit no CashRegMov    */
BEGIN TRANSACTION 

UPDATE
	CashRegMov 
SET	
	FinalWidraw      		= @TotalCash + @TotalCard + @TotalCardPre + @TotalCheck + @TotalOther + @TotalDebit,
	FinalCount     		= @FinalCount,   	
	IDCashRegStatus  	= 2 
WHERE 
	IDCashRegMov = @IDCashRegMov

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -201
	GOTO ERRO
END

/*	Insere no CashRegLog            */
/******************************************************************************
	Obtenho o @IDCashRegLog
*******************************************************************************/

EXEC sp_Sis_GetNextCode 'CashRegLog.IDCashRegLog', @IDCashRegLog OUTPUT
INSERT CashRegLog
	(
	IDCashRegLog,
	IDCashRegMov,
	IDCashRegTipoLog,
	LogTime,
	IDUser,
	Bill100,
	Bill50,
	Bill20,
	Bill10,
	Bill5,
	Bill2,
	Bill1,
	Coin1,
	Coin050,
	Coin025,
	Coin010,
	Coin005,
	Coin001,
	TotalCash,		
	TotalCard,
	TotalCardPre,	
	TotalCheck,
	TotalOther,
	TotalDebit,
	LogDocument		
	)
	VALUES
	(
	@IDCashRegLog,
	@IDCashRegMov,
	4,
	@Date,
	@IDUser,
	@Bill100,
	@Bill50,
	@Bill20,
	@Bill10,
	@Bill5,
	@Bill2,
	@Bill1,
	@Coin1,
	@Coin050,
	@Coin025,
	@Coin010,
	@Coin005,
	@Coin001,
	@TotalCash,		
	@TotalCard,
	@TotalCardPre,
	@TotalCheck,
	@TotalOther,
	@TotalDebit,
	@LogDocument
	)

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -202
	GOTO ERRO
END


-- Quito os lancamento dos invoices
EXEC sp_CashRegister_Quita_Invoice @IDCashRegMov, @IDUsuario, @Date

SET @SysError = @@ERROR
IF @SysError <> 0
BEGIN
	SET @ErrorLevel = -203
	GOTO ERRO
END


OK:	
	COMMIT TRANSACTION 
	RETURN 0

ERRO:
	ROLLBACK
	PRINT CAST(@ErrorLevel AS VARCHAR)

	DECLARE @ErrorLevelStr varchar(10)
	SET  @ErrorLevelStr =  CAST(@ErrorLevel AS VARCHAR)
	EXEC sp_Sis_AppHistory_Add 0, 0, @SysError, 'MainRetail', 'Error: sp_CashRegister_Close', @ErrorLevelStr

	RETURN @ErrorLevel
GO
