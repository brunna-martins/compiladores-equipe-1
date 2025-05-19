#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = op;
    no->esquerda = esq;
    no->direita = dir;
    no->meio = NULL;
    no->tipo = (esq->tipo == dir->tipo) ? esq->tipo : TIPO_ERRO;
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

NoAST *criarNoId(char *nome, Tipo tipo) {
    NoAST *no = malloc(sizeof(NoAST));
    strcpy(no->nome, nome);
    no->operador = 0;
    no->tipo = tipo;
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
    n->meio         = body;           /* corpo (stmt_list) */
    n->direita      = NULL;           /* próximo statement no escopo */
    return n;
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



// void imprimirAST(NoAST *no) {
//     if (!no) return;
//     if (no->operador) {
//         printf("(");
//         imprimirAST(no->esquerda);
//         printf(" %c ", no->operador);
//         imprimirAST(no->direita);
//         printf(")");
//     } else if (strlen(no->nome) > 0) {
//         printf("%s", no->nome);
//     } else {
//         printf("%d", no->valor);
//     }
// }

void imprimirASTBonita(NoAST *no, int nivel, const char *prefixo, int ehUltimo) {
    if (!no) return;

    // Imprime prefixo e conector
    printf("%s", prefixo);
    printf(ehUltimo ? "└── " : "├── ");

    // Imprime conteúdo do nó
    if (no->operador) {
        printf("Operador: %c\n", no->operador);
    } else if (strlen(no->nome) > 0) {
        printf("Nome: %s\n", no->nome);
    } else {
        printf("Valor: %d\n", no->valor);
    }

    // Monta o novo prefixo para os filhos
    char novoPrefixo[256];
    snprintf(novoPrefixo, sizeof(novoPrefixo), "%s%s", prefixo, ehUltimo ? "    " : "│   ");

    // Conta quantos filhos existem
    int temEsquerda = no->esquerda != NULL;
    int temDireita = no->direita != NULL;
    int totalFilhos = temEsquerda + temDireita;
    int filhoAtual = 0;


    if(no->meio)
    {
        printf("(");
        imprimirASTBonita(no->meio, nivel + 1, novoPrefixo, ehUltimo);
        printf(")");
    }
    // Esquerda
    if (temEsquerda) {
        imprimirASTBonita(no->esquerda, nivel + 1, novoPrefixo, ++filhoAtual == totalFilhos);
    }

    // Direita
    if (temDireita) {
        imprimirASTBonita(no->direita, nivel + 1, novoPrefixo, ++filhoAtual == totalFilhos);
    }
}

int tiposCompativeis(Tipo t1, Tipo t2) {
    return t1 == t2;
}