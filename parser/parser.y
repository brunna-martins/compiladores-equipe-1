%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *mensagem);
int yylex(void);
extern int yylineno;
extern char *yytext;
char params[1024] = "";
char* param_names[50];
int func_count = 0;
int param_count = 0;
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


statement_list : statement
               | statement_list statement
               ;

statement : 
            ID ASSIGN expressao       { printf("    %s = %d\n", $1, $3); free($1); }
          | RETURN expressao          { printf("    return %d\n", $2); }
          | ID LPAREN RPAREN          { printf("%s()\n", $1); free($1); }
          | ID    
          | IF                        { printf("    if");}
          | ELSE                        { printf("    else");}
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



%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}
