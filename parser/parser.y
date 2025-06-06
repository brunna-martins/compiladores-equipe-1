%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "numero.h" 
#include "tabela_simbolos.h"

unsigned int hash(const char* chave);
#include "ast.h"

void yyerror(const char *mensagem);
int yylex(void);
NoAST *raiz = NULL;

extern int yylineno;
extern char *yytext;

float get_valor(Numero n) {
    return n.tipo == INTEIRO ? n.valor.i : n.valor.f;
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
%type <no> program stmt_list stmt expr def_stmt block param_list param term factor print_stmt argumentos while_statement if_statement declaracao_variavel

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

program:
    stmt_list                  {raiz = $1; $$ = $1; }
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
        printf("defff");
        $$ = criarNoFunDef($2, NULL, $6);
      }
  | DEF ID LPAREN param_list RPAREN COLON block
      {
        printf("defff2");
        $$ = criarNoFunDef($2, $4, $7);
        printf("oiiii\n");
      }
  ;


param_list:
      param
        { $$ = $1; printf("paramm");}
    | param_list COMMA param
        { $$ = appendParam($1, $3);}
    ;

param:
    ID
      { $$ = criarParam($1);}
    ;

block:
    | stmt_list {$$ = $1; }
    | INDENT stmt_list DEDENT {$$ = $2; }
    | NEWLINE INDENT stmt_list DEDENT { $$ = $3; }
    | INDENT NEWLINE stmt_list DEDENT { $$ = $3; }
    ;


/* line:
    declaracao_variavel NEWLINE     { }  // Declarações de variáveis
    | expressao NEWLINE             { printf("Resultado: %f\n", $1); }  // Expressões
    | NEWLINE                       { $$ = NULL;  }
    | error NEWLINE                 {  }
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

Estrutura IF */

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


comando: 
    declaracao_variavel
    | expressao
    | while_statement
    | if_statement
    | for_statement
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

