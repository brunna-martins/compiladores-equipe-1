## Árvore de Derivação Sintática

Uma árvore de derivação sintática, também chamada de árvore sintática ou parse tree, é uma representação hierárquica que mostra como uma sequência de símbolos de uma linguagem pode ser gerada a partir de sua gramática formal. Cada nó da árvore corresponde a um símbolo da gramática: os nós internos representam variáveis ou não-terminais, enquanto as folhas representam os símbolos terminais, que formam a entrada analisada. A construção da árvore segue as regras de produção da gramática, partindo do símbolo inicial até gerar a cadeia completa. 

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

Com essa visualização fica mais fácil de entender que a árvore é contruída de forma a representar a lógica e a hierárquia do código. No exemplo, divisão viria primeiro antes das outras operações, por isso essa operação fica mais profunda na árvore.

## Criação da árvore

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

Mais das funções usadas podem ser observadas no link abaixo do código.

## Análise sintática e montagem da árvore sintática

O parser, conforme faz a analise sintática do código com base nas regras de produção definidas nele, também monta a árvore sintática. Ou seja, enquanto o analisador sintático verifica se a sequência de tokens gerada pelo analisador léxico está de acordo com a gramática da linguagem, ele constroi a árvore ao seguir uma sequência de instruções ao perceber que a sequência de tokens analisada casa com uma regra da gramática, previamente definida.

O parser ou analisador sintático funciona de forma recursiva enquanto identifica padrões de linguagem nas cadeias de tokens que analisa. Por isso, o parser precisa apenas de funções de reconhecimento, para verificar se os tokens seguem a regra, e funções de criação de nós, já que sempre que uma regra da gramática é reconhecida, cria-se um nó representando essa regra e conecta-se os subnós que correspondem aos seus componentes.

Como um exemplo abaixo temos uma regra de produção para a definição de uma função:

```C
def_stmt:
    DEF ID LPAREN RPAREN COLON block
      {
        $$ = criarNoFunDef($2, NULL, $6);
      }
  | DEF ID LPAREN param_list RPAREN COLON block
      {
        $$ = criarNoFunDef($2, $4, $7);
      }
  ;
```
Onde:
```
DEF → palavra-chave def.

ID → nome da função.

LPAREN RPAREN → parênteses.

COLON → símbolo :, que marca o início do bloco.

block → corpo da função.

param_list → lista de parâmetros (quando existe).
```

Esses simbolos vem do analisador léxico, e ao ser identificada um estrutura de código como a abaixo, é criada uma árvore com as instruções que estão entre chaves.

```Python
def minhaFuncao():
    print("Olá!")
```

Estrutura criada pelo nosso compilador:

```bash
---- AST gerada -------------------

└── Função: minhaFuncao
    ├── Parâmetro: a
    │   └── Parâmetro: b
    └── Chamada-função: print
        └── String: "Olá!"

-------------------------------------
```