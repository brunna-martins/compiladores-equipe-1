%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%union {
  int inteiro;
  float real;
  char* string;
}

%token <real> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <inteiro> INT_LITERAL
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN

%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS

%%

input:
    /* vazio */        { /* entrada vazia é válida */ }
  | input linha        { /* acumula linhas válidas */ }
  ;

linha:
    expressao '\n'     { }
  | '\n'               { /* ignora linha vazia */ }
  | error '\n'         { yyerrok; }
  ;

expressao:
      expressao PLUS expressao
    | expressao MINUS expressao
    | expressao TIMES expressao
    | expressao DIVIDE expressao
    | LPAREN expressao RPAREN
    | INT_LITERAL               { printf("INT: %d\n", $1); }
    | FLOAT_LITERAL             { printf("FLOAT: %f\n", $1); }
    | STRING_LITERAL            { printf("STRING: %s\n", $1); free($1); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}
