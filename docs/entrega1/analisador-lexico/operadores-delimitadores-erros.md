# Operadores, Delimitadores e Erros

##  Tokens

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

## Desafios Encontrados

## Soluções Adotadas

# Histórico de Versões
|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 24/04/2025 | 1.0 | Adiciona tabela de tokens | Brunna Louise | - |
