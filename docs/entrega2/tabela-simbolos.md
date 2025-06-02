# Tabela de Símbolos
<p>A tabela de símbolos é uma estrutura essencial em compiladores, responsável por armazenar informações sobre identificadores (variáveis, funções, classes, etc.) durante a análise do código-fonte. Ela permite verificar declarações duplicadas, escopos válidos e tipos de dados, além de auxiliar na geração de código intermediário e final. Neste projeto, a tabela de símbolos é implementada como uma hash table com encadeamento e suporte a escopos aninhados, simulando o comportamento de linguagens como Python.</p>

## Estrutura da Tabela de Símbolos

<p>A tabela é composta por duas estruturas principais:</p>

```
// armazena dados de um identificador
typedef struct Simbolo {
    char* nome;
    char* tipo;
    struct Simbolo* proximo;
} Simbolo;
// implementa hash table com escopos
typedef struct TabelaSimbolos {
    Simbolo* tabela[TAM_TABELA];
    struct TabelaSimbolos* anterior;  
} TabelaSimbolos;
```

## Funcionalidades

### Operações Básicas

| Função | Descrição | 
| ------ | -------- |
| criar_tabela() | Inicializa um novo escopo (hash table vazia). |
| inserir_simbolo(tabela, nome, tipo) | 	Adiciona um símbolo (ex: inserir_simbolo(escopo_atual, "x", "var")). |
| buscar_simbolo(tabela, nome) | 	Busca um símbolo em todos os escopos aninhados. |
| remover_simbolo(tabela, nome) | 	Remove um símbolo do escopo atual. |

### Gerenciamento de escopo

| Função | Descrição | 
| ------ | -------- |
| empilhar_escopo(tabela) | Cria um novo escopo filho. |
| desempilhar_escopo(tabela) | 	Volta ao escopo pai. |

## Integração com parser
A tabela de símbolos interage diretamente com o analisador sintático (parser.y).
### Inicialização

No início da análise, o parser cria o escopo global e insere símbolos pré-definidos:

```
// Pilha de escopos
TabelaSimbolos* escopo_atual = NULL;

Simbolo* buscar_simbolo_escopo_atual(TabelaSimbolos* escopo, const char* nome) {
    unsigned int indice = hash(nome);
    Simbolo* s = escopo->tabela[indice];
    while (s != NULL) {
        if (strcmp(s->nome, nome) == 0) 
            return s;
        s = s->proximo;
    }
    return NULL;
}

(...)

%initial-action {
    escopo_atual = criar_tabela();  // Cria o escopo global inicial
    printf("Escopo global criado!\n");
    inserir_simbolo(escopo_atual, "print", "funcao");
    inserir_simbolo(escopo_atual, "range", "funcao");
}
```

### Gerenciamento de escopo

O parser manipula escopos através dos tokens INDENT/DEDENT (simulando blocos em Python):

```
line:
    declaracao_variavel NEWLINE     { }  // Declarações de variáveis
    | expressao NEWLINE             { printf("Resultado: %f\n", $1); }  // Expressões
    | NEWLINE                       { /* Empty line */ }
    | error NEWLINE                 { yyerrok; }
    | INDENT {
        escopo_atual = empilhar_escopo(escopo_atual);
        printf(">>> NOVO ESCOPO (endereço: %p)\n", escopo_atual);
    }
    | DEDENT {
        TabelaSimbolos* anterior = escopo_atual->anterior;
        if (anterior != NULL) {
            escopo_atual = desempilhar_escopo(escopo_atual);
            printf("<<< FIM ESCOPO (voltando para: %p)\n", escopo_atual);
        } else {
            printf("!!! Tentativa de dedent no escopo global\n");
        }
    }
    | if_statement NEWLINE     { }  // Adicione esta linha
    | for_statement NEWLINE    { }  // Adicione esta linha
;

```

### Declaração de variáveis

Quando uma variável é encontrada na linha analisada, verifica-se se a variável já foi declarada nesse escopo ou não.



```

declaracao_variavel:
    ID ASSIGN expressao {
        // Verificar se variável já existe no escopo atual
        if (buscar_simbolo_escopo_atual(escopo_atual, $1)) {
            yyerror("Variável já declarada neste escopo");
        } else {
            inserir_simbolo(escopo_atual, $1, "var");
            printf("Variável '%s' declarada no escopo %p\n", $1, escopo_atual);
        }
    }
;
```

### Chamada de função e verificação semântica

Quando uma variável é referenciada, verifica-se se ela já foi declarada e se a variável em questão é uma função sem argumentos.
Uma função também pode ter o formato "func()", e será feita a verificação se a função já foi declarada ou não. 

```
expressao:
    NUMBER { 
        $$ = get_valor($1); 
        printf("Número reconhecido: %f\n", $$);
    }
    | ID { 
        // Verifica se é variável ou função sem argumentos
        Simbolo* s = buscar_simbolo(escopo_atual, $1);
        if (!s) {
            yyerror("Símbolo não declarado");
            $$ = 0;
        } else if (strcmp(s->tipo, "funcao") == 0) {
            // Chamada de função sem argumentos
            printf("Chamando função '%s' sem argumentos\n", $1);
            $$ = 0;
        } else {
            $$ = 0;
            printf("Referência à variável '%s'\n", $1);
        }
    }
    | ID LPAREN argumentos RPAREN {  // Chamada de função com argumentos
        Simbolo* s = buscar_simbolo(escopo_atual, $1);
        if (!s) {
            yyerror("Função não declarada");
            $$ = 0;
        } else {
            printf("Chamando função '%s' com argumentos\n", $1);
            $$ = 0;
        }
    }
(...)
;

```

### Variáveis de iteração (for)

A variável de iteração é inserida no escopo do loop for.

```
/* Estrutura FOR */
for_statement:
    FOR ID IN expressao COLON {
        printf("Loop FOR com variável '%s'\n", $2);
        
        // Inserir variável de iteração no escopo atual
        if (buscar_simbolo_escopo_atual(escopo_atual, $2)) {
            yyerror("Variável de iteração já declarada");
        } else {
            inserir_simbolo(escopo_atual, $2, "var");
            printf("Variável de iteração '%s' declarada\n", $2);
        }
    }
;
```
