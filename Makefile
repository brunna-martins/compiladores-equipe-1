# Arquivos de entrada
LEX = lexer/lexer.l
YACC = parser/parser.y
MAIN = src/main.c
AST_C = ast.c
AST_H = ast.h
TABELA_SIMBOLOS_C = tabela_simbolos.c
TABELA_SIMBOLOS_H = tabela_simbolos.h
GERAR_CODIGO_C = gerarcodigo.c
GERAR_CODIGO_H = gerarcodigo.h
TEST_UNIT_SRC = test_tabela_simbolos.c
TEST_UNIT_EXEC = test_tabela_simbolos
TEST_AST_SRC = test_ast.c
TEST_AST_EXEC = test_ast

# TODOS os testes em uma pasta só
TESTS = $(wildcard testes/*.py)
TARGET = comp

# Inicializando cores
GREEN=\033[1;32m
RED=\033[1;31m
BLUE=\033[1;34m
YELLOW=\033[1;33m
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
comp: $(YACC_C) $(LEX_C) $(AST_C) $(TABELA_SIMBOLOS_C) $(GERAR_CODIGO_C) $(MAIN)
	$(CC) $(CFLAGS) -o $(TARGET) \
	    $(YACC_C) $(LEX_C) \
	    $(AST_C) $(TABELA_SIMBOLOS_C) \
	    $(GERAR_CODIGO_C) $(MAIN) -lfl

# Gera parser.tab.c e parser.tab.h
$(YACC_C) $(YACC_H): $(YACC)
	bison -d $(YACC)

# Gera lex.yy.c
$(LEX_C): $(LEX) $(YACC_H)
	flex -o $(LEX_C) $(LEX)

# Compila o arquivo da AST
ast.o: $(AST_C) $(AST_H)
	$(CC) $(CFLAGS) -c $(AST_C)

# Compila os testes unitários para tabela de símbolos
$(TEST_UNIT_EXEC): $(TEST_UNIT_SRC) $(TABELA_SIMBOLOS_C) $(TABELA_SIMBOLOS_H)
	$(CC) $(CFLAGS) -o $(TEST_UNIT_EXEC) $(TEST_UNIT_SRC) $(TABELA_SIMBOLOS_C)
	chmod +x $(TEST_UNIT_EXEC)

# Compila os testes unitários para AST
$(TEST_AST_EXEC): $(TEST_AST_SRC) $(AST_C) $(AST_H)
	$(CC) $(CFLAGS) -o $(TEST_AST_EXEC) $(TEST_AST_SRC) $(AST_C)
	chmod +x $(TEST_AST_EXEC)

# Executa TODOS os testes (unitários + integração)
test: $(TEST_UNIT_EXEC) $(TEST_AST_EXEC) comp
	@echo "$(GREEN)=== Executando Testes Unitários ===$(NC)"
	./$(TEST_UNIT_EXEC)
	./$(TEST_AST_EXEC)
	@echo "\n$(RED)============================================================$(NC)"
	@echo "$(RED)================= EXECUTANDO TESTES DE INTEGRAÇÃO =========$(NC)"
	@echo "$(RED)============================================================$(NC)\n"
	@PASSED=0; FAILED=0; TOTAL=0; \
	for f in $(TESTS); do \
		if [ -f "$$f" ]; then \
			TOTAL=$$((TOTAL + 1)); \
			echo "$(BLUE)============================================================$(NC)"; \
			echo "$(BLUE)=== TESTE $$TOTAL: $$f $(NC)"; \
			echo "$(BLUE)============================================================$(NC)"; \
			echo "$(YELLOW)--- Conteúdo:$(NC)"; \
			cat $$f; \
			echo "\n$(GREEN)--- Resultado:$(NC)"; \
			if ./$(TARGET) < $$f > /dev/null 2>&1; then \
				echo "$(GREEN)✓ PASSOU$(NC)"; \
				PASSED=$$((PASSED + 1)); \
			else \
				echo "$(RED)✗ FALHOU$(NC)"; \
				echo "$(RED)--- Detalhes do erro:$(NC)"; \
				./$(TARGET) < $$f 2>&1 || true; \
				FAILED=$$((FAILED + 1)); \
			fi; \
			echo ""; \
		fi; \
	done; \
	echo "$(BLUE)========================================================$(NC)"; \
	echo "$(BLUE)                    RESUMO FINAL$(NC)"; \
	echo "$(BLUE)========================================================$(NC)"; \
	echo "Total de testes: $$TOTAL"; \
	echo "$(GREEN)Passaram: $$PASSED$(NC)"; \
	echo "$(RED)Falharam: $$FAILED$(NC)"; \
	if [ $$FAILED -eq 0 ]; then \
		echo "$(GREEN)🎉 TODOS OS TESTES PASSARAM!$(NC)"; \
	else \
		echo "$(RED)❌ ALGUNS TESTES FALHARAM$(NC)"; \
	fi

# Testar arquivo específico
test-file: comp
	@if [ -n "$(FILE)" ]; then \
		if [ -f "$(FILE)" ]; then \
			echo "$(BLUE)=== Testando: $(FILE) ===$(NC)"; \
			echo "$(YELLOW)--- Conteúdo:$(NC)"; \
			cat $(FILE); \
			echo "\n$(GREEN)--- Resultado:$(NC)"; \
			./$(TARGET) < $(FILE); \
		else \
			echo "$(RED)Erro: Arquivo $(FILE) não encontrado$(NC)"; \
		fi; \
	else \
		echo "$(RED)Uso: make test-file FILE=caminho/para/arquivo.py$(NC)"; \
	fi

# Criar novo teste (direto na pasta testes/)
create-test:
	@if [ -n "$(NAME)" ]; then \
		mkdir -p testes; \
		echo "# TESTE: $(NAME)" > testes/$(NAME).py; \
		echo "# OBJETIVO: [Descreva o objetivo do teste]" >> testes/$(NAME).py; \
		echo "# RESULTADO_ESPERADO: [Descreva o resultado esperado]" >> testes/$(NAME).py; \
		echo "" >> testes/$(NAME).py; \
		echo "# Seu código Python aqui" >> testes/$(NAME).py; \
		echo "$(GREEN)✓ Teste criado: testes/$(NAME).py$(NC)"; \
	else \
		echo "$(RED)Uso: make create-test NAME=nome_teste$(NC)"; \
		echo "$(YELLOW)Exemplo: make create-test NAME=meu_teste$(NC)"; \
	fi

# Contar testes
count-tests:
	@echo "$(GREEN)=== Contagem de Testes ===$(NC)"
	@echo "$(BLUE)Total de testes: $$(ls testes/*.py 2>/dev/null | wc -l)$(NC)"
	@if [ $$(ls testes/*.py 2>/dev/null | wc -l) -gt 0 ]; then \
		echo "$(YELLOW)Arquivos encontrados:$(NC)"; \
		ls testes/*.py 2>/dev/null | sed 's/^/  /' || echo "  Nenhum"; \
	fi

# Ajuda
help-tests:
	@echo "$(GREEN)=== Comandos de Teste Disponíveis ===$(NC)"
	@echo "$(BLUE)make test$(NC)              - Todos os testes (unitários + integração)"
	@echo "$(BLUE)make test-file$(NC)         - Teste arquivo específico (FILE=...)"
	@echo "$(BLUE)make create-test$(NC)       - Criar novo teste (NAME=...)"
	@echo "$(BLUE)make count-tests$(NC)       - Contar e listar testes"
	@echo ""
	@echo "$(YELLOW)Exemplos:$(NC)"
	@echo "$(YELLOW)make test-file FILE=testes/meu_teste.py$(NC)"
	@echo "$(YELLOW)make create-test NAME=teste_soma$(NC)"

# Limpa os arquivos gerados
clean:
	rm -f comp $(LEX_C) $(YACC_C) $(YACC_H) *.o $(TEST_UNIT_EXEC) $(TEST_AST_EXEC)

# Remove arquivos temporários
distclean: clean
	rm -f *~

.PHONY: all clean distclean test test-file create-test count-tests help-tests