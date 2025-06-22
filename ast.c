#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "tabela_simbolos.h"

NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = op;
    no->esquerda = esq;
    no->direita = dir;
    no->meio = NULL;
    no->tipo = TIPO_OP;
    return no;
}

NoAST *criarNoOpComposto(char *operador, NoAST *esquerda, NoAST *direita)
{
    NoAST *no = malloc(sizeof(NoAST));
    strcpy(no->operadorComp, operador);
    no->tipo = TIPO_OPCOMP;
    no->esquerda = esquerda;
    no->direita = direita;
    no->meio = NULL;
    return no;
}

NoAST *criarNoNumInt(int val) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor = val;
    no->operador = 0;
    no->tipo = TIPO_INT;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoNumFloat(float valor_float) {
    NoAST *no = malloc(sizeof(NoAST));
    no->valor_float = valor_float;
    no->operador = 0;
    no->tipo = TIPO_FLOAT;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoString(char *valor_string) {
    NoAST *no = malloc(sizeof(NoAST));  
    no->valor_string = valor_string;
    no->operador = 0;
    no->tipo = TIPO_STRING;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoId(char *nome) {
    NoAST *no = malloc(sizeof(NoAST));
    strcpy(no->nome, nome);
    no->operador = 0;
    no->tipo = TIPO_ID;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoPalavraChave(char *palavraChave) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 0;
    no->palavra_chave = palavraChave;
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoDelimitador(char delimitador) {
    NoAST *no = malloc(sizeof(NoAST));    
    no->operador = 0;
    no->delimitador = delimitador;
    no->tipo = TIPO_DELIMITADOR;
    no->esquerda = no->direita = no->meio = NULL;
    return no;
}

NoAST *criarNoParenteses(NoAST *abre, NoAST *conteudo, NoAST *fecha) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = 0;
    no->tipo = TIPO_DELIMITADOR;
    no->esquerda = abre;
    no->meio = conteudo;
    no->direita = fecha;
    return no;
}

NoAST *criarNoFunDef(char *nome, NoAST *params, NoAST *body) {
    NoAST *n = malloc(sizeof(NoAST));
    n->tipo         = TIPO_FUNCAO;
    n->operador     = 0;              /* não usamos */
    n->valor        = 0;
    n->valor_float  = 0.0f;
    n->valor_string = NULL;
    strncpy(n->nome, nome, 31);
    n->nome[31]     = '\0';
    n->delimitador  = 0;
    n->palavra_chave= NULL;
    n->esquerda     = params;         /* lista de params */
    n->meio         = body;           /* corpo (stmt_list) */
    n->direita      = NULL;           /* próximo statement no escopo */
    return n;
}

NoAST *criarNoFuncPrint(NoAST *params)
{
    NoAST *no = malloc(sizeof(NoAST));
    no->esquerda = params;
    no->direita = NULL;
    no->tipo = TIPO_PRINT;
    return no;
}

NoAST *criarParam(char *nome) {
    NoAST *p = malloc(sizeof(NoAST));
    p->tipo         = TIPO_PARAM;
    strncpy(p->nome, nome, 31);
    p->nome[31]     = '\0';
    p->esquerda     = p->meio = NULL;
    p->direita      = NULL;  /* próximo parâmetro */
    return p;
}

NoAST *appendParam(NoAST *lista, NoAST *novo) {
    if (!lista) return novo;
    NoAST *it = lista;
    while (it->direita) it = it->direita;
    it->direita = novo;
    return lista;
}

NoAST* criarNoIf(NoAST *cond, NoAST *corpo) {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->palavra_chave = strdup("if");
    no->esquerda = cond;
    no->direita = corpo;
    no->meio = NULL;
    return no;
}

NoAST* criarNoElif(NoAST *cond, NoAST *corpo) {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->palavra_chave = strdup("elif");
    no->esquerda = cond;
    no->direita = corpo;
    no->meio = NULL;
    return no;
}

NoAST* criarNoElse(NoAST *corpo) {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    no->tipo = TIPO_PALAVRA_CHAVE;
    no->palavra_chave = strdup("else");
    no->esquerda = NULL;
    no->direita = corpo;
    no->meio = NULL;
    return no;
}

NoAST* criarNoSeq(NoAST *primeiro, NoAST *segundo) {
    NoAST *no = (NoAST*) malloc(sizeof(NoAST));
    no->tipo = TIPO_SEQUENCIA;
    no->esquerda = primeiro;
    no->direita = segundo;
    no->meio = NULL;
    return no;
}


// void imprimirAST(NoAST *no) {
//     if (!no) return;
//     if (no->operador) {
//         printf("(");
//         imprimirAST(no->esquerda);
//         printf(" %c ", no->operador);
//         imprimirAST(no->direita);
//         printf(")");
//     } else if (strlen(no->nome) > 0) {
//         printf("%s", no->nome);
//     } else {
//         printf("%d", no->valor);
//     }
// }



void imprimirASTBonita(NoAST *no, const char *prefixo, int ehUltimo) {
    if (!no) return;

    // Imprime prefixo e conector
    printf("%s", prefixo);
    printf(ehUltimo ? "└── " : "├── ");

    // Conteúdo do nó
    switch (no->tipo) {
        case TIPO_FUNCAO:
            printf("Função: %s\n", no->nome);
            break;
        case TIPO_PARAM:
            printf("Parâmetro: %s\n", no->nome);
            break;
        case TIPO_PALAVRA_CHAVE:
            printf("Palavra-chave: %s\n", no->palavra_chave);
            break;
        case TIPO_INT:
            printf("Inteiro: %d\n", no->valor);
            break;
        case TIPO_FLOAT:
            printf("Float: %.2f\n", no->valor_float);
            break;
        case TIPO_STRING:
            printf("String: %s\n", no->valor_string);
            break;
        case TIPO_ID:
            printf("Identificador: %s\n", no->nome);
            break;
        case TIPO_DELIMITADOR:
            printf("Delimitador: %c\n", no->delimitador);
            break;
        case TIPO_OP:
            printf("Operador: %c\n", no->operador);
            break;
        case TIPO_OPCOMP:
            printf("Operador: %s\n", no->operadorComp);
            break;
        case TIPO_ERRO:
            printf("AAAAAA!\n");
            break;
        case TIPO_SEQUENCIA:
            printf("Nó sequência: 🪢\n");
            break; 
        case TIPO_PRINT:
            printf("PRINT\n");
            break;
        default:
            if (no->operador)
                printf("Operador: %c\n", no->operador);
            else
                printf("Nó desconhecido\n");
            break;
    }

    // Novo prefixo para filhos
    char novoPrefixo[256];
    snprintf(novoPrefixo, sizeof(novoPrefixo), "%s%s", prefixo, ehUltimo ? "    " : "│   ");

    // Lista de filhos (meio, esquerda, direita)
    int filhosExistem[3] = { no->esquerda != NULL, no->meio != NULL, no->direita != NULL };
    int totalFilhos = filhosExistem[0] + filhosExistem[1] + filhosExistem[2];
    int contador = 0;

    if (no->esquerda)
        imprimirASTBonita(no->esquerda, novoPrefixo, ++contador == totalFilhos);
    if (no->meio)
        imprimirASTBonita(no->meio, novoPrefixo, ++contador == totalFilhos);
    if (no->direita)
        imprimirASTBonita(no->direita, novoPrefixo, ++contador == totalFilhos);
}

int gerar_codigo_c(NoAST* node, FILE* out, TabelaSimbolos* tabela) {
    if (!node) return 0;
    
    switch (node->tipo) {
        case TIPO_SEQUENCIA:
            gerar_statement(node->esquerda, out, tabela);
            gerar_statement(node->direita, out, tabela);
            break;


        case TIPO_OP:
            if (node->operador == '=') 
            {
                // Atribuição (statement)
                Simbolo* s = buscar_simbolo(tabela, node->esquerda->nome);
                if(!s->foi_traduzido)
                {
                    fprintf(out, "%s ", s->tipo_simbolo);
                    s->foi_traduzido = 1;
                }


                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, " = ");
                gerar_codigo_c(node->direita, out, tabela);
            } 
            else
            {
                // Expressão
                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, " %c ", node->operador);
                fprintf(out, "(");
                gerar_codigo_c(node->direita, out, tabela);
                fprintf(out, ")");
            }
            break;


        case TIPO_ID:
            fprintf(out, "%s", node->nome);
            break;

        case TIPO_INT:
            fprintf(out, "%d", node->valor);
            break;

        case TIPO_FLOAT:
            fprintf(out, "%f", node->valor_float);
            break;

        case TIPO_STRING:
            fprintf(out, "%s", node->valor_string);
            break;

        case TIPO_PRINT:
            fprintf(out, "printf(\"%%d\\n\", ");
            gerar_codigo_c(node->esquerda, out, tabela); // O que está sendo printado
            fprintf(out, ");\n");
            break;

        case TIPO_PALAVRA_CHAVE:
            if (strcmp(node->palavra_chave, "if") == 0) {
                fprintf(out, "if (");
                gerar_codigo_c(node->esquerda, out, tabela); // Condição
                fprintf(out, ") {\n");
                gerar_codigo_c(node->direita, out, tabela);  // Corpo
                fprintf(out, "}\n");
            }

            break;

        default:
            fprintf(out, "// [Não implementado para tipo %d]\n", node->tipo);
            break;
    }

    return 1;
}


void gerar_programa_c(NoAST* raiz, const char* nome_arquivo, TabelaSimbolos* tabela) {
    FILE* out = fopen(nome_arquivo, "w");
    if (!out) {
        perror("Erro ao abrir arquivo");
        return;
    }

    fprintf(out, "#include <stdio.h>\n\nint main() {\n");

    gerar_codigo_c(raiz, out, tabela);

    fprintf(out, "return 0;\n}\n");
    fclose(out);
}

void gerar_statement(NoAST* node, FILE* out, TabelaSimbolos* tabela) {
    if (!node) return;

    switch (node->tipo) {
        case TIPO_OP:
            gerar_codigo_c(node, out, tabela);
            fprintf(out, ";\n");
            break;

        case TIPO_PRINT:
        case TIPO_PALAVRA_CHAVE:
        case TIPO_SEQUENCIA:
            // Já cuidam de \n e ;
            gerar_codigo_c(node, out, tabela);
            break;

        default:
            gerar_codigo_c(node, out, tabela);
            fprintf(out, ";\n");
            break;
    }
}


int tiposCompativeis(Tipo t1, Tipo t2) {
    return t1 == t2;
}