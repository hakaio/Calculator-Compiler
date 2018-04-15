%{
    #include <stdio.h>
    int yylex(void);
    void yyerror(char *);
	int sym[26];
%}


%token INTEGER VARIABLE BOOLEAN MODE
%token AND OR NOT NAND NOR XOR XNOR
%left '+' '-'
%left '*' '/'
%left AND OR NOT NAND NOR XOR XNOR

%%

program:
        program statement '\n'         
        | 
        ;
		
statement:
		  MODE					     { if($1==97){printf("Switched to Arithmetic Mode\n");} else{printf("Switched to Boolean Mode\n");} }
	 	  |arith_expr			             { printf("%d\n", $1); }
		  |bool_expr                                 { printf("%d\n", $1); }
		  |VARIABLE '=' arith_expr                   { sym[$1] = $3; }
		  |VARIABLE '=' bool_expr                    { sym[$1] = $3; }
		  | statement ',' VARIABLE '=' arith_expr    { sym[$3] = $5; }
		  | statement ',' VARIABLE '=' bool_expr     { sym[$3] = $5; }
		  |
		  ;
		  

arith_expr:
        INTEGER                               { $$ = $1; }
	| VARIABLE		              { $$ = sym[$1]; }
        | arith_expr '+' arith_expr           { $$ = $1 + $3; }
        | arith_expr '-' arith_expr           { $$ = $1 - $3; }
	| arith_expr '*' arith_expr           { $$ = $1 * $3; }
	| arith_expr '/' arith_expr 	      { if($3==0){yyerror("Division by 0 error");} else{$$ = $1/$3;} }
	| '(' arith_expr ')' 		      { $$ = $2; }
        ;

bool_expr: 
		BOOLEAN
		| VARIABLE				  { $$ = sym[$1]; }
		| bool_expr OR bool_expr  		  { if($1==1||$3==1){$$=1;} else{$$=0;} }
		| bool_expr AND bool_expr 		  { $$ = $1 * $3; }
		| bool_expr NAND bool_expr 		  { if($1 * $3 == 1){$$=0;} else{$$=1;} }
		| bool_expr XOR bool_expr 		  { if( $1 ==0 && $3==1 || $1 ==1 && $3==0){ $$=1; } else{$$=0 ;} }
		| bool_expr NOR bool_expr 		  { if($1==0&&$3 ==0){$$=1;} else{$$=0;} }
		| bool_expr XNOR bool_expr		  { if( $1 ==0 && $3==0 || $1 ==1 && $3==1){ $$=1; } else{$$=0;} }
		| NOT bool_expr 		          { if($2==1){ $$=0;} else{ $$=1;} }
		| '(' bool_expr ')' 			  { $$ = $2;      }
        ;

%%
#include "lex.yy.c"
void yyerror(char *s) {

    fprintf(stderr, "%s at line: %d\n", s,yylineno);
}

int main(int argc , char * argv[]) {
	
	if(argv[1] != "console"){
		
		yyin = fopen(argv[1],"r");
	}
	
    if(!yyparse()){
		
		printf("Parsing Complete\n");
	}
	else{
		
		printf("Parsing Failed\n");
	}
	
	fclose(yyin);
    return 0;
}

