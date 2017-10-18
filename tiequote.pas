program TieQuote;
{
           TieQuote -  CGI  - Version 0.1/CGI
                            - April 17 2009

       Display a random quote on web page.

        todo:

        Done:

}

{$mode TP}
uses
  dos;                          {Disk}

type
  Foc = File of char;

var
  tieversion: String;           {Program name and Version}
  s: String;                    {Generic String}
  taglist: String;              {Name of the tagline file}
  Tagcolor: String;             {Colour of the tagline}
  tag: String;                  {The actual randomized tagline}
  Ch: Char;
  Ch2: Char;
  Tagfile: Foc;
  FPos: LongInt;

function exedir: string;                         {Get the Main directory}
var
  s: string;
begin
  s:=paramstr(0);
  while s[length(s)]<>'\' do dec(s[0]);
  exedir:=s;
end;

Procedure ReadConfig;                           {Reads the config information}
var
  f: Text;
begin
  Assign(F, exedir + 'tiequote.cfg');           {tiequote.cfg is in the same dir as the tieread.exe}
  {$I-}Reset(f);{$I+}
  if ioresult<>0 then                           {File not found!}
  begin
    WriteLn('<HTML>');
    WriteLn('The Config file does not exist.<BR>');
    WriteLn('Please place the tiequote.cfg in your CGI-BIN Directory.<BR>');
    WriteLn('<BR> <BR>');
    WriteLn('<BR>');
    WriteLn('<BR><BR>');
    WriteLn('<FONT COLOR="Yellow">Written by: Shawn ''<A HREF="http://t1ny.kicks-ass.org:9080/cgi-bin/email.exe?to=tiny">Tiny</A>'' Highfield<BR>');
    WriteLn('<A HREF="http://t1ny.kicks-ass.org:9080/">Shawn''s Place</A>');
    WriteLn('</BODY> </HTML>');
    Halt;
  end;
  ReadLn(F, TagList);                           {Get the datafile name}
  ReadLn(F, tagcolor);                          {Color you want the tagline in}
  Close(F);
end;


Procedure _ReadLn(Var F:Foc;Var Line:String);
var
  ThisCh,
  ThatCh: Char;
Begin
  Line := '';
  if FPos = 0 then Line := Ch;
  Repeat
    if Eof(F) then Exit;
    ThatCh := ThisCh;
    Read(F,ThisCh);
    If (ThisCh <> #13) AND (ThisCh <> #10) Then Line := Line + ThisCh;
  Until (ThatCh = #13) And (ThisCh = #10);
End;


Function Newtag(Show: Boolean): String;
var
  S: String;
begin
  Assign(Tagfile, taglist);
  Reset(Tagfile);
  FPos := Random(Filesize(Tagfile));
  repeat
    Ch2 := Ch;
    Dec(FPos);
    Seek(Tagfile, FPos);
    Read(Tagfile, Ch);
  until ((Ch = #13) And (Ch2 = #10)) OR (FPos = 0);
  _ReadLn(Tagfile, S);
  Close(Tagfile);
  Newtag := S;
end;


begin
  Randomize;                                    {Get some Randomness}
  TieVersion := '<Font Color="grey">TieQuote v0.1</FONT>';
  ReadConfig;                                   {Read config file}
  writeln('Content-type: text/html');           {Send info to browser}
  writeln;
  WriteLn(tagcolor);
  Tag := NewTag(True);
  WriteLn(Tieversion);
  WriteLn(' ...' + tag);
  WriteLn('</FONT>');
end.
