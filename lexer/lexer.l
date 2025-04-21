%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
  
%}

%option noyywrap
%option yylineno
%option noinput
%option nounput

%%

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
"=="        { printf("Operador: %s\n", yytext); return EQ; }
"!="        { printf("Operador: %s\n", yytext); return NEQ; }
"<"         { printf("Operador: %s\n", yytext); return LT; }
">"         { printf("Operador: %s\n", yytext); return GT; }
"<="        { printf("Operador: %s\n", yytext); return LTE; }
">="        { printf("Operador: %s\n", yytext); return GTE; }
"+"         { printf("Operador: %s\n", yytext); return PLUS; }
"-"         { printf("Operador: %s\n", yytext); return MINUS; }
"*"         { printf("Operador: %s\n", yytext); return TIMES; }
"/"         { printf("Operador: %s\n", yytext); return DIVIDE; }

"("         { printf("Delimitador: %s\n", yytext); return LPAREN; }
")"         { printf("Delimitador: %s\n", yytext); return RPAREN; }
":"         { printf("Delimitador: %s\n", yytext); return COLON; }
","         { printf("Delimitador: %s\n", yytext); return COMMA; }

[a-zA-Z_][a-zA-Z0-9_]* {
     
    printf("Identificador: %s\n", yytext);
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+      { 
    printf("Número: %s\n", yytext); 
    yylval.str = strdup(yytext);
    return NUMBER; 
}

\"[^\"]*\"  { 
    printf("String: %s\n", yytext); 
    yylval.str = strdup(yytext);
    return STRING; 
}
\'[^\']*\'  { 
    printf("String: %s\n", yytext); 
    yylval.str = strdup(yytext);
    return STRING; 
}

[ \t\r\n]+  ;  
.           { printf("Caractere desconhecido: %c\n", yytext[0]); }

%%

 