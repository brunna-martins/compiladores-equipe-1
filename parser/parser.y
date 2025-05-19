%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "numero.h" 

void yyerror(const char *mensagem);
int yylex(void);

extern int yylineno;
extern char *yytext;
char params[1024] = "";
char* param_names[50];
int func_count = 0;
int param_count = 0;

float get_valor(Numero n) {
    return n.tipo == TIPO_INT ? n.valor.i : n.valor.f;
}

%}

%code requires {
  #include "numero.h"
}

%union {
  char *str;
  Numero numero;
  int inteiro;
  float real;
  char* string;
}

%type <str> param param_list param_geral


%token ERROR EQUAL
%token INDENT DEDENT NEWLINE
%token PLUS MINUS TIMES DIVIDE MODULO
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE COLON COMMA DOT SEMICOLON
%token ASSIGN EQTO NOTEQTO LESSEQ GREATEQ LESSER GREATER 

%token <numero> NUMBER
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

%type <real> expressao

%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS


%%

input:
    /* empty */
    | input line
;

line:
    expressao NEWLINE   { printf("Resultado: %f\n", $1); }
    | program NEWLINE   { }
    | NEWLINE           { /* Empty line */ }
    | error NEWLINE     { yyerrok; }
    | INDENT
    | DEDENT
;

expressao:
    NUMBER { $$ = get_valor($1); }
    | expressao PLUS expressao    { $$ = $1 + $3; }
    | expressao MINUS expressao   { $$ = $1 - $3; }
    | expressao TIMES expressao   { $$ = $1 * $3; }
    | expressao DIVIDE expressao  { $$ = $1 / $3; }
    | expressao MODULO expressao  { $$ = (int)$1 % (int)$3; }
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
;


program: 
         statement_list
        | func_def
        ;


statement_list : statement
               | statement_list statement
               ;

statement : 
            INDENT ID ASSIGN expressao       { printf("    %s = %d\n", $2, $4); free($2); }
          | INDENT RETURN expressao          { printf("    return %d\n", $3); }
          | ID LPAREN RPAREN          { printf("%s()\n", $1); free($1); }
          | ID    
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

func_def:
    DEF ID LPAREN param_geral RPAREN COLON {
        printf("void %s(", $2);
        for (int i = 0; i < param_count; i++) {
            printf("int %s", param_names[i]);  // ou outro tipo
            if (i < param_count - 1) {
                printf(", ");
            }
        }
        printf(") {\n    // TODO: implementar %s\n", $2);

        for (int i = 0; i < param_count; i++) {
            free(param_names[i]);
        }
        param_count = 0;
        func_count++;
    }
;


param_geral:
    /*vazio*/              { strcpy(param_names, ""); printf("}\n\n"); }
    | param_list    { /* já foi copiado para params */  }
    ;

param_list:
    param {
        $$ = strdup($1);
        printf("3\n");
    }
  | param_list COMMA param {
        int len = strlen($1) + strlen($3) + 3;
        $$ = (char *)malloc(len);
        snprintf($$, len, "%s, %s", $1, $3);
        free($1);
        printf("4\n");
        
    }
;


param:
    ID {
        // Tipo default: int
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "int %s", $1);
        $$ = strdup(buffer);

        param_names[param_count++] = strdup($1);
    }
;


/* 
    Essa regra de produção aqui é uma que 
    já identifica escopo. Então pode ser 
    usada para outras estruturas que precisam
    de escopo como pras regras do IF, do DEF
    do WHILE e por ai vai.
 */
block : NEWLINE INDENT statement_list DEDENT 
    ;

/* 
    As regras de produção abaixo podem ser lidas como:
    
    args → ε
    args → args_
    
    args_ → arg
    args_ → args_ , arg

    arg → ID
    arg → NUMBER

    ou seja, a expressao `args` pode ser algo vazio ou
    uma lista de expressões `args_` e `arg`. Por fim 
    `arg` pode ser um identificar(ID) ou um número(NUMBER)

    No fim, ao colocar isso numa regra de producao, dá pra 
    reconhecer listas de parâmetros. Tipo funcao(a, b, c).
    O conteúdo de dentro do pareteses é o args. E poderia 
    ser usado como no exemplo abaixo:

    function_def: DEF IDENTIFIER LPAREM args RPAREM COLON block 

 */

args  : /* Essa linha quer dizer que o valor de args pode ser vazio*/ {}
      | args_  {}
      ;

/* 
    Essa regra abaixo é recursiva à esquerda, permitindo isso:

    arg → a
    arg , arg → a, b
    arg , arg , arg → a, b, c

    Ou seja, `args_` constrói uma lista encadeada de argumentos.

 */
args_ : arg {}
      | args_ ',' arg {}
      ;

arg   : ID {}
      | NUMBER {}
      ;

%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}
