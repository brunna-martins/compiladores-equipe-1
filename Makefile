# Regra padrão: compila tudo
all: comp

# Compila o executável principal | adicionar tabela.o quando houver
comp: parser.tab.c lex.yy.c ast.o 
	gcc -Wall -g -o comp parser.tab.c lex.yy.c ast.o -lfl

# Gera os arquivos do Bison (analisador sintático)
parser.tab.c parser.tab.h: parser/parser.y
	bison -d parser/parser.y

# Gera o analisador léxico com Flex
lex.yy.c: lexer/lexer.l parser.tab.h
	flex lexer/lexer.l

# Compila o arquivo da AST
ast.o: ast.c ast.h
	gcc -Wall -g -c ast.c

# Compila o arquivo da tabela de símbolos (quando houver)
# tabela.o: tabela.c tabela.h
# 	gcc -Wall -g -c tabela.c

# Remove arquivos gerados
clean:
	rm -f comp parser.tab.c parser.tab.h lex.yy.c ast.o tabela.o

# Remove arquivos temporários também
distclean: clean
	rm -f *~
