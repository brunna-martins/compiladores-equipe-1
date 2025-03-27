# [T01/2025.1] Compiladores - Grupo 01

<br>
<br>

<center>
<h1>Documentação do Projeto! 📖</h1>
</center>

Este é o repositório do projeto da disciplina de Compiladores para o semestre 2025.1. Aqui você encontrará toda as instruções necessária para entender e contribuir para a documentação do projeto.

<br>

### 1. Sobre a Documentação:
Nossa documentação é mantida separadamente da branch principal (main) e é gerenciada utilizando o MkDocs, uma ferramenta popular para criação de documentação estática a partir de arquivos Markdown. Utilizamos o tema "Material" para proporcionar uma experiência de leitura limpa e moderna.

### 2. Clonando o Repositório da Documentação (Se não tiver Clonado):
Antes de começar, é necessário clonar a branch de documentação para obter os arquivos MkDocs necessários:

Use o código abaixo para clonar o repositório:
```shell
git clone https://github.com/brunna-martins/compiladores-equipe-1
```

Utilize o código abaixo para entrar na Branch da Documentação:
```shell
git checkout Doc
```

### 3. Instalando as Dependências do Docs:
Para rodar a documentação, é necessário instalar as dependências do MkDocs e configurar o ambiente local. Siga os passos abaixo:

#### 3.1. Instale a Linguagem Python:
Para rodar o MkDocs, é necessário ter o Python instalado no seu sistema. O Python é uma linguagem de programação amplamente usada para automação de tarefas e gerenciamento de pacotes, o que facilita a instalação do MkDocs e de outras dependências.

- No Windows:

1. Acesse o site [oficial do Python](https://www.python.org/downloads/) e faça o download da versão mais recente.
2. Durante a instalação, marque a opção "Add Python to PATH" (Adicionar Python ao PATH). Isso garante que o Python e o pip estejam acessíveis via linha de comando.
3. Complete a instalação e reinicie o terminal para que o Python seja reconhecido.

- No Ubuntu e em outras distribuições Linux:

1. No terminal, execute o seguinte comando para instalar o Python 3

```shell
sudo apt update
sudo apt install python3 python3-pip
```

2. Confirme que a instalação foi bem-sucedida verificando a versão do Python:

```shell
python3 --version
```
- No macOS:

1. O Python geralmente **já vem pré-instalado no macOS**. Para garantir que a versão esteja atualizada, você pode usar o gerenciador de pacotes Homebrew:

```shell
brew install python
```

2. Verifique a versão para confirmar a instalação:

```shell
python3 --version
```

#### 3.2. Instale o MkDocs:
Certifique-se de ter o MkDocs instalado junto com o tema material. Se ainda não o tiver, você pode instalá-lo utilizando pip, o gerenciador de pacotes do Python:

(funciona no Windows ou Linux):
```shell
pip install mkdocs mkdocs-material
```

##### OPCIONAL | EM CASO DE ERRO NO COMANDO ACIMA:
Em versões mais atuais do Ubuntu, como o 24.04, não é aceito mais o pip como instalador de pacotes e, por isso, é necessário criar um ambiente virtual para realizar as instalações do python, como o Mkdocs. Para isso, utilize os seguintes comandos:

Utilize o código abaixo para criar uma pasta para o ambiente virtual:
```shell
python3 -m venv .venv
```

Agora, utilize o código abaixo para entrar no ambiente virtual:
```shell
source .venv/bin/activate
```

Agora você poderá utilizar o pip!

<!-- ### 4. Instale o Tema "Material":
O tema "Material" é utilizado para fornecer uma experiência de documentação limpa e responsiva. Instale-o usando pip:

Com pip (É necessário ter pip, no Windows e no Linux)
```shell
pip install mkdocs-material
``` -->

### 4. Visualize a Documentação Localmente:
Por fim, inicie o servidor de desenvolvimento MkDocs para visualizar a documentação localmente em seu navegador:

```shell
mkdocs serve
```

Isso iniciará um servidor local em http://localhost:8000, onde você poderá visualizar a documentação. Qualquer alteração nos arquivos Markdown será automaticamente refletida na visualização do navegador.

<br>

Agora que você configurou seu ambiente de desenvolvimento local, você está pronto para explorar nossa documentação e contribuir para o projeto. Se tiver alguma dúvida ou encontrar algum problema, não hesite em entrar em contato conosco. Agradecemos sua contribuição e interesse em nosso projeto!

<br>

## 📝 Acesse a Documentação do Projeto:

Para conferir todos os detalhes sobre o projeto, acesse a documentação completa clicando [aqui](https://brunna-martins.github.io/compiladores-equipe-1/).

<br><br>

# 👩‍💻 Contribuidores do Projeto:

<!-- Foto dos participantes do grupo -->
<div align="center">
  <img src="https://github.com/arthur-suares.png" width="100" />
  <img src="https://github.com/brunna-martins.png" width="100"/>
  <img src="https://github.com/GenilsonJrs.png" width="100"/>
  <img src="https://github.com/laisramos123.png" width="100"/>
  <img src="https://github.com/Marianannn.png" width="100"/>
  <img src="https://github.com/TaynaraCris.png" width="100"/>
</div>
