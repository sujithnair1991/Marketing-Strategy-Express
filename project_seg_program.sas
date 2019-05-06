
LIBNAME UTD 'C:\sxn180033\Project'; run;


proc import datafile = 'C:\sxn180033\Project\express6.csv'
out=UTD.express6
dbms=CSV;
run;


** KMEANS **;



proc fastclus data = UTD.express6
maxclusters = 6 out = UTD.clus ;
var
std_tenure		  std_age	   std_income_est
std_prop_f_prod    std_PROD_CATEGORY_COUNT    std_up_trans
std_discount_amt    std_clearance_pcnt    std_web
std_spring_prop    std_fall_prop   std_holiday_prop        
std_em_rcvd    std_timeuntil_2    std_timeuntil_3;
run;




** steps: standard -- kmeans -- discrim *;


* note rec and resp *;


proc export data = UTD.clus
DBMS = CSV
outfile = 'C:\sxn180033\Project\clus.csv'
;
run;





* discrim tests for best solution *;

proc discrim data= utd.clus out=utd.output scores = x method=normal anova;
   class cluster ;
   priors prop;
   var  

std_tenure		  std_age	   std_income_est
std_prop_f_prod    std_PROD_CATEGORY_COUNT    std_up_trans
std_discount_amt    std_clearance_pcnt    std_web
std_spring_prop    std_fall_prop   std_holiday_prop        
std_em_rcvd    std_timeuntil_2    std_timeuntil_3;
run;


* when happy, output the means *;

proc sort data = utd.clus; by cluster; run;


proc means data = utd.clus; by cluster; 
output out = utd.means; run;


data utd.means2;
set utd.means;
where _stat_ = 'MEAN';
run;


proc export data = UTD.output
DBMS = CSV
outfile = 'C:\sxn180033\Project\output.csv'
;
run;

proc export data = UTD.means
DBMS = CSV
outfile = 'C:\sxn180033\Project\means.csv'
;
run;

proc export data = UTD.means2
DBMS = CSV
outfile = 'C:\sxn180033\Project\means2.csv'
;
run;






