uses crt;
var
 i:longint=0;
 f,g:text;
 a,b,esp:extended;
 e:shortint;
begin
 if paramcount<3 then exp:=1e-7
                 else val(paramstr(3),esp);
 e:=0;
 assign(f,paramstr(1)); reset(f);
 assign(g,paramstr(2)); reset(g);
 while not eof(f) do
 begin
  inc(i);
  if eof(g) then
  begin
   textcolor(lightred);
   writeln('File [',paramstr(2),'] is shorter');
   e:=1;
   break
  end;
  read(f,a);
  read(g,b);
  if abs(a-b)>esp then
  begin
   textcolor(lightred);
   writeln('Error on Line [',i,']  ',a:0:8,' ',b:0:8);
   e:=1
  end
 end;
 if not eof(g) then
 begin
  textcolor(lightred);
  writeln('File [',paramstr(1),'] is shorter');
  e:=1
 end;
 if e=0 then
 begin
  textcolor(lightgreen);
  writeln('No Diff     Total = ',i)
 end;
 writeln;
 halt(e)
end.
