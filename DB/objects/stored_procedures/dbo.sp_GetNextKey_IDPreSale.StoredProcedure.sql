SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sp_GetNextKey_IDPreSale]
AS

/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SUMARIO

		- Incrementa a tabela 

	TABELA DE ERROS PARA RETURN_VALUE

		 000  Ok

	LOG DE MODIFICA��ES

	Data			Programador		Modifica��o
	--------------------------------------- --------------------------------------- -----------------------------------------------------------------------------------------------------
	29 November 	2008	Rodrigo Costa		Cria��o;
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  */

DECLARE @NewSeqValue INT

SET NOCOUNT ON
INSERT INTO Key_IDPreSale (SeqVal) VALUES ('a')

SET @NewSeqValue = scope_identity()

DELETE FROM Key_IDPreSale

RETURN @NewSeqValue
GO
