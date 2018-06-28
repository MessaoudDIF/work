INSERT INTO SysFunction (IDSysFunction, IDMenu, IDSubMenu, SysFunction)
VALUES (73, 1, 3, 'Can change or remove transfer after printing?')
GO

INSERT INTO SysFunctionLanguage (IDSysFunction, IDLanguage, SysFunction)
VALUES (73, 1, 'Can change or remove transfer after printing?')
GO

INSERT INTO SysFunctionLanguage (IDSysFunction, IDLanguage, SysFunction)
VALUES (73, 2, 'Pode alterar ou excluir transfer�ncias depois de imprimir?')
GO

INSERT INTO SysFunctionLanguage (IDSysFunction, IDLanguage, SysFunction)
VALUES (73, 3, '�Puede cambiar o excluir transferencias despu�s de imprimir?')
GO

UPDATE UserTypeToSysFunction
SET Acesso = 1
WHERE IDSysFunction = 73 AND IDUserType = 1
GO
