unit uLanguageFunctions;

{
   Hold multi Languages function
   Developer: Rodrigo Costa - 05/08/02
}

interface

type
   TAcento       = array[0..13, 0..1] of String;

const
  aAcento      : TAcento      =  (
                                  ('a', '�'),
                                  ('a', '�'),
                                  ('a', '�'),
                                  ('a', '�'),
                                  ('c', '�'),
                                  ('e', '�'),
                                  ('e', '�'),
                                  ('i', '�'),
                                  ('o', '�'),
                                  ('o', '�'),
                                  ('o', '�'),
                                  ('o', '�'),
                                  ('u', '�'),
                                  ('u', '�')
                                  );

implementation

end.
