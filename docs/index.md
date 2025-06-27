## 1. Disciplina de Compiladores 
Bem‑vindo à página inicial da documentação do Compiladores – Grupo 01! Aqui você encontra uma visão geral do projeto, a equipe envolvida e o status de versões.
Este é um trabalho desenvolvido por alunos do curso de Engenharia de Software da Universidade de Brasília, sob orientação do Prof. Sérgio Freitas. O objetivo da disciplina é aplicar conceitos de compiladores em um projeto prático.

## 2. Projeto   
O compilador implementado traduz um subconjunto de programas escritos em Python para código em C, utilizando as ferramentas:

- Flex: análise léxica

- Bison: análise sintática e montagem de AST

- Etapa de Análise Semântica: checagem de tipos e escopos básicos

- Geração de Código Intermediário: estruturação de AST para C

- Geração de Código Final: emissão de código C compilável

> Nota: Para instruções de instalação e uso, consulte o README ou a seção "Como Executar" na documentação.

## 3. Estrutura

A estrutura de pastas e arquivos do repositório segue o fluxo clássico de um compilador, organizado em módulos bem definidos:

```C
├── lexer/             # Regras Flex para análise léxica
├── parser/            # Gramática Bison e ações para AST
├── src/               # Código C principal (main, AST, tabela de símbolos)
├── gerarcodigo.c      # Emissão de código C a partir da AST
├── testes/            # Scripts Python de exemplo e casos de teste
├── docs/              # Documentação MkDocs
├── Makefile           # Comandos de build e geração
└── README.md          # Tutorial de instalação e uso
```

Essa organização modular torna o projeto mais legível, facilita a manutenção e deixa claro como cada etapa do compilador está separada em seu próprio componente.

## 4. Equipe
A equipe de desenvolvedores é composta por 6 membros do curso de Engenharia de Software da Universidade de Brasília.

<div align="center">
  <table >
    <tr>
      <td align="center"><a href="https://github.com/arthur-suares"><img style="border-radius: 50%;" src="https://github.com/arthur-suares.png" width="190vw;" alt=""/><br /><strong><b>Arthur Suares</b></strong></a><br /><a href="https://github.com/brunna-martins"></a></td>
      <td align="center"><a href="https://github.com/brunna-martins"><img style="border-radius: 50%;" src="https://github.com/brunna-martins.png" width="190vw;" alt=""/><br /><strong><b>Brunna Louise</b></strong></a><br /><a href="https://github.com/brunna-martins"></a></td>
      <td align="center"><a href="https://github.com/GenilsonJrs"><img style="border-radius: 50%;" src="https://github.com/GenilsonJrs.png" width="190vw;" alt=""/><br /><strong><b>Genilson Junior</b></strong></a><br /><a href="https://github.com/GenilsonJrs"></a></td>
    </tr>
    <tr>
      <td align="center"><a href="https://github.com/laisramos123"><img style="border-radius: 50%;" src="https://github.com/laisramos123.png" width="190vw;" alt=""/><br /><strong><b>Lais Ramos</b></strong></a><br /><a href="https://github.com/laisramos123"></a></td>
      <td align="center"><a href="https://github.com/Marianannn"><img style="border-radius: 50%;" src="https://github.com/Marianannn.png" width="190vw;" alt=""/><br /><strong><b>Mariana Letícia</b></strong></a><br /><a href="https://github.com/Marianannn" title="Rocketseat"></a></td>
      <td align="center"><a href="https://github.com/TaynaraCris"><img style="border-radius: 50%;" src="https://github.com/TaynaraCris.png" width="190vw;" alt=""/><br /><strong><b>Taynara Marcellos</b></strong></a><br /><a href="https://github.com/TaynaraCris" title="Rocketseat"></a></td>
    </tr>
  </table>
</div>

## 5. Histórico de Versões

A Tabela 1 registra o histórico de versão desse documento.

|**Data** | **Versão** | **Descrição** | **Autor** | **Revisor** |
|:---: | :---: | :---: | :---: | :---: |
| 27/03/2025 | 1.0 | Primeira Versão do artefato | [Arthur Suares](https://github.com/arthur-suares) | [Genilson Silva](https://github.com/GenilsonJrs) |
| 27/03/2025 | 1.1 | Adiciona equipe e histórico de versões | [Brunna Louise](https://github.com/brunna-martins) | [Genilson Silva](https://github.com/GenilsonJrs) |
| 27/06/2025 | 1.2 | Ajustes finais para projeto e estrutura | [Genilson Silva](https://github.com/GenilsonJrs) |  |

<h6 align = "center"> Tabela 1: Histórico de Versões
<br> Autor(es): Brunna 
<br>Fonte: Autor(es)</h6>
