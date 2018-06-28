INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado)
VALUES (86, 'Default expiration length for gift cards', '-1', 'Integer', 'The default number of months until gift cards expire (-1 for no expiration)', '-1', 0)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (86, 1, 'Default expiration length for gift cards', 'The default number of months until gift cards expire (-1 for no expiration)')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (86, 2, 'Data de expira��o para vale presente', 'O n�mero de meses que o vale presente ir� expirar (-1 para nenhuma expira��o)')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (86, 3, 'Expiraci�n del tarjetas del regalo', 'El n�mero del defecto de meses hasta tarjetas del regalo expira (- 1 para ninguna expiraci�n)')
GO
