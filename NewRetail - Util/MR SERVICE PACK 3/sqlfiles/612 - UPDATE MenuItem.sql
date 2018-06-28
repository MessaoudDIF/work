UPDATE MenuItem
SET ParentMenu = 'Utilidades', Name = 'Shipping && Distribution', Tip = 'Create Shipping && Distribution sales', ImageIndex = 66, Shortcut = NULL, cmdLine = NULL, Enabled = 1
WHERE IDMenu = 9 AND IDSubMenu = 3
GO

UPDATE MenuItemLanguage
SET ParentMenu = 'Utilidades', Name = 'Shipping && Distribution', Tip = 'Create Shipping && Distribution sales'
WHERE IDMenu = 9 AND IDSubMenu = 3 AND IDLanguage = 1
GO

UPDATE MenuItemLanguage
SET ParentMenu = 'Utilidades', Name = 'Distribui��o && Transporte', Tip = 'Vendas para Distribui��o && Transporte'
WHERE IDMenu = 9 AND IDSubMenu = 3 AND IDLanguage = 2
GO

UPDATE MenuItemLanguage
SET ParentMenu = 'Utilitarios', Name = 'Distribuci�n && Env�o', Tip = 'Ventas para Distribuci�n && Env�o'
WHERE IDMenu = 9 AND IDSubMenu = 3 AND IDLanguage = 3
GO

UPDATE UserRights
SET CanAccess = 1, CanInsert = 1, CanDelete = 1, CanUpdate = 1, CanPrint = 1
WHERE UserTypeID = 1 AND MenuID = 9 AND SubMenuID = 3
GO
