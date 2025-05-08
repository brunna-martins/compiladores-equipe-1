#ifndef NUMERO_H
#define NUMERO_H

typedef struct {
    enum { TIPO_INT, TIPO_FLOAT } tipo;
    union {
        int i;
        float f;
    } valor;
} Numero;

#endif
