%{
#include <stdio.h>
#include <stdlib.h>
#include "numero.h" 
#include "tabela_simbolos.h"

void yyerror(const char *mensagem);
int yylex(void);

extern int yylineno;
extern char *yytext;

float get_valor(Numero n) {
    return n.tipo == TIPO_INT ? n.valor.i : n.valor.f;
}

// Pilha de escopos
TabelaSimbolos* escopo_atual = NULL;

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

%token INDENT DEDENT NEWLINE
%token ERROR EQUAL 
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

%initial-action {
    escopo_atual = criar_tabela();  // Cria o escopo global inicial
    printf("Escopo global criado!\n");
    inserir_simbolo(escopo_atual, "print", "funcao"); 
}


%%

input:
    /* empty */
    | input line
;

line:
    comando NEWLINE     { }  // Comando seguido de nova linha
    | expressao NEWLINE { printf("Resultado: %f\n", $1); }
    | program NEWLINE   { }
    | NEWLINE           { /* Empty line */ }
    | error NEWLINE     { yyerrok; }
    | INDENT
    | DEDENT
;

comando: 
    declaracao_variavel
    | chamada_funcao
    | expressao
    | statement
;

declaracao_variavel:
    ID ASSIGN expressao {
        // Inserir na tabela de simbolos
        if (buscar_simbolo(escopo_atual, $1)) {
            yyerror("Variável já declarada");
        } else {
            inserir_simbolo(escopo_atual, $1, "var");
            printf("Variável '%s' declarada\n", $1);
        }
    }
;

chamada_funcao:
    ID LPAREN argumentos RPAREN {
        Simbolo* s = buscar_simbolo(escopo_atual, $1);
        if (!s) {
            yyerror("Função não declarada");
        } else {
            printf("Chamando função '%s'\n", $1);
        }
    }
;


argumentos:
    /* empty */
    | expressao
    | argumentos COMMA expressao
;


expressao:
    NUMBER { 
        $$ = get_valor($1); 
        printf("Número reconhecido: %f\n", $$);
    }
    | ID { 
        Simbolo* s = buscar_simbolo(escopo_atual, $1);
        if (!s) {
            yyerror("Variável não declarada");
            $$ = 0;
        } else {
            // Aqui você precisaria do valor real da variável
            $$ = 0; // Placeholder - precisa implementar
            printf("Referência à variável '%s'\n", $1);
        }
    }
    | expressao PLUS expressao    { $$ = $1 + $3; }
    | expressao MINUS expressao   { $$ = $1 - $3; }
    | expressao TIMES expressao   { $$ = $1 * $3; }
    | expressao DIVIDE expressao  { $$ = $1 / $3; }
    | expressao MODULO expressao  { $$ = (int)$1 % (int)$3; }
    | LPAREN expressao RPAREN     { $$ = $2; }
    | expressao EQTO expressao    { $$ = $1 == $3; }
    | expressao NOTEQTO expressao { $$ = $1 != $3; }
    | expressao LESSEQ expressao  { $$ = $1 <= $3; }
    | expressao GREATEQ expressao { $$ = $1 >= $3; }
    | expressao LESSER expressao  { $$ = $1 < $3; }
    | expressao GREATER expressao { $$ = $1 > $3; }
    | chamada_funcao              { $$ = 0; } 
;

program : 
    /* empty */
    | program statement
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

/* 
    Essa regra de produção aqui é uma que 
    já identifica escopo. Então pode ser 
    usada para outras estruturas que precisam
    de escopo como pras regras do IF, do DEF
    do WHILE e por ai vai.
 */

block: 
    NEWLINE INDENT program DEDENT 
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

