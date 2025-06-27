#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "ast.h"
#include "tabela_simbolos.h"
#include "gerarcodigo.h"


NoAST* encontrar_no_return(NoAST* node);
const char* inferir_tipo_retorno(NoAST* corpo_funcao, TabelaSimbolos* tabela);

void gerar_programa_c(NoAST* raiz, const char* nome_arquivo, TabelaSimbolos* tabela);
int gerar_codigo_c(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_statement(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_funcoes(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_codigo_funcao(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_parametros(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerar_parametros_declaracao(NoAST* node, FILE* out, TabelaSimbolos* tabela);
void gerarPrint(NoAST* node, FILE* out, TabelaSimbolos* tabela);
bool precisa_concatenar_helper = false;

int gerar_codigo_c(NoAST* node, FILE* out, TabelaSimbolos* tabela) {
    if (!node) return 0;

    if (node->tipo == TIPO_FUNCAO) {
        return 0;
    }

    switch (node->tipo) {
        case TIPO_SEQUENCIA:
            gerar_statement(node->esquerda, out, tabela);
            gerar_statement(node->direita, out, tabela);
            break;

        case TIPO_OP:
            if (node->operador == '=') {
                if (node->esquerda && node->esquerda->tipo == TIPO_ID) {
                    Simbolo* s = buscar_simbolo(tabela, node->esquerda->nome);
                    if(s && strcmp(s->tipo, "param") == 0) {
                        s->foi_traduzido = 1;
                    }
                    else if (s && !s->foi_traduzido){
                        fprintf(out, "%s ", s->tipo_simbolo);   
                        s->foi_traduzido = 1;
                    }
                }
                gerar_codigo_c(node->esquerda, out, tabela); 
                fprintf(out, " = ");
                gerar_codigo_c(node->direita, out, tabela);

            }
            else if (node->operador == '+') {
                int tipo_esq = determinar_tipo_no(node->esquerda, tabela);
                int tipo_dir = determinar_tipo_no(node->direita, tabela);

                // Se qualquer um dos lados for uma string, fazemos concatenação
                if (tipo_esq == TIPO_STRING || tipo_dir == TIPO_STRING) {
                    fprintf(out, "concatenar_strings("); 
                    gerar_codigo_c(node->esquerda, out, tabela);
                    fprintf(out, ", ");
                    gerar_codigo_c(node->direita, out, tabela);
                    fprintf(out, ")");
                } else { 
                    int tipo_resultante = determinar_tipo_no(node, tabela);
                    fprintf(out, "(");
                    if (tipo_resultante == TIPO_FLOAT && tipo_esq == TIPO_INT) fprintf(out, "(float)");
                    gerar_codigo_c(node->esquerda, out, tabela); 
                    fprintf(out, " + ");
                    if (tipo_resultante == TIPO_FLOAT && tipo_dir == TIPO_INT) fprintf(out, "(float)");
                    gerar_codigo_c(node->direita, out, tabela);
                    fprintf(out, ")");
                }
            }
            else {
                int tipo_resultante = determinar_tipo_no(node, tabela);
                fprintf(out, "(");
                if (tipo_resultante == TIPO_FLOAT && determinar_tipo_no(node->esquerda, tabela) == TIPO_INT) fprintf(out, "(float)");
                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, " %c ", node->operador);
                if (tipo_resultante == TIPO_FLOAT && determinar_tipo_no(node->direita, tabela) == TIPO_INT) fprintf(out, "(float)");
                gerar_codigo_c(node->direita, out, tabela);
                fprintf(out, ")");
            }
            break;
        case TIPO_OPCOMP:
            if (strcmp(node->operadorComp, "==") == 0) 
            {
                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, " == ");
                gerar_codigo_c(node->direita, out, tabela);
            } 
            else
            {
                // Expressão
                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, " %s ", node->operadorComp);
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
        
        case TIPO_PARAM:
            fprintf(out, "%s", node->nome);
            break;
        
        case TIPO_PRINT:
            gerarPrint(node, out, tabela);
            break;

        case TIPO_PALAVRA_CHAVE:
            if (strcmp(node->palavra_chave, "if") == 0) {
                fprintf(out, "if (");
                gerar_codigo_c(node->esquerda, out, tabela); // Condição
                fprintf(out, ") {\n");
                gerar_codigo_c(node->direita, out, tabela);  // Corpo
                fprintf(out, "}\n");
            }
            else if (strcmp(node->palavra_chave, "elif") == 0) {
                fprintf(out, "else if (");
                gerar_codigo_c(node->esquerda, out, tabela); // Condição
                fprintf(out, ") {\n");
                gerar_codigo_c(node->direita, out, tabela);  // Corpo
                fprintf(out, "}\n");
            }
            else if (strcmp(node->palavra_chave, "else") == 0) {
                fprintf(out, "else {\n");
                gerar_codigo_c(node->direita, out, tabela); // Corpo do else está sempre no nó direita
                fprintf(out, "}\n");
            }
            else if (strcmp(node->palavra_chave, "return") == 0) {
                fprintf(out, "return ");
                if (node->esquerda) {
                    gerar_codigo_funcao(node->esquerda, out, tabela);
                    if(node->direita)
                        gerar_codigo_funcao(node->direita, out, tabela);
                }
                fprintf(out, ";\n");
            }
            else if (strcmp(node->palavra_chave, "while") == 0) {
                fprintf(out, "while(");
                gerar_codigo_c(node->esquerda, out, tabela); // Condição
                fprintf(out, ") {\n");
                gerar_codigo_c(node->direita, out, tabela);  // Corpo
                fprintf(out, "}\n");
            }
            else if(strcmp(node->palavra_chave, "True") == 0){
                fprintf(out, "true");
            }
            else if(strcmp(node->palavra_chave, "False") == 0){
                fprintf(out, "false");
            }
            else if(strcmp(node->palavra_chave, "None") == 0){
                fprintf(out, "NULL");
            }
            else if(strcmp(node->palavra_chave, "pass") == 0){
                fprintf(out, "; // passou\n");
            }
            break;

        case TIPO_FUNCAO:
            break;

        case TIPO_CHAMADA_DE_FUNCAO:
            fprintf(out, "%s(", node->nome);
            gerar_parametros(node->esquerda, out, tabela);
            fprintf(out, ");\n");
            break;
        
        case TIPO_LOGICO:
            if(strcmp(node->nome, "not") == 0)
            {
                fprintf(out, "!"); //not
                gerar_codigo_c(node->esquerda, out, tabela);
            }
            else if(strcmp(node->nome, "and") == 0)
            {   
                fprintf(out, "(");
                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, ")");
                fprintf(out, " && "); //and
                fprintf(out, "(");
                gerar_codigo_c(node->direita, out, tabela);
                fprintf(out, ")");
            }
            else if(strcmp(node->nome, "or") == 0)
            {
                fprintf(out, "(");
                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, ")");
                fprintf(out, " || "); //or
                fprintf(out, "(");
                gerar_codigo_c(node->direita, out, tabela);
                fprintf(out, ")");
            }
            break;
        default:
            fprintf(out, "// [Não implementado para tipaaao %d]\n", node->tipo);
            break;
    }

    return 1;
}

void gerar_parametros(NoAST* node, FILE* out, TabelaSimbolos* tabela)
{
    if(!node) return;

    switch(node->tipo)
    {
        case TIPO_INT:
            fprintf(out, "%d", node->valor);
            break;
        case TIPO_FLOAT:
            fprintf(out, "%f", node->valor_float);
            break;
        case TIPO_STRING:
            fprintf(out, "%s", node->valor_string);
            break;
        case TIPO_ID:
            fprintf(out, "%s", node->nome);
            break;       
    }

    if(node->esquerda)
        fprintf(out, ",");
    else if(node->direita)
        fprintf(out, ",");
    
    if(node->esquerda)
        gerar_parametros(node->esquerda, out, tabela);
    else
        gerar_parametros(node->direita, out, tabela);
}

void gerar_programa_c(NoAST* raiz, const char* nome_arquivo, TabelaSimbolos* tabela) {
    if (!raiz) {
    printf("Aviso: Nó nulo encontrado durante geração de código\n");
    return;
}
    
    FILE* out = fopen(nome_arquivo, "w");
    if (!out) {
        perror("Erro ao abrir arquivo");
        return;
    }

    fprintf(out, "#include <stdio.h>\n");
    fprintf(out, "#include <string.h>\n");
    fprintf(out, "#include <stdlib.h>\n"); 
    fprintf(out, "#include <stdbool.h>\n\n"); 


    // só exibe função concatenar se for soma de strings
    if (precisa_concatenar_helper) {
        fprintf(out, "char* concatenar_strings(const char* s1, const char* s2) {\n");
        fprintf(out, "\tchar* resultado = (char*) malloc(strlen(s1) + strlen(s2) + 1);\n");
        fprintf(out, "\tstrcpy(resultado, s1);\n");
        fprintf(out, "\tstrcat(resultado, s2);\n");
        fprintf(out, "\treturn resultado;\n");
        fprintf(out, "}\n\n");
    }

    /*
        A ideia é percorrer a árvore sintática 2 vezes
        sendo essa primeira para gerar as funções do
        código de python que devem ficar fora da main
    */
    gerar_funcoes(raiz, out, tabela);

    // E percorrer uma segunda vez gerando a main
    fprintf(out, "int main() {\n");
    gerar_codigo_c(raiz, out, tabela);
    fprintf(out, "return 0;\n}\n");

    fclose(out);
}

void gerar_statement(NoAST* node, FILE* out, TabelaSimbolos* tabela) {
    if (!node) return;

    // Evita imprimir chamadas ou declarações de funções no main
    if (node->tipo == TIPO_FUNCAO)
        return;

    switch (node->tipo) {
        case TIPO_SEQUENCIA:
            gerar_statement(node->esquerda, out, tabela);
            gerar_statement(node->direita, out, tabela);
            break;

        case TIPO_OP:
            gerar_codigo_c(node, out, tabela);
            fprintf(out, ";\n");
            break;

        case TIPO_OPCOMP:
            gerar_codigo_c(node, out, tabela);
            fprintf(out, ";\n");
            break;

        case TIPO_CHAMADA_DE_FUNCAO:
            fprintf(out, "\t");
            gerar_codigo_c(node, out, tabela);
            break;

        case TIPO_PRINT:
        case TIPO_PALAVRA_CHAVE:
            gerar_codigo_c(node, out, tabela);  // já inclui \n
            break;

        default:
            gerar_codigo_c(node, out, tabela);
            break;
    }
}


void gerar_funcoes(NoAST* node, FILE* out, TabelaSimbolos* tabela) {
    if (!node) return;

    if (node->tipo == TIPO_SEQUENCIA) {
        gerar_funcoes(node->esquerda, out, tabela);
        gerar_funcoes(node->direita, out, tabela);
    } else if (node->tipo == TIPO_FUNCAO) {
        gerar_codigo_funcao(node, out, tabela);
    }
}

void gerar_codigo_funcao(NoAST* node, FILE* out, TabelaSimbolos* tabela) 
{
    if (!node) return;
    
    switch (node->tipo) {
        case TIPO_SEQUENCIA:
            gerar_statement(node->esquerda, out, tabela);
            gerar_statement(node->direita, out, tabela);
            break;

        case TIPO_OP:
            if (node->operador == '=') {

                 // Atribuição, a variável vai estar na esquerda do nó
                if (node->esquerda && node->esquerda->tipo == TIPO_ID) {
                    Simbolo* s = buscar_simbolo(tabela, node->esquerda->nome);
                    if(s && (strcmp(s->tipo, "param") == 0)) {
                        s->foi_traduzido = 1;
                    }
                    else if (s && !s->foi_traduzido) {
                        fprintf(out, "%s ", s->tipo_simbolo);
                        s->foi_traduzido = 1;
                    }
                }

                gerar_codigo_funcao(node->esquerda, out, tabela);
                fprintf(out, " = ");
                gerar_codigo_funcao(node->direita, out, tabela); //E o valor vai estar na direita
            }
            else if (node->operador == '+') {
                int tipo_esq = determinar_tipo_no(node->esquerda, tabela);
                int tipo_dir = determinar_tipo_no(node->direita, tabela);

                // Se qualquer um dos lados for uma string, fazemos concatenação
                if (tipo_esq == TIPO_STRING || tipo_dir == TIPO_STRING) {
                    fprintf(out, "concatenar_strings("); // aqui a função de concatenar é criada
                    gerar_codigo_funcao(node->esquerda, out, tabela);
                    fprintf(out, ", ");
                    gerar_codigo_funcao(node->direita, out, tabela);
                    fprintf(out, ")");
                } else { 
                    int tipo_resultante = determinar_tipo_no(node, tabela);
                    fprintf(out, "(");
                    if (tipo_resultante == TIPO_FLOAT && tipo_esq == TIPO_INT) fprintf(out, "(float)");
                    gerar_codigo_c(node->esquerda, out, tabela); 
                    fprintf(out, " + ");
                    if (tipo_resultante == TIPO_FLOAT && tipo_dir == TIPO_INT) fprintf(out, "(float)");
                    gerar_codigo_c(node->direita, out, tabela);
                    fprintf(out, ")");
                }
            }
            else {
                int tipo_resultante = determinar_tipo_no(node, tabela);
                fprintf(out, "(");
                if (tipo_resultante == TIPO_FLOAT && determinar_tipo_no(node->esquerda, tabela) == TIPO_INT) fprintf(out, "(float)");
                gerar_codigo_c(node->esquerda, out, tabela);
                fprintf(out, " %c ", node->operador);
                if (tipo_resultante == TIPO_FLOAT && determinar_tipo_no(node->direita, tabela) == TIPO_INT) fprintf(out, "(float)");
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
            gerarPrint(node, out, tabela); 
            break;

        case TIPO_PALAVRA_CHAVE:
            if (strcmp(node->palavra_chave, "if") == 0) {
                fprintf(out, "if (");
                gerar_codigo_funcao(node->esquerda, out, tabela); // Condição
                fprintf(out, ") {\n");
                gerar_codigo_funcao(node->direita, out, tabela);  // Corpo
                fprintf(out, "}\n");
            }
            else if (strcmp(node->palavra_chave, "else") == 0) {
                fprintf(out, "else {\n");
                gerar_codigo_funcao(node->direita, out, tabela); // Corpo do else está sempre no nó direita
                fprintf(out, "}\n ");
            }
            else if (strcmp(node->palavra_chave, "elif") == 0) {
                fprintf(out, "else if (");
                gerar_codigo_c(node->esquerda, out, tabela); // Condição
                fprintf(out, ") {\n");
                gerar_codigo_c(node->direita, out, tabela);  // Corpo
                fprintf(out, "}\n");
            }
            else if (strcmp(node->palavra_chave, "return") == 0) {
                fprintf(out, "return ");
                if (node->esquerda) { // Só gera valor se existir
                    gerar_codigo_funcao(node->esquerda, out, tabela);
                    if(node->direita)
                        gerar_codigo_funcao(node->direita, out, tabela);
                }
                fprintf(out, ";\n"); // Adiciona ponto-e-vírgula
            }
            else if (strcmp(node->palavra_chave, "while") == 0) {
                fprintf(out, "while(");
                gerar_codigo_funcao(node->esquerda, out, tabela); // Condição
                fprintf(out, ") {\n");
                gerar_codigo_funcao(node->direita, out, tabela);  // Corpo
                fprintf(out, "}\n");
            }
            else if(strcmp(node->palavra_chave, "True") == 0){
                fprintf(out, "true");
            }
            else if(strcmp(node->palavra_chave, "False") == 0){
                fprintf(out, "false");
            }
            else if(strcmp(node->palavra_chave, "None") == 0){
                fprintf(out, "NULL");
            }
            else if(strcmp(node->palavra_chave, "pass") == 0){
                fprintf(out, ";");
            }
            break;

        case TIPO_FUNCAO: 
        {
            const char* tipo_retorno = inferir_tipo_retorno(node->direita, tabela);

            fprintf(out, "%s %s(", tipo_retorno, node->nome);      
            gerar_parametros_declaracao(node->esquerda, out, tabela);
            fprintf(out, ") {\n");
            gerar_codigo_funcao(node->direita, out, tabela); // Corpo da função
            fprintf(out, "}\n\n");
            break;
        }
            
        case TIPO_PARAM:
            fprintf(out, "%s", node->nome);
            if(node->direita)
                fprintf(out, ",");
            gerar_codigo_funcao(node->direita, out, tabela);
            break;
            
        default:
            fprintf(out, "// [Não implementado para tipo %d]\n", node->tipo);
            break;
    }
}

// Função auxiliar otimizada
int determinar_tipo_no(NoAST* node, TabelaSimbolos* tabela) {
    if (!node) return TIPO_INT;

    switch (node->tipo) {
        case TIPO_ID: {
            Simbolo* s = buscar_simbolo(tabela, node->nome);
            if (!s) return TIPO_INT;
            if (strcmp(s->tipo_simbolo, "float") == 0) return TIPO_FLOAT;
            if (strcmp(s->tipo_simbolo, "char*") == 0) return TIPO_STRING;
            return TIPO_INT;
        }
        case TIPO_INT: return TIPO_INT;
        case TIPO_FLOAT: return TIPO_FLOAT;
        case TIPO_STRING: return TIPO_STRING;
        case TIPO_OP: {
            int tipo_esq = determinar_tipo_no(node->esquerda, tabela);
            int tipo_dir = determinar_tipo_no(node->direita, tabela);

            if (node->operador == '+') {
                if (tipo_esq == TIPO_STRING || tipo_dir == TIPO_STRING) {
                    return TIPO_STRING;
                }
            }

            // Se o operador é '/', o resultado é FLOAT.
            if (node->operador == '/') {
                return TIPO_FLOAT;
            }

            // Para qualquer outra operação, se um dos lados for FLOAT, o resultado é FLOAT.
            if (tipo_esq == TIPO_FLOAT || tipo_dir == TIPO_FLOAT) {
                return TIPO_FLOAT;
            }

            // Se nenhuma das regras acima se aplica, o resultado da operação é INT.
            return TIPO_INT;
        }
        case TIPO_PALAVRA_CHAVE:{
            if((strcmp(node->palavra_chave, "True") == 0) || (strcmp(node->palavra_chave, "False") == 0) || (strcmp(node->palavra_chave, "None") == 0))
                return TIPO_BOOL;
        }
        case TIPO_CHAMADA_DE_FUNCAO:{
            Simbolo* s = buscar_simbolo(tabela, node->nome);

            if((s) && strcmp(s->tipo_simbolo, "bool") == 0)
                return TIPO_BOOL;
            else if((s) && strcmp(s->tipo_simbolo, "int") == 0)
                return TIPO_INT;
            else if((s) && strcmp(s->tipo_simbolo, "float") == 0)
                return TIPO_FLOAT;
            else if((s) && strcmp(s->tipo_simbolo, "char*") == 0)
                return TIPO_STRING;
        }

        default: return TIPO_INT;
    }
}

void gerarPrint(NoAST* node, FILE* out, TabelaSimbolos* tabela) {
    if (!node || node->tipo != TIPO_PRINT) return;
    
    NoAST* arg = node->esquerda; // Primeiro argumento (ARG_LIST)
    int arg_count = 0;
    
    // Primeira passada: gerar string de formato
    fprintf(out, "printf(\"");
    NoAST* current = arg;
    while (current) {
        if (arg_count > 0) fprintf(out, " ");
        
        int tipo = determinar_tipo_no(current->esquerda, tabela);
        switch (tipo) {
            case TIPO_INT:    fprintf(out, "%%d"); break;
            case TIPO_FLOAT:  fprintf(out, "%%f"); break;
            case TIPO_STRING: fprintf(out, "%%s"); break;
            case TIPO_BOOL:   fprintf(out, "%%d"); break;
            default:          fprintf(out, "<?>"); break;
        }
        
        arg_count++;
        current = current->direita;
    }
    fprintf(out, "\\n\"");
    
    // Segunda passada: gerar argumentos
    current = arg;
    while (current) {
        NoAST* arg_node = current->esquerda;
        fprintf(out, ", ");

        if(arg_node->tipo == TIPO_CHAMADA_DE_FUNCAO)
        {
            fprintf(out, "%s(", arg_node->nome);
            gerar_parametros(arg_node->esquerda, out, tabela);
            fprintf(out, ")");
        }
        else
        {
            gerar_codigo_c(arg_node, out, tabela);
        }
        current = current->direita;
    }
    
    fprintf(out, ");\n");
}

// Função auxiliar que busca recursivamente por um nó 'return'
bool corpoTemReturn(NoAST* node) {
    if (!node) {
        return false;
    }
    if (node->tipo == TIPO_PALAVRA_CHAVE && strcmp(node->palavra_chave, "return") == 0) {
        return true;
    }
    return corpoTemReturn(node->esquerda) || corpoTemReturn(node->direita);
}


void gerar_parametros_declaracao(NoAST* node, FILE* out, TabelaSimbolos* tabela) {
    if (!node) return;

    if (node->tipo == TIPO_PARAM) {
        Simbolo* s = buscar_simbolo(tabela, node->nome);
        const char* tipo = s && s->tipo_simbolo ? s->tipo_simbolo : "int"; 
        fprintf(out, "%s %s", tipo, node->nome);

        if (node->direita) {
            fprintf(out, ", ");
            gerar_parametros_declaracao(node->direita, out, tabela);
        }
    }
}

NoAST* encontrar_no_return(NoAST* node) {
    if (!node) {
        return NULL;
    }
    // Verifica se o nó atual é a instrução de retorno
    if (node->tipo == TIPO_PALAVRA_CHAVE && strcmp(node->palavra_chave, "return") == 0) {
        return node;
    }
    
    // Busca recursivamente na esquerda e direita
    NoAST* no_encontrado = encontrar_no_return(node->esquerda);
    if (no_encontrado) {
        return no_encontrado;
    }
    return encontrar_no_return(node->direita);
}


const char* inferir_tipo_retorno(NoAST* corpo_funcao, TabelaSimbolos* tabela) {
    NoAST* no_return = encontrar_no_return(corpo_funcao);

    // Caso 1: Não há instrução 'return' na função.
    if (!no_return) {
        return "void";
    }

    // Caso 2: Existe 'return', mas sem valor (ex: return;).
    else if (!no_return->esquerda) {
        return "void";
    }

    // Caso 3: Existe 'return' com um valor
    int tipo_ast = determinar_tipo_no(no_return->esquerda, tabela);

    switch (tipo_ast) {
        case TIPO_INT:
            return "int";
        case TIPO_FLOAT:
            return "float";
        case TIPO_STRING:
            return "char*";
        case TIPO_BOOL:
            return "bool";
        default:
            return "void"; 
    }
}

void verificar_necessidade_concatenar(NoAST* node) {
    if (!node || precisa_concatenar_helper) {
        return; 
    }

    if (node->tipo == TIPO_OP && node->operador == '+') {
        int tipo_esq = determinar_tipo_no(node->esquerda, NULL); 
        int tipo_dir = determinar_tipo_no(node->direita, NULL);
        if (tipo_esq == TIPO_STRING || tipo_dir == TIPO_STRING) {
            precisa_concatenar_helper = true;
            return;
        }
    }

    verificar_necessidade_concatenar(node->esquerda);
    verificar_necessidade_concatenar(node->direita);
}

void alterar_tipagem(char* nome_funcao, TabelaSimbolos* tabela, NoAST* no_da_funcao)
{
    Simbolo *s = buscar_simbolo(tabela, nome_funcao);

    if((s) && (strcmp(s->tipo, "funcao") == 0))
    {
        const char* tipagem_de_retorno = inferir_tipo_retorno(no_da_funcao->direita, tabela);
        
        //Atribuir
        strcpy(s->tipo_simbolo, tipagem_de_retorno);
    }

    return;
}