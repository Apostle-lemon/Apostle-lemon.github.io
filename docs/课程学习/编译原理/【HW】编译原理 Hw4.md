# 编译原理 Hw4

```
prog: stm

stm : stm SEMICOLON stm
    | ID ASSIGN exp            {update(&table, ID, $3);}
    | PRINT LPAREN exps RPAREN { printf("\n"); }


exps: exp                       {printf("%d ", $1);}
    | exps COMMA exp            {printf("%d ", $3);}


exp : INT { printf("%d ", $1); }
    | ID { $$ = lookup(table, $1); }
    | exp PLUS exp { $$ = $1 + $3; }
    | exp MINUS exp { $$ = $1 - $3; }
    | exp TIMES exp { $$ = $1 * $3; }
    | exp DIV exp { $$ = $1 / $3; }
    | LPAREN exp RPAREN { $$ = $2; }
```

首先构造三个集合

|      | nullable | first           | follow                                       |
| ---- | -------- | --------------- | -------------------------------------------- |
| PROG |          | ID,PRINT        | $                                            |
| STM  |          | ID,PRINT        | SEMICOLON                                    |
| EXPS |          | INT, ID, LPAREN | COMMA, RPAREN                                |
| EXP  |          | INT, ID, LPAREN | COMMA,PLUS, MINUS, TIMES, DIV, RPA,SEMICOLON |

```c
enum token{
INT,ID,PLUS,MINUS,TIMES,DIV,ASSIGN,SEMICOLON,COMMA,LPAREN,RPAREN,PRINT
}

typedef struct table *Table_;
Table_ {string id; int value; Table_ tail;};
Table_ Table(string id, int value, struct table *tail);
Table_ table = NULL;

int lookup(Table_ table, string id) {
    assert(table != NULL);
    if (id == table.id)
        return table.value;
    else
        return lookup(table.tail, id);
}

void update(Table_ *tabptr, string id, int value) {
    *tabptr = Table(id, value, *tabptr);
}

int S_list_FOLLOW = {'$'};
void S_list()
{
    S();
    eatOrSkipTo(SEMICOLON, S_list_FOLLOW);
    if (tok != '$')
    {
        S_list();
    }
}

int S_FOLLOW[]={SEMICOLON}
void S(void){
    switch(tok){
	    case ID: {
			string id = tokval.id;
			if(lookahead()==ASSIGN){
				advance();
				update(table,id,E());	
			}
			skipto(S_FOLLOW);
			break;
	    }
	    case PRINT:{
		    advance(); // (
			L();
			advance(); // )
		    break;
	    }
	    default:{
		    print("wrong")
		    skipto(S_FOLLOW)
	    }
    }
}

int L_FOLLOW[] = {COMMA, RPAREN};
void L()
{
	switch(tok){
		case ID:
		case INT:{
			printf("%d",E());
			break;
		}
		default:{
			printf("wrong in L");
			skipto(L_FOLLOW);
		}
	}
}

int E_FOLLOW[] = {COMMA,PLUS, MINUS, TIMES, DIV, RPA,SEMICOLON}
int E()
{
	switch(tok){
		case ID:{
			int i = lookup(table, tokval.id);
			int symbol = lookahead()
			if(symbol == PLUS || symbol == MINUS || symbol == TIMES || symbol == DIV){
				return B(i);
			}
			return i;	
		}
		case INT:{
			int i = tokval.num;
			int symbol = lookahead();
			if(symbol == PLUS || symbol == MINUS || symbol == TIMES || symbol == DIV){
				return B(i);
			}
			return i;
		}
		case LPAREN:{
			int i = E();
			adcance(); // )
			return i;
		}
		default:{
			printf("some thing went wrong in E()");
			skipto(E_FOLLOW);
			return 0;
		}
	}
}

int B_FOLLOW = {ID,INT,LPAREN}
int B(int a){
	switch(tok){
		case PLUS:{
			return a+E();
		}
		case MINUS:{
			return a-E();
		}
		case TIMES:{
			return a*E();
		}
		case DIV:{
			return a/E();
		}
		default:{
			printf("something went wrong in B");
			skipto(B_FOLLOW);
			return 0;
		}
	}
}

void eatOrSkipTo(int expected, int *stop)
{
    if (tok == expected)
        eat(expected);
    else
        skipto(stop);
}
```
