#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabela_simbolos.h"

unsigned int hash(const char* chave) {
    unsigned int h = 0;
    for (; *chave; chave++)
        h = (h << 4) + *chave;
    return h % TAM_TABELA;
}

TabelaSimbolos* criar_tabela() {
    TabelaSimbolos* nova = (TabelaSimbolos*)malloc(sizeof(TabelaSimbolos));
    for (int i = 0; i < TAM_TABELA; i++)
        nova->tabela[i] = NULL;
    nova->anterior = NULL;
    return nova;
}

void destruir_tabela(TabelaSimbolos* tabela) {
    for (int i = 0; i < TAM_TABELA; i++) {
        Simbolo* atual = tabela->tabela[i];
        while (atual) {
            Simbolo* temp = atual;
            atual = atual->proximo;
            free(temp->nome);
            free(temp->tipo);
            free(temp);
        }
    }
    free(tabela);
}

int inserir_simbolo(TabelaSimbolos* tabela, const char* nome, const char* tipo, const char* tipo_simbolo) {
    unsigned int indice = hash(nome);
    Simbolo* novo = (Simbolo*)malloc(sizeof(Simbolo));
    novo->nome = strdup(nome);
    novo->tipo = strdup(tipo);
    novo->tipo_simbolo = strdup(tipo_simbolo);
    novo->proximo = tabela->tabela[indice];
    tabela->tabela[indice] = novo;
    return 1;
}

Simbolo* buscar_simbolo(TabelaSimbolos* tabela, const char* nome) {
    TabelaSimbolos* atual = tabela;
    while (atual != NULL) {
        unsigned int indice = hash(nome);
        Simbolo* s = atual->tabela[indice];
        while (s != NULL) {
            if (strcmp(s->nome, nome) == 0) {
                return s;
            }
            s = s->proximo;
        }
        atual = atual->anterior; // Subir para o escopo superior
    }
    return NULL;
}

int remover_simbolo(TabelaSimbolos* tabela, const char* nome) {
    unsigned int indice = hash(nome);
    Simbolo* atual = tabela->tabela[indice];
    Simbolo* anterior = NULL;
    while (atual != NULL) {
        if (strcmp(atual->nome, nome) == 0) {
            if (anterior == NULL)
                tabela->tabela[indice] = atual->proximo;
            else
                anterior->proximo = atual->proximo;
            free(atual->nome);
            free(atual->tipo);
            free(atual);
            return 1;
        }
        anterior = atual;
        atual = atual->proximo;
    }
    return 0;
}

TabelaSimbolos* empilhar_escopo(TabelaSimbolos* atual) {
    TabelaSimbolos* novo = criar_tabela();
    novo->anterior = atual;
    return novo;
}

TabelaSimbolos* desempilhar_escopo(TabelaSimbolos* atual) {
    if (!atual) return NULL;
    
    TabelaSimbolos* anterior = atual->anterior;
    
    // Não destrua o escopo global!
    if (anterior != NULL) {
        destruir_tabela(atual);
    }
    
    return anterior;
}

void imprimir_tabela(TabelaSimbolos* tabela) {
    int escopo = 0;
    TabelaSimbolos* atual = tabela;

    printf("\n=== TABELA DE SÍMBOLOS ===\n");

    while (atual != NULL) {
        printf("\n--- Escopo %d ---\n", escopo);

        for (int i = 0; i < TAM_TABELA; i++) {
            Simbolo* s = atual->tabela[i];
            while (s != NULL) {
                printf("Nome: %-15s Tipo: %s Tipo de Símbolo: %s\n", s->nome, s->tipo, s->tipo_simbolo);
                s = s->proximo;
            }
        }

        atual = atual->anterior;
        escopo++;
    }

    printf("==========================\n");
}
