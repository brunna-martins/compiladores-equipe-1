#include <stdio.h>

// Declarações externas para usar o parser

int yyparse(void);

int main(void) {
    printf("Digite uma expressão:\n");
    yyparse();
    return 0;
}
