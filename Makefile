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

# Tabela de símbolos
TABELA_SIMBOLOS_C = tabela_simbolos.c
TABELA_SIMBOLOS_H = tabela_simbolos.h

# Arquivos de teste unitário

TEST_UNIT_SRC = test_tabela_simbolos.c
TEST_UNIT_EXEC = test_tabela_simbolos

# Compilador e flags
CC = gcc
CFLAGS = -Wall -g

# Regra principal
all: $(EXEC)

# Compila tudo
$(EXEC): $(LEX_C) $(YACC_C) $(MAIN) $(TABELA_SIMBOLOS_C)
	$(CC) $(CFLAGS) -o $(EXEC) $(LEX_C) $(YACC_C) $(MAIN) $(TABELA_SIMBOLOS_C) -lfl

# Gera lex.yy.c
$(LEX_C): $(LEX)
	flex -o $(LEX_C) $(LEX)

# Gera parser.tab.c e parser.tab.h
$(YACC_C) $(YACC_H): $(YACC)
	bison -d $(YACC)

# Compila os testes unitários

$(TEST_UNIT_EXEC): $(TEST_UNIT_SRC) $(TABELA_SIMBOLOS_C) $(TABELA_SIMBOLOS_H)
	$(CC) $(CFLAGS) -o $(TEST_UNIT_EXEC) $(TEST_UNIT_SRC) $(TABELA_SIMBOLOS_C)
	chmod +x $(TEST_UNIT_EXEC)
# Executa os testes unitários
test: $(TEST_UNIT_EXEC)
	@echo "=== Executando Testes Unitários ==="
	./$(TEST_UNIT_EXEC)


# Limpa os arquivos gerados
clean:
	rm -f $(EXEC) $(LEX_C) $(YACC_C) $(YACC_H) *.o
	rm -f $(TEST_UNIT_EXEC)

distclean: clean
	rm -f *~
