INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (106, 'Confirm budget before import', 'False', 'Boolean', 'Type TRUE to validate delivery and payment condition before import a budget.', 'False', 0, 1)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (106, 1, 'Confirm budget before import', 'Type TRUE to validate delivery and payment condition before import a budget.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (106, 2, 'Confirmar or�amento antes de importar', 'Digite TRUE para validar a entrega e condi��o de pagamento antes de importa��o de um or�amento.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (106, 3, 'Confirmar presupuesto antes importaci�n', 'Tipo TRUE para validar la entrega y el pago condici�n de importaci�n antes de un presupuesto.')
GO
