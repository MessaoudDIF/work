INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (92, 'Apply Bonus Buck on sale', 'False', 'Boolean', 'When a product will be added for sale, the system will go to process the Bonus that it will be tied', 'False', 0, 1)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (92, 1, 'Apply Bonus Buck on sale', 'When a product will be added for sale, the system will go to process the Bonus that it will be tied.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (92, 2, 'Aplicar B�nus na venda', 'Quando um produto for adicionado � venda, o sistema ir� processar o B�nus que ele estiver vinculado.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (92, 3, 'Apliq�ese Prima en la venta', 'Cuando un producto ser� agregado para la venta, el sistema ir� a procesar la Prima que ser� atado.')
GO
