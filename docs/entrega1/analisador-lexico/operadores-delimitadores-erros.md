# Operadores, Delimitadores e Erros

##  Tokens

Neste compilador, foram considerados operadores aritméticos básicos (`+`, `-`, `*`, `/`), operadores relacionais (`==`, `!=`, `<`, `<=`, `>`, `>=`) e delimitadores como `parênteses`, `colchetes` e `chaves`. A escolha desses elementos foi baseada na linguagem escolhida e suas possibilidades.

A Tabela 1 abaixo contém os tokens referentes a operadores aritméticos, operadores relacionais e delimitadores utilizados no compilador, além de suas expressões regulares e descrições.

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
      <td>PLUS</td>
      <td><code>&quot;+&quot;</code></td>
      <td>--</td>
      <td>Token usado durante operações de soma</td>
    </tr>
    <tr>
      <td>MINUS</td>
      <td><code>&quot;-&quot;</code></td>
      <td>--</td>
      <td>Token usado para operações de subtração</td>
    </tr>
    <tr>
      <td>TIMES</td>
      <td><code>&quot;*&quot;</code></td>
      <td>--</td>
      <td>Token usado para operações de multiplicação</td>
    </tr>
    <tr>
      <td>DIVIDE</td>
      <td><code>&quot;/&quot;</code></td>
      <td>--</td>
      <td>Token usado para operações de divisão</td>
    </tr>
    <tr>
      <td>MODULO</td>
      <td><code>&quot;%&quot;</code></td>
      <td>--</td>
      <td>Token usado para obter o quociente de uma divisão</td>
    </tr>
    <tr>
      <td>LPAREN</td>
      <td><code>&quot;(&quot;</code></td>
      <td>--</td>
      <td>Token usado para abrir parênteses</td>
    </tr>
    <tr>
      <td>RPAREN</td>
      <td><code>&quot;)&quot;</code></td>
      <td>--</td>
      <td>Token usado para fechar parênteses</td>
    </tr>
    <tr>
      <td>LBRACKET</td>
      <td><code>&quot;[&quot;</code></td>
      <td>--</td>
      <td>Token usado para abrir colchetes</td>
    </tr>
    <tr>
      <td>RBRACKET</td>
      <td><code>&quot;]&quot;</code></td>
      <td>--</td>
      <td>Token usado para fechar colchetes</td>
    </tr>
    <tr>
      <td>LBRACE</td>
      <td><code>&quot;{&quot;</code></td>
      <td>--</td>
      <td>Token usado para abrir chaves</td>
    </tr>
    <tr>
      <td>RBRACE</td>
      <td><code>&quot;}&quot;</code></td>
      <td>--</td>
      <td>Token usado para fechar chaves</td>
    </tr>
    <tr>
      <td>COMMA</td>
      <td><code>&quot;,&quot;</code></td>
      <td>--</td>
      <td>Token usado para separar argumentos chamados em uma função</td>
    </tr>
    <tr>
      <td>COLON</td>
      <td><code>&quot;:&quot;</code></td>
      <td>--</td>
      <td>Token usado para delimitar início de um procedimento, função, loops ou condicionais</td>
    </tr>
    <tr>
      <td>DOT</td>
      <td><code>&quot;.&quot;</code></td>
      <td>--</td>
      <td>Token usado para chamada de funções</td>
    </tr>
    <tr>
      <td>SEMICOLON</td>
      <td><code>&quot;;&quot;</code></td>
      <td>--</td>
      <td>Token usado para delimitar escopo</td>
    </tr>
    <tr>
      <td>ASSIGN</td>
      <td><code>&quot;=&quot;</code></td>
      <td>--</td>
      <td>Token usado para atribuição</td>
    </tr>
    <tr>
      <td>EQTO</td>
      <td><code>&quot;==&quot;</code></td>
      <td>--</td>
      <td>Token usado para comparar a igualdade entre dois valores</td>
    </tr>
    <tr>
      <td>NOTEQTO</td>
      <td><code>&quot;!=&quot;</code></td>
      <td>--</td>
      <td>Token usado para comparar a diferença entre dois valores</td>
    </tr>
    <tr>
      <td>LESSER</td>
      <td><code>&quot;<&quot;</code></td>
      <td>--</td>
      <td>Token usado para verificar se o argumento da esquerda é menor que o argumento da direita</td>
    </tr>
    <tr>
      <td>GREATER</td>
      <td><code>&quot;>&quot;</code></td>
      <td>--</td>
      <td>Token usado para verificar se o argumento da esquerda é maior que o argumento da direita</td>
    </tr>
    <tr>
      <td>LESSEQ</td>
      <td><code>&quot;<=<&quot;</code></td>
      <td>--</td>
      <td>Token usado para verificar se o argumento da esquerda é menor ou igual ao argumento da direita</td>
    </tr>
    <tr>
      <td>GREATEQ</td>
      <td><code>&quot;>=&quot;</code></td>
      <td>--</td>
      <td>Token usado para verificar se o argumento da esquerda é maior ou igual ao argumento da direita</td>
    </tr>
  </tbody>
</table>

<p><em>Tabela 1: Tokens e suas respectivas expressões regulares. (Fonte: <a href="https://github.com/brunna-martins">Brunna Louise</a>, 2025)</em></p>

</center>

## Decisões técnicas

Durante a implementação dos operadores, delimitadores e do tratamento de erros no analisador léxico, algumas decisões específicas foram tomadas para garantir tanto o funcionamento correto do compilador quanto uma experiência mais clara para quem estivesse depurando o código, como é possível ver presentes em todas as linguagens nos tratamentos de erros.

- Operadores e Delimitadores

A escolha por separar cada operador e delimitador em uma linha distinta no arquivo `lexer.l` foi feita com o objetivo de tornar o código mais organizado e direto, evitando ambiguidade entre símbolos parecidos (como `=` e `==`, ou `<` e `<=`). Essa abordagem também facilitou o mapeamento de cada símbolo para seu respectivo token, diretamente reconhecido pelo analisador sintático (`parser.y`).

Além disso, foram incluídos delimitadores como `parênteses`, `colchetes` e `chaves`, bem como operadores matemáticos (`+`, `-`, `*`, `/`, `%`) e operadores relacionais (`==`, `!=`, `<=`, `>=`, `<`, `>`), permitindo que expressões mais completas fossem avaliadas diretamente pelo parser, que retorna o valor da operação como uma forma simples de interpretar e testar a sintaxe do código.

```python    
"("             { return LPAREN; }
")"             { return RPAREN; }
"["             { return LBRACKET; }
"]"             { return RBRACKET; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
":"             { return COLON; }
","             { return COMMA; }
"."             { return DOT; }
";"             { return SEMICOLON; }

"=="            { return EQTO; }
"!="            { return NOTEQTO; }
"<="            { return LESSEQ; }
">="            { return GREATEQ; }
"<"             { return LESSER; }
">"             { return GREATER; }

"="             { return EQUAL; }  
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"%"             { return MODULO; }
```

- Tratamento de Erros

Para o tratamento de erros léxicos, optou-se por capturar qualquer caractere não reconhecido com o ponto `.` no final das regras do `lexer.l`. Quando isso ocorre, uma mensagem é impressa informando o caractere inválido e a linha em que ele se encontra, utilizando uma variável global.

Essa variável é incrementada a cada ocorrência de `\n` lida pelo analisador léxico, permitindo acompanhar corretamente a posição no código-fonte. Essa decisão foi essencial para fornecer feedback útil durante testes manuais diversos, especialmente para identificar erros simples como símbolos inválidos ou digitados incorretamente.

O token `ERROR` também foi retornado nesses casos, permitindo que o parser pudesse reconhecer e tratar essas situações sem interromper a execução.

```python
LEXER

\n              { linha++; return '\n'; }  
[ \t\r]+        { /* ignorar */ }
.               { printf("Caractere inválido: %s na linha %d\n", yytext, linha); return ERROR; }
```

```python
PARSER

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático na linha: %d: %s\n", linha, s);
}
```

- Testes Realizados

Os testes foram feitos com expressões variadas, combinando operadores aritméticos, relacionais e agrupamentos com delimitadores. Além disso, foram inseridos caracteres inválidos de propósito, como `@`, `!` e `&`, para garantir que o tratamento de erros funcionasse corretamente e as mensagens fossem exibidas com a linha correta.

```python   
(3 + 4) * [2 - 1]
{5 % 2} == (3)
3 + 5 > 2
(1 + 2) * (3 - 4) / 5

(3 + @)
3 + * 2
(4 + 5]
1 + 2; )
{ 1 + [ 2 * 3 }
```

Neste caso, temos as primeiras quatro linhas funcionais testando o analisador, e as posteriores sendo casos que retornarão erro, tipo do erro e a linha em questão.

## Desafios Encontrados

Durante a implementação dos operadores, delimitadores e tratamento de erros no analisador léxico, um dos principais desafios foi evitar ambiguidades entre operadores simples e compostos. Como o `Flex` segue uma lógica sequencial, foi necessário organizar regras no `lexer.l` para garantir que os operadores mais longos fossem reconhecidos corretamente antes dos mais curtos, evitando conflitos na análise léxica.

Houve também a preocupação em garantir que o tratamento de erros não interrompesse o fluxo da análise léxica, deixando que seja rodado por completo para permitir que todos os erros fossem capturados conforme fossem encontrados na execução, seja manual ou com um arquivo de teste.

## Soluções Adotadas

Para o tratamento de erros, foi implementada uma regra genérica que captura qualquer caractere que não casa com os padrões definidos previamente. Nessa regra, foi inserida uma mensagem descritiva com a indicação do caractere inválido e a linha onde o erro foi identificado. A contagem de linhas foi implementada por meio da detecção de quebras de linha (`\n`) no analisador léxico, e armazenada em uma `variável global linha`, que é incrementada a cada ocorrência de nova linha.

Já no `parser.y`, foram definidos tokens específicos para os operadores e delimitadores, assegurando que a análise sintática pudesse utilizá-los corretamente em diferentes expressões aritméticas e lógicas. Para validar o funcionamento da integração léxica e sintática, foram realizados testes manuais utilizando expressões variadas que envolviam diferentes combinações de operadores, parênteses e separadores.

# Histórico de Versões
|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 24/04/2025 | 1.0 | Adiciona tabela de tokens | [Brunna Louise](https://github.com/brunna-martins) | [Mariana Letícia](https://github.com/Marianannn)|
| 24/04/2025 | 1.1 | Decisões, Desafios e Soluções |[Genilson Junior](https://github.com/GenilsonJrs)| [Mariana Letícia](https://github.com/Marianannn)|

