%{
#include <stdio.h>
#include <stdlib.h>

extern int linha;

int yylex(void);
void yyerror(const char *s);
%}

%token NUM ERROR EQUAL
%token PLUS MINUS TIMES DIVIDE MODULO
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE COLON COMMA DOT SEMICOLON
%token EQTO NOTEQTO LESSEQ GREATEQ LESSER GREATER 

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
    | LBRACKET expressao RBRACKET { $$ = $2; }
    | LBRACE expressao RBRACE     { $$ = $2; }
    | expressao EQUAL expressao   { $$ = $1 = $3; }
    | expressao SEMICOLON         { $$ = $2; }
    | expressao EQTO expressao    { $$ = $1 == $3; } // printando resultado = 0 se mentira, = 1 se verdade
    | expressao NOTEQTO expressao { $$ = $1 != $3; }
    | expressao LESSEQ expressao  { $$ = $1 <= $3; }
    | expressao GREATEQ expressao { $$ = $1 >= $3; }
    | expressao LESSER expressao  { $$ = $1 < $3; }
    | expressao GREATER expressao { $$ = $1 > $3; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático na linha: %d: %s\n", linha, s);
}

