UPDATE MenuItem
SET Name = 'Inventory setup',
Tip = 'Calculate margin, ClassABC, Auto-Request, and rounding prices per category, sub-category, and group'
Where IDMenu = 8 AND IDSubMenu = 8
GO

UPDATE MenuItemLanguage
SET Name = 'Inventory setup',
Tip = 'Calculate margin, ClassABC, Auto-Request, and rounding prices per category, sub-category, and group'
Where IDMenu = 8 AND IDSubMenu = 8 AND IDLanguage = 1
GO

UPDATE MenuItemLanguage
SET Name = 'Configura��o do estoque',
Tip = 'Configurar margem, Curva ABC, auto-requisi��o e arredondamento de pre�os para categoria, subcategoria, e grupos'
Where IDMenu = 8 AND IDSubMenu = 8 AND IDLanguage = 2
GO

UPDATE MenuItemLanguage
SET Name = 'Arreglo Inventorio',
Tip = 'Calcule margen, CurvaABC, y precios redondos por la categor�a, por la subcategor�a, y por el grupo'
Where IDMenu = 8 AND IDSubMenu = 8 AND IDLanguage = 3
GO
