#include <stdio.h>
#include <stdlib.h>
#include "../tabela_simbolos.h" 


// Declare a variável global escopo_atual como extern
extern TabelaSimbolos* escopo_atual;

int yyparse(void);

int main(void) {
    printf("Digite uma expressão:\n");
    yyparse();
    // Destrói o escopo global ao final
    if (escopo_atual) {
        destruir_tabela(escopo_atual);
        escopo_atual = NULL;  // Boa prática para evitar referência pendente
    }
    return 0;
}
