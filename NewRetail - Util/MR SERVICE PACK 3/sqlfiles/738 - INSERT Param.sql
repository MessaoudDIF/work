INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (101, 'Calculate commission on hold paid', 'False', 'Boolean', 'If this option is TRUE, the software will calculate commission on hold paid. Otherwise, it calculates commission including all holds.', 'False', 0, 6)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (101, 1, 'Calculate commission on hold paid', 'If this option is TRUE, the software will calculate commission on hold paid. Otherwise, it calculates commission including all holds.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (101, 2, 'Calcular comiss�o sobre pedido pago', 'Se esta op��o for TRUE, o sistema calcular� a comiss�o sobre pedidos com pagamento cadastrado. Se FALSE, calcular� sobre todos os pedidos.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (101, 3, 'Calcular la comisi�n en pedido pago', 'Si esta opci�n es TRUE, el software calcular� a comisi�n en pedido pago. Si FALSE, calcula a comisi�n incluyendo todos.')
GO
