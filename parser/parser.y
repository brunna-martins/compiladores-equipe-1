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
%type <no> assignment_stmt elif_list else_opt arith_expr and_expr not_expr comp_expr

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
  | PASS {$$ = criarNoPalavraChave("pass");}
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
    expr OR and_expr         { $$ = criarNoOpLogico("or", $1, $3); }
  | and_expr                 { $$ = $1; }
;

and_expr:
    and_expr AND not_expr    { $$ = criarNoOpLogico("and", $1, $3); }
  | not_expr                 { $$ = $1; }
;

not_expr:
    NOT not_expr             { $$ = criarNoOpLogico("not", $2, NULL); }
  | comp_expr                { $$ = $1; }
;

comp_expr:
    comp_expr EQTO arith_expr    { $$ = criarNoOpComposto("==", $1, $3); }
  | comp_expr GREATER arith_expr { $$ = criarNoOp('>', $1, $3); }
  | comp_expr LESSER arith_expr  { $$ = criarNoOp('<', $1, $3); }
  | comp_expr GREATEQ arith_expr { $$ = criarNoOpComposto(">=", $1, $3); }
  | comp_expr LESSEQ arith_expr  { $$ = criarNoOpComposto("<=", $1, $3); }
  | comp_expr MINUSEQ arith_expr  { $$ = criarNoOpComposto("-=", $1, $3); }
  | comp_expr PLUSEQ arith_expr  { $$ = criarNoOpComposto("+=", $1, $3); }

  | arith_expr                   { $$ = $1; }
;

arith_expr:
    arith_expr PLUS term     { $$ = criarNoOp('+', $1, $3); }
  | arith_expr MINUS term    { $$ = criarNoOp('-', $1, $3); }
  | term                     { $$ = $1; }
;

term:
    term TIMES factor        { $$ = criarNoOp('*', $1, $3); }
  | term DIVIDE factor       { $$ = criarNoOp('/', $1, $3); }
  | term MODULO factor       { $$ = criarNoOp('%', $1, $3); }
  | factor                   { $$ = $1; }
;

factor:
    LPAREN expr RPAREN       { $$ = $2; }
  | param_list               { $$ = $1; }
  | NUMBER                   {
        if ($1.tipo == INTEIRO)
            $$ = criarNoNumInt($1.valor.i);
        else
            $$ = criarNoNumFloat($1.valor.f);
    }
  | ID LPAREN RPAREN         { $$ = criarNoChamadaFuncao($1, NULL); }
  | ID LPAREN arg_list RPAREN { $$ = criarNoChamadaFuncao($1, $3); }
  | ID                       { $$ = criarNoId($1); }
  | TRUE                     { $$ = criarNoPalavraChave("True"); }
  | FALSE                    { $$ = criarNoPalavraChave("False"); }
  | NONE                     { $$ = criarNoPalavraChave("None"); }
  | STRING_LITERAL           { $$ = criarNoString($1); }
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

        alterar_tipagem($$->nome, escopo_atual, $$);
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

        alterar_tipagem($$->nome, escopo_atual, $$);
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
    IF expr COLON block elif_list else_opt
    {
        NoAST *if_node = criarNoIf($2, $4);
        if ($5) if_node = criarNoSeq(if_node, $5);
        if ($6) if_node = criarNoSeq(if_node, $6);
        $$ = if_node;
    }
;

elif_list:
    /* vazio */                    { $$ = NULL; }
  | ELIF expr COLON block elif_list
    {
        NoAST *elif_node = criarNoElif($2, $4);
        if ($5) {
            $$ = criarNoSeq(elif_node, $5);
        } else {
            $$ = elif_node;
        }
    }
;

else_opt:
    /* vazio */                 { $$ = NULL; }
  | ELSE COLON block            { $$ = criarNoElse($3); }
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
    | stmt_list 
    { 
        yyerror("Erro: bloco esperado após ':' deve estar indentado.");
        YYERROR;
    }
;



%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}