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
