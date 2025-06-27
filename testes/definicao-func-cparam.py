# TESTE: Definição de funções com parâmetros
# OBJETIVO: Validar parsing de funções com múltiplos parâmetros
# RESULTADO_ESPERADO: AST com nós TIPO_PARAM ligados corretamente

def quadrado(x):
    resultado = x * x
    return resultado

def somar(a, b):
    return a + b

def calcular_media(x, y, z):
    soma = x + y + z
    media = soma / 3