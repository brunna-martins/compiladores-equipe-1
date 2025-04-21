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
}

/* Tokens para Python */
%token <str> ID
%token <str> NUMBER
%token <str> STRING
%token IF ELSE ELIF WHILE FOR DEF RETURN IN
%token TRUE FALSE NONE AND OR NOT
%token CLASS IMPORT FROM AS TRY EXCEPT FINALLY
%token WITH PASS  BREAK CONTINUE GLOBAL NONLOCAL LAMBDA
%token ASSIGN EQ NEQ LT GT LTE GTE
%token PLUS MINUS TIMES DIVIDE
%token LPAREN RPAREN COLON COMMA

%%

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