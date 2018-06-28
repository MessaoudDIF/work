unit uClasseFunctions;

interface

uses Math;

const

  CONTADOR_OCORRENCIA_SALES_TODAY   = 0;
  CONTADOR_OCORRENCIA_ITEM_ON_HOLD  = 1;
  CONTADOR_OCORRENCIA_ITEM_ON_PO    = 2;
  CONTADOR_OCORRENCIA_BREAK_EVEN    = 3;
  CONTADOR_CONTAPAGAR_APROVAR       = 4;
  CONTADOR_CONTARECEVER_APROVAR     = 5;
  CONTADOR_PAYABLE_DUE_DATE_PAST    = 6;

function ClasseTem(Propriedade, MClasse: Integer): Boolean;
function GetClasse(Propriedade, MClasse: Integer; bVal:Boolean): Integer;


implementation

function ClasseTem(Propriedade, MClasse: Integer): Boolean;
var
  i: variant;
begin
  i := Power(2, Propriedade);
  Result := (MClasse and i) = i;
end;

function GetClasse(Propriedade, MClasse: Integer; bVal:Boolean): Integer;
var
  i: variant;
begin
  i := Power(2, Propriedade);
  if bVal then
     Result := MClasse + i
  else
     Result := MClasse - i;
end;

end.