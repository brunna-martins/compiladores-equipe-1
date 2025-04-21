/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    NUMBER = 259,                  /* NUMBER  */
    STRING = 260,                  /* STRING  */
    IF = 261,                      /* IF  */
    ELSE = 262,                    /* ELSE  */
    ELIF = 263,                    /* ELIF  */
    WHILE = 264,                   /* WHILE  */
    FOR = 265,                     /* FOR  */
    DEF = 266,                     /* DEF  */
    RETURN = 267,                  /* RETURN  */
    IN = 268,                      /* IN  */
    TRUE = 269,                    /* TRUE  */
    FALSE = 270,                   /* FALSE  */
    NONE = 271,                    /* NONE  */
    AND = 272,                     /* AND  */
    OR = 273,                      /* OR  */
    NOT = 274,                     /* NOT  */
    CLASS = 275,                   /* CLASS  */
    IMPORT = 276,                  /* IMPORT  */
    FROM = 277,                    /* FROM  */
    AS = 278,                      /* AS  */
    TRY = 279,                     /* TRY  */
    EXCEPT = 280,                  /* EXCEPT  */
    FINALLY = 281,                 /* FINALLY  */
    WITH = 282,                    /* WITH  */
    PASS = 283,                    /* PASS  */
    BREAK = 284,                   /* BREAK  */
    CONTINUE = 285,                /* CONTINUE  */
    GLOBAL = 286,                  /* GLOBAL  */
    NONLOCAL = 287,                /* NONLOCAL  */
    LAMBDA = 288,                  /* LAMBDA  */
    ASSIGN = 289,                  /* ASSIGN  */
    EQ = 290,                      /* EQ  */
    NEQ = 291,                     /* NEQ  */
    LT = 292,                      /* LT  */
    GT = 293,                      /* GT  */
    LTE = 294,                     /* LTE  */
    GTE = 295,                     /* GTE  */
    PLUS = 296,                    /* PLUS  */
    MINUS = 297,                   /* MINUS  */
    TIMES = 298,                   /* TIMES  */
    DIVIDE = 299,                  /* DIVIDE  */
    LPAREN = 300,                  /* LPAREN  */
    RPAREN = 301,                  /* RPAREN  */
    COLON = 302,                   /* COLON  */
    COMMA = 303                    /* COMMA  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 11 "parser/parser.y"

    char *str;

#line 116 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
