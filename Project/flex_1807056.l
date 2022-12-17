
%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "bison_1807056.tab.h"
%}

variable [a-zA-Z]+
digit[0-9]


%%
{digit}+	{yylval.num = atoi(yytext); return NUMBER; }
"INTEGER"  			{return INTEGER;}
"CHAR" 		     	{return CHAR;}
"DOUBLE"            {return DOUBLE;}
"FLOAT"			 	{return FLOAT;}
"ADD"               {return ADD;}

"SUB"			 	{return SUB ;}
"MUL" 				{ return MUL;}
"DIV"				{ return DIV;}
"MOD"    			{return MOD ;}
"="               	{return *yytext;}
";"            		{return *yytext;}
"POW" 				{return POW;}
"BIGGER" 			{return BIGGER;}
"LESSER" 			{return LESSER;}			
"DISPLAY"			{return DISPLAY;}
"SIN"		   		{return SIN;}
"COS"          		{return COS;}
"TAN"               { return TAN;}
"{"					{return *yytext;}
"}"                 {return *yytext;}
"("                 {return *yytext;}
")"                 {return *yytext;}
"If" 		  {return IF;}
"Else" 		  {return ELSE;}
"Elif"        {return ELIF;}
"WHILE"		   {return WHILE;}
"<"            {return *yytext;}
">"            {return *yytext;}
"LOOP"         {return LOOP;}
[,]             {return *yytext;}
[:]             {return *yytext;}





{variable}	    {printf("Variable Found %s \n",yytext); strcpy(yylval.text,yytext); return	VAR; }

[\n]*	
[ ]*
.						{printf("\nUnknown syntax : %s\n",yytext);}
%%






