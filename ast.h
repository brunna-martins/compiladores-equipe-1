#ifndef AST_H
#define AST_H

typedef enum { 
    TIPO_INT, 
    TIPO_FLOAT, 
    TIPO_STRING, 
    TIPO_DELIMITADOR, 
    TIPO_PALAVRA_CHAVE, 
    TIPO_ERRO, 
    TIPO_ID, 
    TIPO_FUNCAO, 
    TIPO_PARAM, 
    TIPO_OP,
    TIPO_OPCOMP,
    TIPO_SEQUENCIA,
    TIPO_PRINT,
} Tipo;

typedef struct noAST {
    char operador;
    char operadorComp[2];
    char *valor_string;
    char nome[32];
    char delimitador;
    char *palavra_chave;
    int valor;
    float valor_float;
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
NoAST* criarNoIf(NoAST *cond, NoAST *corpo);
NoAST* criarNoElif(NoAST *cond, NoAST *corpo);
NoAST* criarNoElse(NoAST *corpo);
NoAST* criarNoSeq(NoAST *primeiro, NoAST *segundo);
NoAST *criarNoId(char *nome);
NoAST *criarNoDelimitador(char delimitador);
NoAST *criarNoFunDef(char *nome, NoAST *params, NoAST *body);
NoAST *criarParam(char *nome);
NoAST *appendParam(NoAST *lista, NoAST *novo);
NoAST *criarNoParenteses(NoAST *abre, NoAST *conteudo, NoAST *fecha);
NoAST *criarNoOpComposto(char *operador, NoAST *esquerda, NoAST *direita);
void imprimirASTBonita(NoAST *no, const char *prefixo, int ehUltimo);
int tiposCompativeis(Tipo t1, Tipo t2);
NoAST *criarNoFuncPrint(NoAST *params);

#endif