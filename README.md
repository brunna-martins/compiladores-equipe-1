# Makefile

Bem-vindo ao guia do `Makefile` do nosso compilador! Esta não é apenas uma ferramenta para compilar o projeto, mas sim um **painel de controle completo** para compilar, limpar, testar e gerenciar o ciclo de vida do desenvolvimento.

## Comandos Principais (Resumo Rápido)

| Comando | Descrição |
| :--- | :--- |
| `make` | Compila o projeto e cria o executável principal (`./compilador`). |
| `make test` | **Roda a suíte de testes completa** (unitários e de integração). |
| `make test-file FILE=<caminho>` | Roda o compilador com um único arquivo de teste específico. |
| `make create-test NAME=<nome>` | Cria um novo arquivo de teste na pasta `testes/` a partir de um modelo. |
| `make clean` | Limpa todos os arquivos gerados pela compilação (executáveis, objetos, etc.). |
| `make help-tests` | Mostra uma ajuda rápida com todos os comandos de teste. |

-----

## Comandos de Compilação

### `make` ou `make all`

Este é o comando padrão. Ele automatiza todas as etapas necessárias para construir o executável principal do compilador.

```bash
make
```

Ao ser executado, ele:

1.  Verifica se o analisador léxico (`lexer.l`) e sintático (`parser.y`) precisam ser processados pelo Flex e Bison.
2.  Gera os arquivos `lex.yy.c`, `parser.tab.c` e `parser.tab.h`.
3.  Compila todos os módulos do projeto (`ast.c`, `tabela_simbolos.c`, `gerarcodigo.c`, `main.c`) e os linka.
4.  Gera o executável final chamado `compilador`.

Para executar o compilador (por exemplo, com um arquivo de entrada):

```bash
./comp < caminho/para/seu_arquivo.py
```

### `make clean`

Use este comando para limpar o projeto, removendo todos os arquivos gerados durante a compilação. É útil para forçar uma reconstrução completa.

```bash
make clean
```

Ele apaga:

  - O executável principal (`compilador`)
  - Os executáveis de teste (`test_tabela_simbolos`, `test_ast`)
  - Arquivos C gerados (`lex.yy.c`, `parser.tab.c`, `parser.tab.h`)
  - Arquivos objeto (`*.o`)

### `make distclean`

Uma limpeza ainda mais profunda que `make clean`. Além de tudo que o `clean` apaga, ele também remove arquivos de backup de editores (como `*~`), deixando o diretório como o original do repositório.

-----

## 🧪 O Painel de Controle de Testes

Esta é a parte mais poderosa do nosso `Makefile`. Ele fornece uma suíte de testes completa e automatizada.

### `make test`

Este comando executa a **suíte de testes completa** e fornece um relatório detalhado.

```bash
make test
```

O que ele faz, passo a passo:

1.  **Compila os Testes Unitários:** Cria executáveis para testar módulos isolados, como a Tabela de Símbolos e a AST.
2.  **Executa os Testes Unitários:** Roda esses testes primeiro para garantir que os componentes base estão funcionando.
3.  **Executa os Testes de Integração:**
      * Encontra todos os arquivos de teste `.py` na pasta `testes/`.
      * Para cada arquivo, ele executa o compilador (`./compilador`) com o teste como entrada.
      * Verifica se o compilador terminou sem erros (`PASSOU`) ou se falhou (`FALHOU`).
      * Em caso de falha, ele exibe a saída de erro detalhada do compilador.
4.  **Exibe um Resumo Final:** Ao final, ele mostra um relatório com o número total de testes, quantos passaram e quantos falharam.

### `make test-file`

Quando você está trabalhando em uma funcionalidade específica e quer testar apenas um arquivo, este comando é perfeito.

**Uso:**

```bash
make test-file FILE=caminho/para/o/arquivo.py
```

**Exemplo:**

```bash
make test-file FILE=testes/meu_teste_de_if.py
```

Ele irá compilar o projeto e rodar o compilador usando apenas o arquivo que você especificou, mostrando o resultado diretamente no terminal.

-----

## 📝 Gerenciando Arquivos de Teste

Para facilitar a criação e organização dos testes, existem alguns comandos úteis.

### `make create-test`

Cria um novo arquivo de teste na pasta `testes/` com uma estrutura básica (template) para você preencher.

**Uso:**

```bash
make create-test NAME=<nome_do_teste>
```

**Exemplo:**

```bash
make create-test NAME=teste_de_while
```

Isso criará o arquivo `testes/teste_de_while.py` com campos para objetivo e resultado esperado, pronto para você adicionar seu código de teste.

### `make count-tests`

Lista e conta rapidamente quantos arquivos de teste de integração existem na pasta `testes/`.

### `make help-tests`

Esqueceu como usar os comandos de teste? Sem problemas. Este comando exibe uma mensagem de ajuda rápida com a lista de comandos e exemplos de uso.

```bash
make help-tests
```
