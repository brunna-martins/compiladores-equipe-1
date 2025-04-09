%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUM ERROR EQUAL
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN MODULO

%left PLUS MINUS
%left TIMES DIVIDE

%%

input:
    /* empty */
    | input line
;

line:
    expressao '\n'   { printf("Resultado: %d\n", $1); }
    | '\n'           { /* Empty line */ }
    | error '\n'     { yyerrok; }
;

expressao:
    NUM                           { $$ = $1; }
    | expressao PLUS expressao    { $$ = $1 + $3; }
    | expressao MINUS expressao   { $$ = $1 - $3; }
    | expressao TIMES expressao   { $$ = $1 * $3; }
    | expressao DIVIDE expressao  { $$ = $1 / $3; }
    | expressao MODULO expressao  { $$ = $1 % $3; }
    | LPAREN expressao RPAREN     { $$ = $2; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

