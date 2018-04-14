# Calculator-Compiler
A micro compiler for parsing boolean and arithmetic instructions

# How to compile 

 ```C
 flex calc.l
 bison calc.y -d
 gcc calc.tab.c -ll -ly
 ```
 or use single command make
 
 ```c
 make
 ````
# How to Run

 ```c
 ./a.out
 ````

 After running the a.out file, your calculator runs and you have to enter the input


