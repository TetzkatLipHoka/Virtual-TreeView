# Virtual-Treeview — V8 backport for Delphi 7 to 13.1

This is a fork of [JAM-Software/Virtual-TreeView](https://github.com/JAM-Software/Virtual-TreeView)
that carries **current V8 master backported to older Delphi versions** — one code
base from Delphi 7 up to Delphi 13.1, no separate legacy line. If you are on a
recent RAD Studio, use the [upstream repository](https://github.com/JAM-Software/Virtual-TreeView);
this fork exists for everyone stuck below its supported floor.

Virtual Treeview is a Delphi treeview control built from ground up. Many years of
development made it one of the most flexible and advanced tree controls available
today.

## What is inside

- **Current V8 master** as the base, with newer upstream fixes cherry-picked
  (e.g. the Windows 7 black-tree fix from upstream PR #1390).
- **All fixes from the 2026-08 series** that were developed and measured on this
  code base and are merged upstream: #1197 (SelectedCount), #632 (PaintTo /
  WM_PRINT), #1091 (bands), #1074 (unbuffered painting under mapping modes),
  #765 (full row focus rect), #1379 (keyboard refocus), #1377 (fixed column
  drag trap), the classic-mode `Header.Background` fix and the dpi-independent
  `TestCopyHTML` rework.
- **Fork extras** (opt-in, default behavior unchanged):
  - A manual dark mode for hosts without VCL styles (e.g. IDE plugins):
    classic header cells honor `Header.Background`, plus
    `TBaseVirtualTree.DarkNativeScrollBars` for system-dark native scroll bars
    (Windows 10 1809+; full rendering requires a Unicode window class, i.e.
    Delphi 2009+ built executables).
  - `VirtualTrees.Utils.DrawDataBar`: an Excel-style in-cell data bar with heat
    coloring for use from `OnBeforeCellPaint`.

## Verified compilers

| Compiler | Status |
|---|---|
| Delphi 7 | builds; demos run; headless regression probe green |
| Delphi 2009 | builds; demos run |
| Delphi 10 Seattle – 10.4 | builds (full matrix) |
| Delphi 11.3, 12.3, 13.1 | builds; DUnitX suite **154/154 green** on 13.1 |

Versions between Delphi 2010 and XE8 are untested. XE2/XE3 are known to trip
over compiler quirks of that era (see
[upstream issue #1395](https://github.com/JAM-Software/Virtual-TreeView/issues/1395)
for the measured details and a possible upstream XE3 revival).

Win32 is the tested target. Unicode rendering works on all versions including
Delphi 7; on Delphi 7 the in-place editors accept ANSI input (extensible via
`IVTEditLink`).

## Building

- **Delphi 10 Seattle and newer:** add `Source` to your project/library path —
  done.
- **Delphi 7 / 2009:** additionally add `Compat\2009` to the search path (small
  self-contained shims for `System.UITypes`, `Vcl.Themes` and friends).
  Delphi 2009 also needs the unit aliases from
  `Compat\2009\unit-aliases-2009.txt` (project options → unit aliases, or the
  `-A` command line switch).
- Delphi 7 forms use the generated `*.D7.dfm` variants shipped with the demos.

## Relationship to upstream

Fixes found here are submitted upstream first (see the PR series above — all
merged); upstream fixes are cherry-picked back, so this fork stays a superset
of upstream master rather than a diverging line. Bug reports for old-Delphi
behavior are welcome in this fork's issue tracker; everything else belongs
[upstream](https://github.com/JAM-Software/Virtual-TreeView/issues).

## License and credits

Same licensing as upstream (MPL 1.1 / LGPL 2.1 dual license, see the header of
`Source\VirtualTrees.pas`). Virtual
Treeview was initially created by Mike Lischke and is maintained by JAM Software
and contributors. The backport work in this fork is by TetzkatLipHoka.
