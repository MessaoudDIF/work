INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (100, 'Auto generate transfer items number', 'False', 'Boolean', 'If this option will be TRUE, system will go automatically to generate the number of the transfer for new exit transfers.', 'False', 0, 5)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (100, 1, 'Auto generate transfer items number', 'If this option is TRUE, the software will calculate commission on invoices. Otherwise, it calculates commission including hold.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (100, 2, 'Gerar n�mero de transfer�ncia automatico', 'Se esta op��o for TRUE, sistema ir� gerar automaticamente o n�mero da transfer�ncia para novas transfer�ncias de sa�da.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (100, 3, 'Generar n�mero de la transf. automatic.', 'Si esta opci�n es TRUE, el sistema ir� autom�ticamente a generar el n�mero de la transferencia para las nuevas transferencias de la salida.')
GO
