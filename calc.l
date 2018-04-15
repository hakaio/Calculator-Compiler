%{
    #include <stdlib.h>
    void yyerror(char *);
    #include "calc.tab.h"
%}

%s BOOL ARITHMETIC

%%

arithmetic { yylval = *yytext; BEGIN ARITHMETIC; return MODE; } 
boolean    { yylval = *yytext; BEGIN BOOL; return MODE; }

[a-z]		{
				yylval = *yytext - 'a';
				return VARIABLE;
        	}

<ARITHMETIC>[0-9]+      {
                yylval = atoi(yytext);
                return INTEGER;
            }
			
<BOOL>[0-1]        {
				yylval = atoi(yytext);
				return BOOLEAN; 
				
            }		

<BOOL>not return NOT;
<BOOL>and return AND;
<BOOL>or return OR;
<BOOL>xor return XOR;
<BOOL>xnor return XNOR;
<BOOL>nand return NAND;
<BOOL>nor return NOR;	
			
[-+()=/*]      return *yytext;

,           return *yytext;

[ \t]       ; 
[ \n]       { yylineno = yylineno +1; return *yytext; }

.           yyerror("invalid character");


%%

int yywrap(){
   return 1;
}

