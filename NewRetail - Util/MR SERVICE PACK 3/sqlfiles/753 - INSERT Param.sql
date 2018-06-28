INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (103, 'Disable increase price on sale', 'True', 'Boolean', 'If this option is TRUE, when you change the sale price for more then original value, it will replace the sale price.', 'True', 0, 1)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (103, 1, 'Disable increase price on sale', 'If this option is TRUE, when you change the sale price for more then original value, it will replace the sale price.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (103, 2, 'Desabilitar acr�scimo do pre�os de venda', 'Se for TRUE, quando a altera��o do pre�o de venda for maior que o valor original, o sistema substituir� o pre�o de venda.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (103, 3, 'Deshabilitar aumento de precios la venta', 'Si esta opci�n es TRUE, al cambiar el precio de venta de m�s del valor original, que sustituir� al precio de venta.')
GO
