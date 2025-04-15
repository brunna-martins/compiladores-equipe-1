

# Tokens e comentários

##  Tokens

Segue abaixo a Tabela 1 contendo os tokens utilizados no compilador, além de suas expressões regulares e descrições. Essess tokens foram utilizados para representarem unidades léxicas, utilizados também como a menor elemento que é significativo para o compilador. Sendo assim, pensando em um conjunto de operações matemáticas, strings e operações da lógica da programação, optamos por selecionar os seguintes tokens:

<br>

<center>

| Token |Expressão regular correspondente  |Descrição|
| --- | :--: |:--- |
| INT_LITERAL | [0-9]+  | Designado a identificação de números inteiros.  |
| FLOAT_LITERAL|[0-9]+\.[0-9]+| Designado a identificação de números float. |
| STRING_LITERAL| \"([^\"\\]\|\\.)*\"    e     \'([^\'\\]\|\\.)*\' | Designado a identificação de strings. |
|PLUS|"+"| Token usado durante operações de soma|
|MINUS|"-"|Token usado para operações de subtração|
|TIMES|"*"|Token usado para operações de multiplicação|
|DIVIDE|"/"|Token usado para operações de divisão|
|LPAREN|"("|Token usado para abrir parênteses|
|RPAREN|")"|Token usado para fechar parênteses|

Tabela 1: Tokens e suas respectivas expressões regulares. (Fonte: [Mariana Letícia](https://github.com/Marianannn), 2025)

</center>

## Comentários

Os comentários são elementos fundamentais a nível de organização e documentação, provendo um bom auxílio também para estudos e afins. Sendo assim, foi incluído o reconhecimento de comentários no compilador. Porém, eles **são ignorados** através do lexer pois para o compilador em desenvolvimento, o conteúdo dentro do comentário não é relevante para alguma operação, servindo apenas como meio de documentação de código. Segue abaixo a Tabela 2 contendo os tipos de comentários e suas expressões regulares tratadas no compilador em questão:

<center>

|Tipo de comentário|Expressão regular correspondente| Descrição|
|---|:--:|:--|
|Aspas duplas triplas|\"\"\"([^"]\|\n)*?\"\"\"|Comentário de bloco|
|Aspas simples triplas |\'\'\'([^"]\|\n)*?\'\'\'|Comentário de bloco|
|Hashtag|"#".* |Comentário de linha|

Tabela 2: Comentários e suas respectivas expressões regulares. (Fonte: [Mariana Letícia](https://github.com/Marianannn), 2025)

</center>

---

# Histórico de Versões

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 13/04/2025 | 1.0 | Adicionando Tokens literais e de comentário | [Mariana Letícia](https://github.com/Marianannn) | - |