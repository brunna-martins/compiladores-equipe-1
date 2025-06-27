# Literais e Comentários

##  Tokens

Segue abaixo a Tabela 1 contendo os tokens utilizados no compilador, além de suas expressões regulares e descrições. Essess tokens foram utilizados para representarem unidades léxicas, utilizados também como a menor elemento que é significativo para o compilador. Sendo assim, pensando em um conjunto de operações matemáticas, strings e operações da lógica da programação, optamos por selecionar os seguintes tokens:

<br>

<center>

<table>
  <thead>
    <tr>
      <th>Token</th>
      <th>Expressão regular correspondente</th>
      <th>Campo yyval</th>
      <th>Descrição</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>NUMBER</td>
      <td><code>[0-9]+ ou [0-9]+\.[0-9]+</code></td>
      <td>numero</td>
      <td>Token genérico para literais numéricos. O campo yylval.numero armazena uma struct Numero que contém o tipo (TIPO_INT ou TIPO_FLOAT) e o valor já convertido.</td>
    </tr>
    <tr>
      <td>STRING_LITERAL</td>
      <td><code>`"([^"\]</code></td>
      <td><code>\.)*"\<br\>'([^'\]</code></td>
      <td>Designado a identificação de strings.</td>
    </tr>

  </tbody>
</table>

<p><em>Tabela 1: Tokens e suas respectivas expressões regulares. (Fonte: <a href="https://github.com/Marianannn">Mariana Letícia</a> e <a href="https://github.com/brunna-martins">Brunna Louise</a>, 2025)</em></p>

</center>

## Comentários

Comentários são elementos fundamentais para organização e documentação, mas seu conteúdo não é relevante para a compilação. Portanto, eles são identificados e completamente ignorados pelo analisador léxico.

<center>

<table>
  <thead>
    <tr>
      <th>Tipo de comentário</th>
      <th>Expressão regular correspondente</th>
      <th>Descrição</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Comentário de Linha</td>
      <td><code>"#".*</code></td>
      <td>Ignora todo o texto desde o caractere # até o final da linha.</td>
    </tr>
  </tbody>
</table>

<p><em>Tabela 2:  Tipos de comentários ignorados. (Fonte: <a href="https://github.com/Marianannn">Mariana Letícia</a> e <a href="https://github.com/brunna-martins">Brunna Louise</a>, 2025)</em></p>
</center>

## Decisões técninas tomadas

### Tratamento de Literais Numéricos
Durante a implementação, foi decidido que o analisador léxico faria mais do que apenas identificar o texto de um número. Para otimizar o trabalho do analisador sintático, o lexer já converte o texto (yytext) para seu valor numérico (int ou float) e o armazena, junto com seu tipo, em uma ``struct Numero``. Essa estrutura é então passada para o parser através do campo ``yylval.numero``. Esta abordagem centraliza a lógica de conversão e simplifica as regras sintáticas.

Ambiguidade entre Strings Multilinha e Comentários
Uma característica da linguagem Python é que uma string literal que não é atribuída a uma variável pode funcionar como um comentário de bloco. O desafio era decidir como tratar isso.

A decisão tomada foi: o analisador léxico sempre tratará sequências entre aspas triplas como ``STRING_LITERAL``. Ele não tem contexto para saber se a string será usada ou não. O lexer se encarrega de normalizar a string (removendo as aspas triplas) e a envia para o analisador sintático.

Caberá ao analisador sintático, com base em suas regras gramaticais, decidir o que fazer com esse ``STRING_LITERAL``: se ele fará parte de uma atribuição, de um print, ou se deve ser ignorado (funcionando, na prática, como um comentário).

## Desafios Encontrados
Os principais desafios encontrados foram:

Entender as estruturas básicas de um compilador e como o analisador léxico e sintático se comunicam.

Lidar com a ambiguidade de strings multilinha, que podem ser tanto valores de dados quanto comentários de bloco, dependendo do contexto sintático.

Definir uma forma eficiente de passar dados ricos (como um número já convertido e tipado) do léxico para o sintático, em vez de apenas texto.

## Soluções Adotadas

Para a comunicação entre as ferramentas, foram estudados exemplos e utilizada a estrutura de tokens padrão, onde o `lexer.l` retorna identificadores de token que o `parser.y` espera.

A solução para a ambiguidade foi delegar a responsabilidade: o lexer identifica `STRING_LITERAL` de forma agnóstica, e o parser decide seu destino.

Para passar dados ricos, a solução foi utilizar a diretiva ``%union`` no ``parser.y``. Isso permitiu definir um tipo yylval capaz de armazenar diferentes tipos de valores, incluindo a ``struct Numero`` para literais numéricos e ponteiros de char* para strings, tornando a gramática mais limpa e poderosa.

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 13/04/2025 | 1.0 | Adicionando Tokens literais e de comentário | [Mariana Letícia](https://github.com/Marianannn) | [Arthur Suares](https://github.com/arthur-suares) |
| 17/04/2025 | 1.1 | Adicionando explicação das decisões técnicas |[Arthur Suares](https://github.com/arthur-suares) | [Mariana Letícia](https://github.com/Marianannn) |
| 20/04/2025 | 1.2 | Adicionando desafios e soluções encontrados |[Arthur Suares](https://github.com/arthur-suares) e [Mariana Letícia](https://github.com/Marianannn)| [Mariana Letícia](https://github.com/Marianannn) |
| 27/06/2025 | 1.3 | Atualizando documentação para refletir o atual estado do código |[Brunna Louise](https://github.com/brunna-martins) | - |