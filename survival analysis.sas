
libname sa 'G:\TOSHIBA EXT\HOME\OS\SCHOOL\6337 spring 2019\wk09'; run;


libname sa 'C:\mgrigsby\Other\school\UTD\Marketing Analytics Fall 2015\w08 Oct 16'; run;

libname fall 'C:\mgrigsby\Other\school\UTD\Marketing Analytics Fall 2016\wk 08 10 14'; run;

libname sa 'C:\B+P\school\UTD\Marketing Analytics Summer 2017\wk 07'; run;



data sa_data;
set sa.sa;
censored = 0;
if tt1st_purch > 0 then censored = 1;
run;



proc lifereg data = sa_data;
model tt1st_purch*censored(0) =
discount dir_mail email1 hh_size hh_income
 
/dist = exponential;
output out = output p=median std = s; 
*where seg = 2;
run;


* distribution choices;
* gamma llogistic lnormal weibull exponential ;

proc means data = output; run;

