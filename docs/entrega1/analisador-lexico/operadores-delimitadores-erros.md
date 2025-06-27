# Operadores, Delimitadores e Erros

##  Tokens

Neste compilador, foram considerados operadores aritméticos, relacionais, de atribuição e delimitadores de escopo. A escolha desses elementos foi baseada nas construções comuns da linguagem Python. A Tabela 1 abaixo detalha os tokens gerados para cada um desses elementos.

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
      <td>PLUSEQ</td>
      <td><code>&quot;+=&quot;</code></td>
      <td>--</td>
      <td>Token para o operador de atribuição de soma.</td>
    </tr>
     <tr>
      <td>MINUSEQ</td>
      <td><code>&quot;-=&quot;</code></td>
      <td>--</td>
      <td> Token para o operador de atribuição de subtração.</td>
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



Com certeza\! Analisei a seção "Operadores, Delimitadores e Erros" e comparei com seu `lexer.l` atual.

A boa notícia é que a maior parte da documentação está correta. As principais atualizações necessárias são:

1.  **Tabela de Tokens Incompleta:** Faltam os operadores de atribuição composta (`+=`, `-=`) que existem no seu código. Além disso, há um pequeno erro de digitação na expressão regular de um dos operadores.
2.  **Tratamento de Erros Desatualizado:** A sua documentação descreve um sistema de tratamento de erros que retorna um token `ERROR` e usa uma variável global `linha`. Seu código atual é mais simples: ele apenas imprime o "Caractere inválido" e continua, usando a variável `yylineno` (que é automática do Flex).
3.  **Inconsistência no Código de Exemplo:** O trecho de código na seção "Decisões Técnicas" está diferente do seu arquivo `lexer.l` real (usa `EQUAL` em vez de `ASSIGN`).

Preparei a seção inteira com as correções e atualizações. Assim como da última vez, o mais fácil e seguro é **substituir toda a seção**, desde o título `# Operadores, Delimitadores e Erros` até o final do histórico de versões dela.

-----

### **Documentação Atualizada**

# Operadores, Delimitadores e Erros

## Tokens

Neste compilador, foram considerados operadores aritméticos, relacionais, de atribuição e delimitadores de escopo. A escolha desses elementos foi baseada nas construções comuns da linguagem Python. A Tabela 1 abaixo detalha os tokens gerados para cada um desses elementos.

\<br\>

\<center\>

| Token | Expressão regular correspondente | Campo yyval | Descrição |
| :--- | :--- | :--- | :--- |
| `PLUS` | `"+"` | -- | Token para o operador de soma. |
| `MINUS` | `"-"` | -- | Token para o operador de subtração. |
| `TIMES` | `"*"` | -- | Token para o operador de multiplicação. |
| `DIVIDE` | `"/"` | -- | Token para o operador de divisão. |
| `MODULO` | `"%"` | -- | Token para o operador de módulo (resto da divisão). |
| `ASSIGN` | `"="` | -- | Token para o operador de atribuição simples. |
| `PLUSEQ` | `"+="` | -- | Token para o operador de atribuição de soma. |
| `MINUSEQ` | `"-="` | -- | Token para o operador de atribuição de subtração. |
| `EQTO` | `"=="` | -- | Token para o operador relacional de igualdade. |
| `NOTEQTO` | `"!="` | -- | Token para o operador relacional de diferença. |
| `LESSER` | `"<"` | -- | Token para o operador relacional "menor que". |
| `GREATER` | `">"` | -- | Token para o operador relacional "maior que". |
| `LESSEQ` | `"<="` | -- | Token para o operador relacional "menor ou igual a". |
| `GREATEQ` | `">="` | -- | Token para o operador relacional "maior ou igual a". |
| `LPAREN` | `"("` | -- | Delimitador: abre parênteses. |
| `RPAREN` | `")"` | -- | Delimitador: fecha parênteses. |
| `LBRACKET`| `"["` | -- | Delimitador: abre colchetes. |
| `RBRACKET`| `"]"` | -- | Delimitador: fecha colchetes. |
| `LBRACE` | `"{` | -- | Delimitador: abre chaves. |
| `RBRACE` | `"}"` | -- | Delimitador: fecha chaves. |
| `COLON` | `":"` | -- | Delimitador: dois pontos, usado em `if`, `def`, etc. |
| `COMMA` | `","` | -- | Delimitador: vírgula, usada para separar itens. |
| `DOT` | `"."` | -- | Delimitador: ponto, usado para acesso a atributos. |
| `SEMICOLON`| `";"` | -- | Delimitador: ponto e vírgula. |

\<p align="center"\>\<em\>Tabela 1: Tokens de operadores e delimitadores. (Fonte: \<a href="[https://github.com/brunna-martins](https://github.com/brunna-martins)"\>Brunna Louise\</a\>, 2025)\</em\>\</p\>

\</center\>

## Decisões Técnicas

### Ordem das Regras de Operadores

Durante a implementação, foi crucial ordenar as regras para que os operadores compostos (como `==`, `+=`, `<=`) aparecessem **antes** de seus componentes simples (`=`, `+`, `<`). Como o Flex adota a estratégia de "maior casamento" (longest match), essa ordenação garante que `+=` seja reconhecido como um único token `PLUSEQ`, em vez de um `PLUS` seguido por um `ASSIGN`.

```c
// Correto: operador composto primeiro
"=="      { return EQTO; }
"="       { return ASSIGN; }

// Incorreto: "=" seria reconhecido antes de "=="
// "="       { return ASSIGN; } 
// "=="      { return EQTO; }
```

### Tratamento de Erros Léxicos

Para o tratamento de erros, foi adotada uma abordagem simples e direta. Uma regra "pega-tudo" (`.`) foi posicionada ao final do arquivo de regras do lexer.

```c
// Regra no final de lexer.l
.         { printf("Caractere inválido: %s\n", yytext); }
```

Qualquer caractere no código-fonte que não case com nenhuma das regras de tokens definidas anteriormente (palavras-chave, identificadores, números, operadores, etc.) será capturado por esta regra.

A decisão foi **não parar a execução**. Em vez disso, o lexer simplesmente imprime uma mensagem de erro no console, informando qual foi o caractere inválido (`yytext`), e continua a análise do restante do arquivo. Para a numeração da linha, o lexer utiliza a variável `yylineno`, que é mantida e incrementada automaticamente pelo Flex, garantindo precisão na localização do erro sem a necessidade de uma variável global customizada.

## Desafios Encontrados

O principal desafio foi garantir que o tratamento de erros fosse informativo, mas não interrompesse a análise léxica prematuramente. A ideia é permitir que o compilador reporte o máximo de erros léxicos possível em uma única execução, em vez de parar no primeiro.

Outro ponto de atenção foi a correta definição da precedência dos operadores para evitar ambiguidades, como o caso de `=` vs. `==`.

## Soluções Adotadas

A solução para a precedência foi a ordenação cuidadosa das regras no arquivo `.l`, conforme mencionado.

Para o tratamento de erros, a solução foi a regra `.` no final do arquivo. Ela funciona como um "else" final no reconhecimento de tokens, provendo um feedback imediato sobre caracteres inesperados sem a complexidade de retornar tokens de erro específicos e exigir que o parser os trate, simplificando a lógica geral do compilador nesta fase.

# Histórico de Versões
|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 24/04/2025 | 1.0 | Adiciona tabela de tokens | [Brunna Louise](https://github.com/brunna-martins) | [Mariana Letícia](https://github.com/Marianannn)|
| 24/04/2025 | 1.1 | Decisões, Desafios e Soluções |[Genilson Junior](https://github.com/GenilsonJrs)| [Mariana Letícia](https://github.com/Marianannn)|
| 27/06/2025 | 1.2 | Atualização da documentação para refletir o estado atual do código do lexer |[Brunna Louise](https://github.com/brunna-martins)| - |


