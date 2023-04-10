%{
#include<stdio.h>
%}

%token INT FLOAT TYPE STRUCT
%token IF ELSE WHILE RETURN
%token COMMA SEMI DOT
%token LC RC LB RB LP RP
%token AND OR RELOP ASSIGNOP PLUS MINUS STAR DIV NOT
%token ID
%token Exp
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

Stmt : IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
    | IF LP Exp RP Stmt ELSE Stmt

%%