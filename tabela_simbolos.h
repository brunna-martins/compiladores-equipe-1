#ifndef TABELA_SIMBOLOS_H
#define TABELA_SIMBOLOS_H

#define TAM_TABELA 211

typedef struct Simbolo {
    char* nome;
    char* tipo;
    char* tipo_simbolo;
    struct Simbolo* proximo;
} Simbolo;

typedef struct TabelaSimbolos {
    Simbolo* tabela[TAM_TABELA];
    struct TabelaSimbolos* anterior;  
} TabelaSimbolos;

TabelaSimbolos* criar_tabela();
void destruir_tabela(TabelaSimbolos* tabela);
int inserir_simbolo(TabelaSimbolos* tabela, const char* nome, const char* tipo, const char* tipo_simbolo);
Simbolo* buscar_simbolo(TabelaSimbolos* tabela, const char* nome);
int remover_simbolo(TabelaSimbolos* tabela, const char* nome);
void imprimir_tabela(TabelaSimbolos* tabela);
Simbolo* buscar_simbolo_no_escopo_atual(TabelaSimbolos* tabela, const char* nome);

TabelaSimbolos* empilhar_escopo(TabelaSimbolos* atual);
TabelaSimbolos* desempilhar_escopo(TabelaSimbolos* atual);


#endif
