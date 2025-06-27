#include <stdio.h>
#include <stdlib.h>
#include "../tabela_simbolos.h" 


// Declare a variável global escopo_atual como extern
#include "../parser.tab.h"
#include "../ast.h"

int yyparse(void);

// Declaradas no parser.y
extern TabelaSimbolos* escopo_atual;
extern NoAST *raiz;

int main(void) {
    printf("Digite uma expressão:\n");
    fflush(stdout);
    int status = yyparse();

    if (status == 0) 
    {
        printf("\n---- AST gerada -------------------\n\n");
        imprimirASTBonita(raiz, "", 1);
        printf("\n-------------------------------------\n\n");
        imprimir_tabela(escopo_atual);
    } 
    else 
    {
        printf("Erro ao gerar a AST.\n");
    }
    
    // Destrói o escopo global ao final
    if (escopo_atual) {
        destruir_tabela(escopo_atual);
        escopo_atual = NULL;  // Boa prática para evitar referência pendente
    }
    return 0;
}
