#ifndef SYMBOL_TABLE
#define SYMBOL_TABLE

/*Maxsize of hashtable :) */
#define MAX_SIZE 0x3fff

//from NJU complier PA project2's handbook, thanks
typedef struct Type_* Type;
typedef struct FieldList_* FieldList;

struct Type_
{
    enum { BASIC, ARRAY, STRUCTURE } kind;
    union
    {
    // 基本类型
    int basic;
    // 数组类型信息包括元素类型与数组大小构成
    struct { Type elem; int size; } array;
    // 结构体类型信息是一个链表
    FieldList structure;
    } u;
};

struct FieldList_
{
    char* name; // 域的名字
    Type type; // 域的类型
    FieldList tail; // 下一个域
};

/*Symbol Table Entry*/
typedef struct TableEntry
{
    /*Three types of entry*/
    enum {VAR, FUNC, STRUCT_DEF} entryType;


    /*name of VAR, FUNC, STRUCT_DEF*/
    char* name;
    /*Type attrubute*/
    Type type;


    /*next entry followed the Hashbucket*/
    struct TableEntry * bucketnext;
    /*next entry followed the ScopeStack, wait to finish...*/
    //struct TableEntry * stacknext;

    /*judge the function whether defined, wait to finish*/
    //int defined;
} TableEntry;

typedef struct Hashbucket
{
    int size;
    TableEntry * firstTableEntry;
    /*init*/
    
}Hashbucket;

int hash_pjw(char* name);
#endif