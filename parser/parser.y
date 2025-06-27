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
%type <no> for_statement declaracao_variavel if_stmt

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
    stmt                      { $$ = $1;}
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
    | while_statement
    | for_statement
    | if_stmt
    | expr
    | RETURN {$$ = NULL;}
    | RETURN expr
    | NEWLINE {$$ = NULL;}    
;

expr:
      expr PLUS term          { $$ = criarNoOp('+', $1, $3); }
    | expr MINUS term         { $$ = criarNoOp('-', $1, $3); }
    | expr GREATER term       { $$ = criarNoOp('>', $1, $3); }
    | expr LESSER term        { $$ = criarNoOp('<', $1, $3); }
    | expr ASSIGN term        
        { 
            $$ = criarNoOp('=', $1, $3); 

            if ($1->tipo == TIPO_ID) 
            {   
                Simbolo* s = buscar_simbolo_escopo_atual(escopo_atual, $1->nome);
                if (!s) 
                {
                    switch($3->tipo)
                    {
                        case TIPO_INT:
                            inserir_simbolo(escopo_atual, $1->nome, "variavel", "int");
                            break;
                        case TIPO_FLOAT:
                            inserir_simbolo(escopo_atual, $1->nome, "variavel", "float");
                            break;
                        case TIPO_STRING:
                            inserir_simbolo(escopo_atual, $1->nome, "variavel", "string");
                            break;                        
                    }
                    printf("Variável '%s' inserida na tabela de símbolos!\n", $1->nome);
                }   
            }   
        }
    | expr PLUSEQ term        { $$ = criarNoOpComposto("+=", $1, $3); }
    | expr MINUSEQ term       { $$ = criarNoOpComposto("-=", $1, $3); }
    | expr GREATEQ term       { $$ = criarNoOpComposto(">=", $1, $3); }
    | expr LESSEQ term        { $$ = criarNoOpComposto("=>", $1, $3); }
    | expr MODULO term        { $$ = criarNoOp('%', $1, $3); }
    | term                    { $$ = $1; }
;

term:
    term TIMES factor       { $$ = criarNoOp('*', $1, $3); }
    | term DIVIDE factor    { $$ = criarNoOp('/', $1, $3); }
    | PRINT factor          { $$ = criarNoFuncPrint($2); } 
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

print_stmt:
    PRINT LPAREN expr RPAREN {
        NoAST *printNode = criarNoPalavraChave("print");
        printNode->esquerda = $3;
        $$ = printNode;
    }
    /* | PRINT LPAREN param_list RPAREN {
        NoAST *printNode = criarNoPalavraChave("print");
        printNode->esquerda = $3;
        $$ = printNode;
    } */

;

chamada_funcao_stmt:
    ID LPAREN param_list RPAREN { }
;
def_stmt:
    DEF ID LPAREN RPAREN COLON block
      {
        $$ = criarNoFunDef($2, NULL, $6);

        Simbolo* s = buscar_simbolo_escopo_atual(escopo_atual, $2);
        // depois verificar se caso a funcão já estiver na tabela, emitir erro
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
      }
  ;

/* Estrutura WHILE */
while_statement:
    WHILE expr COLON block{
        printf("Condição WHILE verificada!\n");
        // Não criamos novo escopo aqui - o INDENT fará isso

        //////////////////////////////////////////////////////////
        /// Criando a estrutura do while para árvore sintática /// 
        //////////////////////////////////////////////////////////

        NoAST *no_while = criarNoPalavraChave("while");
        no_while->esquerda = $2;
        no_while->direita = $4;

        $$ = no_while;
    }
;

/* Estrutura FOR */
for_statement:
    FOR ID IN expr COLON block{
        
        NoAST *no_for = criarNoPalavraChave("for");
        no_for->esquerda = $4;
        no_for->direita = $6;
        $$ = no_for;

        printf("Loop FOR com variável \n");
        
        // Inserir variável de iteração no escopo atual
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
;

block:
    /* pode ser vazio */
    | stmt_list {$$ = $1; }
    | INDENT stmt_list DEDENT {$$ = $2; }
    | NEWLINE INDENT stmt_list DEDENT { $$ = $3; }
    | INDENT NEWLINE stmt_list DEDENT { $$ = $3; }
;



%%

void yyerror(const char *mensagem) {
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, mensagem);
}


/* declaracao_variavel:
    ID ASSIGN expr {        
        // Verificar se variável já existe no escopo atual
        if (buscar_simbolo_escopo_atual(escopo_atual, $1)) {
            yyerror("Variável já declarada neste escopo");
        } else {
            inserir_simbolo(escopo_atual, $1, "var");
            printf("Variável '%s' declarada no escopo %p\n", $1, escopo_atual);
        }
    }
; */

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
/* 
if_statement:
    IF expressao COLON {
        printf("Condição IF verificada. Valor: %f\n", $2);
    }
;

argumentos:
    /* empty 
    | expressao
    | argumentos COMMA expressao
; */

/* 
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
; */