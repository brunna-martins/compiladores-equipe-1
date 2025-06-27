## Árvore de Derivação Sintática

Uma árvore de derivação sintática, também chamada de árvore sintática ou parse tree, é uma representação hierárquica que mostra como uma sequência de símbolos de uma linguagem pode ser gerada a partir de sua gramática formal. Cada nó da árvore corresponde a um símbolo da gramática: os nós internos representam variáveis ou não-terminais, enquanto as folhas representam os símbolos terminais, que formam a entrada analisada. A construção da árvore segue as regras de produção da gramática, partindo do símbolo inicial até gerar a cadeia completa. 

Objetivos:

- **Clareza Semântica:** destaca operações e estruturas lógicas.

- **Eficiência:** reduz o tamanho da estrutura em memória, facilitando percursos e transformações.

- **Base para Fases Posteriores:** serve de suporte para análise de tipos, controle de escopo, otimizações e geração de código.

A árvore de derivação sintática representa um código intermediário. Um código intermediário é uma forma de representação do programa que o compilador está analisando. Ele é criado junto da análise léxica e sintática antes de gerar o código final de fato. A árvore sintática é construída de forma a respeitar a estrutura hierárquica e lógica do código. Por exemplo o código:

```C
x = 1 + 2/3;
```

Ao ser analisado pelo compilador, sua construção na árvore sintática seria a seguinte:

```C
           (=)
          /   \
        (id)   (expr)
         |        |
         x       (+)
                /   \
             (num)   (/)
               |    /   \
               1 (num) (num)
                   |     |
                   2     3
```

```C
Assign (=)
├── Identifier: x
└── Op(+)
    ├── LiteralInt: 1
    └── Op(/)
        ├── LiteralInt: 2
        └── LiteralInt: 3
```

Essa representação deixa evidente não apenas a precedência dos operadores com a divisão sendo avaliada antes da soma, mas também como a AST reflete a estrutura lógica do programa. Ao posicionar cada operação em seu próprio nível hierárquico, fica claro:

- **Fluxo de avaliação:** nós mais profundos correspondem a operações que devem ocorrer primeiro.

- **Organização semântica:** dividindo expressões complexas em subárvores menores, facilita-se a análise e transformações posteriores.

- **Legibilidade para desenvolvedores:** ao imprimir ou visualizar a AST, a árvore hierárquica serve como um diagrama compreensível do comportamento do código.

## Criação da Árvore

Nesse projeto, a criação da árvore sintática começa com a definição da estrutura que será o nó da árvore. A estrutura abaixo foi utiliza, contendo todos os possiveis atributos necessários para alocar cada parte do código analisado.

```C
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
```

<p align="center"><em><a href="https://github.com/brunna-martins/compiladores-equipe-1/blob/arvore/ast.h">Veja mais aqui!</a></em></p>


Após isso, foram definidas funções de alocação dessa estrutra na memória conforme as regras de produção definidas no parser sentissem necessidade, ao analisar determinada cadeia de tokens, criar e preencher os campos corretos da estrutura do nó, conforme prenchiam a estrutura da árvore e faziam a análise sintática do código. Como exempo, a função abaixo cria um nó para um operador matemático com `=`, `+` ou `-`.

```C
NoAST *criarNoOp(char op, NoAST *esq, NoAST *dir) {
    NoAST *no = malloc(sizeof(NoAST));
    no->operador = op;
    no->esquerda = esq;
    no->direita = dir;
    no->meio = NULL;
    no->tipo = TIPO_OP;
    return no;
}
```
<p align="center"><em><a href="https://github.com/brunna-martins/compiladores-equipe-1/blob/arvore/ast.c">Veja mais aqui!</a></em></p>


## Análise Sintática e Montagem da AST

O  parser (analisador sintático), gerado pelo Bison a partir de `parser.y`, percorre a sequência de tokens emitida pelo lexer e, ao reconhecer cada regra da gramática, invoca a função de criação de nós correspondente para montar a AST. Esse processo é naturalmente recursivo, pois regras compostas se aninham umas nas outras.

- **Reconhecimento de padrões:** sempre que um conjunto de tokens corresponde a uma produção, o parser entra na ação associada.

- **Criação de nós:** dentro da ação, chama-se criarNoX(...) com os campos extraídos dos símbolos da produção.

- **Conexão de subárvores:** os valores retornados por produções menores são passados como parâmetros para construir nós de nível mais alto.

Definição de Função:

```C
def_stmt:
    DEF ID LPAREN RPAREN COLON block {
        // função sem parâmetros
        $$ = criarNoFunDef($2, NULL, $6);
    }
  | DEF ID LPAREN param_list RPAREN COLON block {
        // função com parâmetros
        $$ = criarNoFunDef($2, $4, $7);
    }
  ;
```

- `$2` é o nome da função (token ID).

- `$4` corresponde à lista de parâmetros (se presente).

- `$6` ou `$7` é o nó que representa o corpo (block).

<p align="center"><em><a href="https://github.com/brunna-martins/compiladores-equipe-1/blob/arvore/parser/parser.y">Veja mais aqui!</a></em></p>

Fluxo:

```C
def minhaFunc(a, b):
    print(a + b)
```

1. O lexer emite tokens: DEF, ID(minhaFunc), LPAREN, ID(a), COMMA, ID(b), RPAREN, COLON, ..., PRINT, LPAREN, ID(a), PLUS, ID(b), RPAREN.

2. O parser casa DEF ID LPAREN param_list RPAREN COLON block e executa criarNoFunDef("minhaFunc", param_list, blocoAST).

3. Para param_list, cada parâmetro gera um nó criarNoParam("a") e criarNoParam("b"), conectados em sequência.

4. A chamada print(a + b) gera um nó criarNoChamada("print", exprAST); onde exprAST é construído via criarNoOp('+', criarNoId("a"), criarNoId("b")).

5. O resultado final é uma subárvore onde o nó raiz é NoAST de tipo TIPO_FUNDEF, com filhos apontando para parâmetros e bloco.

Exibição:

```C
FunDef: minhaFunc
├── Params
│   ├── Param: a
│   └── Param: b
└── Block
    └── FunCall: print
        └── Op(+)
            ├── Identifier: a
            └── Identifier: b
```

## Aplicações e Práticas

- **Análise Semântica:** ao construir cada nó da AST, informações sobre declarações e usos de identificadores são registradas na tabela de símbolos (`tabela_simbolos.c`). Em seguida, percorre-se a árvore para validar a existência de variáveis e funções antes da geração de código.

- **Geração de Código:** o módulo de geração (`gerarcodigo.c`) faz uma travessia da AST e emite trechos equivalentes em C. Cada tipo de nó (atribuição, operação, chamada de função) tem sua rotina, garantindo que o código intermediário reflita fielmente a estrutura da árvore.

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 31/05/2025 | 1.0 | Criação da página e adição de conteúdo  | [Arthur Suares](https://github.com/arthur-suares) | [Mariana Letícia](https://github.com/Marianannn) |
| 27/06/2025 | 1.1 | Alterações de conteúdo  | [Genilson Silva](https://github.com/GenilsonJrs) |  |