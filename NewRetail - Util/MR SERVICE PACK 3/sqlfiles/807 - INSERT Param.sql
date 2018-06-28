INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (107, 'Auto generate document number', 'False', 'Boolean', 'If this option will be TRUE, system will go automatically to generate the document number in receiving.', 'False', 0, 4)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (107, 1, 'Auto generate document number', 'If this option will be TRUE, system will go automatically to generate the document number in receiving.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (107, 2, 'Gerar n�mero do documento automatico', 'Se esta op��o for TRUE, sistema ir� gerar automaticamente o n�mero de documento de compras no recebimento.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (107, 3, 'Generar n�mero de la compra automatic.', 'Si esta opci�n es TRUE, el sistema ir� autom�ticamente a generar el n�mero de la compra.')
GO

INSERT Sis_CodigoIncremental (Tabela, UltimoCodigo)
VALUES ('Pur_Purchase.DocNum', 1000)
GO
