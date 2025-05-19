#include <stdio.h>
#include <stdlib.h>
//#include <ast.h>

int yyparse(void);

// Declarada no parser.y
//extern int yyparse(void);
//extern NoAST *raizAST;

int main(void) {
    printf("Digite uma expressão:\n");
    yyparse();

    // if (yyparse() == 0) 
    // {
    //     printf("\nAST gerada:\n");
    //     imprimirASTBonita(raizAST, 0);
    //     printf("\n");
    // } 
    // else 
    // {
    //     printf("Erro ao gerar a AST.\n");
    // }
    
    return 0;
}
