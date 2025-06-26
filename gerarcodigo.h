#ifndef GC
#define GC
#include "ast.h"
#include "tabela_simbolos.h"

int gerar_codigo_c(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_parametros(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_programa_c(NoAST* raiz, const char* nome_arquivo, TabelaSimbolos* tabela);
void gerar_statement(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_funcoes(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_codigo_funcao(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_sintaxe_print(NoAST* node, FILE* out, TabelaSimbolos* tabela);
int determinar_tipo_no(NoAST* node, TabelaSimbolos* tabela);
void gerarPrint(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void verificar_necessidade_concatenar(NoAST* node);

#endif