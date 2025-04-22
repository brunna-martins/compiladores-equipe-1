%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
%}

%option noyywrap
%option yylineno
%option noinput
%option nounput

int linha = 1;

%%

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

[0-9]+\.[0-9]+      { yylval.real = atof(yytext); return FLOAT_LITERAL;}
[0-9]+              { yylval.inteiro = atoi(yytext); return INT_LITERAL; }
\"([^\"\\]|\\.)*\"  { yylval.string = strdup(yytext); return STRING_LITERAL; }
\'([^\'\\]|\\.)*\'  { yylval.string = strdup(yytext); return STRING_LITERAL; }

"if"        { printf("Palavra-chave: %s\n", yytext); return IF; }
"else"      { printf("Palavra-chave: %s\n", yytext); return ELSE; }
"elif"      { printf("Palavra-chave: %s\n", yytext); return ELIF; }
"while"     { printf("Palavra-chave: %s\n", yytext); return WHILE; }
"for"       { printf("Palavra-chave: %s\n", yytext); return FOR; }
"def"       { printf("Palavra-chave: %s\n", yytext); return DEF; }
"return"    { printf("Palavra-chave: %s\n", yytext); return RETURN; }
"in"        { printf("Palavra-chave: %s\n", yytext); return IN; }
"True"      { printf("Palavra-chave: %s\n", yytext); return TRUE; }
"False"     { printf("Palavra-chave: %s\n", yytext); return FALSE; }
"None"      { printf("Palavra-chave: %s\n", yytext); return NONE; }
"and"       { printf("Palavra-chave: %s\n", yytext); return AND; }
"or"        { printf("Palavra-chave: %s\n", yytext); return OR; }
"not"       { printf("Palavra-chave: %s\n", yytext); return NOT; }
"class"     { printf("Palavra-chave: %s\n", yytext); return CLASS; }
"import"    { printf("Palavra-chave: %s\n", yytext); return IMPORT; }
"from"      { printf("Palavra-chave: %s\n", yytext); return FROM; }
"as"        { printf("Palavra-chave: %s\n", yytext); return AS; }
"try"       { printf("Palavra-chave: %s\n", yytext); return TRY; }
"except"    { printf("Palavra-chave: %s\n", yytext); return EXCEPT; }
"finally"   { printf("Palavra-chave: %s\n", yytext); return FINALLY; }
"with"      { printf("Palavra-chave: %s\n", yytext); return WITH; }
"pass"      { printf("Palavra-chave: %s\n", yytext); return PASS; }
"break"     { printf("Palavra-chave: %s\n", yytext); return BREAK; }
"continue"  { printf("Palavra-chave: %s\n", yytext); return CONTINUE; }
"global"    { printf("Palavra-chave: %s\n", yytext); return GLOBAL; }
"nonlocal"  { printf("Palavra-chave: %s\n", yytext); return NONLOCAL; }
"lambda"    { printf("Palavra-chave: %s\n", yytext); return LAMBDA; }

"="         { printf("Operador: %s\n", yytext); return ASSIGN; }
"=="        { printf("Operador: %s\n", yytext); return EQTO; }
"!="        { printf("Operador: %s\n", yytext); return NOTEQTO; }
"<"         { printf("Operador: %s\n", yytext); return LESSER; }
">"         { printf("Operador: %s\n", yytext); return GREATER; }
"<="        { printf("Operador: %s\n", yytext); return LESSEQ; }
">="        { printf("Operador: %s\n", yytext); return GREATEQ; }
"+"         { printf("Operador: %s\n", yytext); return PLUS; }
"-"         { printf("Operador: %s\n", yytext); return MINUS; }
"*"         { printf("Operador: %s\n", yytext); return TIMES; }
"/"         { printf("Operador: %s\n", yytext); return DIVIDE; }
"%"         { printf("Operador: %s\n", yytext); return MODULO; }

"("         { printf("Delimitador: %s\n", yytext); return LPAREN; }
")"         { printf("Delimitador: %s\n", yytext); return RPAREN; }
":"         { printf("Delimitador: %s\n", yytext); return COLON; }
","         { printf("Delimitador: %s\n", yytext); return COMMA; }
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

[ \t]+              { /* Ignorar espaços em branco */ }
\r                  { /* ignora carriage return */ }
\uFEFF              { /* ignora BOM */ }
\n                  { return '\n'; }

.                   { printf("Caractere inválido: %s\n", yytext); }

%%

 
