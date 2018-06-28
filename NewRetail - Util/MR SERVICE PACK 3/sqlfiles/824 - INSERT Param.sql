INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (110, 'Service Order Type', '0', 'Integer', '0 - Other, 1 - Auto Repair', '0', 0, 9)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (110, 1, 'Service Order Type', '0 - Other, 1 - Auto Repair')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (110, 2, 'Tipo de Ordem Servi�o', '0 - Outros, 1 - Auto-pe�as')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (110, 3, 'Tipo de Orden de Servicio', '0 - Otros, 1 - Repar. de Autom�viles')
GO

INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (111, 'Disable Defects in Service Order', 'False', 'Boolean', 'If this option is TRUE, system will disable defects option on Service Order.', 'False', 0, 9)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (111, 1, 'Disable Defects in Service Order', 'If this option is TRUE, system will disable defects option on Service Order.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (111, 2, 'Desabilite defeitos na OS', 'Se esta op��o for TRUE, O sistema ir� desativar a op��o defeitos na Service Order.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (111, 3, 'Deshabilitar defectos en la OS', 'Si esta opci�n es TRUE, se desactivar� el sistema de opci�n sobre defectos de la orden de servicio.')
GO
