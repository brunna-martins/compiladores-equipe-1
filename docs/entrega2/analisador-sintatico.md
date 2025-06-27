# Analisador Sintático 

## Visão Geral

O analisador sintático é o componente central do compilador. Sua principal responsabilidade é verificar se a sequência de tokens fornecida pelo analisador léxico (`lexer.l`) obedece à estrutura gramatical da linguagem.

Além da validação sintática, o parser desempenha duas outras funções vitais:

1.  **Construção da Árvore Sintática Abstrata (AST):** À medida que as regras gramaticais são reconhecidas, o parser executa ações semânticas (código em C) para construir uma representação hierárquica do código-fonte, a AST.
2.  **Análise Semântica Preliminar:** O parser interage diretamente com a **Tabela de Símbolos** para gerenciar escopos, declarar variáveis e funções, e realizar a **inferência de tipos** em tempo de análise.

## Configuração e Declarações do Bison

A primeira parte do arquivo define a interface entre o parser, o lexer e os módulos de dados (AST e Tabela de Símbolos).

### `%union`

A diretiva `%union` define um conjunto de tipos de dados que podem ser associados a tokens e regras gramaticais. Isso permite que o lexer passe valores ricos (como uma `struct Numero`) e que as regras do parser construam e passem ponteiros para nós da AST (`NoAST*`).

```yacc
%union {
  char *str;
  Numero numero;
  int inteiro;
  float real;
  char* string;
  NoAST* no;
  NoAST* param_list;
}
```

### Declaração de Tokens e Tipos (`%token`, `%type`)

Aqui são declarados os símbolos terminais (tokens, vindos do lexer) e não-terminais (regras da gramática), associando-os aos tipos definidos na `%union`.

| Declaração | Exemplo | Propósito |
| :--- | :--- | :--- |
| `%token` | `%token INDENT DEDENT PLUS` | Define os tokens que não carregam valor. |
| `%token <tipo>` | `%token <numero> NUMBER` | Define tokens que carregam um valor, especificando qual campo da `%union` usar. |
| `%type <tipo>` | `%type <no> program stmt` | Define o tipo de valor que uma regra gramatical (não-terminal) irá retornar, geralmente um ponteiro para um nó da AST. |

### Precedência e Associatividade de Operadores

Para resolver ambiguidades em expressões matemáticas, são definidas a associatividade e a precedência dos operadores. Operadores na mesma linha têm a mesma precedência, e as linhas mais baixas têm maior precedência.

```yacc
%left PLUS MINUS   // Menor precedência, associatividade à esquerda
%left TIMES DIVIDE // Maior precedência, associatividade à esquerda
```

## Estrutura da Gramática

A gramática define a sintaxe válida da linguagem de forma hierárquica.

### Regra Inicial e Estrutura do Programa

A análise começa pela regra `program`, que é definida como uma lista de "statements" (`stmt_list`). A `stmt_list` é uma sequência recursiva de `stmt`, que são as instruções individuais da linguagem. Ao final, o resultado é atribuído à variável global `raiz`, que se torna a raiz da AST completa.

```yacc
program:
    stmt_list  { raiz = $1; $$ = $1; }
;

stmt_list:
    stmt
  | stmt_list stmt
;

stmt:
    def_stmt
  | print_stmt
  | while_statement
  | if_stmt
  | assignment_stmt
  // ... e outras instruções
;
```

### Construções de Controle de Fluxo

A gramática define regras para estruturas como `if-elif-else` e `while`, construindo os nós correspondentes na AST para representar a lógica de controle.

```yacc
if_stmt:
    IF expr COLON block {
        $$ = criarNoIf($2, $4);
    }
  | IF expr COLON block ELSE COLON block {
        NoAST *if_node = criarNoIf($2, $4);
        NoAST *else_node = criarNoElse($7);
        $$ = criarNoSeq(if_node, else_node);
    }
;

while_statement:
    WHILE expr COLON block {
        NoAST *no_while = criarNoPalavraChave("while");
        no_while->esquerda = $2; // Condição
        no_while->direita = $4;  // Corpo do laço
        $$ = no_while;
    }
;
```

### Expressões e Operadores

As regras `expr`, `term` e `factor` implementam a gramática de expressões, respeitando a precedência definida anteriormente para construir a árvore de operações corretamente.

```yacc
expr:
    expr PLUS term  { $$ = criarNoOp('+', $1, $3); }
  | term
;

term:
    term TIMES factor { $$ = criarNoOp('*', $1, $3); }
  | factor
;

factor:
    LPAREN expr RPAREN { $$ = $2; }
  | NUMBER { /* cria nó numérico */ }
  | ID     { $$ = criarNoId($1); }
;
```

## Análise Semântica e Integração

O parser é o ponto central de integração dos diferentes módulos do compilador.

### Gerenciamento de Escopo com INDENT/DEDENT

A estrutura de blocos da linguagem é gerenciada pela regra `block`, que espera uma sequência de `INDENT`, uma lista de statements e um `DEDENT`. As ações de empilhar e desempilhar escopos na Tabela de Símbolos são coordenadas com o reconhecimento desses blocos, principalmente nas regras que os utilizam, como `def_stmt`.

```yacc
// Um bloco é definido pela indentação
block:
    INDENT stmt_list DEDENT { $$ = $2; }
;

// Exemplo: def_stmt usa 'block' para o corpo da função
def_stmt:
    DEF ID LPAREN param_list RPAREN COLON block {
        // ... (ação de empilhar escopo antes de processar 'block')
        // ... (ação de desempilhar escopo após processar 'block')
    }
;
```

### Inferência de Tipo em Atribuições

Uma das funcionalidades mais avançadas do parser é a **inferência de tipo**. Quando uma nova variável é declarada através de uma atribuição, o parser analisa a expressão no lado direito para deduzir o tipo de dado da variável e registrá-la corretamente na Tabela de Símbolos.

```yacc
// parser.y - Regra de atribuição
assignment_stmt:
    ID ASSIGN expr {
        $$ = criarNoOp('=', criarNoId($1), $3);

        Simbolo* s = buscar_simbolo_escopo_atual(escopo_atual, $1);
        if (!s) { // Só executa se a variável for nova neste escopo
            int tipo_expr = deduzir_tipo_expr($3); // **INFERÊNCIA DE TIPO**
            char* tipo_deduzido = "int"; // Padrão

            if (tipo_expr == TIPO_FLOAT) tipo_deduzido = "float";
            else if (tipo_expr == TIPO_STRING) tipo_deduzido = "char*";
            else if (tipo_expr == TIPO_BOOL) tipo_deduzido = "bool";
            
            // Insere o símbolo com o tipo de dado correto
            inserir_simbolo(escopo_atual, $1, "variavel", tipo_deduzido);
        }
    }
;
```

## Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 27/06/2025 | 1.0 | Criação inicial da documentação do analisador sintático (`parser.y`) | [Brunna Louise](https://github.com/brunna-martins) | [Genilson Silva](https://github.com/GenilsonJrs) |
