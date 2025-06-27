%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
#include "numero.h" 

int indent_stack[100];
int top = -1;
int dedent_level = 0; 
char firstChar;
char *copyyytext; 
void handle_dedent() {
    top--;
}


%}

%option noyywrap
%option yylineno
%x DEDENTATION

NUMBER {INT_LITERAL}|{FLOAT_LITERAL}
FLOAT_LITERAL [0-9]+\.[0-9]+ 
INT_LITERAL [0-9]+
%%

%{
    if (top == -1) {
        indent_stack[++top] = 0;
    }
%}


"#".*               { /*Ignora o conteúdo do comentário*/ }


\"\"\"([^\"\\]|\\.|(\n))*?\"\"\"     {
    char* raw = strdup(yytext);
    int len = strlen(raw);
    raw[len - 3] = '\0';
    yylval.string = strdup(raw + 3);
    free(raw);
    return STRING_LITERAL;
}

\'\'\'([^\'\\]|\\.|(\n))*?\'\'\'     {
    char* raw = strdup(yytext);
    int len = strlen(raw);
    raw[len - 3] = '\0';
    yylval.string = strdup(raw + 3);
    free(raw);
    return STRING_LITERAL;
}

{FLOAT_LITERAL} {
    Numero n;
    n.tipo = TIPO_FLOAT;
    n.valor.f = atof(yytext);
    yylval.numero = n;
    printf("Numero Real: %f\n", n.valor.f);
    return NUMBER;
}

{INT_LITERAL} {
    Numero n;
    n.tipo = TIPO_INT;
    n.valor.i = atoi(yytext);
    yylval.numero = n;
    printf("Numero Inteiro: %d\n", n.valor.i);
    return NUMBER;
}

\"([^\"\\]|\\.)*\"  { yylval.string = strdup(yytext); return STRING_LITERAL; }
\'([^\'\\]|\\.)*\'  { yylval.string = strdup(yytext); return STRING_LITERAL; }

"if"            { printf("Palavra-chave: %s\n", yytext); return IF; }
"print"         { return PRINT;}
"else"          { printf("Palavra-chave: %s\n", yytext); return ELSE; }
"elif"          { printf("Palavra-chave: %s\n", yytext); return ELIF; }
"while"         { printf("Palavra-chave: %s\n", yytext); return WHILE; }
"for"           { printf("Palavra-chave: %s\n", yytext); return FOR; }
"def"           { printf("Palavra-chave: %s\n", yytext); return DEF; }
"return"        { printf("Palavra-chave: %s\n", yytext); return RETURN; }
"in"            { printf("Palavra-chave: %s\n", yytext); return IN; }
"True"          { printf("Palavra-chave: %s\n", yytext); return TRUE; }
"False"         { printf("Palavra-chave: %s\n", yytext); return FALSE; }
"None"          { printf("Palavra-chave: %s\n", yytext); return NONE; }
"and"           { printf("Palavra-chave: %s\n", yytext); return AND; }
"or"            { printf("Palavra-chave: %s\n", yytext); return OR; }
"not"           { printf("Palavra-chave: %s\n", yytext); return NOT; }
"class"         { printf("Palavra-chave: %s\n", yytext); return CLASS; }
"import"        { printf("Palavra-chave: %s\n", yytext); return IMPORT; }
"from"          { printf("Palavra-chave: %s\n", yytext); return FROM; }
"as"            { printf("Palavra-chave: %s\n", yytext); return AS; }
"try"           { printf("Palavra-chave: %s\n", yytext); return TRY; }
"except"        { printf("Palavra-chave: %s\n", yytext); return EXCEPT; }
"finally"       { printf("Palavra-chave: %s\n", yytext); return FINALLY; }
"with"          { printf("Palavra-chave: %s\n", yytext); return WITH; }
"pass"          { printf("Palavra-chave: %s\n", yytext); return PASS; }
"break"         { printf("Palavra-chave: %s\n", yytext); return BREAK; }
"continue"      { printf("Palavra-chave: %s\n", yytext); return CONTINUE; }
"global"        { printf("Palavra-chave: %s\n", yytext); return GLOBAL; }
"nonlocal"      { printf("Palavra-chave: %s\n", yytext); return NONLOCAL; }
"lambda"        { printf("Palavra-chave: %s\n", yytext); return LAMBDA; }

"="             { printf("Operador: %s\n", yytext); return ASSIGN; }
"=="            { printf("Operador: %s\n", yytext); return EQTO; }
"!="            { printf("Operador: %s\n", yytext); return NOTEQTO; }
"<"             { printf("Operador: %s\n", yytext); return LESSER; }
">"             { printf("Operador: %s\n", yytext); return GREATER; }
"<="            { printf("Operador: %s\n", yytext); return LESSEQ; }
">="            { printf("Operador: %s\n", yytext); return GREATEQ; }
"+"             { printf("Operador: %s\n", yytext); return PLUS; }
"+="            { printf("Operador: %s\n", yytext); return PLUSEQ; }
"-="            { printf("Operador: %s\n", yytext); return MINUSEQ; }
"-"             { printf("Operador: %s\n", yytext); return MINUS; }
"*"             { printf("Operador: %s\n", yytext); return TIMES; }
"/"             { printf("Operador: %s\n", yytext); return DIVIDE; }
"%"             { printf("Operador: %s\n", yytext); return MODULO; }

"("             { printf("Delimitador: %s\n", yytext); return LPAREN; }
")"             { printf("Delimitador: %s\n", yytext); return RPAREN; }
":"             { printf("Delimitador: %s\n", yytext); return COLON; }
","             { printf("Delimitador: %s\n", yytext); return COMMA; }
"["             { printf("Delimitador: %s\n", yytext); return LBRACKET; }
"]"             { printf("Delimitador: %s\n", yytext); return RBRACKET; }
"{"             { printf("Delimitador: %s\n", yytext); return LBRACE; }
"}"             { printf("Delimitador: %s\n", yytext); return RBRACE; }
"."             { printf("Delimitador: %s\n", yytext); return DOT; }
";"             { printf("Delimitador: %s\n", yytext); return SEMICOLON; }

"~"             {return DEDENT;}


[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identificador: %s\n", yytext);
    yylval.str = strdup(yytext);
    return ID;
}

^[^ \t\n]+ {
    if (indent_stack[top]!= 0){
        copyyytext=strdup(yytext);
        firstChar = yytext[0];
        unput(yytext[0]);
        BEGIN(DEDENTATION);
    }
    else
    {
        REJECT;
    }
}

^[ \t]+  {
    if (indent_stack[top] < yyleng) 
    {
        indent_stack[++top] = yyleng;
        printf("INDENT EMITIDO! (nível %d)\n", yyleng);
        return INDENT;

    } else if (indent_stack[top] > yyleng) 
    {
        dedent_level=yyleng;
        unput(32);/*32 for space*/
        BEGIN(DEDENTATION);

    } 
}

[ \t]+              { /* Ignorar espaços em branco */ }
\uFEFF              { /* ignora BOM */ }

\r?\n {
    printf("---- nova linha (linha %d) ----\n", yylineno);

    // Consumir e contar a indentação da linha seguinte
    int c;
    int count = 0;

    while ((c = input()) == ' ' || c == '\t') {
        count++;
    }

    if (c == '\n' || c == '\r' || c == EOF) {
        // Linha vazia: só emite NEWLINE, não mexe na indentação.
        unput(c);
        return NEWLINE;
    }

    unput(c);  // devolve o caractere não espaço

    if (count > indent_stack[top]) {
        indent_stack[++top] = count;
        printf("INDENT EMITIDO! (nível %d)\n", count);
        return INDENT;
    } else if (count < indent_stack[top]) {
        dedent_level = count;
        unput(' '); // força a entrada no modo DEDENTATION
        BEGIN(DEDENTATION);
    } 

    return NEWLINE;
}


\r                  { /* ignora carriage return */ }


<DEDENTATION>[ ] {
        if (top >= 0 && indent_stack[top] != dedent_level) {
            handle_dedent();
          
            unput(32);
            printf("DEDENT EMITIDO!\n");
            return DEDENT;
        }
        else
        {
            dedent_level=0;
            BEGIN(INITIAL);
        }

        if (top == -1) {
            fprintf(stderr, "Error: Incorrect indentation on line %d\n", yylineno);
            exit(1);
        }
}

<DEDENTATION>[^ \t\n] {
    if (indent_stack[top] != 0) {
        top--;
        unput(yytext[0]);

        printf("DEDENT EMITIDO!\n");
        return DEDENT;
    }
    else
    {
        for (int i = strlen(copyyytext) - 1; i >= 0; i--) {
            unput(copyyytext[i]);
        }
    BEGIN(INITIAL);
    }
    
}

<<EOF>>    {
    while (top >0) {
        handle_dedent();
        // printf("dedent = %s in line = %d\n",yytext,yylineno);
        printf("DEDENT FINAL EMITIDO!\n");
        return DEDENT;
    }
    
    return 0;    
}

.                   { printf("Caractere inválido: %s\n", yytext); }


%%

 