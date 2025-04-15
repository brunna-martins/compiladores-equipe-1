# Analisador Léxico Desenvolvido 


## Tokens

| Token |Expressão regular correspondente | Descrição|
| --- | :--: | :--- |
| INT_LITERAL | [0-9]+  | Designado a identificação de números inteiros.  |
| FLOAT_LITERAL|[0-9]+\.[0-9]+| Designado a identificação de números float. |
| STRING_LITERAL|\"([^\"\\]|\\.)*\" E \'([^\'\\]|\\.)*\' | Designado a identificação de strings. |
|PLUS|"+"| Token usado durante operações de soma|
|MINUS|"-"|Token usado para operações de subtração|
|TIMES|"*"|Token usado para operações de multiplicação|
|DIVIDE|"/"|Token usado para operações de divisão|
|LPAREN|"("|Token usado para abrir parênteses|
|RPAREN|")"|Token usado para fechar parênteses|

## Comentários

Os comentários são ignorados através do lexer pois para o compilador em desenvolvimento, o conteúdo dentro do comentário não é relevante para alguma operação, servindo apenas como meio de documentação de código.

|Tipo de comentário|Expressão regular correspondente| Descrição|
|---|:--:|:--|
|Aspas duplas triplas|\"\"\"([^"]\|\n)*?\"\"\"|Comentário de bloco|
|Aspas simples triplas |\'\'\'([^"]\|\n)*?\'\'\'|Comentário de bloco|
|Hashtag|"#".* |Comentário de linha|

---

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 13/04/2025 | 1.0 | Adicionando Tokens literais e de comentário | [Mariana Letícia](https://github.com/Marianannn) | - |