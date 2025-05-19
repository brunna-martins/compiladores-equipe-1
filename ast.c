#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = op;
    no->esquerda = esq;
    no->direita = dir;
    no->tipo = (esq->tipo == dir->tipo) ? esq->tipo : TIPO_ERRO;
    return no;
}

NoAST *criarNoNumInt(int val) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor = val;
    no->operador = 0;
    no->tipo = TIPO_INT;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoNumFloat(float valor_float) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor_float = valor_float;
    no->operador = 0;
    no->tipo = TIPO_FLOAT;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoString(char *valor_string) {
    NoAST *no = malloc(sizeof(NoAST));  
    no->valor_string = valor_string;
    no->operador = 0;
    no->tipo = TIPO_STRING;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoId(char *nome, Tipo tipo) {
    NoAST *no = malloc(sizeof(NoAST));
    strcpy(no->nome, nome);
    no->operador = 0;
    no->tipo = tipo;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoPalavraChave(char *palavraChave) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 0;
    no->palavra_chave = palavraChave;
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->esquerda = no->direita = NULL;
    return no;
}

NoAST *criarNoDelimitador(char delimitador) {
    NoAST *no = malloc(sizeof(NoAST));    
    no->operador = 0;
    no->delimitador = delimitador;
    no->tipo = TIPO_DELIMITADOR;
    no->esquerda = no->direita = NULL;
    return no;
}

void imprimirAST(NoAST *no) {
    if (!no) return;
    if (no->operador) {
        printf("(");
        imprimirAST(no->esquerda);
        printf(" %c ", no->operador);
        imprimirAST(no->direita);
        printf(")");
    } else if (strlen(no->nome) > 0) {
        printf("%s", no->nome);
    } else {
        printf("%d", no->valor);
    }
}

void imprimirASTBonita(NoAST *no, int nivel) {
    if (!no) return;

    // Imprime a indentação
    for (int i = 0; i < nivel; i++) {
        printf("  "); // 2 espaços por nível
    }

    // Imprime o conteúdo do nó
    if (no->operador) {
        printf("Operador: %c\n", no->operador);
    } else if (strlen(no->nome) > 0) {
        printf("Nome: %s\n", no->nome);
    } else {
        printf("Valor: %d\n", no->valor);
    }

    // Se tiver filhos, imprime com o traço e chamada recursiva
    if (no->esquerda) {
        for (int i = 0; i < nivel; i++) printf("  ");
        printf(" no->esq ");
        imprimirASTBonita(no->esquerda, nivel + 1);
    }
    if (no->direita) {
        for (int i = 0; i < nivel; i++) printf("  ");
        printf(" no->dir ");
        imprimirASTBonita(no->direita, nivel + 1);
    }
}


int tiposCompativeis(Tipo t1, Tipo t2) {
    return t1 == t2;
}