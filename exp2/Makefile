CC = gcc
CFLAGS = -std=c99

parser: syntax.tab.c tree.c main.c tree.c
	$(CC) main.c syntax.tab.c tree.c -lfl -ly -o parser
syntax.tab.c:syntax.y lex.yy.c
	bison -d syntax.y
lex.yy.c:lexical.l
	flex lexical.l

.PHONY:clean
clean:
	rm -f $(target)
	rm -f syntax.tab.h syntax.tab.c syntax.output lex.yy.c

