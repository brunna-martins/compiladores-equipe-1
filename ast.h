#ifndef AST_H
#define AST_H

typedef enum { TIPO_INT, TIPO_FLOAT, TIPO_STRING, TIPO_DELIMITADOR, TIPO_PALAVRA_CHAVE, TIPO_ERRO, TIPO_ID} Tipo;

typedef struct noAST {
    char operador;
    int valor;
    float valor_float;
    char *valor_string;
    char nome[32];
    char delimitador;
    char *palavra_chave;
    Tipo tipo;
    struct noAST *esquerda;
    struct noAST *direita;
    struct noAST *meio;
} NoAST;

NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir);
NoAST *criarNoNumInt(int val);
NoAST *criarNoNumFloat(float valor_float);
NoAST *criarNoString(char *valor_string);
NoAST *criarNoPalavraChave(char *palavraChave);
NoAST *criarNoId(char *nome, Tipo tipo);
NoAST *criarNoDelimitador(char delimitador);
NoAST *criarNoParenteses(NoAST *abre, NoAST *conteudo, NoAST *fecha);
void imprimirAST(NoAST *no);
int tiposCompativeis(Tipo t1, Tipo t2);

#endif