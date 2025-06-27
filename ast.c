#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "tabela_simbolos.h"
#include "gerarcodigo.h"

NoAST* criarNoFuncCall(char *nome_funcao, NoAST *args) {
    NoAST* no = malloc(sizeof(NoAST));
    no->tipo = TIPO_CHAMADA_DE_FUNCAO;
    strncpy(no->nome, nome_funcao, sizeof(no->nome));
    no->esquerda = args;  // lista de argumentos
    no->direita = NULL;
    no->meio = NULL;
    return no;
}

NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = op;
    no->esquerda = esq;
    no->direita = dir;
    no->meio = NULL;
    no->tipo = TIPO_OP;
    return no;
}

NoAST *criarNoOpComposto(char *operador, NoAST *esquerda, NoAST *direita)
{
    NoAST *no = malloc(sizeof(NoAST));
    strcpy(no->operadorComp, operador);
    no->tipo = TIPO_OPCOMP;
    no->esquerda = esquerda;
    no->direita = direita;
    no->meio = NULL;
    return no;
}

NoAST *criarNoNumInt(int val) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor = val;
    no->operador = 0;
    no->tipo = TIPO_INT;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoNumFloat(float valor_float) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor_float = valor_float;
    no->operador = 0;
    no->tipo = TIPO_FLOAT;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoString(char *valor_string) {
    NoAST *no = malloc(sizeof(NoAST));  
    no->valor_string = valor_string;
    no->operador = 0;
    no->tipo = TIPO_STRING;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoId(char *nome) {
    NoAST *no = malloc(sizeof(NoAST));
    strcpy(no->nome, nome);
    no->operador = 0;
    no->tipo = TIPO_ID;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoPalavraChave(char *palavraChave) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 0;
    no->palavra_chave = palavraChave;
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoDelimitador(char delimitador) {
    NoAST *no = malloc(sizeof(NoAST));    
    no->operador = 0;
    no->delimitador = delimitador;
    no->tipo = TIPO_DELIMITADOR;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoParenteses(NoAST *abre, NoAST *conteudo, NoAST *fecha) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 0;
    no->tipo = TIPO_DELIMITADOR;
    no->esquerda = abre;
    no->meio = conteudo;
    no->direita = fecha;
    return no;
}

NoAST *criarNoFunDef(char *nome, NoAST *params, NoAST *body) {
    NoAST *n = malloc(sizeof(NoAST));
    n->tipo         = TIPO_FUNCAO;
    n->operador     = 0;              /* não usamos */
    n->valor        = 0;
    n->valor_float  = 0.0f;
    n->valor_string = NULL;
    strncpy(n->nome, nome, 31);
    n->nome[31]     = '\0';
    n->delimitador  = 0;
    n->palavra_chave= NULL;
    n->esquerda     = params;         /* lista de params */
    n->meio         = NULL;           /* corpo (stmt_list) */
    n->direita      = body;           /* próximo statement no escopo */
    return n;
}

NoAST *criarNoChamadaFuncao(char *nome, NoAST *params)
{
    NoAST* no = malloc(sizeof(NoAST));
    strncpy(no->nome, nome, 31);
    no->nome[31] = '\0';
    no->operador = 0;
    no->esquerda = params;
    no->direita = NULL;
    no->tipo = TIPO_CHAMADA_DE_FUNCAO;
    return no;
}

NoAST *criarNoFuncPrint(NoAST *params)
{
    NoAST *no = malloc(sizeof(NoAST));
    no->esquerda = params;
    no->palavra_chave = strdup("print");
    no->direita = NULL;
    no->tipo = TIPO_PRINT;
    return no;
}

NoAST *criarParam(char *nome) {
    NoAST *p = malloc(sizeof(NoAST));
    p->tipo         = TIPO_PARAM;
    strncpy(p->nome, nome, 31);
    p->nome[31]     = '\0';
    p->esquerda     = p->meio = NULL;
    p->direita      = NULL;  /* próximo parâmetro */
    return p;
}

NoAST *appendParam(NoAST *lista, NoAST *novo) {
    if (!lista) return novo;
    NoAST *it = lista;
    while (it->direita) it = it->direita;
    it->direita = novo;
    return lista;
}

NoAST* criarNoIf(NoAST *cond, NoAST *corpo) {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->palavra_chave = strdup("if");
    no->esquerda = cond;
    no->direita = corpo;
    no->meio = NULL;
    return no;
}

NoAST* criarNoElif(NoAST *cond, NoAST *corpo) {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->palavra_chave = strdup("elif");
    no->esquerda = cond;
    no->direita = corpo;
    no->meio = NULL;
    return no;
}

NoAST* criarNoElse(NoAST *corpo) {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->palavra_chave = strdup("else");
    no->esquerda = NULL;
    no->direita = corpo;
    no->meio = NULL;
    return no;
}

NoAST* criarNoSeq(NoAST* esq, NoAST* dir) {
    NoAST* no = malloc(sizeof(NoAST));
    no->tipo = TIPO_SEQUENCIA;
    no->esquerda = esq;
    no->direita = dir;
    return no;
}

NoAST* criarNoPrint(NoAST* args) {
    NoAST* node = (NoAST*)malloc(sizeof(NoAST));
    node->tipo = TIPO_PRINT;
    node->esquerda = args; // Lista de argumentos
    node->direita = NULL;
    return node;
}

NoAST* criarNoArgList(NoAST* first_arg) {
    NoAST* node = (NoAST*)malloc(sizeof(NoAST));
    node->tipo = TIPO_ARG_LIST;
    node->esquerda = first_arg; // Primeiro argumento
    node->direita = NULL; // Próximos argumentos vão na lista
    return node;
}

NoAST* appendArgList(NoAST* list, NoAST* new_arg) {
    if (!list) return criarNoArgList(new_arg);
    
    NoAST* last = list;
    while (last->direita) {
        last = last->direita;
    }
    last->direita = criarNoArgList(new_arg);
    return list;
}

NoAST* criarNoOpLogico(char* op, NoAST* esquerda, NoAST* direita) {
    NoAST* no = malloc(sizeof(NoAST));
    no->tipo = TIPO_LOGICO;
    strcpy(no->nome, op);
    no->esquerda = esquerda;
    no->direita = direita;
    return no;
}

void imprimirASTBonita(NoAST *no, const char *prefixo, int ehUltimo) {
    if (!no) return;

    // Imprime prefixo e conector
    printf("%s", prefixo);
    printf(ehUltimo ? "└── " : "├── ");

    // Conteúdo do nó
    switch (no->tipo) {
    case TIPO_FUNCAO:
        printf("\033[35mFunção: %s\033[0m\n", no->nome);  // roxo
        break;
    case TIPO_PARAM:
        printf("\033[38;5;87mParâmetro: %s\033[0m\n", no->nome);  // azul esverdeado
        break;
    case TIPO_PALAVRA_CHAVE:
        printf("\033[38;5;197mPalavra-chave: %s\033[0m\n", no->palavra_chave);  // vermelho meio rosa
        break;
    case TIPO_INT:
        printf("\033[34mInteiro: %d\033[0m\n", no->valor);  // azul
        break;
    case TIPO_FLOAT:
        printf("\033[38;5;87mFloat: %.2f\033[0m\n", no->valor_float);  // azul esverdeado
        break;
    case TIPO_STRING:
        printf("\033[32mString: %s\033[0m\n", no->valor_string);  // verde
        break;
    case TIPO_ID:
        printf("\033[36mIdentificador: %s\033[0m\n", no->nome);  // ciano
        break;
    case TIPO_DELIMITADOR:
        printf("\033[90mDelimitador: %c\033[0m\n", no->delimitador);  // cinza claro
        break;
    case TIPO_OP:
        printf("\033[33mOperador: %c\033[0m\n", no->operador);  // amarelo
        break;
    case TIPO_OPCOMP:
        printf("\033[33mOperador: %s\033[0m\n", no->operadorComp);  // amarelo
        break;
    case TIPO_ERRO:
        printf("\033[41mAAAAAA!\033[0m\n");  // fundo vermelho
        break;
    case TIPO_SEQUENCIA:
        printf("\033[94mNó sequência: 🪢\033[0m\n");  // azul claro
        break;
    case TIPO_PRINT:
        printf("\033[38;5;208mPRINT\033[0m\n");  // laranja queimado
        break;
    case TIPO_CHAMADA_DE_FUNCAO:
        printf("\033[95mChamada_função: %s\033[0m\n", no->nome);  // magenta claro
        break;
    case TIPO_ARG_LIST:
        printf("\033[96mARG_LIST\033[0m\n");  // ciano claro
        break;
    case TIPO_LOGICO:
        printf("\033[38;5;220mOperador Lógico: %s\033[0m\n", no->nome);  // amarelo claro
        break;
    default:
        if (no->operador)
            printf("Operador: %c\n", no->operador);
        else
            printf("Nó desconhecido\n");
        break;
}

        
    // Novo prefixo para filhos
    char novoPrefixo[256];
    snprintf(novoPrefixo, sizeof(novoPrefixo), "%s%s", prefixo, ehUltimo ? "    " : "│   ");

    // Lista de filhos (meio, esquerda, direita)
    int filhosExistem[3] = { no->esquerda != NULL, no->meio != NULL, no->direita != NULL };
    int totalFilhos = filhosExistem[0] + filhosExistem[1] + filhosExistem[2];
    int contador = 0;

    if (no->esquerda)
        imprimirASTBonita(no->esquerda, novoPrefixo, ++contador == totalFilhos);
    if (no->meio)
        imprimirASTBonita(no->meio, novoPrefixo, ++contador == totalFilhos);
    if (no->direita)
        imprimirASTBonita(no->direita, novoPrefixo, ++contador == totalFilhos);
}

int tiposCompativeis(Tipo t1, Tipo t2) {
    return t1 == t2;
}