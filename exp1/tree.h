#ifndef TREE
#define TREE


#define TYPE_ID 0

#define TYPE_VARIABLE 1
#define TYPE_TOKEN 2 

#define TYPE_TYPE 3
#define TYPE_INT 4
#define TYPE_FLOAT 5
#define TYPE_RELOP 6

struct Tree
{
    char * name;
    int lineno;

    /*Tree Node Type : variable or int, id ... defined in tree.h*/
    int type;

   /*attribute*/
    int int_attr;
    char * char_attr;
    float float_attr;
    
    struct Tree * next;
    struct Tree * child;
};

/*Specially, Create root for AST*/
struct Tree * CreateTree(struct Tree * ExtDefList);

/*Create SubTree for any production*/
struct Tree * CreateSubTree(const char * name, int branch,...);

/*Create terminals' Node (Tokens' Node)*/
struct Tree * CreateTokenNode(char * name, int yylineno);
  
void CopyString(char ** dst , const char * src);

/*Display the tree*/
void ShowTree(struct Tree * root, int layer);

void PrintTreeNode(struct Tree * node, int layer);

#endif