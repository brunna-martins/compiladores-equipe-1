#include <stdio.h>
#include <stdlib.h>
#include "../tabela_simbolos.h" 


// Declare a variável global escopo_atual como extern
extern TabelaSimbolos* escopo_atual;
#include "../parser.tab.h"
#include "../ast.h"

int yyparse(void);

// Declarada no parser.y
//extern int yyparse(void);
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
