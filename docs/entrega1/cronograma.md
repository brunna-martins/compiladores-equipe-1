# 3. Cronograma de sprints

## Introdução

O objetivo do cronograma é organizar a equipe em relação as entregas durante o desenvolvimento do compilador. Sendo assim, através da metodologia Scrum, construímos um cronograma com esse objetivo.

## Planejamento da Equipe

Na tabela 1 abaixo, estão descritas a enumeração de sprint, suas durações, os pontos de controle(entregas), objetivos, resultados esperados e a pessoa responsável pelo acompanhamento semanal. Dessa forma, será possível visualizar de maneira mais clara as atividades que deveremos fazer na semana e como se organizar.


<table border="1">
  <thead>
    <tr style="background-color: #13C5D0;">
      <th><strong>Sprints</strong></th>
      <th><strong>Duração</strong></th>
      <th><strong>Pontos de controle</strong></th>
      <th><strong>Objetivos</strong></th>
      <th><strong>Resultado esperado</strong></th>
      <th><strong>Responsável pelo acompanhamento semanal</strong></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>24/03-28/03</td>
      <td></td>
      <td>Montar a equipe e configurar ambiente de desenvolvimento</td>
      <td>Equipe montada e ambiente de desenvolvimento da maioria dos integrantes funcionando</td>
      <td>Brunna</td>
    </tr>
    <tr>
      <td>2</td>
      <td>31/03-04/04</td>
      <td></td>
      <td>Definir o compilador e suas linguagens (Python → C)</td>
      <td>Ambiente funcionando para todos; linguagens definidas</td>
      <td>Brunna</td>
    </tr>
    <tr>
      <td>3</td>
      <td>07/04-11/04</td>
      <td></td>
      <td>Definir issues principais do analisador léxico e documentar o projeto</td>
      <td>Documentação inicial pronta (escopo, linguagem escolhida, justificativas)</td>
      <td>Arthur</td>
    </tr>
    <tr>
      <td>4</td>
      <td>14/04-18/04</td>
      <td></td>
      <td>Finalizar analisador léxico e documentações do P1</td>
      <td>Issues do léxico concluídas; início do sintático</td>
      <td>Genilson</td>
    </tr>
    <tr>
      <td>5</td>
      <td>21/04-25/04</td>
      <td></td>
      <td>Desenvolver analisador sintático (atribuições, funções, condicionais, indentação)</td>
      <td>Continuação do analisador sintático</td>
      <td>Laís</td>
    </tr>
    <tr style="background-color: #EA4335;">
      <td><strong>fim de semana</strong></td>
      <td><strong>25/04-28/04</strong></td>
      <td><strong>P1</strong></td>
      <td><strong>Ajustes finais e preparação para a apresentação do P1</strong></td>
      <td><strong>Compilador pronto para demonstração básica</strong></td>
      <td><strong>Mariana</strong></td>
    </tr>
    <tr>
      <td>6</td>
      <td>28/04-02/05</td>
      <td></td>
      <td>Avançar no analisador sintático (expressões, operadores, estruturas de repetição básicas)</td>
      <td>Sintático lidando com mais construções da linguagem</td>
      <td>Taynara</td>
    </tr>
    <tr>
      <td>7</td>
      <td>05/05-09/05</td>
      <td></td>
      <td>Iniciar análise semântica básica (verificação de tipos e escopo)</td>
      <td>Validação de tipos e variáveis implementada</td>
      <td>Arthur</td>
    </tr>
    <tr>
      <td>8</td>
      <td>12/05-16/05</td>
      <td></td>
      <td>Continuar análise semântica e tratar erros (variáveis não declaradas, tipos incompatíveis)</td>
      <td>Erros semânticos básicos detectados</td>
      <td>Brunna</td>
    </tr>
    <tr>
      <td>9</td>
      <td>19/05-23/05</td>
      <td></td>
      <td>Início da geração de código C (tradução básica de estruturas)</td>
      <td>Primeiros códigos C sendo gerados a partir da árvore sintática</td>
      <td>Genilson</td>
    </tr>
    <tr>
      <td>10</td>
      <td>26/05-30/05</td>
      <td></td>
      <td>Avançar na geração de código C (tratando mais casos e ajustes)</td>
      <td>Saída em C funcionando para programas pequenos</td>
      <td>Laís</td>
    </tr>
    <tr style="background-color: #EA4335;">
      <td><strong>fim de semana</strong></td>
      <td><strong>30/05-02/06</strong></td>
      <td><strong>P2</strong></td>
      <td><strong>Preparação e entrega do P2 (avanço da análise semântica e primeira geração de código)</strong></td>
      <td><strong>x</strong></td>
      <td><strong>Mariana</strong></td>
    </tr>
    <tr>
      <td>11</td>
      <td>02/06-06/06</td>
      <td></td>
      <td>Correções pós-P2 e otimizações no compilador</td>
      <td>Compilador corrigido e mais robusto</td>
      <td>Taynara</td>
    </tr>
    <tr>
      <td>12</td>
      <td>09/06-13/06</td>
      <td></td>
      <td>Testes finais e adição de exemplos mais complexos</td>
      <td>Compilador testado com diversos programas</td>
      <td>Arthur</td>
    </tr>
    <tr>
      <td>13</td>
      <td>16/06-20/06</td>
      <td></td>
      <td>Finalização do projeto e ajustes finos</td>
      <td>Versão final do compilador pronta</td>
      <td>Brunna</td>
    </tr>
    <tr>
      <td>14</td>
      <td>23/06-27/06</td>
      <td></td>
      <td>Preparação dos materiais de entrega final (documentação + código)</td>
      <td>Projeto preparado para submissão</td>
      <td>Genilson</td>
    </tr>
    <tr style="background-color: #EA4335;">
      <td><strong>dia</strong></td>
      <td><strong>27/06</strong></td>
      <td><strong>Entrega final</strong></td>
      <td><strong>Submissão oficial do projeto</strong></td>
      <td><strong>Entrega realizada</strong></td>
      <td><strong>Laís</strong></td>
    </tr>
    <tr>
      <td>15</td>
      <td>30/06-04/07</td>
      <td></td>
      <td>Feedback pós-entrega e encerramento</td>
      <td>Projeto concluído</td>
      <td>Mariana</td>
    </tr>
  </tbody>
</table>

<p><em>Tabela 1: Cronograma de planejamento da equipe. (Fonte: <a href="https://github.com/arthur-suares">Arthur Suares</a><a href="https://github.com/Marianannn">Mariana Letícia</a>, 2025)</em></p>

<br>

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 10/04/2025 | 1.0 | Repassando dados  | [Arthur Suares](https://github.com/arthur-suares) | [Mariana Letícia](https://github.com/Marianannn) |
| 10/04/2025 | 1.0 | Adicionando introdução e planejamento de equipe  | [Mariana Letícia](https://github.com/Marianannn) | [Arthur Suares](https://github.com/arthur-suares) |