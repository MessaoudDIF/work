INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (114, 'Editing Purchase History back in month', '0', 'Integer', 'Allow editing of purchase history back # of month', '0', 0, 4)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (114, 1, 'Editing Purchase History back in month', 'Allow editing of purchase history back # of month.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (114, 2, 'Alterar Hist�rico de Compras em X meses', 'Esta op��o permite alterar o Hist�rico de Compras em X meses retroativo!')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (114, 3, 'Edici�n historia de compra en el mes', 'Permitir la edici�n de la historia de la compra de nuevo # de mes.')
GO
