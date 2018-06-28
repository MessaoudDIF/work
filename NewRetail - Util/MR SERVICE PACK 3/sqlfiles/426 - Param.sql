Insert into Param (IDParam, SrvParameter, SrvValue, SrvType, Description, DefaultValue)
Values (80, 'Apply promo on sale', 'False', 'Boolean', 'When a product will be added for sale, the system will go to process the promotion that it will be tied.', 'False')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (80, 1, 'Apply promo on sale', 'When a product will be added for sale, the system will go to process the promotion that it will be tied.')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (80, 2, 'Aplicar promo��o na venda', 'Quando um produto for adicionado � venda, o sistema ir� processar a promo��o que ele estiver vinculado.')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (80, 3, 'Apliq�ese promoci�n en la venta', 'Cuando un producto ser� agregado para la venta, el sistema ir� a procesar la promoci�n que ser� atado.')
GO
