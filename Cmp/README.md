# Cmp
◆RandomUnit附属的比较文件

# 样例[2017/05/26]：

# pai.bat
```
@echo off
:loop
 3787ran.exe
 3787.exe
 3787a.exe
cmp_real 3787.out 3787a.out 1e-7
if not errorlevel 1 goto loop
pause
goto loop
```

上述代码，用cmp_real来对比两个输出文件的若干个实数是否在误差范围内（Luogu3787）。




>cmp            忽略行末空格、忽略多余空行对比                     
>cmp_real       实数绝对误差对比                     
>cmp_bin        完全对比                       
