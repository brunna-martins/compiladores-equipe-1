%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUM
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN

// Precedência e associatividade
%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS  // pra quando formos implementar -x como negação

%%

input:
    expressao '\n'       { printf("Expressão válida!\n"); }
  | '\n'                 { /* Linha vazia, ignora */ }
  ;

expressao:
      expressao PLUS expressao
    | expressao MINUS expressao
    | expressao TIMES expressao
    | expressao DIVIDE expressao
    | LPAREN expressao RPAREN
    | NUM
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}
