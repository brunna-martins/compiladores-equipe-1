%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%

[0-9]+          { yylval = atoi(yytext); return NUM; }

"("             { return LPAREN; }
")"             { return RPAREN; }
"["             { return LBRACKET; }
"]"             { return RBRACKET; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
":"             { return COLON; }
","             { return COMMA; }
"."             { return DOT; }

"="             { return EQUAL; }  
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"%"             { return MODULO; }

\n              { return '\n'; }  // Explicitly return newline as token
[ \t]+          { /* Ignore spaces/tabs */ }
.               { printf("Caractere inválido: %s\n", yytext); return ERROR; }

%%