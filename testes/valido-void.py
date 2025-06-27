# Teste para verificar se o compilador identifica
# e gera corretamente uma função com retorno void.

def olaMundo():
  # Esta função não tem 'return', portanto deve ser 'void' em C.
  print("Ola, mundo! Void.")


# Bloco principal do programa
print("O programa vai chamar a funcao void agora.")
olaMundo()
print("A funcao ola mundo foi executada com sucesso.")