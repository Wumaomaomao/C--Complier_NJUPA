#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stdarg.h>

#include"tree.h"

extern char * yytext;
extern struct Tree * AST;

struct Tree * CreateTokenNode(char * name, int yylineno)
{
    // printf("Create Token node: %s, yytext = %s\n", name, yytext);
    fflush(stdout);

    struct Tree * TreeNode = malloc(sizeof(struct Tree));
    TreeNode->child = NULL;
    TreeNode->next = NULL;

    /*Create Identifier Token Tree Node*/
    if (!strcmp("ID", name))
    {
        /*init name*/
        CopyString(&TreeNode->name, "ID");

        /*Node type*/
        TreeNode->type = TYPE_ID;

        /*init attribute value*/
        CopyString(&TreeNode->char_attr,yytext);
        
        TreeNode->lineno = yylineno;
    
    }
    else if (!strcmp("TYPE",name))
    {
        CopyString(&TreeNode->name, "TYPE");

        /*Node type*/
        TreeNode->type = TYPE_TYPE;
        CopyString(&TreeNode->char_attr, yytext);
        
        TreeNode->lineno = yylineno;
        // printf("Create TYPE token: %s\n", TreeNode->char_attr);
    }
    else if (!strcmp("INT", name))
    {
        CopyString(&TreeNode->name, "INT");

        /*Node type*/
        TreeNode->type = TYPE_INT;
        TreeNode->int_attr = atoi(yytext);
        
        TreeNode->lineno = yylineno;
        // printf("Create TYPE token: %s\n", TreeNode->char_attr);        
    }
    else if (!strcmp("FLOAT",name))
    {
       CopyString(&TreeNode->name, "INT");

        /*Node type*/
        TreeNode->type = TYPE_FLOAT;
        TreeNode->float_attr = atof(yytext);
        
        TreeNode->lineno = yylineno;        
    }
    else if (!strcmp("RELOP",name))
    {
        CopyString(&TreeNode->name, name);

        /*Node type*/
        TreeNode->type = TYPE_RELOP;
        CopyString(&TreeNode->char_attr,yytext);
        
        TreeNode->lineno = yylineno;        
    }   
    else
    {
        /*init name*/
        CopyString(&TreeNode->name, name);

        /*Node type*/
        TreeNode->type = TYPE_TOKEN;
        
        TreeNode->lineno = yylineno;
    }     

    return TreeNode;
}

struct Tree * CreateTree(struct Tree * ExtDefList)
{
    // printf("Create Tree root\n");
    AST = malloc(sizeof(struct Tree));

    AST->next= NULL;
    AST->child = ExtDefList;
    CopyString(&AST->name,"Program");
    AST->lineno = ExtDefList->lineno;
    AST->type = TYPE_VARIABLE;

    return AST;
}
/*
    I choose a way to let n-Tree to be constructed by the 2-Tree 
    be like the precise graph:  :)
    ============================================================
    root
    |
    | (Tree * child)
    |
    |           (Tree * next)                
    firstchild-------secondchild---------...(other children)
    |                     |                                                        
    |                   ....
    |
    children...
    |
    |
    ...
    =============================================================
*/
struct Tree * CreateSubTree(const char * name, int branch, ...)
{
    // printf("Create SubTree root: %s\n", name);
    struct Tree * root = malloc(sizeof(struct Tree));
    CopyString(&root->name, name);
    root->type = TYPE_VARIABLE;

    /*child parameter*/
    va_list para;
    va_start(para, branch);

    struct Tree * pre = NULL;
    struct Tree * cur = NULL;
    // printf("debug1\n");
    fflush(stdout);
    for (int i = 0; i < branch; ++ i)
    {
        if (pre == NULL)
        {
            // printf("debug2\n");
            fflush(stdout);
            /*first child directly connected to the root*/
            cur = va_arg(para, struct Tree*);
            if (cur == NULL)
            {
                // printf("root: %s, child is NULL\n", root->name);
                fflush(stdout);
                
                continue;
            }
            fflush(stdout);
            // printf("    add child : %s\n", cur->name);
            fflush(stdout);
            root->child = cur;
            pre = cur;
            /*inherient the line No.*/
            root->lineno = cur->lineno;
        }
        else
        {
            /*so other children will append to the tail*/
            // printf("    add child : %s\n", cur->name);
            fflush(stdout);
            cur = va_arg(para, struct Tree*);
            if (cur == NULL)
            {
                // printf("root: %s, child is NULL\n", root->name);
                continue;
            }
            pre->next = cur;
            pre = cur;
        }
    }

//    ShowTree(root,0);
    return root;
}

void ShowTree(struct Tree * root, int layer)
{
    if (root != NULL)
    {
        PrintTreeNode(root, layer);
        // if (!strcmp(root->name,"ExtDef"))
        // {
        //     struct Tree * p = root->child;
        //     printf("ExtDef child: ");
        //     while(p != NULL)
        //     {
        //         printf("%s ",p->name);
        //         p = p->next;
        //     }                        
        // }
        // if (!strcmp(root->name,"FunDec"))
        // {
        //     printf("debug: layer = %d\n", layer);
        // }
        struct Tree * p = root->child;
        while(p != NULL)
        {
            ShowTree(p, layer+1);
            p = p->next;
        }
    }
}

void PrintTreeNode(struct Tree * Node, int layer)
{
    for (int i = 0; i < layer; ++ i)
    {
        printf("  ");
    }
    switch (Node->type)
    {
    case TYPE_ID:
    {
        printf("ID: %s\n", Node->char_attr);
        break;
    }
    case TYPE_VARIABLE:
    {
        printf("%s (%d)\n",Node->name,Node->lineno);
        break;
    }
    case TYPE_TOKEN:
    {
        printf("%s\n", Node->name);
        break;
    }
    case TYPE_INT:
    {
        printf("INT: %d\n",Node->int_attr);
        break;
    }
    case TYPE_FLOAT:
    {
        printf("FLOAT: %f\n",Node->float_attr);
        break;        
    }
    case TYPE_RELOP:
    {
        printf("%s\n",Node->name);
        break;             
    }
    case TYPE_TYPE:
    {
        printf("TYPE: %s\n",Node->char_attr);
        break;          
    }
        /* code */
        break;
    
    default:
        printf("ALARM: NULL TOKEN\n");
        break;
    }
}

void CopyString(char ** dst, const char * src)
{
    *dst = malloc(strlen(src) + 1);
    strcpy(*dst, src);
    // printf("debug: src: %s, dst : %s\n", src, dst);
}
