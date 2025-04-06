# Nome do executável
EXEC = compilador

# Arquivos de entrada renomeados
LEX = lexer/lexer.l
YACC = parser/parser.y

# Arquivos gerados
LEX_C = lex.yy.c
YACC_C = parser.tab.c
YACC_H = parser.tab.h

# Arquivo principal (você pode adicionar main.c se tiver)
MAIN = src/main.c

# Compilador e flags
CC = gcc
CFLAGS = -Wall -g

# Regra principal
all: $(EXEC)

# Compila tudo
$(EXEC): $(LEX_C) $(YACC_C) $(MAIN)
	$(CC) $(CFLAGS) -o $(EXEC) $(LEX_C) $(YACC_C) $(MAIN) -lfl

# Gera lex.yy.c
$(LEX_C): $(LEX)
	flex -o $(LEX_C) $(LEX)

# Gera parser.tab.c e parser.tab.h
$(YACC_C) $(YACC_H): $(YACC)
	bison -d $(YACC)

# Limpa os arquivos gerados
clean:
	rm -f $(EXEC) $(LEX_C) $(YACC_C) $(YACC_H) *.o

distclean: clean
	rm -f *~
