# RandomUnit
◆Pascal的随机数据生成库

# 样例：

```
uses
 RandomUnit;
const
 n=100;
begin
 Fopen('Sample.in');
 RandomTree(n,1,1000);
 writeln(n);
 writeuvw(n-1);
 Fclose
end.
```

上述代码，使用RandomUnit库生成了一个100个节点的、边权范围在[1,1000]的随机树，并输出到Sample.in文件中。







# 2017/03/12上传了RandomUnit   新版本 有更多用处了      
bzoj 4771的随机数据生成器（Tips:善用各种内置处理，强制在线的题可以把标程与待测程序的xor都去除进行对拍）
```
uses RandomUnit;
const
 n=100000;
 m=100000;
var
 i,x:longint;
begin
 Fopen('4771.in');
 writeln(1);
 writeln(n,' ',m);
 RandomArray(n,1,n);                    //生成范围在[1,n]的n个数
 writea(n);                             //输出刚才生成的n个数
 RandomTree(n,1,1);                     //生成大小为n的树
 writeTree1(1,n);                       //以输出父亲的方式输出树
 TreeGo(1,n);                           //遍历树
 for i:=1 to m do
 begin
  x:=rnd(1,n);
  writeln(x,' ',rnd(0,mx_d-_d[x]))      //mx_d表示最大深度，_d[x]表示点x的深度，这样深度就不会超限了
 end;
 Fclose
end.
```


bzoj 4765的随机数据生成器（Tips:随机库只有处理longint范围，记得改了数据范围n时要把正则表达式内的数据范围也适当调整）   
/// 2017/03/17附：可以x.def('N',100000)后将语句中N替换成100000（def(ansistring,ansistring)，可以直接写longint因为本库支持隐式转换）。注意写的是大写N不然例如rnd中的小写n会被替换掉。
```
uses RandomUnit;
const
 n=100000;
 m=100000;
var
 x:Msg;                                               //向消息体中添加正则表达式吧
begin
 Fopen('4765.in');
 writeln(n,' ',m);
 RandomArray(n,0,maxlongint-1);                       //慎用maxlongint，因为[0,maxlongint]区间长度会爆
 writea(n);
 RandomTree(n,1,1);
 writeuv(n-1);
 x.add(1,'1 &rnd(1,100000) &rnd(0,2100000000)');      //匹配——&rnd(l,r)转换成一个[l,r]随机数
 x.add(1,'2 &itvl(1,100000)');                        //匹配——&itvl(l,r)转换成一个[l,r]区间
 x.println(m);                                        //输出m句消息，上面添加的消息权重都是1，所以输出概率各50%
 Fclose
end.
```


# 2017/03/16上传了RandomUnit   新版本 添加了一些小功能       
bzoj 2759随机数据生成器（RandomUnit不能解决全部问题，有的功能还是要自己写）
```
uses RandomUnit;
{
const
 n=30000;
 q=100000;
 p=10007;
这些是原本的数据范围}
var
 n,q,p,i,x,y:longint;
 f:array[1..30000]of longint;
begin
 Option([@n,@q,@p]);                             //通过外部的opt.txt中获取n,q,p的值，这样免得每次编译了
                                                 //还可以写成Option('opt.txt',[...]);
 Fopen('2759.in');
 writeln(n);
 for i:=1 to n do
 begin
  f[i]:=antiRnd(1,n,[i]);                        //antiRnd(l,r,[...])生成[l,r]间的随机数
                                                 //但不等于后面动态数组里的数
  writeln(rnd(0,p-1),' ',f[i],' ',rnd(0,p-1))
 end;
 writeln(q);
 for i:=1 to q do
 case random(10) of                              //根据题目要求80%的数据是询问，我们可以粗略地这样写
  2..9:begin
        writeln('A ',rnd(1,n))
       end;
  0..1:begin
        x:=rnd(1,n);
        y:=antiRnd(1,n,[x]);
        writeln('C ',x,' ',rnd(0,p-1),' ',y,' ',rnd(0,p-1));
        f[x]:=y
       end
 end;
 Fclose
end.
```
