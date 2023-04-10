#include"SymbolTable.h"
#include"tree.h"
#include<string.h>
#include<stdio.h>
#include<assert.h>

/*Variable symbol table*/
Hashbucket VarSymbolTable[MAX_SIZE];
/*Function symbol table*/
Hashbucket FuncSymbolTable[MAX_SIZE];
/*Struct defination symbol table*/
Hashbucket StructDefSymbolTable[MAX_SIZE];

// Program : ExtDefList 
void Program(struct Tree * root)
{
    assert(!strcmp(root->name,"Program"));
    assert(!strcmp(root->child->name,"ExtDefList"));
    // printf("debug: schedule Program analysis\n");
    ExtDefList(root->child);
}

// ExtDefList : /*empty*/
//     | ExtDef ExtDefList
//     ;
void ExtDefList(struct Tree * Node)
{
    assert(!strcmp(Node->name,"ExtDefList"));
//     | ExtDef ExtDefList
    if (Node->child != NULL)
    {
        ExtDef(Node->child);
        ExtDefList(Node->child->next);
    }
}
