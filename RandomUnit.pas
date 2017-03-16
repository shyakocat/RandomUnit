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
type
 Chart=record      //边表
  e:longint;                                  //边表的边数
  tim:longint;                                //时间戳
  head:array of longint;                      //头指针
  flag:array of longint;                      //标记数组
  next:array of longint;                      //后继数组
  node:array of record u,v:longint end;       //边表中记录过的边
  appr:array of longint;                      //边表中记录过的值
 end;
 Msg=object        //消息体
  n:longint;           //消息总数
  pr:boolean;          //输出状态
  weightsum:real;      //权重总和
  a:array of record weight:real; code:ansistring; timelim,time:longint end; //weight语句权重，code正则表达式（由Trans识别），timelim语句限制个数
  procedure add(const p:real;const s:ansistring);                           //添加语句：权重，正则表达式
  procedure add(const p:real;const s:ansistring;t:longint);                 //添加语句：权重，正则表达式，语句限制个数
  procedure print;                                                          //输出单行（不换行）
  procedure println;                                                        //输出单行（换行）
  procedure println(k:longint);                                             //输出连续K句消息，语句限制个数起作用
 end;
 alphabet=set of char;
 pint=^longint;
var
 a,f,u,v,w,_d,_s:array[0..3000005]of longint;  //a为随机数组
                                               //f为并查集
                                               //u为边的起点
                                               //v为边的终点
                                               //w为边权
                                               //_d为树深
                                               //_s为子树大小

 h,dfn:array[0..6000005]of longint;            //h为二次幂
                                               //dfn为欧拉序
 st:array of array of longint;                 //st为ST表

 mx_d,mx_s:longint;                            //mx_d为最大树深
                                               //mx_s为最大子树大小
 b:array[0..3000005]of extended;               //b为随机实数数组
 s,t:ansistring;                               //s为文本字符串
                                               //t为匹配字符串

 _pn:longint;                                  //质因子个数
 _p,_c:array[0..1005]of longint;               //_p为质数
                                               //_c为质数个数

operator :=(x:longint)s:ansistring;
operator :=(x:longint)s:string;

procedure Fopen(const s:ansistring);                     //打开输出文件
procedure Fclose;                                        //关闭输出文件
procedure Pai(ran,A,B,Ao,Bo:ansistring);                 //生成对拍的bat，ran为随机程序名，A为标程名，B为待测程序名，Ao为标程输出文件名，Bo为待测程序输出文件名
procedure Pai(x:ansistring);                             //生成对拍的bat，对应Pai(xran.exe,xa.exe,x.exe,xa.out,x.out)
procedure Option(const f:ansistring;const a:array of pint);  //从f文件读取配置的数据范围
procedure Option(const a:array of pint);                     //从opt.txt文件读取配置的数据范围

function Rnd(l,r:longint):longint;                       //随机生成[L,R]的数
function antiRnd(l,r:longint;const a:array of longint):longint; //随机生成[L,R]的数，但不能是给定的数
function Sign:longint;                                   //生成1或-1，1的概率为1/2
function Sign(x:real):longint;                           //生成1或-1，1的概率为x，x∈[0,1]
function RandomString(n:longint;s:alphabet):ansistring;  //生成长度为n，字符集为s的随机字符串
function Pair(l,r:longint):ansistring;                   //生成一个[l,r]内的不相等的两个数
function Itvl(l,r:longint):ansistring;                   //生成一个[l,r]区间
function Itvl_Lim(l,r,b:longint):ansistring;             //生成一个[l,r]区间，满足r-l+1<=b
function Trans(const s:ansistring):ansistring;           //转换正则表达式
                                                         //支持识别rnd(l,r) [l,r]随机数
                                                         //        chr(l,r) [l,r]随机字符
                                                         //        itvl(l,r) [l,r]区间
                                                         //        pair(l,r) [l,r]的两个数

procedure TreeGo(rt,n:longint);                          //以rt为根遍历树，统计_d,_s,mx_d,mx_s
function lca(u,v:longint):longint;                       //TreeGo后，求u，v的最近公共祖先

procedure FactorGo(x:longint);                           //分解质因数
function isPrime(x:longint):boolean;                     //判断质数
function PrimeRoot(x:longint):longint;                   //求原根
function Inv(a,b:longint):longint;                       //求逆元
function Phi(x:longint):longint;                         //求欧拉函数
function Miu(x:longint):longint;                         //求莫比乌斯函数

procedure RandomArray(n:longint);                        //生成一个N的排列
procedure RandomArray(n,l,r:longint);                    //生成长度为N，范围于[L,R]的数组
procedure RandomCleanArray(n,l,r:longint);               //生成长度为N，范围于[L,R]的非重复数组
procedure RandomIntervalArray(n,l,r,x:longint);          //生成长度为N，范围于[L,R]的递增数组，相邻数的差至少为x
procedure RandomArrayFloat(n,l,r:longint);               //生成长度为N，范围于[L,R+1)的实数数组
procedure RandomTree(n,l,r:longint);                     //用并查集生成随机树
procedure RandomTree2(n,l,r:longint);                    //生成随机树，i的父亲在[1,i-1]中随机
procedure RandomCircle(n,l,r:longint);                   //生成环
procedure ChainTree(n,l,r:longint);                      //生成链
procedure MumTree(n,l,r:longint);                        //生成菊花树
procedure BroomTree(n,l,r:longint);                      //生成扫帚树（菊花+链）
procedure StarTree(n,l,r:longint);                       //生成星星树，从根连接sqrt(N)条长sqrt(N)的链
procedure FullTree(n,l,r:longint);                       //生成完全二叉树
procedure CircleTree(n,l,r:longint);                     //生成环套树
procedure RandomGraph(n,m,l,r:longint);                  //生成随机图
procedure RandomCleanGraph(n,m,l,r:longint);             //生成没有自环、重边的随机有向图
procedure RandomCactus(n,m,l,r:longint);                 //生成n个点m个环的点仙人掌
procedure writea(n:longint);                             //输出a数组，一行，空格隔开
procedure writeb(n:longint);                             //输出b数组，一行，空格隔开，保留3位小数
procedure writelna(n:longint);                           //输出a数组，N行
procedure writeuv(n:longint);                            //输出u、v数组，N行
procedure writeuvw(n:longint);                           //输出u、v、w数组，N行
procedure writeTree1(Rt,n:longint);                      //输出Rt为根的N元树，N-1行，第i行为i+1点的父亲
procedure writeTree2(Rt,n:longint);                      //输出Rt为根的N元树，N行，第i行先是Si表示儿子个数，后面Si个数为i点的儿子
procedure writeGraph1(n,m,x,y:longint);                  //输出图，以n行×n列的邻接表形式，无边的权值初始化为x，y=0表示无向图否则为有向图

procedure KMPArr1(n,m:longint);                          //构造卡朴素匹配算法（非KMP）的数据（一）
procedure QSORTArr1(n:longint);                          //构造卡(l+r)div 2型快速排序的数据（一）
function SpfaGraph1(n:longint):longint;                  //构造wiki中的卡SPFA数据（实际效果一般）（一）


implementation

operator :=(x:longint)s:ansistring;begin str(x,s) end;
operator :=(x:longint)s:string;begin str(x,s) end;

  function sread_int(const s:ansistring;var i,x:longint):boolean;
  var sgn:longint;
  begin
   x:=0;
   if (i<=length(s))and(s[i]='-') then
   begin sgn:=-1; inc(i) end else sgn:=1;
   if not((i<=length(s))and('0'<=s[i])and(s[i]<='9')) then exit(false);
   while (i<=length(s))and('0'<=s[i])and(s[i]<='9') do
   begin x:=x*10+ord(s[i])-48; inc(i) end;
   x:=x*sgn;
   exit(true)
  end;

  function mch_rnd(const s:ansistring;var i:longint):ansistring;
  var j,L,R:longint;
  begin
   if copy(s,i+1,4)='rnd(' then
   begin
    j:=i+5;
    if sread_int(s,j,L) then
    if (j<=length(s))and(s[j]=',') then begin inc(j);
    if sread_int(s,j,R) then
    if (j<=length(s))and(s[j]=')') then begin i:=j+1; exit(ranC) end
    end
   end;
   exit('')
  end;

  function mch_chr(const s:ansistring;var i:longint):ansistring;
  var j,L,R:longint;
  begin
   if copy(s,i+1,4)='chr(' then
   begin
    j:=i+5;
    if j<=length(s) then begin L:=ord(s[j]); inc(j);
    if (j<=length(s))and(s[j]=',') then begin inc(j);
    if j<=length(s) then begin R:=ord(s[j]); inc(j);
    if (j<=length(s))and(s[j]=')') then begin i:=j+1; exit(char(ranC)) end
    end end end
   end;
   exit('')
  end;

  function mch_itvl(const s:ansistring;var i:longint):ansistring;
  var j,L,R,x,y:longint;
  begin
   if copy(s,i+1,5)='itvl(' then
   begin
    j:=i+6;
    if sread_int(s,j,L) then
    if (j<=length(s))and(s[j]=',') then begin inc(j);
    if sread_int(s,j,R) then
    if (j<=length(s))and(s[j]=')') then begin i:=j+1;
    x:=ranC; y:=ranC; if x>y then begin j:=x; x:=y; y:=j end;
    exit(ansistring(x)+' '+y) end
    end
   end;
   exit('')
  end;

  function mch_pair(const s:ansistring;var i:longint):ansistring;
  var j,L,R,x,y:longint;
  begin
   if copy(s,i+1,5)='pair(' then
   begin
    j:=i+6;
    if sread_int(s,j,L) then
    if (j<=length(s))and(s[j]=',') then begin inc(j);
    if sread_int(s,j,R) then
    if (j<=length(s))and(s[j]=')') then begin i:=j+1;
    x:=ranC; repeat y:=ranC until y<>x;
    exit(ansistring(x)+' '+y) end
    end
   end;
   exit('')
  end;


function Trans(const s:ansistring):ansistring;
var
 t,z:ansistring;
 i,j,tmp:longint;
begin
 t:='';
 i:=1;
 while i<=length(s) do
 begin
  if s[i]='&' then
  begin
   z:=mch_rnd(s,i);  if z<>'' then begin t:=t+z; continue end;
   z:=mch_chr(s,i);  if z<>'' then begin t:=t+z; continue end;
   z:=mch_itvl(s,i); if z<>'' then begin t:=t+z; continue end;
   z:=mch_pair(s,i); if z<>'' then begin t:=t+z; continue end;

  end;
  t:=t+s[i];
  i:=i+1
 end;
 exit(t)
end;


 procedure Msg.add(const p:real;const s:ansistring);
 begin
  inc(n);
  if n>high(a) then setlength(a,n<<1);
  a[n].weight:=p;
  a[n].code:=s;
  a[n].timelim:=maxlongint;
  weightsum:=weightsum+p
 end;

 procedure Msg.add(const p:real;const s:ansistring;t:longint);
 begin
  add(p,s);
  a[n].timelim:=t
 end;

 procedure Msg.print;
 var
  rp,ps:real;
  i:longint;
 begin
  if n=0 then exit;
  repeat
   rp:=random(maxlongint)/(maxlongint-1)*weightsum;
   ps:=0;
   for i:=1 to n do
   with a[i] do
   begin
    ps:=ps+weight;
    if ps>=rp then
    begin
     if pr then
     begin
      if timelim=time then break;
      inc(time)
     end;
     write(trans(code));
     exit
    end
   end
  until false
 end;

 procedure Msg.println;
 begin
  print; writeln
 end;

 procedure Msg.println(k:longint);
 var i:longint;
 begin
  pr:=true;
  for i:=1 to n do a[i].time:=0;
  for i:=1 to k do println;
  pr:=false
 end;


procedure Fopen(const s:ansistring);
begin
 assign(output,s); rewrite(output)
end;

procedure Fclose;
begin
 close(output)
end;

procedure Pai(ran,A,B,Ao,Bo:ansistring);
var f:text;
begin
 if (length(ran)<4)or(copy(ran,length(ran)-3,4)<>'.exe') then ran:=ran+'.exe';
 if (length(A  )<4)or(copy(A  ,length(A  )-3,4)<>'.exe') then A  :=A  +'.exe';
 if (length(B  )<4)or(copy(B  ,length(B  )-3,4)<>'.exe') then B  :=B  +'.exe';
 if (length(Ao )<4)or(copy(Ao ,length(Ao )-3,4)<>'.out')
                  and(copy(Ao ,length(Ao )-3,4)<>'.ans') then Ao :=Ao +'.out';
 if (length(Bo )<4)or(copy(Bo ,length(Bo )-3,4)<>'.out')
                  and(copy(Bo ,length(Bo )-3,4)<>'.ans') then Bo :=Bo +'.out';
 assign(f,'pai.bat'); rewrite(f);
 writeln(f,'@echo off');
 writeln(f,':loop');
 writeln(f,' '+ran);
 writeln(f,' '+A);
 writeln(f,' '+B);
 writeln(f,'fc '+Ao+' '+Bo);
 writeln(f,'if not errorlevel 1 goto loop');
 writeln(f,'pause');
 writeln(f,'goto loop');
 close(f)
end;

procedure Pai(x:ansistring);
begin
 Pai(x+'ran.exe',x+'.exe',x+'a.exe',x+'.out',x+'a.out')
end;

procedure Option(const f:ansistring;const a:array of pint);
var i:longint;
begin
 assign(input,f); reset(input);
 for i:=0 to high(a) do read(a[i]^);
 close(input)
end;

procedure Option(const a:array of pint);
begin Option('opt.txt',a) end;

function Rnd(l,r:longint):longint;
begin exit(RanC) end;

function antiRnd(l,r:longint;const a:array of longint):longint;
var x,i:longint; b:boolean;
begin
 repeat
  x:=ranC;
  b:=true;
  for i:=0 to high(a) do
  if a[i]=x then begin b:=false; break end
 until b;
 exit(x)
end;

function Sign:longint;
begin if random(2)=0 then exit(1); exit(-1) end;

function Sign(x:real):longint;
begin if random(oo)<oo*x then exit(1); exit(-1) end;

procedure sw(var a,b:longint);
var c:longint; begin c:=a; a:=b; b:=c end;

function lw(u,v:longint):longint;
begin if _d[u]<_d[v] then exit(u); exit(v) end;

procedure TreeGo(rt,n:longint);
var
 z:Chart;
 i,j,w,t:longint;

 procedure ad(u,v:longint);
 begin
  with z do
  begin
   inc(e);
   next[e]:=head[u];
   head[u]:=e;
   appr[e]:=v
  end
 end;

 procedure sk(u,k:longint);
 var i,v:longint;
 begin
  _s[u]:=1;
  inc(t);
  dfn[u]:=t;
  st[0,t]:=u;
  i:=z.head[u];
  while i<>0 do
  begin
   v:=z.appr[i];
   if v<>k then
   begin
    _d[v]:=_d[u]+1;
    sk(v,u);
    inc(_s[u],_s[v]);
    inc(t);
    st[0,t]:=u
   end;
   i:=z.next[i]
  end;
  if _d[u]>mx_d then mx_d:=_d[u];
  if (u<>rt)and(_s[u]>mx_s) then mx_s:=_s[u]
 end;

begin
 with z do
 begin
  e:=0;
  setlength(head,n+5);
  for i:=0 to n+4 do head[i]:=0;
  setlength(next,n*2+5);
  setlength(appr,n*2+5);
 end;
 for i:=1 to n-1 do
 begin
  ad(u[i],v[i]);
  ad(v[i],u[i])
 end;
 mx_d:=0;
 mx_s:=0;
 fillchar(_d,sizeof(_d),0);
 fillchar(_s,sizeof(_s),0);
 t:=0;
 w:=trunc(ln(n)/ln(2)+1e-6);
 setlength(st,w+1,n+5);
 sk(rt,0);
 for i:=2 to t do h[i]:=h[i>>1]+1;
 for j:=1 to w do
 for i:=1 to t-1<<j+1 do st[j,i]:=lw(st[j-1,i],st[j-1,i+1<<(j-1)])
end;

function lca(u,v:longint):longint;
var w:longint;
begin
 u:=dfn[u]; v:=dfn[v]; if u>v then sw(u,v); w:=h[v-u+1];
 exit(lw(st[w,u],st[w,v-1<<w+1]))
end;

procedure FactorGo(x:longint);
var i:longint;
begin
 _pn:=0;
 i:=2;
 while x>=i*i do
 begin
  if x mod i=0 then
  begin
   inc(_pn);
   _p[_pn]:=i;
   _c[_pn]:=0;
   repeat x:=x div i; inc(_c[_pn]) until x mod i<>0
  end;
  inc(i)
 end;
 if x>1 then begin inc(_pn); _p[_pn]:=x; _c[_pn]:=1 end
end;

function isPrime(x:longint):boolean;
var i:longint;
begin
 for i:=2 to trunc(sqrt(x)) do
 if x mod i=0 then exit(false);
 exit(true)
end;

function pw(const x,y,z:int64):int64;
begin
 if y=0 then exit(1);
 if y=1 then exit(x);
 exit(sqr(pw(x,y>>1,z))mod z*pw(x,y and 1,z)mod z)
end;

function PrimeRoot(x:longint):longint;
var g,i:longint; j:boolean;
begin
 FactorGo(x-1);
 for g:=2 to x-1 do
 begin
  j:=true;
  for i:=1 to _pn do
  if pw(g,(x-1)div _p[i],x)=1 then
  begin j:=false; break end;
  if j then exit(g)
 end
end;

procedure exgcd(a,b:longint;var x,y:longint);
var t:longint;
begin
 if b=0 then begin x:=1; y:=0; exit end;
 exgcd(b,a mod b,x,y);
 t:=x; x:=y; y:=t-a div b*y
end;

function Inv(a,b:longint):longint;
var y:longint; begin exgcd(a,b,Inv,y) end;

function Phi(x:longint):longint;
var i:longint;
begin
 if x=1 then exit(1);
 FactorGo(x);
 Phi:=x;
 for i:=1 to _pn do Phi:=Phi div _p[i]*(_p[i]-1)
end;

function Miu(x:longint):longint;
var i:longint;
begin
 if x=1 then exit(1);
 FactorGo(x);
 for i:=1 to _pn do
 if _c[i]>1 then exit(0);
 exit(1-(_pn and 1)*2)
end;

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
 z:Chart;

 procedure ad(v:longint);
 var
  u:longint;
 begin
  with z do
  begin
   u:=v mod P;
   flag[u]:=tim;
   inc(e);
   next[e]:=head[u];
   head[u]:=e;
   appr[e]:=v
  end
 end;

 function sk(v:longint):boolean;
 var
  i,u:longint;
 begin
  with z do
  begin
   u:=v mod P;
   if flag[u]<>tim then exit(false);
   i:=head[u];
   while i<>0 do
   begin
    if appr[i]=v then exit(true);
    i:=next[i]
   end;
   exit(false)
  end
 end;

begin
 with z do
 begin
  e:=0;
  inc(tim);
  setlength(head,P+5);
  setlength(flag,P+5);
  setlength(next,n+5);
  setlength(appr,n+5);
  for i:=1 to n do
  repeat
   a[i]:=ranC;
   if not sk(a[i]) then
   begin
    ad(a[i]);
    break
   end
  until false
 end
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

procedure RandomTree2(n,l,r:longint);
var i:longint;
begin
 for i:=1 to n-1 do
 begin
  u[i]:=rnd(1,i);
  v[i]:=i+1;
  w[i]:=ranC
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
 for i:=1 to n-1 do
 begin
  u[i]:=Root;
  v[i]:=a[i+1];
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
 for i:=n>>1 to n-1 do
 begin
  u[i]:=a[i+1];
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
 for i:=1 to (n-2)div p+1 do
 begin
  k:=(i-1)*p;
  inc(t);
  u[t]:=Root;
  v[t]:=a[k+1];
  w[t]:=ranC;
  for j:=k+2 to min(k+p,n-1) do
  begin
   inc(t);
   u[t]:=a[j-1];
   v[t]:=a[j];
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
 z:Chart;

 procedure ad(x,y:longint);
 var
  u:longint;
 begin
  with z do
  begin
   u:=(int64(x)*n+y)mod P;
   inc(e);
   next[e]:=head[u];
   head[u]:=e;
   node[e].u:=x;
   node[e].v:=y
  end
 end;

 function sk(x,y:longint):boolean;
 var
  u,i:longint;
 begin
  with z do
  begin
   u:=(int64(x)*n+y)mod P;
   i:=head[u];
   while i<>0 do
   begin
    if (node[i].u=x)and(node[i].v=y) then exit(true);
    i:=next[i]
   end;
   exit(false)
  end
 end;

begin
 with z do
 begin
  e:=0;
  setlength(head,P+5);
  for i:=0 to P+4 do head[i]:=0;
  setlength(next,m+5);
  setlength(node,m+5);
  for i:=1 to m do
  begin
   u[i]:=v[i];
   while (u[i]=v[i])or sk(u[i],v[i]) do
   begin
    u[i]:=ranN;
    v[i]:=ranN
   end;
   w[i]:=ranC;
   ad(u[i],v[i])
  end
 end
end;

function Pair(l,r:longint):ansistring;
var
 x,y:longint;
 u,v:ansistring;
begin
 x:=ranC;
 y:=ranC;
 while x=y do y:=ranC;
 str(x,u);
 str(y,v);
 exit(u+' '+v)
end;

function Itvl(l,r:longint):ansistring;
var
 x,y:longint;
 u,v:ansistring;
begin
 x:=ranC;
 y:=ranC;
 if x>y then sw(x,y);
 str(x,u);
 str(y,v);
 exit(u+' '+v)
end;

function Itvl_Lim(l,r,b:longint):ansistring;
var
 x,y:longint;
 u,v:ansistring;
begin
 x:=ranC;
 y:=min(x+rnd(0,b-1),r);
 if x>y then sw(x,y);
 str(x,u);
 str(y,v);
 exit(u+' '+v)
end;

function RandomString(n:longint;s:alphabet):ansistring;
var
 i,t:longint;
 c:char;
 x,y:ansistring;
begin
 x:='';
 t:=0;
 for c in s do
 begin
  inc(t);
  x:=x+c
 end;
 y:='';
 for i:=1 to n do
  y:=y+x[rnd(1,t)];
 exit(y)
end;

function SpfaGraph1(n:longint):longint;
var
 i,EG:longint;
begin
 for i:=1 to n-1 do
 begin
  inc(EG);
  u[EG]:=i;
  v[EG]:=i+1;
  w[EG]:=1
 end;
 for i:=1 to 4*n do
 begin
  inc(EG);
  u[EG]:=ranN;
  v[EG]:=ranN;
  w[EG]:=random(n)+n
 end;
 exit(EG)
end;

procedure writea(n:longint);
var
 i:longint;
begin
 for i:=1 to n-1 do write(a[i],' ');
 writeln(a[n])
end;

procedure writelna(n:longint);
var
 i:longint;
begin
 for i:=1 to n do writeln(a[i])
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

procedure RandomCactus(n,m,l,r:longint);             //m必须大于0且不超过[n/2]
var
 x,i,j,s,t,EG,NL,NR:longint;
 z:Chart;

 procedure ad(u,v:longint);
 begin
  with z do
  begin
   inc(e);
   next[e]:=head[u];
   head[u]:=e;
   appr[e]:=v
  end
 end;

 function Probable(l,r,x:longint):longint;
 var y:longint;
 begin
  y:=random(r-l+2);
  case y of
   0:exit(x);
   else exit(y+l-1)
  end
 end;

begin
 with z do
 begin
  e:=0;
  setlength(head,n+5);
  for i:=0 to n+4 do head[i]:=0;
  setlength(next,(n+m+5)*2);
  setlength(appr,(n+m+5)*2);
  t:=random(n-2*m+1)+m;
  s:=n-t;
  RandomTree(s,l,r);
  writeuv(s-1); writeln('The Tree');
  EG:=0;
  for i:=1 to s-1 do
  begin
   ad(u[i],v[i]);
   ad(v[i],u[i]);
   if (u[i]>m)and(v[i]>m) then
   begin
    inc(EG);
    u[EG]:=u[i];
    v[EG]:=v[i]
   end
  end;
  RandomCleanArray(m-1,1,t-1);
  qs(@a[1],m-1);
  a[0]:=0;
  for i:=1 to m-1 do
  begin
   NL:=a[i-1]+s+1;
   NR:=a[i]+s;
   for j:=NL to NR-1 do
   begin
    inc(EG);
    u[EG]:=j;
    v[EG]:=j+1
   end;
   inc(EG); u[EG]:=i; v[EG]:=NL;
   inc(EG); u[EG]:=i; v[EG]:=NR;
   j:=head[i];
   while j<>0 do
   begin
    x:=appr[j];
    if (x>m)or(x<i) then
    begin
     inc(EG);
     u[EG]:=Probable(NL,NR,i);
     v[EG]:=x
    end;
    j:=next[j]
   end
  end;
  NL:=a[m-1]+s+1;
  NR:=t+s;
  for j:=NL to NR-1 do
  begin
   inc(EG);
   u[EG]:=j;
   v[EG]:=j+1
  end;
  inc(EG); u[EG]:=m; v[EG]:=NL;
  inc(EG); u[EG]:=m; v[EG]:=NR;
  j:=head[m];
  while j<>0 do
  begin
   inc(EG);
   u[EG]:=Probable(NL,NR,m);
   v[EG]:=appr[j];
   j:=next[j]
  end;
  for i:=1 to n-1+m do w[i]:=ranC
 end
end;

procedure RandomIntervalArray(n,l,r,x:longint);      //区间总数r-l+1必须大于最大相差数(n-1)x
var
 i:longint;
begin
 RandomArray(n,l,r-(n-1)*x);
 qs(@a[1],n);
 for i:=1 to n do inc(a[i],(i-1)*x)
end;

procedure writeTree1(Rt,n:longint);
var
 z:Chart;
 i:longint;

 procedure ad(u,v:longint);
 begin
  with z do
  begin
   inc(e);
   next[e]:=head[u];
   head[u]:=e;
   appr[e]:=v
  end
 end;

 procedure sk(u,k:longint);
 var
  i,v:longint;
 begin
  with z do
  begin
   i:=head[u];
   while i<>0 do
   begin
    v:=appr[i];
    if v<>k then
    begin
     f[v]:=u;
     sk(v,u)
    end;
    i:=next[i]
   end
  end
 end;

begin
 with z do
 begin
  e:=0;
  setlength(head,n+5);
  for i:=0 to n+4 do head[i]:=0;
  setlength(next,(n+5)*2);
  setlength(appr,(n+5)*2);
  for i:=1 to n-1 do
  begin
   ad(u[i],v[i]);
   ad(v[i],u[i])
  end;
  sk(Rt,0);
  f[Rt]:=0;
  for i:=2 to n do writeln(f[i])
 end
end;

procedure writeTree2(Rt,n:longint);
var
 z:Chart;
 i,j:longint;
 a:array of longint;

 procedure ad(u,v:longint);
 begin
  with z do
  begin
   inc(e);
   next[e]:=head[u];
   head[u]:=e;
   appr[e]:=v
  end
 end;

 procedure sk(u,k:longint);
 var
  i,v:longint;
 begin
  with z do
  begin
   i:=head[u];
   while i<>0 do
   begin
    v:=appr[i];
    if v<>k then
    begin
     f[v]:=u;
     sk(v,u)
    end;
    i:=next[i]
   end
  end
 end;

begin
 with z do
 begin
  e:=0;
  setlength(head,n+5);
  for i:=0 to n+4 do head[i]:=0;
  setlength(next,(n+5)*2);
  setlength(appr,(n+5)*2);
  for i:=1 to n-1 do
  begin
   ad(u[i],v[i]);
   ad(v[i],u[i])
  end;
  sk(Rt,0);
  setlength(a,n+5);
  for i:=0 to n+4 do a[i]:=0;
  e:=0;
  for i:=0 to n+4 do head[i]:=0;
  for i:=1 to n-1 do
  if f[u[i]]=v[i] then begin ad(v[i],u[i]); inc(a[v[i]]) end
                  else begin ad(u[i],v[i]); inc(a[u[i]]) end;
  for i:=1 to n do
  begin
   write(a[i]);
   j:=head[i];
   while j<>0 do
   begin
    write(' ',appr[j]);
    j:=next[j]
   end;
   writeln
  end
 end
end;

procedure writeGraph1(n,m,x,y:longint);
var
 i,j:longint;
 a:array of array of longint;
begin
 setlength(a,n+5,n+5);
 for i:=0 to n+4 do
 for j:=0 to n+4 do a[i,j]:=x;
 for i:=1 to m do begin a[u[i],v[i]]:=w[i]; if y=0 then a[v[i],u[i]]:=w[i] end;
 for i:=1 to n do begin write(a[i,1]);
 for j:=2 to m do write(  ' ',a[i,j]); writeln end
end;




begin
 randomize;
end.
