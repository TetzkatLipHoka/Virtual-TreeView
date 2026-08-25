unit Vcl.Themes;

// Compatibility bridge for Delphi 7 / 2009 (Virtual-Treeview backport):
// maps the XE2+ StyleServices API onto Themes.TThemeServices.
// VCL styles do not exist before XE2 - IsSystemStyle is always True,
// style colors fall back to the classic system colors.

interface

uses
  Windows, Graphics, Controls, Themes, UxTheme;

type
  TThemedElement        = Themes.TThemedElement;
  TThemedElementDetails = Themes.TThemedElementDetails;
  TThemedButton         = Themes.TThemedButton;
  TThemedHeader         = Themes.TThemedHeader;
  TThemedListview       = Themes.TThemedListview;
  TThemedTreeview       = Themes.TThemedTreeview;
  TThemedToolTip        = Themes.TThemedToolTip;
  TThemedWindow         = Themes.TThemedWindow;

const
  // Typ-Aliase re-exportieren keine Enum-Werte (Delphi_Eigenheiten.md, "Ein Typ-Alias
  // re-exportiert die Enum-Werte nicht") - daher Const-Re-Exports der benutzten Werte.
  tbButtonRoot                   = Themes.tbButtonRoot;
  tbCheckBoxCheckedDisabled      = Themes.tbCheckBoxCheckedDisabled;
  tbCheckBoxCheckedHot           = Themes.tbCheckBoxCheckedHot;
  tbCheckBoxCheckedNormal        = Themes.tbCheckBoxCheckedNormal;
  tbCheckBoxCheckedPressed       = Themes.tbCheckBoxCheckedPressed;
  tbCheckBoxMixedDisabled        = Themes.tbCheckBoxMixedDisabled;
  tbCheckBoxMixedHot             = Themes.tbCheckBoxMixedHot;
  tbCheckBoxMixedNormal          = Themes.tbCheckBoxMixedNormal;
  tbCheckBoxMixedPressed         = Themes.tbCheckBoxMixedPressed;
  tbCheckBoxUncheckedDisabled    = Themes.tbCheckBoxUncheckedDisabled;
  tbCheckBoxUncheckedHot         = Themes.tbCheckBoxUncheckedHot;
  tbCheckBoxUncheckedNormal      = Themes.tbCheckBoxUncheckedNormal;
  tbCheckBoxUncheckedPressed     = Themes.tbCheckBoxUncheckedPressed;
  tbGroupBoxNormal               = Themes.tbGroupBoxNormal;
  tbPushButtonDisabled           = Themes.tbPushButtonDisabled;
  tbPushButtonHot                = Themes.tbPushButtonHot;
  tbPushButtonNormal             = Themes.tbPushButtonNormal;
  tbPushButtonPressed            = Themes.tbPushButtonPressed;
  tbRadioButtonCheckedDisabled   = Themes.tbRadioButtonCheckedDisabled;
  tbRadioButtonCheckedHot        = Themes.tbRadioButtonCheckedHot;
  tbRadioButtonCheckedNormal     = Themes.tbRadioButtonCheckedNormal;
  tbRadioButtonCheckedPressed    = Themes.tbRadioButtonCheckedPressed;
  tbRadioButtonUncheckedDisabled = Themes.tbRadioButtonUncheckedDisabled;
  tbRadioButtonUncheckedHot      = Themes.tbRadioButtonUncheckedHot;
  tbRadioButtonUncheckedNormal   = Themes.tbRadioButtonUncheckedNormal;
  tbRadioButtonUncheckedPressed  = Themes.tbRadioButtonUncheckedPressed;
  thHeaderItemHot                = Themes.thHeaderItemHot;
  thHeaderItemNormal             = Themes.thHeaderItemNormal;
  thHeaderItemPressed            = Themes.thHeaderItemPressed;
  thHeaderItemRightNormal        = Themes.thHeaderItemRightNormal;
  thHeaderSortArrowSortedDown    = Themes.thHeaderSortArrowSortedDown;
  thHeaderSortArrowSortedUp      = Themes.thHeaderSortArrowSortedUp;
  ttBranch                       = Themes.ttBranch;
  ttItemDisabled                 = Themes.ttItemDisabled;
  ttItemHot                      = Themes.ttItemHot;
  ttItemNormal                   = Themes.ttItemNormal;
  ttItemSelected                 = Themes.ttItemSelected;
  ttItemSelectedNotFocus         = Themes.ttItemSelectedNotFocus;
  ttGlyphClosed                  = Themes.ttGlyphClosed;
  ttGlyphOpened                  = Themes.ttGlyphOpened;
  tttStandardNormal              = Themes.tttStandardNormal;
  twWindowRoot                   = Themes.twWindowRoot;
  teButton                       = Themes.teButton;

type
  TElementColor = (ecBorderColor, ecFillColor, ecTextColor, ecGradientColor1, ecGradientColor2);
  TElementSize  = (esMinimum, esActual, esStretch);

  TElementEdge  = (eeRaisedOuter, eeRaisedInner, eeSunkenOuter, eeSunkenInner);
  TElementEdges = set of TElementEdge;
  TElementEdgeFlag  = (efRect, efLeft, efTop, efRight, efBottom);
  TElementEdgeFlags = set of TElementEdgeFlag;

  // Nur die von VirtualTreeView benutzten Werte.
  TStyleColor = (scTreeView);
  TStyleFont  = (sfTreeItemTextDisabled);

  // XE3+: TControl.StyleElements. Ohne Styles sind immer alle Elemente aktiv; Setter ist No-Op.
  TStyleElement  = (seFont, seClient, seBorder);
  TStyleElements = set of TStyleElement;

  TCustomStyleServices = class(TObject)
  private // not "strict": D7 does not know strict visibility
    function GetEnabled : Boolean;
    function GetAvailable : Boolean;
    function GetIsSystemStyle : Boolean;
    function ThemeHandle(const Details : TThemedElementDetails) : HTHEME;
  public
    function GetElementDetails(Detail : TThemedButton) : TThemedElementDetails; overload;
    function GetElementDetails(Detail : TThemedHeader) : TThemedElementDetails; overload;
    function GetElementDetails(Detail : TThemedListview) : TThemedElementDetails; overload;
    function GetElementDetails(Detail : TThemedTreeview) : TThemedElementDetails; overload;
    function GetElementDetails(Detail : TThemedToolTip) : TThemedElementDetails; overload;
    function GetElementDetails(Detail : TThemedWindow) : TThemedElementDetails; overload;
    // Boolean result like XE2+: False = nothing drawn (themes off), caller falls back to classic painting.
    function DrawElement(DC : HDC; const Details : TThemedElementDetails; const R : TRect; ClipRect : PRect = nil) : Boolean;
    procedure DrawEdge(DC : HDC; const Details : TThemedElementDetails; const R : TRect; Edges : TElementEdges; Flags : TElementEdgeFlags);
    function GetElementColor(const Details : TThemedElementDetails; ElementColor : TElementColor; out Color : TColor) : Boolean;
    function GetElementSize(DC : HDC; const Details : TThemedElementDetails; ElementSize : TElementSize; out Size : TSize) : Boolean;
    function GetSystemColor(Color : TColor) : TColor;
    function GetStyleColor(Color : TStyleColor) : TColor;
    function GetStyleFontColor(Font : TStyleFont) : TColor;
    procedure PaintBorder(Control : TWinControl; EraseLRCorner : Boolean);
    property Enabled : Boolean read GetEnabled;
    property Available : Boolean read GetAvailable;
    property IsSystemStyle : Boolean read GetIsSystemStyle;
  end;

{$IF CompilerVersion >= 18} // class helpers exist since D2006; on D7 the StyleElements call sites are version-gated instead
  TControlStyleElementsHelper = class helper for TControl
  private
    function GetStyleElements : TStyleElements;
    procedure SetStyleElements(const Value : TStyleElements);
  public
    property StyleElements : TStyleElements read GetStyleElements write SetStyleElements;
  end;
{$IFEND}

function StyleServices : TCustomStyleServices;

implementation

var
  GServices : TCustomStyleServices = nil;

function StyleServices : TCustomStyleServices;
begin
  if GServices = nil then
    GServices := TCustomStyleServices.Create;
  Result := GServices;
end;

{ TCustomStyleServices }

function TCustomStyleServices.GetEnabled : Boolean;
begin
  Result := ThemeServices.ThemesEnabled;
end;

function TCustomStyleServices.GetAvailable : Boolean;
begin
  Result := ThemeServices.ThemesAvailable;
end;

function TCustomStyleServices.GetIsSystemStyle : Boolean;
begin
  Result := True; // VCL-Styles gibt es vor XE2 nicht
end;

function TCustomStyleServices.ThemeHandle(const Details : TThemedElementDetails) : HTHEME;
begin
  Result := ThemeServices.Theme[Details.Element];
end;

function TCustomStyleServices.GetElementDetails(Detail : TThemedButton) : TThemedElementDetails;
begin
  Result := ThemeServices.GetElementDetails(Detail);
end;

function TCustomStyleServices.GetElementDetails(Detail : TThemedHeader) : TThemedElementDetails;
begin
  Result := ThemeServices.GetElementDetails(Detail);
end;

function TCustomStyleServices.GetElementDetails(Detail : TThemedListview) : TThemedElementDetails;
begin
  Result := ThemeServices.GetElementDetails(Detail);
end;

function TCustomStyleServices.GetElementDetails(Detail : TThemedTreeview) : TThemedElementDetails;
begin
  Result := ThemeServices.GetElementDetails(Detail);
end;

function TCustomStyleServices.GetElementDetails(Detail : TThemedToolTip) : TThemedElementDetails;
begin
  Result := ThemeServices.GetElementDetails(Detail);
end;

function TCustomStyleServices.GetElementDetails(Detail : TThemedWindow) : TThemedElementDetails;
begin
  Result := ThemeServices.GetElementDetails(Detail);
end;

function TCustomStyleServices.DrawElement(DC : HDC; const Details : TThemedElementDetails; const R : TRect; ClipRect : PRect) : Boolean;
begin
  Result := ThemeServices.ThemesEnabled;
  if not Result then
    Exit;
{$IF CompilerVersion < 20} // D7's Themes.pas takes ClipRect as PRect directly
  ThemeServices.DrawElement(DC, Details, R, ClipRect);
{$ELSE}
  if ClipRect = nil then
    ThemeServices.DrawElement(DC, Details, R)
  else
    ThemeServices.DrawElement(DC, Details, R, ClipRect^);
{$IFEND}
end;

procedure TCustomStyleServices.DrawEdge(DC : HDC; const Details : TThemedElementDetails; const R : TRect; Edges : TElementEdges; Flags : TElementEdgeFlags);
var
  edge, flg : Cardinal;
begin
  edge := 0;
  if eeRaisedOuter in Edges then edge := edge or BDR_RAISEDOUTER;
  if eeRaisedInner in Edges then edge := edge or BDR_RAISEDINNER;
  if eeSunkenOuter in Edges then edge := edge or BDR_SUNKENOUTER;
  if eeSunkenInner in Edges then edge := edge or BDR_SUNKENINNER;
  flg := 0;
  if efRect   in Flags then flg := flg or BF_RECT;
  if efLeft   in Flags then flg := flg or BF_LEFT;
  if efTop    in Flags then flg := flg or BF_TOP;
  if efRight  in Flags then flg := flg or BF_RIGHT;
  if efBottom in Flags then flg := flg or BF_BOTTOM;
  ThemeServices.DrawEdge(DC, Details, R, edge, flg);
end;

function TCustomStyleServices.GetElementColor(const Details : TThemedElementDetails; ElementColor : TElementColor; out Color : TColor) : Boolean;
const
  cPropId : array [TElementColor] of Integer = (
    TMT_BORDERCOLOR, TMT_FILLCOLOR, TMT_TEXTCOLOR, TMT_GRADIENTCOLOR1, TMT_GRADIENTCOLOR2);
var
  cref : COLORREF;
begin
  Color := clNone;
  Result := ThemeServices.ThemesEnabled and Assigned(GetThemeColor) and
    (GetThemeColor(ThemeHandle(Details), Details.Part, Details.State, cPropId[ElementColor], cref) = S_OK);
  if Result then
    Color := cref;
end;

function TCustomStyleServices.GetElementSize(DC : HDC; const Details : TThemedElementDetails; ElementSize : TElementSize; out Size : TSize) : Boolean;
const
  cSizeKind : array [TElementSize] of TThemeSize = (TS_MIN, TS_TRUE, TS_DRAW);
begin
  Size.cx := 0;
  Size.cy := 0;
  Result := ThemeServices.ThemesEnabled and Assigned(GetThemePartSize) and
    (GetThemePartSize(ThemeHandle(Details), DC, Details.Part, Details.State, nil, cSizeKind[ElementSize], Size) = S_OK);
end;

function TCustomStyleServices.GetSystemColor(Color : TColor) : TColor;
begin
  Result := Color; // klassische Systemfarben werden von der VCL selbst aufgeloest
end;

function TCustomStyleServices.GetStyleColor(Color : TStyleColor) : TColor;
begin
  Result := clWindow; // scTreeView
end;

function TCustomStyleServices.GetStyleFontColor(Font : TStyleFont) : TColor;
begin
  Result := clGrayText; // sfTreeItemTextDisabled
end;

procedure TCustomStyleServices.PaintBorder(Control : TWinControl; EraseLRCorner : Boolean);
begin
  ThemeServices.PaintBorder(Control, EraseLRCorner);
end;

{$IF CompilerVersion >= 18}
{ TControlStyleElementsHelper }

function TControlStyleElementsHelper.GetStyleElements : TStyleElements;
begin
  Result := [seFont, seClient, seBorder];
end;

procedure TControlStyleElementsHelper.SetStyleElements(const Value : TStyleElements);
begin
  // No-Op: ohne VCL-Styles gibt es nichts umzuschalten
end;
{$IFEND}

initialization

finalization
  GServices.Free;

end.
