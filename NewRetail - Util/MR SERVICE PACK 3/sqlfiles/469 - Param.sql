INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado)
VALUES (85, 'Use fractional quantities in system', 'False', 'Boolean', 'Use fractional quantities on purchase orders, requests, etc.', 'False', 0)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (85, 1, 'Use fractional quantities in system', 'Use fractional quantities on purchase orders, requests, etc.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (85, 2, 'Usar Quantidade fracion�ria', 'Usar quantidades fracion�rias em ordens de compra, pedidos, etc.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (85, 3, 'Utilizar el Qtd fractionary', 'Utilizar las cantidades fraccionarias en las �rdenes de compra, peticiones, etc')
GO
