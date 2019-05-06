

libname utd 'C:\school\SCHOOL\6337 spring 2019\wk08';
run;


*********** LOGIT ******************;
************************************;

libname summer 'C:\mgrigsby\Other\school\UTD\Marketing Analytics Summer 2016\WK05 JUN 27'; run;
libname utd 'C:\mgrigsby\Other\school\UTD\Marketing Analytics Fall 2016\wk 06 09 30'; run;


proc sort data = utd.logit_data_062016; by custid; run;

proc sort data = utd.logit_demo_062016; by custid; run;

data logit_merge;
merge utd.logit_data_062016 utd.logit_demo_062016; 
by custid; run;




data logit;
set logit_merge;
purch = 0;
if purch_amt > 0 then purch = 1;
run;


proc means data = logit; run;


proc logistic descending data = logit;
model purch = dm em1 em2 hhincome/  
ctable; 
output out = logit_pred p = phat;
run;


** to cmpare to logit remove DESCENDING **;

** catmod *;


proc catmod data=logit;
direct dm em1 em2 hhincome;
model purch = dm em1 em2 hhincome /  covb corrb ;
quit;


** probit **;

proc probit data=logit;
model purch = dm em1 em2 hhincome/ d = logistic;
run;

** probit **;


proc probit data=logit;
model purch = dm em1 em2 hhincome;
run;

*** lift chart /gains table ;

proc sort data = logit_pred; 
by phat; run;


proc rank data=logit_pred 
out=ranks (keep = phat purch) 
groups = 10 descending ties=low; 
var phat;
run;


proc sort data = ranks; 
by phat; run;


proc means data = ranks noprint;
by phat; output out = means; run;



data means2;
set means;
where _stat_ = 'MEAN';
run;

****;
* market basket ;


data products;
set logit_merge;
logit_a = 0; logit_b = 0; logit_c = 0; logit_d = 0; logit_e = 0;
if proda > 0 then logit_a = 1;
if prodb > 0 then logit_b = 1;
if prodc > 0 then logit_c = 1;
if prodd > 0 then logit_d = 1;
if prode > 0 then logit_e = 1;
run;


proc means data = products;
var logit_a logit_b logit_c logit_d logit_e;
run;


proc logistic descending data = products;
model logit_b = logit_a logit_c logit_d logit_e hhsize hhincome em1 em2 dm sms; run;


**************************;


