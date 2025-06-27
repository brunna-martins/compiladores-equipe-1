# Geração de Código

## Visão Geral e Arquitetura

O módulo gerarcodigo.c é a fase final e uma das mais complexas do compilador. Sua função é receber a Árvore Sintática Abstrata (AST) validada pelo parser e traduzi-la em um programa C completo, funcional e semanticamente equivalente, que é então salvo em output.c.

A arquitetura de geração de código foi projetada para ser robusta e otimizada, seguindo um fluxo de múltiplos passos:

### Análise Preliminar de Necessidades (verificar_necessidade_concatenar):

Antes de gerar qualquer código, é feita uma passagem rápida pela AST para verificar se o código fonte utiliza funcionalidades que exigem código auxiliar em C (concatenação de strings). Ela ativa um flag global (precisa_concatenar_helper) se encontrar tal necessidade. Esta etapa é uma otimização que garante que o código final gerado seja limpo e não contenha funções auxiliares desnecessárias.

### Organização da Geração do Código (gerar_programa_c):

Esta função atua orquestrando a montagem do arquivo output.c em uma ordem lógica e válida para o compilador C:

#### Inclusão de Cabeçalhos:

Inclui bibliotecas padrão como <stdio.h>, <stdbool.h>, <string.h> e, condicionalmente, <stdlib.h>.

#### Injeção de Código Auxiliar:

Com base no flag ativado na análise, esta etapa injeta o código C completo para funções auxiliares, como por exemplo concatenar_strings, garantindo que elas estejam definidas antes de serem usadas.

#### Geração de Funções Definidas:

A função gerar_funcoes é chamada para traduzir todas as funções definidas pelo usuário no código de entrada.

#### Geração da Função main:

O corpo do script principal é traduzido para se tornar o corpo da função main em C.

## Lógica de Geração e Mapeamento da AST

A tradução da AST é realizada por um conjunto de funções recursivas, principalmente gerar_codigo_c e gerar_codigo_funcao. Elas operam com base no tipo de cada nó da árvore.

### Mapeamento de Nós Simples:

#### TIPO_ID, TIPO_INT, TIPO_FLOAT, TIPO_STRING, TIPO_BOOL: 

São mapeados diretamente para seus equivalentes em C.

#### TIPO_SEQUENCIA:

Garante a ordem correta das instruções, gerando o código para o filho da esquerda e depois para o da direita.

### Mapeamento de Nós Complexos:

#### TIPO_OP (Operações):

Este é o nó mais inteligente do gerador. A lógica if/else if/else implementada permite um tratamento diferenciado e sensível ao contexto para cada operador:

- `= (Atribuição):` Gera uma instrução de atribuição em C. Uma lógica crucial aqui é a consulta à Tabela de Símbolos usando o flag foi_traduzido para implementar a estratégia declaração em primeiro uso. Isso garante que o tipo da variável (int, float, etc.) seja impresso apenas na primeira vez que ela é usada em um escopo, evitando erros de "redeclaração" em C.

- `+ (Adição/Concatenação):` Este operador demonstra a capacidade de sobrecarga do compilador. A função determinar_tipo_no é chamada para verificar os tipos dos operandos. Se algum for TIPO_STRING, o gerador produz uma chamada para a função auxiliar concatenar_strings. Caso contrário, ele gera uma soma numérica, inserindo casts (float) quando necessário para garantir a precisão aritmética.

 - `-, *, / (Outros Operadores):` Para esses operadores, a lógica gera a expressão aritmética correspondente, também utilizando determinar_tipo_no para inserir casts (float) e garantir que operações como a divisão de inteiros produzam um resultado de ponto flutuante, espelhando o comportamento do Python.

- `TIPO_PRINT:` É mapeado para uma chamada printf() em C. A função gerarPrint executa um processo de duas passadas: primeiro, constrói a string de formato (%d, %f, %s, etc.) inspecionando o tipo de cada argumento; depois, gera a lista de argumentos em si.

- `TIPO_FUNCAO:` A geração de uma função definida pelo usuário começa com a chamada a inferir_tipo_retorno, que analisa o corpo da função em busca de uma instrução return para determinar o tipo de retorno (void, int, float, char*, bool). Em seguida, gera a assinatura completa da função em C, incluindo os tipos dos parâmetros, e chama recursivamente gerar_codigo_funcao para preencher seu corpo.

## Decisões de Projeto Notáveis

### Sistema de Tipos Híbrido:

#### A inferência de tipos ocorre em dois momentos cruciais: 

No Parser (para decidir o tipo de armazenamento de uma nova variável na Tabela de Símbolos) e no Gerador de Código (para decidir como traduzir uma expressão em tempo de geração). Essa abordagem híbrida garante flexibilidade e correção.

#### Segurança na Concatenação:

Em vez de gerar chamadas strcat diretas e inseguras, o compilador adota a estratégia de injetar uma função auxiliar (concatenar_strings) que gerencia corretamente a alocação de memória (malloc), evitando segmentation faults e vazamentos de memória.

#### Otimização de Código Gerado:

A análise preliminar para a injeção condicional de código auxiliar é para melhorar a qualidade do código de saída, evitando incluir código morto e mantendo o arquivo output.c o mais limpo possível.



