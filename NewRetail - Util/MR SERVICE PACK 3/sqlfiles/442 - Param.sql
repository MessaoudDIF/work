INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, Description, DefaultValue)
VALUES (82, 'Generate Hold# when opening sale.', 'False', 'Boolean', 'Set the max number of days for payments when to validade payment method in sale', 'False')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
VALUES (82, 1, 'Generate Hold# when opening sale.', 'When the screen of venda will be opened to generate the number of the order. It enters with Falsifies to incapacitate the option')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
VALUES (82, 2, 'Gerar n�mero do pedido ao abrir a venda. ', 'Quando for aberta a tela de venda gerar o n�mero do pedido. Entre com False para desabilitar a op��o')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
VALUES (82, 3, 'Genere Asimiento al abrir venta. ', 'Cuando la pantalla del venda ser� abierta para generar el n�mero de la orden. Entre False para incapacita la opci�n')
GO
