%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h" // para reconhecer os tokens e yylval
%}

%%

// Palavras-chave da linguagem
if          { return IF; }
else        { return ELSE; }
while       { return WHILE; }
def         { return DEF; }
return      { return RETURN; }

[a-zA-Z_][a-zA-Z0-9_]* {
    // Verifica se é uma palavra-chave
    if (strcmp(yytext, "if") == 0)
        return IF;
    else if (strcmp(yytext, "else") == 0)
        return ELSE;
    else if (strcmp(yytext, "while") == 0)
        return WHILE;
    else if (strcmp(yytext, "def") == 0)
        return DEF;
    else if (strcmp(yytext, "return") == 0)
        return RETURN;
    else {
        // Se não for palavra-chave, é um identificador
        yylval.str = strdup(yytext);
        return ID;
    }
}

// Símbolos
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"="         { return ASSIGN; }
";"         { return ';'; }

[ \t\n]+    ;   // ignora espaços, tabs e quebras de linha

.           { printf("Caractere desconhecido: %s\n", yytext); }

%%
