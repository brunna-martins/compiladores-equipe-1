# TESTE: Números válidos suportados pelo lexer
# OBJETIVO: Validar que diferentes formatos de números são aceitos
# RESULTADO_ESPERADO: Parsing bem-sucedido, números reconhecidos corretamente

# Números inteiros básicos
zero = 0
um = 1
dez = 10
cem = 100
mil = 1000

# Números negativos
negativo_um = -1
negativo_dez = -10
negativo_cem = -100

# Números float básicos
float_simples = 1.0
float_zero = 0.0
float_decimal = 0.5

# Números float com várias casas decimais
pi_aproximado = 3.14159
euler = 2.71828
float_preciso = 123.456789

# Números float negativos
float_negativo = -1.5
float_negativo_zero = -0.1

# Números grandes (testando limites)
numero_grande = 999999999
float_grande = 999999.999999

# Operações com números
soma_int = 100 + 200
soma_float = 1.5 + 2.5
soma_mista = 10 + 5.5

# Multiplicação
mult_int = 10 * 20
mult_float = 2.5 * 4.0
mult_mista = 5 * 2.2

# Divisão
div_int = 100 / 10
div_float = 15.0 / 3.0
div_mista = 20 / 4.0

# Operações complexas
calculo = 10 + 5 * 2
calculo_parenteses = (10 + 5) * 2
calculo_float = 3.14 * 2.0 + 1.5

# Atribuições com números
resultado1 = 42
resultado2 = 3.14159
resultado3 = -273.15

# Print de números
print(zero)
print(pi_aproximado)
print(numero_grande)
print(calculo_parenteses)