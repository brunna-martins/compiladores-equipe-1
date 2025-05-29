%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "numero.h" 
#include "tabela_simbolos.h"

unsigned int hash(const char* chave);

void yyerror(const char *mensagem);
int yylex(void);

extern int yylineno;
extern char *yytext;

float get_valor(Numero n) {
    return n.tipo == TIPO_INT ? n.valor.i : n.valor.f;
}

// Pilha de escopos
TabelaSimbolos* escopo_atual = NULL;

Simbolo* buscar_simbolo_escopo_atual(TabelaSimbolos* escopo, const char* nome) {
    unsigned int indice = hash(nome);
    Simbolo* s = escopo->tabela[indice];
    while (s != NULL) {
        if (strcmp(s->nome, nome) == 0) 
            return s;
        s = s->proximo;
    }
    return NULL;
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
    inserir_simbolo(escopo_atual, "range", "funcao");
}


%%

input:
    /* empty */
    | input line
;

line:
    declaracao_variavel NEWLINE     { }  // Declarações de variáveis
    | expressao NEWLINE             { printf("Resultado: %f\n", $1); }  // Expressões
    | NEWLINE                       { /* Empty line */ }
    | error NEWLINE                 { yyerrok; }
    | INDENT {
        escopo_atual = empilhar_escopo(escopo_atual);
        printf(">>> NOVO ESCOPO (endereço: %p)\n", escopo_atual);
    }
    | DEDENT {
        TabelaSimbolos* anterior = escopo_atual->anterior;
        if (anterior != NULL) {
            escopo_atual = desempilhar_escopo(escopo_atual);
            printf("<<< FIM ESCOPO (voltando para: %p)\n", escopo_atual);
        } else {
            printf("!!! Tentativa de dedent no escopo global\n");
        }
    }
    | if_statement NEWLINE     { }  // Adicione esta linha
    | for_statement NEWLINE    { }  // Adicione esta linha
;

comando: 
    declaracao_variavel
    | expressao
    | while_statement
    | if_statement
    | for_statement
;

/* Estrutura IF */
if_statement:
    IF expressao COLON {
        printf("Condição IF verificada. Valor: %f\n", $2);
    }
;

/* Estrutura WHILE */
while_statement:
    WHILE expressao COLON {
        printf("Condição WHILE verificada. Valor: %f\n", $2);
        // Não criamos novo escopo aqui - o INDENT fará isso
    }
;

/* Estrutura FOR */
for_statement:
    FOR ID IN expressao COLON {
        printf("Loop FOR com variável '%s'\n", $2);
        
        // Inserir variável de iteração no escopo atual
        if (buscar_simbolo_escopo_atual(escopo_atual, $2)) {
            yyerror("Variável de iteração já declarada");
        } else {
            inserir_simbolo(escopo_atual, $2, "var");
            printf("Variável de iteração '%s' declarada\n", $2);
        }
    }
;

declaracao_variavel:
    ID ASSIGN expressao {
        // Verificar se variável já existe no escopo atual
        if (buscar_simbolo_escopo_atual(escopo_atual, $1)) {
            yyerror("Variável já declarada neste escopo");
        } else {
            inserir_simbolo(escopo_atual, $1, "var");
            printf("Variável '%s' declarada no escopo %p\n", $1, escopo_atual);
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
        // Verifica se é variável ou função sem argumentos
        Simbolo* s = buscar_simbolo(escopo_atual, $1);
        if (!s) {
            yyerror("Símbolo não declarado");
            $$ = 0;
        } else if (strcmp(s->tipo, "funcao") == 0) {
            // Chamada de função sem argumentos
            printf("Chamando função '%s' sem argumentos\n", $1);
            $$ = 0;
        } else {
            $$ = 0;
            printf("Referência à variável '%s'\n", $1);
        }
    }
    | ID LPAREN argumentos RPAREN {  // Chamada de função com argumentos
        Simbolo* s = buscar_simbolo(escopo_atual, $1);
        if (!s) {
            yyerror("Função não declarada");
            $$ = 0;
        } else {
            printf("Chamando função '%s' com argumentos\n", $1);
            $$ = 0;
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
    | TRUE {
        $$ = 1;
        printf("Valor booleano True\n");
    }
    | FALSE {
        $$ = 0;
        printf("Valor booleano False\n");
    }
    | NONE {
        $$ = 0;
        printf("Valor None\n");
    }
;

%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}

