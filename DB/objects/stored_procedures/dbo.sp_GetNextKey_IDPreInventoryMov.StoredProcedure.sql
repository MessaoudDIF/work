SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sp_GetNextKey_IDPreInventoryMov]
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
INSERT INTO Key_IDPreInventoryMov (SeqVal) VALUES ('a')

SET @NewSeqValue = scope_identity()

DELETE FROM Key_IDPreInventoryMov

RETURN @NewSeqValue
GO
