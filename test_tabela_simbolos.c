#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabela_simbolos.h"

// Cores para output
#define VERDE "\033[0;32m"
#define VERMELHO "\033[0;31m"
#define AZUL "\033[0;34m"
#define RESET "\033[0m"

int testes_executados = 0;
int testes_passou = 0;

void teste_assert(int condicao, const char* nome_teste) {
    testes_executados++;
    if (condicao) {
        printf(VERDE "✓ PASSOU: %s" RESET "\n", nome_teste);
        testes_passou++;
    } else {
        printf(VERMELHO "✗ FALHOU: %s" RESET "\n", nome_teste);
    }
}

void teste_criacao_tabela() {
    printf(AZUL "\n=== Testando Criação de Tabela ===" RESET "\n");
    
    TabelaSimbolos* tabela = criar_tabela();
    teste_assert(tabela != NULL, "Criação de tabela não retorna NULL");
    
    if (tabela) {
        teste_assert(tabela->anterior == NULL, "Tabela inicial não tem anterior");
        destruir_tabela(tabela);
    }
}

void teste_insercao_simbolos() {
    printf(AZUL "\n=== Testando Inserção de Símbolos ===" RESET "\n");
    
    TabelaSimbolos* tabela = criar_tabela();
    
    if (tabela) {
        int resultado = inserir_simbolo(tabela, "variavel1", "int", ";");
        teste_assert(resultado == 1, "Inserção de símbolo retorna sucesso");
        
        inserir_simbolo(tabela, "variavel2", "float", ";");
        inserir_simbolo(tabela, "funcao1", "function", ";");
        
        destruir_tabela(tabela);
    }
}

void teste_busca_simbolos() {
    printf(AZUL "\n=== Testando Busca de Símbolos ===" RESET "\n");
    
    TabelaSimbolos* tabela = criar_tabela();
    
    if (tabela) {
        inserir_simbolo(tabela, "x", "int", ";");
        inserir_simbolo(tabela, "y", "float", ";");
        
        // Teste busca existente
        Simbolo* simbolo = buscar_simbolo(tabela, "x");
        teste_assert(simbolo != NULL, "Busca encontra símbolo existente");
        
        if (simbolo) {
            teste_assert(strcmp(simbolo->nome, "x") == 0, "Nome do símbolo correto");
            teste_assert(strcmp(simbolo->tipo, "int") == 0, "Tipo do símbolo correto");
        }
        
        // Teste busca não existente
        simbolo = buscar_simbolo(tabela, "z");
        teste_assert(simbolo == NULL, "Busca retorna NULL para símbolo inexistente");
        
        destruir_tabela(tabela);
    }
}

void teste_remocao_simbolos() {
    printf(AZUL "\n=== Testando Remoção de Símbolos ===" RESET "\n");
    
    TabelaSimbolos* tabela = criar_tabela();
    
    if (tabela) {
        inserir_simbolo(tabela, "temp1", "int", ";");
        inserir_simbolo(tabela, "temp2", "float", ";");
        
        int resultado = remover_simbolo(tabela, "temp2");
        teste_assert(resultado == 1, "Remoção de símbolo existente retorna sucesso");
        teste_assert(buscar_simbolo(tabela, "temp2") == NULL, "Símbolo removido não é encontrado");
        
        resultado = remover_simbolo(tabela, "inexistente");
        teste_assert(resultado == 0, "Remoção de símbolo inexistente retorna falha");
        
        destruir_tabela(tabela);
    }
}

void teste_tipos(){
    printf(AZUL "\n=== Testando Tipos ===" RESET "\n");

    TabelaSimbolos* tabela = criar_tabela();
    if(tabela){
        inserir_simbolo(tabela, "a", "int", "int");
        inserir_simbolo(tabela, "b", "int", "int");
        
        Simbolo* simbolo_a = buscar_simbolo(tabela, "a");
        Simbolo* simbolo_b = buscar_simbolo(tabela, "b");

        teste_assert(simbolo_a != NULL, "Simbolo não nulo");

        int tipos_sao_iguais = strcmp("int", simbolo_a->tipo) == 0;
        
        teste_assert(tipos_sao_iguais, "tipo correto aferido");
    }
    destruir_tabela(tabela);
}

void teste_soma_int_str() {
     printf(AZUL "\n=== Testando soma de inteiro com string ===" RESET "\n");

    TabelaSimbolos* tabela = criar_tabela();

    inserir_simbolo(tabela, "g", "int", "");
    inserir_simbolo(tabela, "h", "string", "");

    Simbolo* s1 = buscar_simbolo(tabela, "g");
    Simbolo* s2 = buscar_simbolo(tabela, "h");

    int tipos_sao_iguais = strcmp(s1->tipo, s2->tipo) == 0;

    teste_assert(!tipos_sao_iguais, "Erro de tipo ao somar int com string");

    destruir_tabela(tabela);
}

void teste_soma_float_str() {
     printf(AZUL "\n=== Testando soma de float com string ===" RESET "\n");

    TabelaSimbolos* tabela = criar_tabela();

    inserir_simbolo(tabela, "g", "float", "");
    inserir_simbolo(tabela, "h", "string", "");

    Simbolo* s1 = buscar_simbolo(tabela, "g");
    Simbolo* s2 = buscar_simbolo(tabela, "h");

    int tipos_sao_iguais = strcmp(s1->tipo, s2->tipo) == 0;

    teste_assert(!tipos_sao_iguais, "Erro de tipo ao somar int com string");

    destruir_tabela(tabela);
}


void teste_escopos() {
    printf(AZUL "\n=== Testando Escopos ===" RESET "\n");
    
    TabelaSimbolos* global = criar_tabela();
    
    if (global) {
        inserir_simbolo(global, "global_var", "int", ";");
        
        // Criar escopo local
        TabelaSimbolos* local = empilhar_escopo(global);
        teste_assert(local != NULL, "Empilhar escopo retorna nova tabela");
        
        if (local) {
            teste_assert(local->anterior == global, "Escopo local aponta para global");
            
            inserir_simbolo(local, "local_var", "float", ";");
            
            // Teste busca em escopo aninhado
            Simbolo* simbolo = buscar_simbolo(local, "global_var");
            teste_assert(simbolo != NULL, "Busca encontra variável do escopo superior");
            
            simbolo = buscar_simbolo(local, "local_var");
            teste_assert(simbolo != NULL, "Busca encontra variável do escopo atual");
            
            // Desempilhar
            TabelaSimbolos* volta = desempilhar_escopo(local);
            teste_assert(volta == global, "Desempilhar retorna escopo anterior");
        }
        
        // Tentar desempilhar escopo global
        TabelaSimbolos* resultado_null = desempilhar_escopo(global);
        teste_assert(resultado_null == NULL, "Desempilhar escopo global retorna NULL");
        
        destruir_tabela(global);
    }
}

void teste_casos_basicos() {
    printf(AZUL "\n=== Testando Casos Básicos ===" RESET "\n");
    
    TabelaSimbolos* tabela = criar_tabela();
    
    if (tabela) {
        // Teste com string vazia
        inserir_simbolo(tabela, "", "empty", ";");
        Simbolo* simbolo = buscar_simbolo(tabela, "");
        teste_assert(simbolo != NULL, "Inserção e busca de string vazia funciona");
        
        // Teste com nome comum
        inserir_simbolo(tabela, "var_test_123", "special", ";");
        simbolo = buscar_simbolo(tabela, "var_test_123");
        teste_assert(simbolo != NULL, "Inserção com nome comum funciona");
        
        destruir_tabela(tabela);
    }
    
    // Teste com ponteiros NULL
    teste_assert(buscar_simbolo(NULL, "teste") == NULL, "Busca em tabela NULL retorna NULL");
}

int main() {
    printf(AZUL "=================================================================" RESET "\n");
    printf(AZUL "              TESTES UNITÁRIOS - TABELA DE SÍMBOLOS" RESET "\n");
    printf(AZUL "=================================================================" RESET "\n");
    printf("\n");
    
    teste_criacao_tabela();
    teste_insercao_simbolos();
    teste_busca_simbolos();
    teste_remocao_simbolos();
    teste_tipos();
    teste_soma_int_str();
    teste_soma_float_str();
    teste_escopos();
    teste_casos_basicos();
    
    printf(AZUL "\n=================================================================" RESET "\n");
    printf(AZUL "                          RESUMO" RESET "\n");
    printf(AZUL "=================================================================" RESET "\n");
    printf("Testes executados: %d\n", testes_executados);
    printf("Testes que passaram: " VERDE "%d" RESET "\n", testes_passou);
    printf("Testes que falharam: " VERMELHO "%d" RESET "\n", testes_executados - testes_passou);
    
    if (testes_passou == testes_executados) {
        printf(VERDE "\n🎉 TODOS OS TESTES PASSARAM!" RESET "\n");
        return 0;
    } else {
        printf(VERMELHO "\n❌ ALGUNS TESTES FALHARAM!" RESET "\n");
        return 1;
    }
}