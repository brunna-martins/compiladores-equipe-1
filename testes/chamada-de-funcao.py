# TESTE: Chamadas de funções
# OBJETIVO: Validar que chamadas de função são parseadas corretamente
# RESULTADO_ESPERADO: AST com nós representando chamadas de função

def dobrar(x):
    return x * 2

def somar(a, b):
    return a + b

resultado1 = dobrar(5)
resultado2 = somar(10, 20)
resultado3 = dobrar(somar(3, 4))
print(dobrar(resultado1))