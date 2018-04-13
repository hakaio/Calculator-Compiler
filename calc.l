%{
    #include <stdlib.h>
    void yyerror(char *);
    #include "calc.tab.h"
%}

%%

[a-z]		{
				yylval = *yytext - 'a';
				return VARIABLE;
        	}

[0-9]+      {
                yylval = atoi(yytext);
                return INTEGER;
            }

[-+()=/*\n]      return *yytext;

,           return *yytext;

[ \t]       ; /* skip whitespace */

.           yyerror("invalid character");

%%

int yywrap(){
   return 1;
}

