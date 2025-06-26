# TESTE: Geração de código C para operações aritméticas
# OBJETIVO: Validar que operações matemáticas geram código C correto
# RESULTADO_ESPERADO: output.c compilável com gcc

a = 10
b = 5
resultado_soma = a + b
resultado_mult = a * b
resultado_complexo = (a + b) * (a - b)

pi = 3.14159
raio = 2.5
area = pi * raio * raio

print(resultado_soma)
print(area)