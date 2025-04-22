%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *mensagem);
int yylex(void);
extern int yylineno;
extern char *yytext;
%}

%union {
  char *str;
  int inteiro;
  float real;
  char* string;
}

%token <real> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <inteiro> INT_LITERAL

/* Tokens para Python */
%token <str> ID
%token <str> STRING
%token IF ELSE ELIF WHILE FOR DEF RETURN IN
%token TRUE FALSE NONE AND OR NOT
%token CLASS IMPORT FROM AS TRY EXCEPT FINALLY
%token WITH PASS  BREAK CONTINUE GLOBAL NONLOCAL LAMBDA
%token ASSIGN EQ NEQ LT GT LTE GTE
%token PLUS MINUS TIMES DIVIDE
%token LPAREN RPAREN COLON COMMA

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
  | program '\n'       { }
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


program : 
        | statement_list
        ;

statement_list : statement
               | statement_list statement
               ;

statement : ID    
          | IF    
          | ELSE
          | WHILE
          | FOR
          | ELIF
          | DEF
          | RETURN
          | IN
          | TRUE
          | FALSE
          | NONE
          | AND
          | OR
          | NOT
          | CLASS
          | IMPORT
          | FROM
          | AS
          | TRY
          | EXCEPT
          | FINALLY
          | WITH
          | PASS
          | BREAK
          | CONTINUE
          | GLOBAL
          | NONLOCAL
          | LAMBDA
          ;

%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}