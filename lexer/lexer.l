%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%

\"\"\"([^"]|\n)*?\"\"\"     {
    char* raw = strdup(yytext);
    int len = strlen(raw);

    raw[len - 3] = '\0';
    yylval.string = strdup(raw + 3);
    free(raw);
    
    { /*Ignora o conteúdo do comentário*/ }
}

\'\'\'([^"]|\n)*?\'\'\'     { 
    char* raw = strdup(yytext);
    int len = strlen(raw);

    raw[len - 3] = '\0';
    yylval.string = strdup(raw + 3);
    free(raw);
    
    /*Ignora o conteúdo do comentário*/ 
}

"#".*               { /*Ignora o conteúdo do comentário*/ }

[0-9]+\.[0-9]+      { yylval.real = atof(yytext); return FLOAT_LITERAL;}
[0-9]+              { yylval.inteiro = atoi(yytext); return INT_LITERAL; }
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