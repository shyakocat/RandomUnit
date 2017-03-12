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







# 2017/03/12上传了RandomUnit   新版本有更多用处了      
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
 RandomArray(n,1,n);
 writea(n);
 RandomTree(n,1,1);
 writeTree1(1,n);
 TreeGo(1,n);
 for i:=1 to m do
 begin
  x:=rnd(1,n);
  writeln(x,' ',rnd(0,mx_d-_d[x]))
 end;
 Fclose
end.
```


bzoj 4765的随机数据生成器（Tips:随机库只有处理longint范围，记得改了数据范围n时要把正则表达式内的数据范围也适当调整）
```
uses RandomUnit;
const
 n=100000;
 m=100000;
var
 x:Msg;
begin
 Fopen('4765.in');
 writeln(n,' ',m);
 RandomArray(n,0,maxlongint-1);
 writea(n);
 RandomTree(n,1,1);
 writeuv(n-1);
 x.add(1,'1 &rnd(1,100000) &rnd(0,2100000000)');
 x.add(1,'2 &itvl(1,100000)');
 x.println(m);
 Fclose
end.
```
