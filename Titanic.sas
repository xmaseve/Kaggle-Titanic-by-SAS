libname kaggle 'C:\Users\Yi\Desktop\kaggle';

proc import out=kaggle.train
datafile = 'C:\Users\Yi\Downloads\train.csv'
dbms = csv replace;
getnames = yes;
datarows = 2;
run;

proc contents data=kaggle.train;
run;

proc print data=kaggle.train (obs=20);
run;

proc means data=kaggle.train;
run;

proc freq data=kaggle.train;
table sex cabin embarked pclass;
run;

%let var = sex;
%let var = pclass;

proc sgplot data=kaggle.train;
vbar &var / group=survived;
run;

/*antoher way to use sas macro*/

%macro plot(var=);
proc sgplot data=kaggle.train;
vbar &var / group=survived;
run;
%mend plot;

%plot(var=sex)
%plot(var=pclass)

proc format;
value age low - < 20 = 'young'
          20 - < 50 = 'adult'
          50 -  high = 'old';
run;

proc freq data=kaggle.train;
table age;
format age age.;
run;

proc sgplot data=kaggle.train;
vbar age / group=survived;
format age age.;
run;

data missing;
set kaggle.train;
if age = . then output;
run;

proc print data=missing (obs=20);
run;

proc means data=kaggle.train;
class sex;
run;

ata new;
set kaggle.train;
if age = . and sex = 'male' then age = 31;
if age = . and sex = 'female' then age = 28;
format survived yesno.;
run;

proc print data=new (obs=20); 
run;

proc logistic data=new;
	class sex (param=ref ref='female');
	model survived (event='Yes')= sex / clodds=pl;
run;

proc logistic data=new;
	class sex (param=ref ref='female');
	model survived (event='Yes')= sex age/ clodds=pl;
run;

proc logistic data=new;
	class sex (param=ref ref='female')
		  age;
	model survived (event='Yes')= sex age/ clodds=pl;
	format age age.;
run;

proc logistic data=new;
	class sex (param=ref ref='female')
		  age
          pclass (param=ref ref='1');
	model survived (event='Yes')= sex age pclass/ clodds=pl;
	format age age.;
run;

proc logistic data=new plot(only)=(roc oddsratio);
	class sex (param=ref ref='female')
          pclass (param=ref ref='1');
	model survived (event='Yes')= sex | age | pclass @2/ selection=backward clodds=pl;
run;


