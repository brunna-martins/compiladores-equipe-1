# Identificadores e Palavras-chave

## Tokens

Segue abaixo a Tabela 1 contendo os tokens referentes aos identificadores e palavras-chave utilizados no compilador, além de suas expressões regulares e descrições. A escolha desses elementos foi baseada nas palavras-chave própria da linguagem escolhida bem como na estrutura de identificadorres proposta pelo compiador:

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
      <td>ID</td>
      <td><code>[a-zA-Z_][a-zA-Z0-9_]*</code></td>
      <td>str</td>
      <td>Designado a identificação de identificadores</td>
    </tr>
    <tr>
      <td>IF</td>
      <td><code>"if"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave if</td>
    </tr>
    <tr>
      <td>ELSE</td>
      <td><code>"else"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave else</td>
    </tr>
    <tr>
      <td>ELIF</td>
      <td><code>"elif"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave elif</td>
    </tr>
    <tr>
      <td>WHILE</td>
      <td><code>"while"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave  while</td>
    </tr>
    <tr>
      <td>FOR</td>
      <td><code>"for"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave for</td>
    </tr>
    <tr>
      <td>DEF</td>
      <td><code>"def"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave def </td>
    </tr>
    <tr>
      <td>RETURN</td>
      <td><code>"return"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave return</td>
    </tr>
    <tr>
      <td>IN</td>
      <td><code>"in"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave in</td>
    </tr>
    <tr>
      <td>TRUE</td>
      <td><code>"true"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave true</td>
    </tr>
    <tr>
      <td>FALSE</td>
      <td><code>"false"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave false</td>
    </tr>
    <tr>
      <td>AND</td>
      <td><code>"and"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave and</td>
    </tr>
    <tr>
      <td>OR</td>
      <td><code>"or"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave or</td>
    </tr>
    <tr>
      <td>NOT</td>
      <td><code>"not"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave not</td>
    </tr>
    <tr>
      <td>CLASS</td>
      <td><code>"class"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave class</td>
    </tr>
    <tr>
      <td>IMPORT</td>
      <td><code>"import"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave import</td>
    </tr>
    <tr>
      <td>FROM</td>
      <td><code>"from"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave from</td>
    </tr>
    <tr>
      <td>AS</td>
      <td><code>"as"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave as</td>
    </tr>
    <tr>
      <td>TRY</td>
      <td><code>"try"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave try</td>
    </tr>
    <tr>
      <td>EXCEPT</td>
      <td><code>"except"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave except</td>
    </tr>
    <tr>
      <td>FINALLY</td>
      <td><code>"finally"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave finally</td>
    </tr>
    <tr>
      <td>WITH</td>
      <td><code>"with"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave with</td>
    </tr>
    <tr>
      <td>PASS</td>
      <td><code>"pass"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave pass</td>
    </tr>
    <tr>
      <td>BREAK</td>
      <td><code>"break"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave break</td>
    </tr>
     <tr>
      <td>CONTINUE</td>
      <td><code>"continue"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave continue</td>
    </tr>
     <tr>
      <td>GLOBAL</td>
      <td><code>"global"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave global</td>
    </tr>
     <tr>
      <td>NONLOCAL</td>
      <td><code>"nonlocal"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave nonlocal</td>
    </tr>
    <tr>
      <td>LAMBDA</td>
      <td><code>"lambda"</code></td>
      <td>--</td>
      <td>Token usado para identificar a palavra-chave lambda</td>
    </tr>
  </tbody>
</table>

<p><em>Tabela 1: Tokens e suas respectivas expressões regulares. (Fonte: <a href="https://github.com/laisramos123">Laís Ramos</a> e <a href="https://github.com/TaynaraCris">Taynara Cristina</a>, 2025)</em></p>

</center>

## Decisões técnicas

Foram listadas todas as palavras-chave desconhecidas, e realizada uma pesquisa online para compreender e identificar termos técnicos que não eram de conhecimento da equipe.

## Desafios Encontradas

- Escassez de materiais sobre a tecnologia Bison.
- Interface do Bison pouco intuitiva, dificultando o entendimento de seu funcionamento.
- Dificuldade em identificar qual seria o resultado esperado para as entradas fornecidas.

## Soluções Adotadas

- Realização de análise detalhada das palavras-chave, considerando também casos de borda para validar o comportamento esperado.
- Utilização das saídas do terminal para acompanhar e verificar se os resultados obtidos estavam alinhados às expectativas.

# Histórico de Versões

|  **Data**  | **Versão** |                                   **Descrição**                                    |             **Autor**              | **Revisor** |
| :--------: | :--------: | :--------------------------------------------------------------------------------: | :--------------------------------: | :---------: |
| 28/04/2025 |    1.0     | Criação do documento e inclusão de informações sobre decisões, desafios e soluções |         Laís Ramos Barbosa         |  170107574  |
| 28/04/2025 |    1.0     | Criação do documento e inclusão de informações sobre decisões, desafios e soluções | Taynara Cristina Ribeiro Marcellos |  211031833  |
