# Arquivos de entrada
LEX = lexer/lexer.l
YACC = parser/parser.y
MAIN = src/main.c
AST_C = ast.c
AST_H = ast.h
TABELA_SIMBOLOS_C = tabela_simbolos.c
TABELA_SIMBOLOS_H = tabela_simbolos.h
TEST_UNIT_SRC = test_tabela_simbolos.c
TEST_UNIT_EXEC = test_tabela_simbolos
TESTS = $(wildcard testes/*.py)
TARGET = comp

#Inicializando cores
GREEN=\033[1;32m
RED=\033[1;31m
BLUE=\033[1;34m
NC=\033[0m

# Arquivos gerados
LEX_C = lex.yy.c
YACC_C = parser.tab.c
YACC_H = parser.tab.h

# Compilador e flags
CC = gcc
CFLAGS = -Wall -g

# Regra padrão
all: comp

# Compila o executável principal
comp: $(YACC_C) $(LEX_C) $(AST_C) $(TABELA_SIMBOLOS_C) $(MAIN)
	$(CC) $(CFLAGS) -o comp $(YACC_C) $(LEX_C) $(AST_C) $(TABELA_SIMBOLOS_C) $(MAIN) -lfl

# Gera parser.tab.c e parser.tab.h
$(YACC_C) $(YACC_H): $(YACC)
	bison -d $(YACC)

# Gera lex.yy.c
$(LEX_C): $(LEX) $(YACC_H)
	flex -o $(LEX_C) $(LEX)

# Compila o arquivo da AST
ast.o: $(AST_C) $(AST_H)
	$(CC) $(CFLAGS) -c $(AST_C)

# Compila os testes unitários
$(TEST_UNIT_EXEC): $(TEST_UNIT_SRC) $(TABELA_SIMBOLOS_C) $(TABELA_SIMBOLOS_H)
	$(CC) $(CFLAGS) -o $(TEST_UNIT_EXEC) $(TEST_UNIT_SRC) $(TABELA_SIMBOLOS_C)
	chmod +x $(TEST_UNIT_EXEC)

# Executa os testes unitários
test: $(TEST_UNIT_EXEC)
	@echo "=== Executando Testes Unitários ==="
	./$(TEST_UNIT_EXEC)
	@echo "\n$(RED)============================================================$(NC)"
	@echo "$(RED)================= EXECUTANDO MAIS TESTES ===================$(NC)"
	@echo "$(RED)============================================================$(NC)\n"
	@for f in $(TESTS); do \
		echo "$(BLUE)============================================================$(NC)"; \
		echo "$(BLUE)=== ARQUIVO: $$f $(NC)"; \
		echo "$(BLUE)============================================================$(NC)\n"; \
		cat $$f; \
		echo "\n\n$(GREEN)============================================================$(NC)"; \
		echo "$(GREEN)=== bitcode $(NC)"; \
		echo "$(GREEN)============================================================$(NC)\n"; \
		chmod +x $(TARGET); \
		./$(TARGET) < $$f; \
		echo ""; \
	done

# Limpa os arquivos gerados
clean:
	rm -f comp $(LEX_C) $(YACC_C) $(YACC_H) *.o $(TEST_UNIT_EXEC)

# Remove arquivos temporários
distclean: clean
	rm -f *~
