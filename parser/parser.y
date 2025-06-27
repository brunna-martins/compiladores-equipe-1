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
int deduzir_tipo_expr(NoAST* node) {
    if (!node) return TIPO_INT;
    if (node->tipo == TIPO_FLOAT) return TIPO_FLOAT;
    if (node->tipo == TIPO_STRING) return TIPO_STRING;
    if (node->tipo == TIPO_INT) return TIPO_INT;
    if (node->tipo == TIPO_OP) {
         if (node->operador == '+') {
            if (deduzir_tipo_expr(node->esquerda) == TIPO_STRING ||
                deduzir_tipo_expr(node->direita) == TIPO_STRING) {
                return TIPO_STRING;
            }
        }
        if (node->operador == '/') return TIPO_FLOAT;
        // Se qualquer um dos lados for float, a expressão inteira vira float.
        if (deduzir_tipo_expr(node->esquerda) == TIPO_FLOAT) return TIPO_FLOAT;
        if (deduzir_tipo_expr(node->direita) == TIPO_FLOAT) return TIPO_FLOAT;
    }
    if(
        (node->tipo == TIPO_PALAVRA_CHAVE) && 
        ( 
            (strcmp(node->palavra_chave, "True") == 0)||
            (strcmp(node->palavra_chave, "False") == 0)||
            (strcmp(node->palavra_chave, "None") == 0)
        )
    ) {
        return TIPO_BOOL;
    }
    return TIPO_INT;
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
%token PLUS MINUS PLUSEQ MINUSEQ TIMES DIVIDE MODULO
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
%type <no> program stmt_list stmt expr def_stmt block param_list param
%type <no> term factor print_stmt argumentos while_statement if_statement
%type <no> for_statement declaracao_variavel if_stmt return_stmt arg_list
%type <no> assignment_stmt 

%left PLUS MINUS
%left TIMES DIVIDE
%left UMINUS

%initial-action {
    escopo_atual = criar_tabela();  // Cria o escopo global inicial
    printf("Escopo global criado!\n");
}


%%

program:
    stmt_list                  {raiz = $1; $$ = $1; }
;

stmt_list:
    stmt                      { $$ = ($1 == NULL)? NULL : criarNoSeq($1, NULL) ;}
  | stmt_list stmt
    {
        if ($2 == NULL) {
            $$ = $1; // ignora stmt vazio (NEWLINE)
        } else if ($1 == NULL) {
            $$ = $2; // primeira stmt válida
        } else {
            $$ = criarNoSeq($1, $2); // junta duas stmts
        }
    }
;

stmt:
    def_stmt
  | print_stmt
  | while_statement
  | for_statement
  | if_stmt
  | assignment_stmt 
  | expr             
  | return_stmt
  | NEWLINE {$$ = NULL;}
;

assignment_stmt:
    ID ASSIGN expr {
        $$ = criarNoOp('=', criarNoId($1), $3);

        Simbolo* s = buscar_simbolo_escopo_atual(escopo_atual, $1);
        if (!s) {
            char* tipo_deduzido = "int";

            int tipo_expr = deduzir_tipo_expr($3); // Deduz o tipo uma vez

            if (tipo_expr == TIPO_FLOAT) {
                tipo_deduzido = "float";
            } else if (tipo_expr == TIPO_STRING) {
                tipo_deduzido = "char*";
            } else if (tipo_expr == TIPO_BOOL) {
                tipo_deduzido = "bool";
            }
            inserir_simbolo(escopo_atual, $1, "variavel", tipo_deduzido);
            printf("Variável '%s' inserida na tabela com tipo '%s'!\n", $1, tipo_deduzido);
        }
    }
;


expr:
    expr PLUS term          { $$ = criarNoOp('+', $1, $3); }
  | expr MINUS term         { $$ = criarNoOp('-', $1, $3); }
  | expr GREATER term       { $$ = criarNoOp('>', $1, $3); }
  | expr LESSER term        { $$ = criarNoOp('<', $1, $3); }
  | expr PLUSEQ term        { $$ = criarNoOpComposto("+=", $1, $3); }
  | expr MINUSEQ term       { $$ = criarNoOpComposto("-=", $1, $3); }
  | expr GREATEQ term       { $$ = criarNoOpComposto(">=", $1, $3); }
  | expr LESSEQ term        { $$ = criarNoOpComposto("=>", $1, $3); }
  | expr EQTO term          { $$ = criarNoOpComposto("==", $1, $3); }
  | expr MODULO term        { $$ = criarNoOp('%', $1, $3); }
  | term                    { $$ = $1; }
  | /* vazio */             { $$ = NULL; }
;

term:
    term TIMES factor       { $$ = criarNoOp('*', $1, $3); }
  | term DIVIDE factor    { $$ = criarNoOp('/', $1, $3); }
  | factor                { $$ = $1; }
;

factor:
  | LPAREN expr RPAREN  { $$ = $2; }
  | param_list          { $$ = $1; }
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
  | ID LPAREN RPAREN            { $$ = criarNoChamadaFuncao($1, NULL); }
  | ID LPAREN param_list RPAREN { $$ = criarNoChamadaFuncao($1, $3); }
  | ID   { $$ = criarNoId($1); }
  | TRUE {
        $$ = criarNoPalavraChave("True");
        printf("Valor booleano True\n");
    }
  | FALSE {
        $$ = criarNoPalavraChave("False");
        printf("Valor booleano False\n");
    }
  | NONE {
        $$ = criarNoPalavraChave("None");
        printf("Valor None\n");
    }
  | STRING_LITERAL     { $$ = criarNoString($1);}
;

return_stmt:
    RETURN expr
    {
        NoAST* no = criarNoPalavraChave("return");
        no->esquerda = $2;
        $$ = no;
    }
;

print_stmt:
    PRINT LPAREN arg_list RPAREN { $$ = criarNoPrint($3); }
;

arg_list:
    /* vazio */ { $$ = NULL; }
  | expr { $$ = criarNoArgList($1); }
  | arg_list COMMA expr { $$ = appendArgList($1, $3); }
;

def_stmt:
    DEF ID LPAREN RPAREN COLON block
      {
        $$ = criarNoFunDef($2, NULL, $6);

        Simbolo* s = buscar_simbolo_escopo_atual(escopo_atual, $2);
        if (!s)
        {
            inserir_simbolo(escopo_atual, $2, "funcao", "teste");
            printf("Função '%s' inserida na tabela de símbolos!\n", $2);
        }
      }
    | DEF ID LPAREN param_list RPAREN COLON block
{
    $$ = criarNoFunDef($2, $4, $7);

    Simbolo* s = buscar_simbolo_escopo_atual(escopo_atual, $2);
    if (!s)
    {
        inserir_simbolo(escopo_atual, $2, "funcao", "teste");
        printf("Função '%s' inserida na tabela de símbolos!\n", $2);
    }

    NoAST* param = $4;
    while (param) {
        if (param->tipo == TIPO_PARAM) {
            if (!buscar_simbolo_escopo_atual(escopo_atual, param->nome)) {
                inserir_simbolo(escopo_atual, param->nome, "param", "int");
                printf("Parâmetro '%s' inserido no escopo da função\n", param->nome);
            }
        }
        param = param->direita;
    }
}
  ;

while_statement:
    WHILE expr COLON block{
        printf("Condição WHILE verificada!\n");
        NoAST *no_while = criarNoPalavraChave("while");
        no_while->esquerda = $2;
        no_while->direita = $4;
        $$ = no_while;
    }
;

for_statement:
    FOR ID IN expr COLON block{
        NoAST *no_for = criarNoPalavraChave("for");
        no_for->esquerda = $4;
        no_for->direita = $6;
        $$ = no_for;

        printf("Loop FOR com variável \n");

        if (buscar_simbolo_escopo_atual(escopo_atual, $2)) {
            yyerror("Variável de iteração já declarada");
        } else {
            inserir_simbolo(escopo_atual, $2, "var", "int");
            printf("Variável de iteração '%s' declarada\n", $2);
        }
    }
;

if_stmt:
    IF expr COLON block
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
;

param_list:
    param { $$ = $1;}
  | param_list COMMA param { $$ = appendParam($1, $3);}
;

param:
    ID  { $$ = criarParam($1);}
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
;

block:
    INDENT stmt_list DEDENT {$$ = $2; }
  /* | NEWLINE INDENT stmt_list DEDENT { $$ = $3; } */
;



%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}