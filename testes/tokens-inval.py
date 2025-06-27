# TESTE: Tokens válidos reconhecidos pelo lexer
# OBJETIVO: Validar que todos os tokens suportados são reconhecidos corretamente
# RESULTADO_ESPERADO: Parsing bem-sucedido, todos tokens identificados

# Teste de números inteiros
numero_int = 123
numero_negativo = -456
numero_zero = 0

# Teste de números float
numero_float = 123.456
float_pequeno = 0.001
float_grande = 999.999

# Teste de strings
string_simples = "Hello World"
string_aspas_simples = 'Ola mundo'
string_vazia = ""
string_com_espacos = "  texto com espacos  "

# Teste de strings multiline (triplas)
string_multiline = """Esta e uma string
que ocupa multiplas linhas
para teste"""

# Teste de identificadores válidos
variavel_simples = 10
variavel_com_underscore = 20
variavel_123 = 30
_variavel_underscore = 40

# Teste de palavras-chave
valor_true = True
valor_false = False
valor_none = None

