uses crt;
var
 i,Line,sum:longint;
 f,g:text;
 a,b:char;
 e:shortint;
begin
 i:=0;
 Sum:=0;
 Line:=1;
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
  if a<>b then
  begin
   textcolor(lightred);
   writeln('Error on Line [',Line,']  ',a,'(Ascii=',ord(a),')  ',b,'(Ascii=',ord(b),')');
   e:=1
  end;
  if a=#13 then inc(Line)
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
  writeln('No Diff     Total Byte = ',i)
 end;
 writeln;
 halt(e)
end.
