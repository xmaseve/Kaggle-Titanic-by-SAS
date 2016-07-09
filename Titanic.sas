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

data new (drop=sex embarked);
set kaggle.train;
if age = . and sex = 'male' then age = 31;
if age = . and sex = 'female' then age = 28;
if sex = 'male' then gender = 0;
else gender = 1;
if embarked = 'Q' then embark = 0;
else if embarked = 'S' then embark = 1;
else embark = 2;
run;

proc print data=new (obs=20); run;

proc logistic data=new;
model survived = gender age pclass;
run;

