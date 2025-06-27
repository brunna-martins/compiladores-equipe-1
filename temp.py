def func_temp(i):
    contador = 0

    while contador < i:
        print("contador é", contador)
        contador = contador + 1
    
    return i

teste = func_temp(2)
func_temp(2)

print(func_temp(2))