INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (98, 'Use identification number on serial', 'False', 'Boolean', 'It qualifies a field to be used as one second identification of the serial number.', 'False', 0, 5)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (98, 1, 'Use identification on serial', 'It qualifies a field to be used as one second identification of the serial number.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (98, 2, 'Usa identifica��o no serial', 'Habilita um campo para ser utilizado como uma segunda identifica��o do n�mero de s�rie.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (98, 3, 'Utilizar identificacion en serial', 'Califica un campo para ser utilizado como una segundo identificacion del numero de serie.')
GO
