unit System.NetEncoding;

{ Compatibility shim for Delphi 7 / 2009 (Virtual-Treeview backport):
  nur die von VirtualTrees.Export benutzte HTML-Encode-Oberflaeche. }

interface

type
  THtmlEncoding = class
  public
    class function Encode(const S : string) : string;
    // satisfies the modern call form THtmlEncoding.HTML.Encode(...)
    class function HTML : THtmlEncoding;
  end;

implementation

uses SysUtils;

class function THtmlEncoding.Encode(const S : string) : string;
var
  i : Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    case S[i] of
      '&' : Result := Result + '&amp;';
      '<' : Result := Result + '&lt;';
      '>' : Result := Result + '&gt;';
      '"' : Result := Result + '&quot;';
    else
      Result := Result + S[i];
    end;
end;

class function THtmlEncoding.HTML : THtmlEncoding;
begin
  Result := nil; // Encode is a class function; the reference is never dereferenced
end;

end.
