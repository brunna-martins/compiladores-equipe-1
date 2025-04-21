#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;

int yyparse(void);

int main(void) {
    yyin = fopen("teste.txt", "r");
    if (!yyin) {
        perror("Erro ao abrir arquivo");
        return 1;
    }

    yyparse();

    fclose(yyin);
    return 0;
}

//#include <stdio.h>

// Declarações externas para usar o parser
//int yyparse(void);

//int main(void) {
//    printf("Digite uma expressão:\n");
//    yyparse();
//    return 0;
//}
