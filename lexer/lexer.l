%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%

[0-9]+          { yylval = atoi(yytext); return NUM; }
"="             { return EQUAL; }  
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
\n              { return '\n'; }  // Explicitly return newline as token
[ \t]+          { /* Ignore spaces/tabs */ }
.               { printf("Caractere inválido: %s\n", yytext); return ERROR; }

%%