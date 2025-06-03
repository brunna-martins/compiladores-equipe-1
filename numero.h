#ifndef NUMERO_H
#define NUMERO_H

typedef struct {
    enum { INTEIRO, REAL } tipo;
    union {
        int i;
        float f;
    } valor;
} Numero;

#endif
