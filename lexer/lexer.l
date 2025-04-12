%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%

[0-9]+\.[0-9]+      { yylval.real = atof(yytext); return FLOAT_LITERAL;}
[0-9]+              { yylval.inteiro = atoi(yytext); return NUM; }
\"([^\"\\]|\\.)*\"  { yylval.string = strdup(yytext); return STRING_LITERAL; }
\'([^\'\\]|\\.)*\'  { yylval.string = strdup(yytext); return STRING_LITERAL; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return TIMES; }
"/"                 { return DIVIDE; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
[ \t]+              { /* Ignorar espaços em branco */ }
\n                  { return '\n'; }

.                   { printf("Caractere inválido: %s\n", yytext); }

%%