%{
#include<stdio.h>
#include<stdlib.h>
#include"syntax.tab.h"
#include"tree.h"
extern int errorFlag;
int yycolumn = 1;
#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; \
    yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng;
%}
%option yylineno
digit [0-9]
digits {digit}*
FLOAT (([1-9]{digits}|0)"."{digits})|((({digits}"."{digit}+)|({digit}+"."{digits}))[Ee][+-]?{digit}+) 
DEC ([1-9]{digit}{0,9}|0)
OCT (0[1-7]([0-7]){0,10}|0)
HEX (0x|0X)([1-9a-fA-F]([0-9a-fA-f]{0,3})|0)
INT {DEC}|{OCT}|{HEX}
SEMI ;
COMMA ,
ASSIGNOP =
RELOP >|<|>=|<=|==|!=
PLUS \+
MINUS -
STAR \*
DIV \/
AND &&
OR \|\|
DOT \.
NOT !
TYPE int|float
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
STRUCT struct    
RETURN return
IF if
ELSE else
WHILE while
ID [_a-zA-Z][_0-9a-zA-Z]*
BLANK " "|(\n)
%%
{FLOAT} {/*printf("token name: FLOAT, attribute: %f\n", atof(yytext));*/yylval.type_tree = CreateTokenNode("FLOAT",yylineno);return FLOAT;}
{INT} {yylval.type_tree = CreateTokenNode("INT",yylineno);return INT;}
{SEMI} {/*printf("token name: SEMI\n");*/yylval.type_tree = CreateTokenNode("SEMI",yylineno);return SEMI;}
{COMMA} {/*printf("token name: COMMA\n");*/yylval.type_tree = CreateTokenNode("COMMA",yylineno);return COMMA;}
{ASSIGNOP} {/*printf("token name: ASSIGNOP\n");*/yylval.type_tree = CreateTokenNode("ASSIGNOP",yylineno);return ASSIGNOP;}
{RELOP} {/*printf("token name: RELOP, attribute: %s\n", yytext);*/yylval.type_tree = CreateTokenNode("RELOP",yylineno); return RELOP;}
{PLUS} {/*printf("token name: PLUS\n");*/yylval.type_tree = CreateTokenNode("PLUS",yylineno);return PLUS;}
{MINUS} {/*printf("token name: MINUS\n");*/yylval.type_tree = CreateTokenNode("MINUS",yylineno);return MINUS;}
{STAR} {/*printf("token name: STAR\n");*/yylval.type_tree = CreateTokenNode("STAR",yylineno);return STAR;}
{DIV} {/*printf("token name: DIV\n");*/yylval.type_tree = CreateTokenNode("DIV",yylineno);return DIV;}
{AND} {/*printf("token name: AND\n");*/yylval.type_tree = CreateTokenNode("AND",yylineno);return AND;}
{OR} {/*printf("token name: OR\n");*/yylval.type_tree = CreateTokenNode("OR",yylineno);return OR;}
{DOT} {/*printf("token name: DOT\n");*/yylval.type_tree = CreateTokenNode("DOT",yylineno);return DOT;}
{NOT} {/*printf("token name: NOT\n");*/yylval.type_tree = CreateTokenNode("NOT",yylineno);return NOT;}
{TYPE} {/*printf("token name: TYPE, attribute: %s\n", yytext);*/yylval.type_tree = CreateTokenNode("TYPE",yylineno); return TYPE;}
{LP} {/*printf(/*"token name: LP\n");*/yylval.type_tree = CreateTokenNode("LP",yylineno);return LP;}
{RP} {/*printf("token name: RP\n");*/yylval.type_tree = CreateTokenNode("RP",yylineno);return RP;}
{LB} {/*printf("token name: LB\n");*/yylval.type_tree = CreateTokenNode("LB",yylineno);return LB;}
{RB} {/*printf("token name: RB\n");*/yylval.type_tree = CreateTokenNode("RB",yylineno);return RB;}
{LC} {/*printf("token name: LC\n");*/yylval.type_tree = CreateTokenNode("LC",yylineno);return LC;}
{RC} {/*printf("token name: RC\n");*/yylval.type_tree = CreateTokenNode("RC",yylineno);return RC;}
{STRUCT} {/*printf("token name: STRUCT\n");*/yylval.type_tree = CreateTokenNode("STRUCT",yylineno);return STRUCT;}
{RETURN} {/*printf("token name: RETURN\n");*/yylval.type_tree = CreateTokenNode("RETURN",yylineno);return RETURN;}
{IF} {/*printf("token name: IF\n");*/yylval.type_tree = CreateTokenNode("IF",yylineno);return IF;}
{ELSE} {/*printf("token name: ELSE\n");*/yylval.type_tree = CreateTokenNode("ELSE",yylineno);return ELSE;}
{WHILE} {/*printf("token name: WHILE\n");*/yylval.type_tree = CreateTokenNode("WHILE",yylineno);return WHILE;}
{ID} {/*printf("token name: ID, attribute: %s\n", yytext);*/yylval.type_tree = CreateTokenNode("ID",yylineno); return ID;}
\n {yycolumn = 1;}
{BLANK} {}
. {printf("Error type A at Line %d: Mysterious characters \'%s\'.\n",yylineno,yytext);errorFlag = 1;}
%%
/*int main()
{
    while(yylex() != 0);
    return 0;
}*/
