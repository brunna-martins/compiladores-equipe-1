%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *mensagem);
int yylex(void);
extern int yylineno;
extern char *yytext;
char params[1024] = "";
int func_count = 0;
%}

%union {
  char *str;
  int inteiro;
  float real;
  char* string;
}

%type <str> param param_list param_geral


%token ERROR EQUAL
%token PLUS MINUS TIMES DIVIDE MODULO
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE COLON COMMA DOT SEMICOLON
%token ASSIGN EQTO NOTEQTO LESSEQ GREATEQ LESSER GREATER 

%token <real> FLOAT_LITERAL
%token <string> STRING_LITERAL
%token <inteiro> INT_LITERAL

/* Tokens para Python */
%token <str> ID
%token <str> STRING
%token IF ELSE ELIF WHILE FOR DEF RETURN IN
%token TRUE FALSE NONE AND OR NOT
%token CLASS IMPORT FROM AS TRY EXCEPT FINALLY
%token WITH PASS BREAK CONTINUE GLOBAL NONLOCAL LAMBDA

%type <inteiro> expressao

%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS


%%

input:
    /* empty */
    | input line
;

line:
    expressao '\n'   { printf("Resultado: %d\n", $1); }
    | program '\n'   { }
    | '\n'           { /* Empty line */ }
    | error '\n'     { yyerrok; }
;

expressao:
    INT_LITERAL                   { $$ = $1; } // essa linha pode ser retirada
    | expressao PLUS expressao    { $$ = $1 + $3; }
    | expressao MINUS expressao   { $$ = $1 - $3; }
    | expressao TIMES expressao   { $$ = $1 * $3; }
    | expressao DIVIDE expressao  { $$ = $1 / $3; }
    | expressao MODULO expressao  { $$ = $1 % $3; }
    | LPAREN expressao RPAREN     { $$ = $2; }
    | LBRACKET expressao RBRACKET { $$ = $2; }
    | LBRACE expressao RBRACE     { $$ = $2; }
    | expressao EQUAL expressao   { $$ = $1 = $3; }
    | expressao SEMICOLON         { $$ = $1; }
    | expressao EQTO expressao    { $$ = $1 == $3; } // printando resultado = 0 se mentira, = 1 se verdade
    | expressao NOTEQTO expressao { $$ = $1 != $3; }
    | expressao LESSEQ expressao  { $$ = $1 <= $3; }
    | expressao GREATEQ expressao { $$ = $1 >= $3; }
    | expressao LESSER expressao  { $$ = $1 < $3; }
    | expressao GREATER expressao { $$ = $1 > $3; }
    | INT_LITERAL                 { printf("INT: %d\n", $1); }
    | FLOAT_LITERAL               { printf("FLOAT: %f\n", $1); }
    | STRING_LITERAL              { printf("STRING: %s\n", $1); free($1); }
;


program: 
         statement_list
        | func_def
        ;

func_def:
    DEF ID LPAREN param_geral RPAREN COLON {
        if (strlen($4) == 0)
            printf("void %s() {\n // TODO: implementar %s\n}\n\n", $2, $2);
        else
            printf("void %s(tipoVariavel %s)  {\n   // TODO: implementar %s\n}\n\n", $2, $4, $2);
        func_count++;
        free($2);
        free($4);
    }
;


param_geral:
    /*vazio*/              { strcpy(params, ""); }
    | param_list    { /* já foi copiado para params */ }
    ;

param_list:
    param {
        $$ = strdup($1);
    }
  | param_list COMMA param {
        int len = strlen($1) + strlen($3) + 3;
        $$ = (char *)malloc(len);
        snprintf($$, len, "%s, %s", $1, $3);
    }
;


param:
    ID { $$ = $1; }
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
