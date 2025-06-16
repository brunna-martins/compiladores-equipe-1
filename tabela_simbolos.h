#ifndef TABELA_SIMBOLOS_H
#define TABELA_SIMBOLOS_H

#define TAM_TABELA 211

typedef struct Simbolo {
    char* nome;
    char* tipo;
    struct Simbolo* proximo;
} Simbolo;

typedef struct TabelaSimbolos {
    Simbolo* tabela[TAM_TABELA];
    struct TabelaSimbolos* anterior;  
} TabelaSimbolos;

TabelaSimbolos* criar_tabela();
void destruir_tabela(TabelaSimbolos* tabela);
int inserir_simbolo(TabelaSimbolos* tabela, const char* nome, const char* tipo);
Simbolo* buscar_simbolo(TabelaSimbolos* tabela, const char* nome);
int remover_simbolo(TabelaSimbolos* tabela, const char* nome);
void imprimir_tabela(TabelaSimbolos* tabela);

TabelaSimbolos* empilhar_escopo(TabelaSimbolos* atual);
TabelaSimbolos* desempilhar_escopo(TabelaSimbolos* atual);


#endif
