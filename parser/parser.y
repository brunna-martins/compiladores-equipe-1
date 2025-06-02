%{
#include <stdio.h>
#include <stdlib.h>
#include "numero.h" 
#include "ast.h"

void yyerror(const char *mensagem);
int yylex(void);
NoAST *raiz = NULL;

extern int yylineno;
extern char *yytext;

float get_valor(Numero n) {
    return n.tipo == INTEIRO ? n.valor.i : n.valor.f;
}

%}

%code requires {
    #include "numero.h"
    #include "ast.h"
}

%union {
  char *str;
  Numero numero;
  int inteiro;
  float real;
  char* string;
  NoAST* no;  
  NoAST* param_list;
}

%token INDENT DEDENT NEWLINE
%token ERROR EQUAL 
%token PLUS MINUS TIMES DIVIDE MODULO
%token LPAREN RPAREN LBRACKET RBRACKET LBRACE RBRACE COLON COMMA DOT SEMICOLON
%token ASSIGN EQTO NOTEQTO LESSEQ GREATEQ LESSER GREATER PRINT

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
%type <no> program stmt_list stmt expr def_stmt block param_list param term factor print_stmt

%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS


%%

program:
    stmt_list                  { raiz = $1; $$ = $1; }
;

stmt_list:
    stmt                      { $$ = $1;}
  | stmt_list stmt            
     {
        if ($2 == NULL) {
            $$ = $1; // ignora stmt vazio (NEWLINE)
        } else if ($1 == NULL) {
            $$ = $2; // primeira stmt válida
        } else {
            $$ = criarNoOp(';', $1, $2); // junta duas stmts
        }
    }
;

stmt:
    def_stmt
    | IF expr COLON block
        {
            $$ = criarNoIf($2, $4);
        }
    | IF expr COLON block ELSE COLON block
        {
            NoAST *if_node = criarNoIf($2, $4);
            NoAST *else_node = criarNoElse($7);
            $$ = criarNoSeq(if_node, else_node);
        }
    | IF expr COLON block ELIF expr COLON block
        {
            NoAST *if_node = criarNoIf($2, $4);
            NoAST *elif_node = criarNoElif($6, $8);
            $$ = criarNoSeq(if_node, elif_node);
        }
    | IF expr COLON block ELIF expr COLON block ELSE COLON block
        {
            NoAST *if_node = criarNoIf($2, $4);
            NoAST *elif_node = criarNoElif($6, $8);
            NoAST *else_node = criarNoElse($11);
            NoAST *if_elif = criarNoSeq(if_node, elif_node);
            $$ = criarNoSeq(if_elif, else_node);
        }
    | print_stmt
    | expr
    | RETURN {$$ = NULL;}
    | RETURN expr
    | NEWLINE {$$ = NULL;}
;


/* expr:
    ID                        { $$ = criarNoId($1, TIPO_ID); }
    | NUMBER                  
        {
            if ($1.tipo == INTEIRO)
            $$ = criarNoNumInt($1.valor.i);
            else
            $$ = criarNoNumFloat($1.valor.f);
        }
    | expr PLUS expr          { $$ = criarNoOp('+', $1, $3); }
    | expr MINUS expr         { $$ = criarNoOp('-', $1, $3); }
    | expr TIMES expr         { $$ = criarNoOp('*', $1, $3); }
    | expr DIVIDE expr        { $$ = criarNoOp('/', $1, $3); }
    | expr GREATER expr       { $$ = criarNoOp('>', $1, $3); }
    | expr ASSIGN expr        { $$ = criarNoOp('=', $1, $3); }
    | LPAREN expr RPAREN      { $$ = $2; }
; */

expr:
      expr PLUS term          { $$ = criarNoOp('+', $1, $3); }
    | expr MINUS term         { $$ = criarNoOp('-', $1, $3); }
    | expr GREATER term       { $$ = criarNoOp('>', $1, $3); }
    | expr ASSIGN term        { $$ = criarNoOp('=', $1, $3); }
    | term                    { $$ = $1; }
;

term:
    term TIMES factor { $$ = criarNoOp('*', $1, $3); }
  | term DIVIDE factor{ $$ = criarNoOp('/', $1, $3); }
  | factor            { $$ = $1; }
  ;

factor:
    LPAREN expr RPAREN { $$ = $2; }
  | NUMBER             
    { 
        if ($1.tipo == INTEIRO)
        {
            $$ = criarNoNumInt($1.valor.i);
            printf("caracter chamado %d\n\n",$1.valor.i);
        }
        else
        {
            $$ = criarNoNumFloat($1.valor.f); 
        }
    }
  | ID                 { $$ = criarNoId($1, TIPO_ID); }
  | STRING_LITERAL     { $$ = criarNoString($1);}
  ; 

print_stmt:
    PRINT LPAREN expr RPAREN {
        NoAST *printNode = criarNoPalavraChave("print");
        printNode->esquerda = $3;
        $$ = printNode;
    }

def_stmt:
    DEF ID LPAREN RPAREN COLON block
      {
        $$ = criarNoFunDef($2, NULL, $6);
      }
  | DEF ID LPAREN param_list RPAREN COLON block
      {
        $$ = criarNoFunDef($2, $4, $7);
      }
  ;


param_list:
      param
        { $$ = $1; }
    | param_list COMMA param
        { $$ = appendParam($1, $3); }
    ;

param:
    ID
      { $$ = criarParam($1); }
    ;



block:
    stmt_list { $$ = $1; }
    | NEWLINE INDENT stmt_list DEDENT { $$ = $3; }
    ;


/* line:
    expressao NEWLINE   { printf("Resultado: %f\n", $1); }
    | program NEWLINE   { }
    | NEWLINE           { /* Empty line  }
    | error NEWLINE     { yyerrok; }
    | INDENT
    | DEDENT
;
 */

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

/* 
    Essa regra de produção aqui é uma que 
    já identifica escopo. Então pode ser 
    usada para outras estruturas que precisam
    de escopo como pras regras do IF, do DEF
    do WHILE e por ai vai.
 */


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
