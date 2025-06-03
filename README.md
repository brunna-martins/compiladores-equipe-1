# 📘 Minitutorial: Usando `make` e `make clean` no Projeto de Compilador

## 🚀 Fluxo recomendado de uso

1. Para compilar:
   ```bash
   make
   ```

2. Para executar o compilador:
   ```bash
   ./compilador
   ```

3. Se quiser recompilar tudo do zero:
   ```bash
   make clean
   make
   ```

---

## 🛠️ O que é `make`?

`make` é uma ferramenta que **automatiza a compilação de projetos**. Em vez de compilar manualmente cada etapa do compilador (com Flex, Bison e GCC), o **Makefile** faz todo o passo a passo sozinho. Ele identifica quais arquivos precisam ser recompilados e executa somente os comandos necessários, de forma rápida e eficiente. 

---

## ✅ Comando `make`

Ao rodar o comando:

```bash
make
```

o `make` executa automaticamente todos os passos necessários para gerar o executável do seu compilador. Ou seja, ele executa:

1. Gera o analisador léxico (scanner) com o Flex:
   ```bash
   flex -o lex.yy.c lexer/lexer.l
   ```

2. Gera o analisador sintático (parser) com o Bison:
   ```bash
   bison -d parser/parser.y
   ```

3. Compila os arquivos C resultantes (e o main) com o GCC:
   ```bash
   gcc -Wall -g -o compilador lex.yy.c parser.tab.c src/main.c -lfl
   ```

Tudo isso de forma automática e com um único comando: `make`. 🎯

---

## 🧹 Comando `make clean`

Esse comando serve para **limpar** todos os arquivos gerados pela compilação. Útil quando você quer recompilar tudo do zero ou deixar o projeto mais limpo.

Ao rodar:

```bash
make clean
```

o `make` remove:

- `compilador` (executável final)
- `lex.yy.c` (arquivo gerado pelo Flex)
- `parser.tab.c` e `parser.tab.h` (arquivos gerados pelo Bison)
- Arquivos `.o`, se houver

---


