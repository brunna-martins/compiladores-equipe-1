%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *mensagem);
int yylex(void);
extern int yylineno;
%}

%union {
    char *str;
}

// Tokens reconhecidos
%token <str> ID
%token IF ELSE WHILE DEF RETURN
%token LPAREN RPAREN LBRACE RBRACE
%token ASSIGN

%type <str> expressao opt_expressao
%type opt_lista_comandos

%%

// lista de comandos
programa:
    lista_comandos
;

// pode ser um comando ou vários
lista_comandos:
      comando
    | lista_comandos comando
;

// Comandos suportados pela linguagem
comando:
      IF LPAREN opt_expressao RPAREN bloco ELSE bloco
    | WHILE LPAREN opt_expressao RPAREN bloco
    | DEF ID LPAREN RPAREN bloco
    | RETURN opt_expressao ';'
    | opt_expressao ';'
;

bloco:
    LBRACE opt_lista_comandos RBRACE
;

opt_expressao:
      expressao
    | /* vazio */ { $$ = NULL; }
;

opt_lista_comandos:
      lista_comandos
    | /* vazio */
;

expressao:
    ID { $$ = $1; }
;

%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}
