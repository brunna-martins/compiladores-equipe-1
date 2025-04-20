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
      <td>INT_LITERAL</td>
      <td><code>[0-9]+</code></td>
      <td>ival</td>
      <td>Designado a identificação de números inteiros.</td>
    </tr>
    <tr>
      <td>FLOAT_LITERAL</td>
      <td><code>[0-9]+\.[0-9]+</code></td>
      <td>fval</td>
      <td>Designado a identificação de números float.</td>
    </tr>
    <tr>
      <td>STRING_LITERAL</td>
      <td><code>&quot;([^&quot;\\]|\\.)*&quot;</code> e <code>&#39;([^&#39;\\]|\\.)*&#39;</code></td>
      <td>str</td>
      <td>Designado a identificação de strings.</td>
    </tr>
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
  </tbody>
</table>

<p><em>Tabela 1: Tokens e suas respectivas expressões regulares. (Fonte: <a href="https://github.com/Marianannn">Mariana Letícia</a>, 2025)</em></p>

</center>

## Comentários

Os comentários são elementos fundamentais a nível de organização e documentação, provendo um bom auxílio também para estudos e afins. Sendo assim, foi incluído o reconhecimento de comentários no compilador. Porém, eles **são ignorados** através do lexer pois para o compilador em desenvolvimento, o conteúdo dentro do comentário não é relevante para alguma operação, servindo apenas como meio de documentação de código. Segue abaixo a Tabela 2 contendo os tipos de comentários e suas expressões regulares tratadas no compilador em questão:

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
      <td>Aspas duplas triplas</td>
      <td><code>&quot;&quot;&quot;([^&quot;]|\n)*?&quot;&quot;&quot;</code></td>
      <td>Comentário de bloco</td>
    </tr>
    <tr>
      <td>Aspas simples triplas</td>
      <td><code>&#39;&#39;&#39;([^&#39;]|\n)*?&#39;&#39;&#39;</code></td>
      <td>Comentário de bloco</td>
    </tr>
    <tr>
      <td>Hashtag</td>
      <td><code>&quot;#&quot;.*</code></td>
      <td>Comentário de linha</td>
    </tr>
  </tbody>
</table>

<p><em>Tabela 2: Comentários e suas respectivas expressões regulares. (Fonte: <a href="https://github.com/Marianannn">Mariana Letícia</a>, 2025)</em></p>
</center>

## Decisões técninas tomadas

Durante a escrita da regex que identifica números inteiros e reias, foi escolhido identificar apenas os números, sem que a regex agrupasse o sinal que os números pudessem vir a ter. Deixando assim que uma regex separada se encarregasse de identifcar o sinal do número, seja ele um sinal positivo `+`, ou um sinal negativo `-`.

Além disso, devido a como o python permite que strings estejam flutuando dentro do código fonte e possam servir de comentário consequentemente, foi então formada as regex `"""([^"]|\n)*?"""` e `'''([^']|\n)*?'''` que identificam uma string delimitada por 3 aspas duplas e simples, respectivamente. E nesse sentido, houve uma preocupação para que casos em que uma string dessa forma pudesse aparecer durante o funcionamento do compilador desenvolvido. Isso devido ao caso abaixo:

```python    
"""teste"""
'''teste'''
string = """teste"""
x = 4 
y = 5
z = x + y

print("Resultado:", z)
```

Onde o primeiro e segundo `"""teste"""` são ignorados, mas o terceiro é atribuído a variável `string`. Então, esses regex retornam um `STRING_LITERAL` para que possa ser analisado posteriormente no analisador sintático se essa string deva ou não ser ignorada. Diferentemente do comentário de linha `#`, que realmente não precisa retornar nada no regex.


## Desafios Encontrados
Os principais desafios encontrados durante a execução dessa primeira etapa foi primeiramente entender as estruturas básicas de um compilador e de que maneira se poderia organizar o grupo para dividir o desenvolvimento dele. Durante esse período, tivemos apoio não somente das aulas como do professor para auxiliar em decisões técnicas principalmente. Portanto, conforme se foi aprendendo mais sobre a teoria e implementação do compilador juntamente com as aulas teóricas e práticas, conseguimos iniciar o desenvolvimento do léxico e sintático com sucesso.

No entanto, parte pela qual foi sentida uma maior dificuldade foi em relação sobre como identificar comentários e lidar com comentários de linha, e sobre como passar tokens do léxico para o sintático.

## Soluções Adotadas

As soluções adotadas incluíram a construção de regex que conseguissem englobar os caracteres especias como o `\n` ou `//` dentro do corpo da própria string. Além disso, construir estruturas no arquivo `parser.y` que se integrasse com o `lexer.l` como `%union` para que fosse possível mandar através de funções como o `yylval` , tokens já identificados como inteiros, reais, strings, etc. Adicionalmente, foi utilizado testes manuais e testes com um arquivo de código fonte em python que pudessem estimar o funcionamento do que foi desenvolvido do `lexer.l` e do `parser.y`.

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 13/04/2025 | 1.0 | Adicionando Tokens literais e de comentário | [Mariana Letícia](https://github.com/Marianannn) | [Arthur Suares](https://github.com/arthur-suares) |
| 17/04/2025 | 1.1 | Adicionando explicação das decisões técnicas |[Arthur Suares](https://github.com/arthur-suares) | [Mariana Letícia](https://github.com/Marianannn) |
| 20/04/2025 | 1.2 | Adicionando desafios e soluções encontrados |[Arthur Suares](https://github.com/arthur-suares) e [Mariana Letícia](https://github.com/Marianannn)| [Mariana Letícia](https://github.com/Marianannn) |