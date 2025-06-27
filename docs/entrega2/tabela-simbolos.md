# Tabela de Símbolos

A tabela de símbolos é uma estrutura de dados central do compilador, projetada para gerenciar informações sobre todos os identificadores (variáveis, funções, parâmetros) encontrados no código-fonte. A sua principal função é dar suporte à **análise semântica**, permitindo a verificação de escopos, a detecção de redeclarações e a **inferência de tipos**.

Adicionalmente, ela é uma peça fundamental para a etapa de **geração de código**, fornecendo os tipos de dados necessários para a tradução do código-fonte para a linguagem C. A implementação utiliza uma *hash table* com tratamento de colisões por encadeamento e uma estrutura de pilha para gerenciar escopos aninhados, refletindo a natureza de linguagens como Python.

## Estrutura de Dados

A implementação é baseada em duas `structs` principais: `Simbolo`, que armazena os dados de um identificador individual, e `TabelaSimbolos`, que representa um escopo contendo múltiplos símbolos.

### `struct Simbolo`

Esta estrutura foi enriquecida para armazenar metadados detalhados sobre cada identificador, essenciais para as fases de análise e tradução.

```c
typedef struct Simbolo {
    char* nome;                 // Nome do identificador (ex: "minha_variavel").
    char* tipo;                 // Categoria do símbolo (ex: "variavel", "funcao", "param").
    char* tipo_simbolo;         // Tipo de dado do símbolo (ex: "int", "float", "char*", "bool").
    bool foi_traduzido;         // Flag para controlar a geração de código C.
    char* tipo_retorno_funcao;  // Armazena o tipo de retorno, aplicável apenas a funções.
    struct Simbolo* proximo;    // Ponteiro para o próximo símbolo em caso de colisão na hash.
} Simbolo;
```

### `struct TabelaSimbolos`

Representa um único escopo. A ligação com escopos pais é feita através do ponteiro `anterior`, formando uma pilha de escopos.

```c
typedef struct TabelaSimbolos {
    Simbolo* tabela[TAM_TABELA];      // A hash table (array de ponteiros para Símbolos).
    struct TabelaSimbolos* anterior;  // Ponteiro para o escopo pai (superior).
} TabelaSimbolos;
```

## Funcionalidades 


| Função | Descrição |
| :--- | :--- |
| `criar_tabela()` | Aloca e inicializa uma nova tabela de símbolos (um novo escopo). |
| `destruir_tabela(tabela)` | Libera toda a memória associada a uma tabela e seus símbolos. |
| `inserir_simbolo(tabela, nome, tipo, tipo_simbolo)` | Adiciona um novo símbolo ao escopo atual, incluindo sua categoria e tipo de dado. |
| `buscar_simbolo(tabela, nome)` | Busca um símbolo no escopo atual e, se não encontrar, continua a busca recursivamente nos escopos pais até o escopo global. |
| `buscar_simbolo_no_escopo_atual(tabela, nome)` | Busca um símbolo **apenas** no escopo fornecido, sem subir para os escopos pais. Essencial para detectar redeclarações. |
| `empilhar_escopo(tabela_atual)` | Cria um novo escopo (tabela) cujo escopo pai é `tabela_atual`. |
| `desempilhar_escopo(tabela_atual)` | Descarta o escopo atual e retorna o ponteiro para o escopo pai. |
| `imprimir_tabela(tabela)` | Exibe o conteúdo de todos os escopos de forma aninhada para fins de depuração. |

## Integração e Análise Semântica

A tabela de símbolos é gerenciada primariamente pelo analisador sintático (`parser.y`), que a utiliza para realizar a análise semântica.

### Gerenciamento de Escopo

O parser cria e destrói escopos para refletir os blocos de código da linguagem. Um novo escopo é empilhado ao entrar em um bloco (`INDENT`) e desempilhado ao sair (`DEDENT`). A gramática que gerencia isso é a regra `block`:

```yacc
// parser.y
block:
    INDENT stmt_list DEDENT {
        $$ = $2;
        escopo_atual = desempilhar_escopo(escopo_atual); // Desempilha ao final do bloco
    }
;

// A regra de definição de função, por exemplo, empilha o escopo antes de processar o bloco
def_stmt:
    DEF ID LPAREN param_list RPAREN COLON {
        escopo_atual = empilhar_escopo(escopo_atual); // Empilha para o corpo da função
    } 
    block
    ...
;
```

### Declaração de Variáveis com Inferência de Tipo

Esta é a funcionalidade semântica mais importante. Quando uma atribuição (`=`) é reconhecida, o parser realiza as seguintes ações:

1.  Verifica se a variável já existe no escopo atual usando `buscar_simbolo_no_escopo_atual`.
2.  Se a variável é nova, o parser chama a função `deduzir_tipo_expr` para analisar a expressão à direita do `=` e inferir seu tipo de dado (e.g., uma soma de inteiros resulta em `TIPO_INT`, uma divisão resulta em `TIPO_FLOAT`).
3.  Finalmente, insere a nova variável na tabela de símbolos com o tipo de dado inferido.

<!-- end list -->

```yacc
// parser.y - Regra de atribuição
assignment_stmt:
    ID ASSIGN expr {
        $$ = criarNoOp('=', criarNoId($1), $3);

        Simbolo* s = buscar_simbolo_escopo_atual(escopo_atual, $1);
        if (!s) { // Só insere se for a primeira vez neste escopo
            char* tipo_deduzido = "int"; // Padrão
            int tipo_expr = deduzir_tipo_expr($3);

            if (tipo_expr == TIPO_FLOAT) {
                tipo_deduzido = "float";
            } else if (tipo_expr == TIPO_STRING) {
                tipo_deduzido = "char*";
            } else if (tipo_expr == TIPO_BOOL) {
                tipo_deduzido = "bool";
            }
            // Insere com o tipo de dado correto!
            inserir_simbolo(escopo_atual, $1, "variavel", tipo_deduzido);
        }
    }
;
```

## Uso na Geração de Código

A tabela de símbolos é passada para o módulo de geração de código (`gerar_codigo.c`), onde é usada para traduzir o código para C. O campo `foi_traduzido` é fundamental aqui para lidar com a declaração de variáveis em C.

Em C, uma variável deve ser declarada (`int x;`) antes de seu primeiro uso. Para simular isso, o gerador de código, ao encontrar uma atribuição, consulta a tabela:

  - Se `s->foi_traduzido` for `false`, significa que esta é a primeira vez que a variável aparece. O gerador então imprime a declaração do tipo (ex: ` int  `) antes da atribuição e marca o flag como `true`.
  - Nas próximas vezes que a mesma variável for usada, o flag estará `true`, e o gerador de código não imprimirá a declaração de tipo novamente.

<!-- end list -->

```c
// gerar_codigo.c - Trecho da geração de atribuição
if (node->operador == '=') {
    if (node->esquerda && node->esquerda->tipo == TIPO_ID) {
        Simbolo* s = buscar_simbolo(tabela, node->esquerda->nome);
        // Se o símbolo existe e ainda não foi traduzido/declarado
        if (s && !s->foi_traduzido){
            fprintf(out, "%s ", s->tipo_simbolo); // Imprime "int", "float", etc.
            s->foi_traduzido = true;              // Marca como traduzido
        }
    }
    gerar_codigo_c(node->esquerda, out, tabela);
    fprintf(out, " = ");
    gerar_codigo_c(node->direita, out, tabela);
}
```

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 02/06/2025 | 1.0 | Adiciona versão inicial do documento de tabela de símbolos. | [Brunna Louise](https://github.com/brunna-martins) | [Mariana Letícia](https://github.com/Marianannn) |
| 27/06/2025 | 1.1 | Atualiza documentação para refletir estado atual do código. | [Brunna Louise](https://github.com/brunna-martins) | - |

