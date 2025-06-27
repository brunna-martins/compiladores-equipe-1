# 1. Introdução e Definição do Projeto

Este trabalho consiste no desenvolvimento de um **compilador** capaz de traduzir um subconjunto de programas escritos em Python para código equivalente em C. Utilizamos **Flex** (analisador léxico) e **Bison** (analisador sintático) para montar as etapas de análise léxica, análise sintática, construção de AST e geração de código, consolidando conceitos fundamentais de compiladores em uma aplicação prática.

A escolha de Python como linguagem-fonte e C como linguagem-alvo se deve à familiaridade da equipe com ambas, além de permitir demonstrar, de forma clara e didática, como estruturas de alto nível (listas, controle de fluxo, chamadas de função) podem ser traduzidas para um código de baixo nível.

# 1.1 Definição de Escopo

O compilador a ser desenvolvido terá como escopo a conversão de programas Python com estruturas básicas para códigos equivalentes em C. Dentre os elementos que o compilador deve reconhecer e processar corretamente, estão:

- Declaração e uso de variáveis;
- Operadores aritméticos (adição, subtração, multiplicação, divisão, etc.);
- Operadores relacionais (>, <, ==, etc.);
- Atribuições;
- Delimitadores, como parênteses (, ) e ponto e vírgula ;;
- Espaços e quebras de linha, que serão devidamente ignorados ou tratados conforme o contexto;
- Estrutura geral de um programa: lógica de programação, declaração de funções e procedimentos.

Vale ressaltar que o compilador não tem a intenção de cobrir todos os recursos avançados da linguagem Python, como orientação a objetos, estruturas complexas (como listas, dicionários ou funções aninhadas), ou bibliotecas externas. O foco é a tradução de programas simples e lineares, o que permite uma análise e geração de código mais direta e didática.

# 1.2 Implementação do Escopo

O compilador suporta um **subconjunto básico** de Python, suficiente para escrever pequenos programas funcionais e lineares. Mais exatamente, reconhece e processa:

- **Declarações e atribuições de variáveis**  
  — Inteiros e ponto-flutuante (ex.: `x = 42`, `y = 3.14`).  
- **Operadores aritméticos**  
  — `+`, `-`, `*`, `/` com precedência correta.  
- **Operadores relacionais e lógicos**  
  — `>`, `<`, `>=`, `<=`, `==`, `!=`, além de `and`, `or`, `not`.  
- **Estruturas de controle de fluxo**  
  - **Condicionais**: `if ...: [elif ...:] [else ...:]`  
  - **Laços**: `while`  
- **Definição e chamada de funções**  
  — Sintaxe `def nome(param1, param2):` com corpo indentado; chamadas com argumentos posicionais.  
- **Delimitadores e indentação**  
  — Parênteses `(` `)`, dois-pontos `:`, ponto-vírgula opcional; indentação (INDENT/DEDENT) usada para delimitar blocos.  
- **Comentários e espaços em branco**  
  — Comentários em linha (`# ...`) são ignorados; quebras de linha e espaços são tratados conforme a sintaxe Python.

> **Não abrange** recursos avançados como orientação a objetos, compreensões de lista, dicionários, multithreading ou módulos externos.  

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 11/04/2025 | 1.0 | Versão inicial da introdução e definição de escopo do projeto. | [Brunna Louise](https://github.com/brunna-martins) | [Genilson Silva](https://github.com/GenilsonJrs) |
| 27/06/2025 | 1.1 | Documentação atualizada para refletir estado atual do código. | [Genilson Silva](https://github.com/GenilsonJrs)  | |
