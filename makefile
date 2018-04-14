all: 
	flex calc.l
	bison calc.y -d
	gcc calc.tab.c -ll -ly
	