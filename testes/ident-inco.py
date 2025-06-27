# TESTE: Indentação válida e consistente
# OBJETIVO: Validar que o sistema de INDENT/DEDENT funciona corretamente
# RESULTADO_ESPERADO: Parsing bem-sucedido com indentação correta

# Função com indentação simples
def funcao_simples():
    x = 10
    y = 20
    return x + y

# Função com estrutura if
def funcao_com_if():
    numero = 5
    resultado = 0
    if numero > 0:
        resultado = numero * 2
        print(resultado)
    else:
        resultado = 0
        print(resultado)
    return resultado

# Função com estrutura while
def funcao_com_while():
    contador = 0
    while contador < 3:
        print(contador)
        contador = contador + 1
    return contador

# Função com estrutura for
def funcao_com_for():
    soma = 0
    for i in range(5):
        soma = soma + i
        print(soma)
    return soma

# Função com indentação aninhada
def funcao_aninhada():
    x = 10
    
    if x > 5:
        y = 20
        if y > 15:
            z = x + y
            print(z)
        else:
            z = x - y
            print(z)
    else:
        z = 0
        print(z)
    return z

# Código no nível global
valor_global = 100
print(valor_global)

# Chamadas de função
resultado1 = funcao_simples()
resultado2 = funcao_com_if()
print(resultado1)
print(resultado2)