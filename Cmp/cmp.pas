uses crt;
var
 i:longint;
 f,g:text;
 a,b:ansistring;
 e:shortint;
begin
 i:=0;
 e:=0;
 assign(f,paramstr(1)); reset(f);
 assign(g,paramstr(2)); reset(g);
 while not eof(f) do
 begin
  inc(i);
  if eof(g) then
  begin
   repeat
    readln(a);
    while a[length(a)]<=' ' do delete(a,length(a),1);
    if a<>'' then begin e:=1; break end
   until eof(f);
   if e=1 then
   begin
    textcolor(lightred);
    writeln('File [',paramstr(2),'] is shorter')
   end;
   break
  end;
  readln(f,a);
  readln(g,b);
  while a[length(a)]<=' ' do delete(a,length(a),1);
  while b[length(b)]<=' ' do delete(b,length(b),1);
  if a<>b then
  begin
   textcolor(lightred);
   writeln('Error on Line [',i,']');
   writeln('   ',a);
   writeln('   ',b);
   e:=1
  end
 end;
 if not eof(g) then
 begin
  repeat
   readln(f,b);
   while b[length(b)]<=' ' do delete(b,length(b),1);
   if b<>'' then begin e:=1; break end
  until eof(g);
  if e=1 then
  begin
   textcolor(lightred);
   writeln('File [',paramstr(1),'] is shorter')
  end
 end;
 if e=0 then
 begin
  textcolor(lightgreen);
  writeln('No Diff     Total Line = ',i)
 end;
 writeln;
 halt(e)
end.
