# Controle de Indentação (INDENT/DEDENT)

Para emular a estrutura de blocos de linguagens como Python, o analisador léxico implementa um mecanismo sofisticado para controlar os níveis de indentação do código-fonte. Em vez de usar delimitadores como {} para definir o escopo de funções, laços e condicionais, o compilador utiliza a variação no número de espaços ou tabulações no início de cada linha para gerar os tokens INDENT e DEDENT.

## Tokens de Indentação

A Tabela 1 descreve os tokens gerados pelo mecanismo de controle de indentação.

| Token	| Expressão regular correspondente  |	Descrição |
| ---- | --------------- |  ------------ |
| INDENT |	^[ \t]+ (contextual) |	Gerado quando a indentação de uma nova linha é maior que a da linha anterior, indicando o início de um novo bloco de escopo. |
| DEDENT |	^[ \t]+ (contextual) ou ~	|	Gerado quando a indentação de uma nova linha é menor que a da linha anterior, indicando o fim de um ou mais blocos de escopo. O token ~ também pode ser usado para disparar um DEDENT manualmente. |
| NEWLINE	| \r?\n	|	Gerado ao final de uma linha de código, sendo fundamental para a lógica de indentação e para a separação de statements no analisador sintático. |

<p><em>Tabela 1: Tokens de controle de indentação. (Fonte: <a href="https://github.com/brunna-martins">Brunna Louise</a>, 2025)</em></p>

# Histórico de Versões

|  **Data**  | **Versão** |                                   **Descrição**                                    |             **Autor**              | **Revisor** |
| :--------: | :--------: | :--------------------------------------------------------------------------------: | :--------------------------------: | :---------: |
| 27/06/2025 |    1.0     | Criação do documento de controle de identação no lexer |         [Brunna Louise](https://github.com/brunna-martins)       |  -  |

