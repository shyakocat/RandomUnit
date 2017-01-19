{$M 100000000,0,100000000}       //����ջ�ռ�
{$MACRO ON}                      //�����궨��
{$define ranC:=random(R-L+1)+L}  //����[L,R]���������
{$define ranN:=random(N)+1}      //����[1,N]���������

unit RandomUnit;

interface
uses math;
const
 oo=$3f3f3f3f;     //�����
 P=6662333;        //�߱��Hashģֵ
var
 a,f,u,v,w:array[0..3000005]of longint;  //aΪ�������
                                         //fΪ���鼯
                                         //uΪ���ߵĵ�
                                         //vΪ��ߵĵ�
                                         //wΪ��Ȩ
 b:array[0..3000005]of extended;         //bΪ���ʵ������

 e:longint;                                              //�߱�ı���
 head:array[0..P]of longint;                             //ͷָ��
 next:array[0..10000005]of longint;                      //�������
 node:array[0..10000005]of record u,v:longint end;       //�߱��м�¼���ı�


procedure RandomArray(n:longint);                        //����һ��N������
procedure RandomArray(n,l,r:longint);                    //���ɳ���ΪN����Χ��[L,R]������
procedure RandomArrayFloat(n,l,r:longint);               //���ɳ���ΪN����Χ��[L,R]��ʵ������
procedure RandomTree(n,l,r:longint);                     //�ò��鼯���������
procedure ChainTree(n,l,r:longint);                      //������
procedure MumTree(n,l,r:longint);                        //���ɾջ���
procedure BroomTree(n,l,r:longint);                      //����ɨ�������ջ�+����
procedure StarTree(n,l,r:longint);                       //�������������Ӹ�����sqrt(N)����sqrt(N)����
procedure FullTree(n,l,r:longint);                       //������ȫ������
procedure RandomGraph(n,m,l,r:longint);                  //�������ͼ
procedure RandomCleanGraph(n,m,l,r:longint);             //����û���Ի����رߵ��������ͼ
procedure SpfaGraph(n:longint);                          //����wiki�еĿ�SPFA���ݣ�ʵ��Ч��һ�㣩
procedure writea(n:longint);                             //���a���飬һ�У��ո����
procedure writeb(n:longint);                             //���b���飬һ�У��ո����������3λС��
procedure writeuv(n:longint);                            //�������N��
procedure writeuvw(n:longint);                           //�������Ȩ����N��



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



begin
 randomize;
end.