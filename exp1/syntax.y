%{
#include<stdio.h>
#include"tree.h"
extern int yylineno;
extern int errorFlag;
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
Program : ExtDefList {$$ = CreateTree($1);}
    ;
ExtDefList : /*empty*/ {$$ = NULL;}
    | ExtDef ExtDefList {$$ = CreateSubTree("ExtDefList",2,$1,$2);}
    ;
ExtDef : Specifier ExtDecList SEMI {$$ = CreateSubTree("ExtDef",3,$1,$2,$3);}
    | Specifier SEMI {$$ = CreateSubTree("ExtDef",2,$1,$2);}
    | Specifier FunDec CompSt {$$ = CreateSubTree("ExtDef",3,$1,$2,$3);}
    ;
ExtDecList : VarDec {$$ = CreateSubTree("ExtDecList",1,$1);}
    | VarDec COMMA ExtDecList  {$$ = CreateSubTree("ExtDecList",3,$1,$2,$3);}
    ;
Specifier : TYPE {$$ = CreateSubTree("Specifier",1,$1);}
    | StructSpecifier {$$ = CreateSubTree("Specifier",1,$1);}
    ;
StructSpecifier : STRUCT OptTag LC DefList RC {$$ = CreateSubTree("StructSpecifier",5,$1,$2,$3,$4,$5);}
    | STRUCT OptTag LC error RC 
    | STRUCT Tag {$$ = CreateSubTree("StructSpecifier",2,$1,$2);}
    ;
OptTag : /*empty*/ {$$ = NULL;}
    | ID {$$ = CreateSubTree("OptTag",1,$1);}
    ;
Tag : ID {$$ = CreateSubTree("Tag",1,$1);}
    ;
VarDec : ID {$$ = CreateSubTree("VarDec",1,$1);}
    | VarDec LB INT RB  {$$ = CreateSubTree("VarDec",4,$1,$2,$3,$4);}
    | VarDec error INT RB
    | VarDec LB INT error {yyerror("Missing \"]\"\n");}
    | VarDec LB error RB
    ;
FunDec : ID LP VarList RP {$$ = CreateSubTree("FunDec",4,$1,$2,$3,$4);}
    | ID LP RP {$$ = CreateSubTree("FunDec",3,$1,$2,$3);}
    | ID LP error RP
    ;
VarList : ParamDec COMMA VarList {$$ = CreateSubTree("VarList",3,$1,$2,$3);}
    | ParamDec  {$$ = CreateSubTree("ParamDec",1,$1);}
    ;
ParamDec : Specifier VarDec {$$ = CreateSubTree("ParamDec",2,$1,$2);}
    ;
CompSt : LC DefList StmtList RC {$$ = CreateSubTree("CompSt",4,$1,$2,$3,$4);}
    ;
StmtList : /*empty*/ {$$ = NULL;}
    | Stmt StmtList {$$ = CreateSubTree("StmtList",2,$1,$2);}
    ;
Stmt : Exp SEMI {$$ = CreateSubTree("Stmt",2,$1,$2);}
    | CompSt {$$ = CreateSubTree("Stmt",1,$1);}
    | RETURN Exp SEMI {$$ = CreateSubTree("Stmt",3,$1,$2,$3);}
    | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE   {$$ = CreateSubTree("Stmt",5,$1,$2,$3,$4,$5);}
    | IF LP error RP Stmt %prec LOWER_THAN_ELSE 
    | IF LP Exp RP Stmt ELSE Stmt   {$$ = CreateSubTree("Stmt",7,$1,$2,$3,$4,$5,$6,$7);}
    | IF LP error RP Stmt ELSE Stmt
    | WHILE LP Exp RP Stmt  {$$ = CreateSubTree("Stmt",5,$1,$2,$3,$4,$5);}
    | WHILE LP error RP Stmt
    | error SEMI
    ;
DefList :/*empty*/ {$$ = NULL;}
    | Def DefList   {$$ = CreateSubTree("DefList",2,$1,$2);}
    ;
Def : Specifier DecList SEMI {$$ = CreateSubTree("Def",3,$1,$2,$3);}
    | Specifier error SEMI
    ;
DecList : Dec   {$$ = CreateSubTree("DecList",1,$1);}
    | Dec COMMA DecList {$$ = CreateSubTree("DecList",3,$1,$2,$3);}
    ;
Dec : VarDec {$$ = CreateSubTree("Dec",1,$1);}
    | VarDec ASSIGNOP Exp {$$ = CreateSubTree("Dec",3,$1,$2,$3);}
    ;
Exp : Exp ASSIGNOP Exp {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp AND Exp  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp OR Exp  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp RELOP Exp  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp PLUS Exp  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp MINUS Exp  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp STAR Exp  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp DIV Exp  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | LP Exp RP  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | LP error RP
    | MINUS Exp %prec UMINUS  {$$ = CreateSubTree("Exp",2,$1,$2);}
    | NOT Exp   {$$ = CreateSubTree("Exp",2,$1,$2);}
    | ID LP Args RP {$$ = CreateSubTree("Exp",4,$1,$2,$3,$4);}
    | ID LP error RP
    | ID LP RP  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}
    | Exp LB Exp RB {$$ = CreateSubTree("Exp",4,$1,$2,$3,$4);}
    | Exp DOT ID  {$$ = CreateSubTree("Exp",3,$1,$2,$3);}  
    | ID  {$$ = CreateSubTree("Exp",1,$1);};
    | INT  {$$ = CreateSubTree("Exp",1,$1);}
    | FLOAT  {$$ = CreateSubTree("Exp",1,$1);}
    ;
Args : Exp COMMA Args {$$ = CreateSubTree("Args",3,$1,$2,$3);}
    | Exp  {$$ = CreateSubTree("Args",1,$1);}
    ;
%%
#include"lex.yy.c"
void yyerror(const char* msg)
{
    errorFlag = 1;
    fprintf(stderr, "Error type B at Line %d : %s.\n", yylineno, msg);
    return 0;
}