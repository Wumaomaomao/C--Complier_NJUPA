%{
#include<stdio.h>
#include"tree.h"
extern int yylineno;
void yyerror(const char* msg);
%}

/*declare token type*/
%union{
    struct Tree* type_tree;
}

/*yylloc declartion*/
%locations

%token <type_tree>INT FLOAT TYPE STRUCT
%token <type_tree>IF ELSE WHILE RETURN
%token <type_tree>COMMA SEMI DOT
%token <type_tree>LC RC LB RB LP RP
%token <type_tree>AND OR RELOP ASSIGNOP PLUS MINUS STAR DIV NOT
%token <type_tree>ID

%right ASSIGNOP
%left OR
%left AND
%left RELOP 
%left PLUS MINUS
%left STAR DIV
%right NOT UMINUS
%left LP RP LB RB DOT

%type <type_tree>Program ExtDef ExtDefList Specifier ExtDecList FunDec CompSt VarDec StructSpecifier Tag OptTag DefList VarList ParamDec StmtList Stmt Def DecList Dec Exp Args
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%% /*the syntax follows*/
Program : ExtDefList {/*$$ = CreateTree($1);*/}
    ;
ExtDefList : /*empty*/
    | ExtDef ExtDefList {/*$$ = CreateSubTree("ExtDefList", 2, $1, $2);*/}
    ;
ExtDef : Specifier ExtDecList SEMI {/*$$ = CreateSubTree("ExtDef",3,$1,$2,$3);*/}
    | Specifier SEMI {/*$$ = CreateSubTree("ExtDef",2,$1,$2);*/}
    | Specifier FunDec CompSt
    ;
ExtDecList : VarDec
    | VarDec COMMA ExtDecList
    ;
Specifier : TYPE {/*$$ = CreateSubTree("Specifier",1,$1);*/}
    | StructSpecifier
    ;
StructSpecifier : STRUCT OptTag LC DefList RC
    | STRUCT Tag
    ;
OptTag : /*empty*/
    | ID
    ;
Tag : ID
    ;
VarDec : ID
    | VarDec LB INT RB
    ;
FunDec : ID LP VarList RP
    | ID LP RP
    ;
VarList : ParamDec COMMA VarList
    | ParamDec
    ;
ParamDec : Specifier VarDec
    ;
CompSt : LC DefList StmtList RC
    ;
StmtList : /*empty*/    
    | Stmt StmtList
    ;
Stmt : Exp SEMI
    | CompSt
    | RETURN Exp SEMI
    | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
    | IF LP Exp RP Stmt ELSE Stmt
    | WHILE LP Exp RP Stmt
    ;
DefList :/*empty*/
    | Def DefList
    ;
Def : Specifier DecList SEMI
    ;
DecList : Dec
    | Dec COMMA DecList
    ;
Dec : VarDec
    | VarDec ASSIGNOP Exp
    ;
Exp : Exp ASSIGNOP Exp
    | Exp AND Exp
    | Exp OR Exp
    | Exp RELOP Exp
    | Exp PLUS Exp
    | Exp MINUS Exp
    | Exp STAR Exp
    | Exp DIV Exp
    | LP Exp RP
    | MINUS Exp %prec UMINUS
    | NOT Exp
    | ID LP Args RP
    | ID LP RP
    | Exp LB Exp RB
    | Exp DOT ID
    | ID
    | INT
    | FLOAT
    ;
Args : Exp COMMA Args
    | Exp
    ;
%%
#include"lex.yy.c"
void yyerror(const char* msg)
{
    fprintf(stderr, "Error type B at %d : %s\n", yylineno, msg);
}