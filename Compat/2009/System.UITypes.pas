unit System.UITypes;

{ Compatibility shim for Delphi 7 / 2009 (Virtual-Treeview backport) }

interface

uses ImgList, StdCtrls;

type
  TImageIndex  = ImgList.TImageIndex;
  TScrollStyle = StdCtrls.TScrollStyle;

const
  // Typ-Aliase re-exportieren keine Enum-Werte (Delphi_Eigenheiten.md) - daher Const-Re-Exports.
  ssNone       = StdCtrls.ssNone;
  ssHorizontal = StdCtrls.ssHorizontal;
  ssVertical   = StdCtrls.ssVertical;
  ssBoth       = StdCtrls.ssBoth;

implementation

end.
