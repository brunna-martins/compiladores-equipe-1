

# Tokens e comentários

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



Tabela 2: Comentários e suas respectivas expressões regulares. (Fonte: [Mariana Letícia](https://github.com/Marianannn), 2025)

</center>

---

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 13/04/2025 | 1.0 | Adicionando Tokens literais e de comentário | [Mariana Letícia](https://github.com/Marianannn) | [Arthur Suares](https://github.com/arthur-suares) |