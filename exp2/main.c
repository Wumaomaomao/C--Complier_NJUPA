#include<stdio.h>
#include"syntax.tab.h"
#include"tree.h"
extern FILE* yyin;
extern int yylex(void);
struct Tree * AST;
int errorFlag;

int main(int argc, char** argv)
{
    // if (argc > 1){
    //     if (!(yyin = fopen(argv[1],"r")))
    //     {
    //         perror(argv[1]);
    //         return 1;
    //     }
    // }
    if (argc <= 1) return 1;
    FILE * f = fopen(argv[1], "r");
    AST = NULL;
    errorFlag = 0;
    if (!f)
    {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yyparse();
    /*print the AST result*/
    if (!errorFlag)
    {
        ShowTree(AST, 0);
    }
    
    return 0;
}