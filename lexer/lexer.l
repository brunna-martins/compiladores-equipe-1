%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
#include "numero.h" 

int indent_stack[100] = {0};  // Inicializado com zeros
int top = 0;  // Topo da pilha (primeira posição livre)
int current_line_indent = 0;

%}

%option noinput nounput noyywrap yylineno

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
    return NUMBER;
}

{INT_LITERAL} {
    Numero n;
    n.tipo = TIPO_INT;
    n.valor.i = atoi(yytext);
    yylval.numero = n;
    return NUMBER;
}
\"([^\"\\]|\\.)*\"  { yylval.string = strdup(yytext); return STRING_LITERAL; }
\'([^\'\\]|\\.)*\'  { yylval.string = strdup(yytext); return STRING_LITERAL; }

"if"            { printf("Palavra-chave: %s\n", yytext); return IF; }
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
"range"         { printf("Identificador: %s\n", yytext); yylval.str = strdup(yytext); return ID; }

"="             { printf("Operador: %s\n", yytext); return ASSIGN; }
"=="            { printf("Operador: %s\n", yytext); return EQTO; }
"!="            { printf("Operador: %s\n", yytext); return NOTEQTO; }
"<"             { printf("Operador: %s\n", yytext); return LESSER; }
">"             { printf("Operador: %s\n", yytext); return GREATER; }
"<="            { printf("Operador: %s\n", yytext); return LESSEQ; }
">="            { printf("Operador: %s\n", yytext); return GREATEQ; }
"+"             { printf("Operador: %s\n", yytext); return PLUS; }
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


[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identificador: %s\n", yytext);
    yylval.str = strdup(yytext);
    return ID;
}

^[ \t]+             {       
    int indent = yyleng;
    current_line_indent = indent;
    
    if (indent > indent_stack[top-1]) {
        // Aumento de indentação
        indent_stack[top++] = indent;
        printf("INDENT EMITIDO! (nível %d)\n", indent);
        return INDENT;
    }
    else if (indent < indent_stack[top-1]) {
        // Diminuição de indentação - emite DEDENT
        top--;
        printf("DEDENT EMITIDO! (nível %d -> %d)\n", indent_stack[top], indent);
        yyless(0); // Reprocessa a linha sem a indentação
        return DEDENT;
    }
    // Mesmo nível: não faz nada
}

\n                  {
    current_line_indent = 0;
    printf("---- nova linha (linha %d) ----\n", yylineno);
    return NEWLINE;
}

[ \t]+              { /* Ignorar espaços em branco */ }

<<EOF>>             { // Emite DEDENTs para todos os níveis restantes
    
    if (top > 1) {  // Mantém o nível 0 base
        top--;
        printf("DEDENT FINAL EMITIDO!\n");
        return DEDENT;
    }
    else {
        return 0;
    }
}


.                   { printf("Caractere inválido: %s\n", yytext); }


%%

 
