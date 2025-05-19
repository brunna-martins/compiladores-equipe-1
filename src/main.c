#include <stdio.h>
#include <stdlib.h>
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
        printf("\n---- AST gerada ----\n");
        imprimirASTBonita(raiz, 0, "", 1);
        printf("-------------------\n");
    } 
    else 
    {
        printf("Erro ao gerar a AST.\n");
    }
    
    return 0;
}
