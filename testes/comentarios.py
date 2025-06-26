# TESTE: Comentários válidos suportados pelo lexer
# OBJETIVO: Validar que comentários são ignorados corretamente
# RESULTADO_ESPERADO: Código funcional com comentários ignorados apropriadamente

# Comentário no início do arquivo

# Função com comentários
def funcao_comentada():
    # Comentário antes da declaração
    x = 10  # Comentário inline
    
    # Comentário explicativo
    y = 20
    
    # Múltiplos comentários
    # uma linha após a outra
    # para testar o parsing
    
    resultado = x + y  # Resultado da soma
    return resultado  # Retorna o valor

# Comentário com vários caracteres especiais
# Teste: !@#$%^&*()_+-=[]{}|;':\",./<>?

# Comentário com números: 123456789
valor = 42  # Valor importante

# Comentário antes de estrutura de controle
if valor > 0:  # Verifica se é positivo
    # Comentário dentro do if
    print("Positivo")  # Imprime resultado
else:  # Caso contrário
    # Comentário dentro do else
    print("Não positivo")  # Mensagem alternativa

# Comentário antes de loop
for i in range(3):  # Loop de 0 a 2
    # Comentário dentro do loop
    print(i)  # Imprime índice

# Função sem implementação
def funcao_vazia():
    # Esta função não faz nada
    pass  # Comando pass

# Comentário com # duplo no meio
x = 5  ## Duplo sustenido
y = 10 # Comentário # com # vários # sustenidos

# Comentário muito longo para testar se o lexer consegue processar comentários extensos que ocupam uma linha muito longa sem problemas
resultado_final = funcao_comentada()
print(resultado_final)

# Comentário final do arquivo
