/*
======================== TESTES PARA ÁRVORE DE DERIVAÇÃO SINTÁTICA ========================

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

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

void teste_funcao(){
    printf(AZUL "\n=== Testando Função ===" RESET "\n");
    // x = 1
    NoAST* var_x = criarNoId("x");
    NoAST* val_1 = criarNoNumInt(1);
    NoAST* atribuicao_x = criarNoOp('=', var_x, val_1);

    // y = 2
    NoAST* var_y = criarNoId("y");
    NoAST* val_2 = criarNoNumInt(2);
    NoAST* atribuicao_y = criarNoOp('=', var_y, val_2);

    // x + y
    NoAST* soma = criarNoOp('+', criarNoId("x"), criarNoId("y"));

    // return x + y
    NoAST* retorno = criarNoPalavraChave("return");
    retorno->direita = soma;

    // Corpo da função (sequência de instruções)
    NoAST* corpo1 = criarNoSeq(atribuicao_x, atribuicao_y);
    NoAST* corpo_completo = criarNoSeq(corpo1, retorno);

    // Função soma()
    NoAST* func_soma = criarNoFunDef("soma", NULL, corpo_completo);

    // Verificações simples estruturais
    teste_assert(func_soma != NULL, "Função foi criada com sucesso");
    teste_assert(func_soma->tipo == TIPO_FUNCAO, "Tipo do nó é função");
    teste_assert(func_soma->direita != NULL, "Corpo da função existe");
    teste_assert(func_soma->direita->direita->tipo == TIPO_PALAVRA_CHAVE &&
                 strcmp(func_soma->direita->direita->palavra_chave, "return") == 0,
                 "Corpo termina com return");
}

void teste_chamada_de_funcao() {
    printf(AZUL "\n=== Testando Chamada de Função ===" RESET "\n");
    // Definição da função soma(a, b)
    NoAST* param_a = criarParam("a");
    NoAST* param_b = criarParam("b");
    NoAST* lista_params = appendParam(param_a, param_b);

    NoAST* soma_ab = criarNoOp('+', criarNoId("a"), criarNoId("b"));
    NoAST* retorno = criarNoPalavraChave("return");
    retorno->direita = soma_ab;

    NoAST* func_soma = criarNoFunDef("soma", lista_params, retorno);

    // Chamada: soma(1, 2)
    NoAST* arg1 = criarNoNumInt(1);
    NoAST* arg2 = criarNoNumInt(2);
    NoAST* lista_args = appendParam(arg1, arg2);
    NoAST* chamada_soma = criarNoFuncCall("soma", lista_args);

    // x = soma(1, 2)
    NoAST* atribuicao = criarNoOp('=', criarNoId("x"), chamada_soma);

    // função principal
    NoAST* func_principal = criarNoFunDef("principal", NULL, atribuicao);

    // Testes
    teste_assert(chamada_soma != NULL, "Chamada da função foi criada");
    teste_assert(strcmp(chamada_soma->nome, "soma") == 0, "Nome da função chamada é 'soma'");
    teste_assert(chamada_soma->esquerda != NULL, "Argumentos da chamada existem");
    teste_assert(chamada_soma->esquerda->valor == 1, "Primeiro argumento é 1");
    teste_assert(chamada_soma->esquerda->direita->valor == 2, "Segundo argumento é 2");
}

void teste_return_varios_tipos(){
    printf(AZUL "\n=== Testando retorno de varios tipos ===" RESET "\n");
    NoAST* retorno1 = criarNoPalavraChave("return");
    retorno1->direita = criarNoNumInt(1);
    NoAST* funcao1 = criarNoFunDef("printaInt", NULL, retorno1);

    teste_assert(funcao1->direita->direita->tipo == TIPO_INT, "Retorno de inteiro com sucesso");

    NoAST* retorno2 = criarNoPalavraChave("return");
    retorno2->direita = criarNoString("oioi");
    NoAST* funcao2 = criarNoFunDef("printaString", NULL, retorno2);

    teste_assert(funcao2->direita->direita->tipo == TIPO_STRING, "Retorno de string com sucesso");

    NoAST* retorno3 = criarNoPalavraChave("return");
    NoAST* somaIntString = criarNoOp('+', criarNoString("oioi"), criarNoNumInt(1));
    retorno3->direita = somaIntString;
    NoAST* funcao3 = criarNoFunDef("printaString", NULL, retorno3);

    teste_assert(retorno3->direita->direita->tipo != retorno3->direita->esquerda->tipo, "Retorno indevido processado corretamente");

}

void teste_if_elif_else() {
    printf(AZUL "\n=== Testando Condições ===" RESET "\n");
    // Condição: x > 0
    NoAST* cond_if = criarNoOpComposto(">", criarNoId("x"), criarNoNumInt(0));
    NoAST* corpo_if = criarNoFuncPrint(criarNoString("positivo"));
    NoAST* no_if = criarNoIf(cond_if, corpo_if);

    // Condição: x == 0
    NoAST* cond_elif = criarNoOpComposto("==", criarNoId("x"), criarNoNumInt(0));
    NoAST* corpo_elif = criarNoFuncPrint(criarNoString("zero"));
    NoAST* no_elif = criarNoElif(cond_elif, corpo_elif);

    // Else: print("negativo")
    NoAST* corpo_else = criarNoFuncPrint(criarNoString("negativo"));
    NoAST* no_else = criarNoElse(corpo_else);

    // Sequência: if -> elif -> else
    NoAST* condicao_completa = criarNoSeq(no_if, no_elif);
    NoAST* bloco_condicional = criarNoSeq(condicao_completa, no_else);

    // Função exemplo()
    NoAST* func_exemplo = criarNoFunDef("exemplo", NULL, bloco_condicional);

    // Impressão opcional para debug
    imprimirASTBonita(func_exemplo, "", 1);

    // Verificações
    teste_assert(func_exemplo != NULL, "Função 'exemplo' criada");
    teste_assert(func_exemplo->direita != NULL, "Função 'exemplo' tem corpo");
    teste_assert(func_exemplo->direita->esquerda != NULL, "Contém if");
    teste_assert(func_exemplo->direita->esquerda->direita != NULL, "Contém elif");
    teste_assert(func_exemplo->direita->direita != NULL, "Contém else");

    // Verificar conteúdo do else
    NoAST* else_body = func_exemplo->direita->direita->direita; // else → corpo

    teste_assert(else_body != NULL && else_body->tipo == TIPO_PRINT &&
                 strcmp(else_body->palavra_chave, "print") == 0,
                 "Else imprime 'negativo'");
}

void teste_while(){
    printf(AZUL "\n=== Testando Condições ===" RESET "\n");

    NoAST* condicao = criarNoOpComposto(">", criarNoId("x"), criarNoNumInt(2));
    NoAST* corpo = criarNoFuncPrint(criarNoString("x é maior que 2"));
    NoAST* no_while = criarNoPalavraChave("while");

    no_while->esquerda = corpo;
    no_while->direita = condicao;
    
    teste_assert(no_while != NULL, "Nó while criado com sucesso");
    teste_assert(strcmp(no_while->palavra_chave, "while") == 0, "Nó é palavra-chave while");
    teste_assert(no_while->direita != NULL, "While tem condição");
    teste_assert(no_while->direita->tipo == TIPO_OPCOMP, "Condição é operador composto");
    teste_assert(no_while->esquerda != NULL, "While tem corpo");
    teste_assert(no_while->esquerda->tipo == TIPO_PRINT &&
             strcmp(no_while->esquerda->palavra_chave, "print") == 0,
             "Corpo do while é um print");
}





int main() {
    printf(AZUL "=================================================================" RESET "\n");
    printf(AZUL "                 TESTES UNITÁRIOS - AST" RESET "\n");
    printf(AZUL "=================================================================" RESET "\n");
    printf("\n");

    teste_funcao();
    teste_chamada_de_funcao();
    teste_return_varios_tipos();
    teste_if_elif_else();
    teste_while();
    
    
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