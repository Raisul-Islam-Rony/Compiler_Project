%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	#include<string.h>

	int yylex();
	
    char var_table[1000][1000];
	
    int var_val[1000];
	int index=1;
	
	int isDeclared(char *now){
		for(int i=1;i<index;i++){
			if(strcmp(var_table[i],now)==0){
				return i; 
			}
		}
		return 0;
	}
	int save_val(char *now){
		if(isDeclared(now)!=0)return 0;
		strcpy(var_table[index],now);
		var_val[index]=0;
		index++;
        return 1;
	}

 
	
	int set_val(char *now,int v){
		int id = isDeclared(now);
        if(id==0)
        {
            return 0;
        }
        else
        {
            var_val[id]=v;
        }

        return 1;
    }
%}

%union{
	char text[1000];
	int num;
}

%token<num>NUMBER
%token<text>VAR
%token INTEGER CHAR FLOAT DOUBLE ADD MUL SUB DIV MOD BIGGER LESSER POW SIN COS TAN DISPLAY IF ELSE ELIF WHILE LOOP FACT PRIME
%token SWITCH CASE DEFAULT CheckEven
%type<num>expression
%type<num>statement
%nonassoc IFX
%nonassoc ELIF
%nonassoc ELSE
%left ADD SUB
%left MUL DIV
%left LESSER BIGGER


%%



program: /* NULL */

	| program statement ';'
	;

statement: 			
	| declaration 		

	| expression 			{   printf("value of expression: %d\n", $1); $$=$1;
		printf("\n\n");
		}
	
	| VAR '=' expression  { 
                           
                                printf("\nValue of %s : %d\n",$1,$3);
							set_val($1,$3);
							
							$$=$3;
							printf("\n\n");
                                
                            
							
						} 
    | DISPLAY '(' expression ')'  {printf("\nPrint Expression %d\n",$3);
		printf("\n\n");}

		| IF '(' expression ')' '{' statement '}' %prec IFX {
								if($3){
									printf("\n Condition True: %d\n",$6);
								}
								else{
									printf("\nCondition False \n");
								}
								printf("\n\n");
							}

	| IF '(' expression ')' '{' statement  '}' ELSE '{' statement '}'  {
								if($3){
									printf("If Block Executed : %d\n",$6);
								}
								else{
									printf("Else block Executed: %d\n",$10);
								}
								printf("\n\n");
							}
	| IF '(' expression ')' '{' statement  '}' ELIF '(' expression ')' '{' statement '}' ELSE '{' statement '}' {
									if($3){
									printf("If Block Executed : %d\n",$6);
								}
								else if($10){
									printf("ElseIf Block Executed : %d\n",$13);
								}
								else{
									printf("ELSE block executed : %d\n",$17);
								}
								printf("\n\n");
	}
	| WHILE '(' NUMBER '<' NUMBER ')' '{' statement '}' {
	                                int i;
	                                printf("WHILE Loop execution\n");
									i=$3;
									while(i<$5)
									{
										printf("Value of i : %d\n",i);
										++i;
									}

									printf("\n\n");
	                               
	                                								
				               }


		| WHILE '(' NUMBER '>' NUMBER ')' '{' statement '}' {
	                                int i;
	                                printf("WHILE Loop execution\n");
									i=$3;
									while(i>$5)
									{
										printf("Value of i : %d\n",i);
										--i;
									}

									printf("\n\n");
	                               
	                                								
				               }

			| LOOP '(' NUMBER ',' NUMBER ','NUMBER ')' '{' statement '}' {
					int k = $3;
					
					printf("For Loop Execution Started\n\n");

					for(k=$3; k<= $5; k=k+$7)
					{
						printf("Value of k : %d\n",k);
					}
			}

			| FACT '('NUMBER ')' {
				int i=1;
				int sum=1;

				for(int i=1; i<=$3; i++)
				{
					sum=sum*i;
				}

				printf("Factorial of %d is %d \n\n",$3, sum);
			}
			| PRIME '('NUMBER ')' {
				int f=0;
				for(int i=1; i<$3; i++)
				{
					if($3%i==0)
					{
						printf("%d Not a prime Number\n",$3);
						f=1;
						break;
					}
				}
				if(!f)
				{
					printf("%d Is a Prime Number\n\n ",$3);
				}

				

			}

			| CheckEven '('NUMBER ')' {
				if($3%2==0)
				{
					printf("%d Is Even",$3);
				}
				else
				{
					printf("%d Is ODD",$3);
				}
			}
			


	

	


declaration : TYPE ID1   {printf("\nIdentifier Declaration\n");
		printf("\n\n");}
            ;


TYPE : INTEGER   {printf("Interger declaration\n");}
     | FLOAT  {printf("Float declaration\n");}
     | CHAR   {printf("Char declaration\n");}
     ;


     
ID1 : ID1 ',' VAR {
	int res = save_val($3);
		if(res== 0){
			printf("Compilation Error :: Variable already declared\n");
			exit(-1);
		}
	} 
    |VAR {
		int res = save_val($1);
		if(res == 0){
			printf("Compilation Error :: Variable already declared\n");
			exit(-1);
		}
	}  

expression: NUMBER					{  $$ = $1;  }

	| VAR						{ 
    
                                    int p=isDeclared($1);
                                    if(p==0)
                                    {
                                        printf("Variable %s Yet Not Declared\n",$1);
                                        exit(-1);
                                    }
                                    else
                                    {
                                        $$=var_val[p];
                                    }
    
                                                 }
    | expression POW expression	{printf("\nPower  :%d ^ %d \n",$1,$3);  $$ = pow($1 , $3);}

	| expression LESSER expression	{printf("\nLess Than :%d < %d \n",$1,$3); $$ = $1 < $3 ; }
	
	| expression BIGGER expression	{printf("\nGreater than :%d > %d \n ",$1,$3); $$ = $1 > $3; }

    | expression ADD expression	{printf("\nAddition :%d + %d = %d \n",$1,$3,$1+$3 );  $$ = $1 + $3;}

	| expression SUB expression	{printf("\nSubtraction :%d-%d=%d \n ",$1,$3,$1-$3); $$ = $1 - $3; }

	| expression MUL expression	{printf("\nMultiplication :%d*%d \n ",$1,$3,$1*$3); $$ = $1 * $3; }

	| expression DIV expression	{ if($3){
				     					printf("\nDivision :%d/%d \n ",$1,$3,$1/$3);
				     					$$ = $1 / $3;
				     					
				  					}
				  					else{
										$$ = 0;
										printf("\nDivision by zero\n");
				  					} 	
				    			}
	| expression MOD expression	{ if($3){
				     					printf("\nMod :%d % %d \n",$1,$3,$1 % $3);
				     					$$ = $1 % $3;
				     					
				  					}
				  					else{
										$$ = 0;
										printf("\nMOD by zero\n");
				  					} 	
				    			}
	| SIN expression 			{printf("Value of Sin(%d) is : %lf\n",$2,sin($2*3.1416/180)); $$=sin($2*3.1416/180);}

    | COS expression 			{printf("Value of Cos(%d) is : %lf\n",$2,cos($2*3.1416/180)); $$=cos($2*3.1416/180);}

	|TAN expression              {printf("Value od Tan(%d) is : %lf\n",$2, tan($2*3.1416/180)); $$=tan($2*3.1416/180);}








%%

int  yyerror(char *s){
	printf( "%s\n", s);
}

int yywrap()
{
	return 1;
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();

    
	return 0;
}
