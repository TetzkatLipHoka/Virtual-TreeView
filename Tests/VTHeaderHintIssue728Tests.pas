unit VTHeaderHintIssue728Tests;

// Regression test for issue #728 "Header tooltip not always displaying".
//
// The header lives in the window's non-client area (WMNCCalcSize reserves it,
// WMNCHitTest returns HTBORDER), so hovering it produces WM_NCMOUSEMOVE messages.
// The stock THintWindow.IsHintMsg tells the VCL to cancel a pending hint on every
// such message, which made header tooltips unreliable - they only worked while
// Application.FHintWindow happened to be a TVirtualTreeHintWindow (whose IsHintMsg
// override filters those messages out).
//
// Fix: TVirtualTreeHintWindow installs itself as the application-wide hint window
// class so the override is always in effect, and falls back to the stock rendering
// for hints that do not belong to a tree (AData / FHintData.Tree = nil).
//
// These two facts are what the tests below pin down; the full end-to-end cancel
// behaviour (which needs a real cursor and message pump) is covered by the
// deterministic measurement harness build\HintProbe728.dpr.

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TVTHeaderHintIssue728Tests = class
  public
    /// The unit must have made TVirtualTreeHintWindow the application's hint window
    /// class, otherwise its IsHintMsg override cannot keep header hints alive.
    [Test]
    procedure InstallsItselfAsApplicationHintWindowClass;

    /// Because we are now the app-wide hint window, hints of foreign controls pass
    /// through us with nil hint data. CalcHintRect must still size them (previously
    /// it returned an empty rect, which would have made every other hint invisible).
    [Test]
    procedure ForeignControlHintGetsANonEmptyRect;
  end;

implementation

uses
  System.Types,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.Forms,
  VirtualTrees.AncestorVCL;

procedure TVTHeaderHintIssue728Tests.InstallsItselfAsApplicationHintWindowClass;
begin
  Assert.IsTrue(HintWindowClass = TVirtualTreeHintWindow,
    'VirtualTrees.AncestorVCL must register TVirtualTreeHintWindow as the application-wide ' +
    'hint window class so its WM_NCMOUSEMOVE filtering is always effective (issue #728).');
end;

procedure TVTHeaderHintIssue728Tests.ForeignControlHintGetsANonEmptyRect;
var
  HintWin: TVirtualTreeHintWindow;
  R: TRect;
  H: HWND;
begin
  HintWin := TVirtualTreeHintWindow.Create(nil);
  try
    H := HintWin.Handle; // force handle creation; CalcHintRect measures via the canvas
    Assert.IsTrue(H <> 0, 'Sanity: hint window handle must be created.');
    // nil hint data == a hint that does not belong to a tree (a foreign control).
    R := HintWin.CalcHintRect(300, 'A foreign control hint', nil);
    Assert.IsFalse(IsRectEmpty(R),
      'With nil hint data CalcHintRect must fall back to the stock sizing so that ' +
      'hints of other controls stay visible (issue #728).');
  finally
    HintWin.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TVTHeaderHintIssue728Tests);

end.
