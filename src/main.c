#include <stdio.h>
#include <stdlib.h>

int yyparse(void);

int main(void) {
    printf("Digite uma expressão:\n");
    yyparse();
    return 0;
}
