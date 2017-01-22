{$M 100000000,0,100000000}         //扩大栈空间
{$MACRO ON}                        //开启宏定义
{$define ranC:=random(R-L+1)+L}    //生成[L,R]的随机整数
{$define ranN:=random(N)+1}        //生成[1,N]的随机整数
{$define ranA:=chr(97+random(26))} //生成随机小写字母

unit RandomUnit;

interface
uses math;
const
 oo=$3f3f3f3f;     //无穷大
 P=6662333;        //边表的Hash模值
var
 a,f,u,v,w:array[0..3000005]of longint;  //a为随机数组
                                         //f为并查集
                                         //u为出边的点
                                         //v为入边的点
                                         //w为边权
 b:array[0..3000005]of extended;         //b为随机实数数组
 s,t:ansistring;                         //s为文本字符串
                                         //t为匹配字符串

 e:longint;                                              //边表的边数
 head:array[0..P]of longint;                             //头指针
 next:array[0..10000005]of longint;                      //后继数组
 node:array[0..10000005]of record u,v:longint end;       //边表中记录过的边
 appr:array[0..10000005]of longint;                      //边表中记录过的值

procedure RandomArray(n:longint);                        //生成一个N的排列
procedure RandomArray(n,l,r:longint);                    //生成长度为N，范围于[L,R]的数组
procedure RandomCleanArray(n,l,r:longint);               //生成长度为N，范围于[L,R]的非重复数组
procedure RandomArrayFloat(n,l,r:longint);               //生成长度为N，范围于[L,R]的实数数组
procedure RandomTree(n,l,r:longint);                     //用并查集生成随机树
procedure RandomCircle(n,l,r:longint);                   //生成环
procedure ChainTree(n,l,r:longint);                      //生成链
procedure MumTree(n,l,r:longint);                        //生成菊花树
procedure BroomTree(n,l,r:longint);                      //生成扫帚树（菊花+链）
procedure StarTree(n,l,r:longint);                       //生成星星树，从根连接sqrt(N)条长sqrt(N)的链
procedure FullTree(n,l,r:longint);                       //生成完全二叉树
procedure CircleTree(n,l,r:longint);                     //生成环套树
procedure RandomGraph(n,m,l,r:longint);                  //生成随机图
procedure RandomCleanGraph(n,m,l,r:longint);             //生成没有自环、重边的随机有向图
procedure SpfaGraph(n:longint);                          //生成wiki中的卡SPFA数据（实际效果一般）
procedure writea(n:longint);                             //输出a数组，一行，空格隔开
procedure writeb(n:longint);                             //输出b数组，一行，空格隔开，保留3位小数
procedure writeuv(n:longint);                            //输出树，N行
procedure writeuvw(n:longint);                           //输出带边权树，N行

procedure KMPArr1(n,m:longint);                          //构造卡朴素匹配算法的数据（一）
procedure QSORTArr1(n:longint);                          //构造卡(l+r)div 2型快速排序的数据（一）


implementation

procedure sw(var a,b:longint);
var c:longint; begin c:=a; a:=b; b:=c end;

procedure RandomArray(n:longint);
var
 i:longint;
begin
 for i:=1 to n do a[i]:=i;
 for i:=1 to n do sw(a[ranN],a[ranN]);
end;

procedure RandomArray(n,l,r:longint);
var
 i:longint;
begin
 for i:=1 to n do a[i]:=ranC
end;

procedure RandomCleanArray(n,l,r:longint);
var
 i:longint;

 procedure ad(v:longint);
 var
  u:longint;
 begin
  u:=v mod P;
  inc(e);
  next[e]:=head[u];
  head[u]:=e;
  appr[e]:=v
 end;

 function sk(v:longint):boolean;
 var
  i,u:longint;
 begin
  u:=v mod P;
  i:=head[u];
  while i<>0 do
  begin
   if appr[i]=v then exit(true);
   i:=next[i]
  end;
  exit(false)
 end;

begin
 e:=0;
 fillchar(head,sizeof(head),0);
 for i:=1 to n do
 repeat
  a[i]:=ranC;
  if not sk(a[i]) then
  begin
   ad(a[i]);
   break
  end
 until false
end;

procedure RandomArrayFloat(n,l,r:longint);
var
 i:longint;
begin
 for i:=1 to n do b[i]:=ranC+random(1000)/1000
end;

procedure RandomTree(n,l,r:longint);
var
 i,ru,rv:longint;

 function sk(x:longint):longint;
 begin if x<>f[x] then f[x]:=sk(f[x]); exit(f[x]) end;

begin
 for i:=1 to n do f[i]:=i;
 for i:=1 to n-1 do
 begin
  ru:=rv;
  while ru=rv do
  begin
   u[i]:=ranN;
   v[i]:=ranN;
   ru:=sk(u[i]);
   rv:=sk(v[i])
  end;
  w[i]:=ranC;
  f[ru]:=rv
 end
end;

procedure CircleTree(n,l,r:longint);
begin
 RandomTree(n,l,r);
 u[n]:=ranN;
 v[n]:=u[n]; while u[n]=v[n] do v[n]:=ranN;
 w[n]:=ranC
end;

procedure ChainTree(n,l,r:longint);
var
 i:longint;
begin
 RandomArray(n);
 for i:=1 to n-1 do
 begin
  u[i]:=a[i];
  v[i]:=a[i+1];
  w[i]:=ranC
 end
end;

procedure RandomCircle(n,l,r:longint);
var
 Root,i:longint;
begin
 ChainTree(n,l,r);
 u[n]:=a[1];
 v[n]:=a[n];
 w[n]:=ranC
end;

procedure MumTree(n,l,r:longint);
var
 Root,i:longint;
begin
 RandomArray(n);
 Root:=a[1];
 for i:=2 to n do
 begin
  u[i]:=Root;
  v[i]:=a[i];
  w[i]:=ranC
 end
end;

procedure BroomTree(n,l,r:longint);
var
 Root,i:longint;
begin
 RandomArray(n);
 Root:=a[n>>1];
 for i:=1 to n>>1-1 do
 begin
  u[i]:=Root;
  v[i]:=a[i];
  w[i]:=ranC
 end;
 for i:=n>>1+1 to n do
 begin
  u[i]:=a[i-1];
  v[i]:=a[i];
  w[i]:=ranC
 end
end;

procedure StarTree(n,l,r:longint);
var
 Root,t,i,j,k,p:longint;
begin
 t:=0;
 RandomArray(n);
 Root:=a[n];
 p:=trunc(sqrt(n-1));
 for i:=1 to n div p+1 do
 begin
  k:=(i-1)*p;
  inc(t);
  u[t]:=Root;
  v[t]:=k+1;
  w[t]:=ranC;
  for j:=k+2 to min(k+p,n-1) do
  begin
   inc(t);
   u[t]:=j-1;
   v[t]:=j;
   w[t]:=ranC
  end
 end
end;

procedure FullTree(n,l,r:longint);
var
 i:longint;
begin
 RandomArray(n);
 for i:=2 to n do
 begin
  u[i]:=a[i];
  v[i]:=a[i>>1];
  w[i]:=ranC
 end
end;

procedure RandomGraph(n,m,l,r:longint);
var
 i:longint;
begin
 for i:=1 to m do
 begin
  u[i]:=ranN;
  v[i]:=ranN;
  w[i]:=ranC
 end
end;

procedure RandomCleanGraph(n,m,l,r:longint);
var
 i:longint;

 procedure ad(x,y:longint);
 var
  u:longint;
 begin
  u:=(int64(x)*n+y)mod P;
  inc(e);
  next[e]:=head[u];
  head[u]:=e;
  node[e].u:=x;
  node[e].v:=y
 end;

 function sk(x,y:longint):boolean;
 var
  u,i:longint;
 begin
  u:=(int64(x)*n+y)mod P;
  i:=head[u];
  while i<>0 do
  begin
   if (node[i].u=x)and(node[i].v=y) then exit(true);
   i:=next[i]
  end;
  exit(false)
 end;

begin
 e:=0;
 fillchar(head,sizeof(head),0);
 for i:=1 to m do
 begin
  u[i]:=v[i];
  while (u[i]=v[i])or sk(u[i],v[i]) do
  begin
   u[i]:=ranN;
   v[i]:=ranN
  end;
  w[i]:=ranC
 end
end;

procedure SpfaGraph(n:longint);
var
 i:longint;
begin
 for i:=1 to n-1 do
 begin
  u[i]:=i;
  v[i]:=i+1;
  w[i]:=1
 end;
 for i:=1 to 4*n do
 begin
  u[i]:=ranN;
  v[i]:=ranN;
  w[i]:=random(n)+n
 end
end;

procedure writea(n:longint);
var
 i:longint;
begin
 for i:=1 to n-1 do write(a[i],' ');
 write(a[n])
end;

procedure writeb(n:longint);
var
 i:longint;
begin
 for i:=1 to n-1 do write(b[i]:0:3,' ');
 write(b[n]:0:3)
end;

procedure writeuv(n:longint);
var
 i:longint;
begin
 for i:=1 to n do writeln(u[i],' ',v[i])
end;

procedure writeuvw(n:longint);
var
 i:longint;
begin
 for i:=1 to n do writeln(u[i],' ',v[i],' ',w[i])
end;



procedure KMPArr1(n,m:longint);
var
 i:longint;
 a,b:char;
begin
 s:='';
 t:='';
 a:=ranA;
 b:=a; while b=a  do b:=ranA;
 for i:=1 to m-1 do t:=t+a; t:=t+b;
 for i:=1 to n do s:=s+a
end;

procedure sw(a,b:Pointer);
var
 p:Pointer;
begin
 GetMem(p,4);
 Move(a^,p^,4);
 Move(b^,a^,4);
 Move(p^,b^,4);
 FreeMem(p)
end;

procedure qs(a:Pointer;n:longint);
var
 i,j,m:longint;
begin
 if n<15 then
 begin
  for i:=0   to n-2 do
  for j:=1+i to n-1 do
  if longint((a+i<<2)^)>longint((a+j<<2)^) then sw(a+i<<2,a+j<<2);
  exit
 end;
 i:=0; j:=n-1; m:=longint((a+random(n)<<2)^);
 repeat
  while longint((a+i<<2)^)<m do inc(i);
  while longint((a+j<<2)^)>m do dec(j);
  if i<=j then begin sw(a+i<<2,a+j<<2); inc(i); dec(j) end
 until i>j;
 if i<n-1 then qs(a+i<<2,n-i);
 if 0<j   then qs(a,j+1)
end;

procedure qs(l,r:longint);
var
 i,j,m:longint;
begin
 i:=l; j:=r; m:=a[(l+r)>>1];
 repeat
  while a[i]<m do inc(i);
  while a[j]>m do dec(j);
  if i<=j then begin sw(a[i],a[j]); inc(i); dec(j) end
 until i>j;
 if i<r then qs(i,r);
 if l<j then qs(l,j)
end;

procedure QSORTArr1(n:longint);
var
 i:longint;
begin
 RandomArray(n);
 qs(@a[1],n);
 for i:=2 to n do sw(a[(1+i)>>1],a[i])
end;

begin
 randomize;
end.
