%{
#include<stdio.h>
#include<stdlib.h>
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
{FLOAT} {printf("token name: FLOAT, attribute: %f\n", atof(yytext));}
{OCT} {printf("token name: OCT, attribute: %o\n", atoi(yytext));}
{DEC} {printf("token name: DEC, attribute: %d\n", atoi(yytext));}
{HEX} {printf("token name: HEX, attribute: %x\n", atoi(yytext));}
{SEMI} {printf("token name: SEMI\n");}
{COMMA} {printf("token name: COMMA\n");}
{ASSIGNOP} {printf("token name: ASSIGNOP\n");}
{RELOP} {printf("token name: RELOP, attribute: %s\n", yytext);}
{PLUS} {printf("token name: PLUS\n");}
{MINUS} {printf("token name: MINUS\n");}
{STAR} {printf("token name: STAR\n");}
{DIV} {printf("token name: DIV\n");}
{AND} {printf("token name: AND\n");}
{OR} {printf("token name: OR\n");}
{DOT} {printf("token name: DOT\n");}
{NOT} {printf("token name: NOT\n");}
{TYPE} {printf("token name: TYPE, attribute: %s\n", yytext);}
{LP} {printf("token name: LP\n");}
{RP} {printf("token name: RP\n");}
{LB} {printf("token name: LB\n");}
{RB} {printf("token name: RB\n");}
{LC} {printf("token name: LC\n");}
{RC} {printf("token name: RC\n");}
{STRUCT} {printf("token name: STRUCT\n");}
{RETURN} {printf("token name: RETURN\n");}
{IF} {printf("token name: IF\n");}
{ELSE} {printf("token name: ELSE\n");}
{WHILE} {printf("token name: WHILE\n");}
{ID} {printf("token name: ID, attribute: %s\n", yytext);}
{BLANK} {}
. {printf("Error type A at Line %d: Mysterious characters \'%s\'\n",yylineno,yytext);}
%%
/*int main()
{
    while(yylex() != 0);
    return 0;
}*/
