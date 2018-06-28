INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (113, 'Return without receipt = Store Credit', 'True', 'Boolean', 'If this option is TRUE, Return without receipt requires Store credit payment only', 'True', 0, 1)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (113, 1, 'Return without receipt = Store Credit', 'If this option is set to True then returns without a receipt can only be issued by store credit.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (113, 2, 'Devolu��o sem recibo = Cr�dito loja', 'Sef or TRUE, Devolu��o sem recibo deve ser conclu�do com pagamento do cr�dito da loja!')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (113, 3, 'Volver sin recibir = cr�dito tienda', 'Si esta opci�n se establece en True devuelve sin un recibo s�lo puede ser expedido por cr�dito en la tienda.')
GO
