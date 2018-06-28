INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (97, 'Auto generate price', 'False', 'Boolean', 'When a product will be saled below of the suggest price for the vendor, the system will go to generate the price automatically.', 'False', 0, 1)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (97, 1, 'Auto generate PRICE', 'When a product will be saled below of the suggest price for the vendor, the system will go to generate the price automatically.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (97, 2, 'Gerar PRICE automaticamente', 'Quando um produto for vendido abaixo do pre�o sugerido pelo fornecedor, o sistema ir� gerar o price automaticamente.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (97, 3, 'Generar PRICE autom�ticamente', 'Cuando ser� un producto saled abajo del precio del sugerir para el vendedor, el sistema ir� a generar el precio autom�ticamente.')
GO
