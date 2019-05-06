


* Influential Observations;


libname collin 'C:\sxn180033\Project'; run;


*Identifying influential observation in clus1;

proc reg data = collin.clus1;
model QTY = cluster PRICE DISCOUNT_AMT age size_hh	income_est	TENURE	sales_prop	spring_prop	fall_prop	holiday_prop clearance_pcnt	PROD_CATEGORY_COUNT	 pcnt_m_casual_bottoms	pcnt_m_knits	pcnt_m_shirts	pcnt_m_suits	pcnt_w_denim	pcnt_w_dress	pcnt_w_knit_tops	pcnt_w_pants	pcnt_w_sweaters	pcnt_w_woven_tops	prop_f_prod	product_category_count	em_received_ty	dm_received_ty	up_trans	management_occ	technical_occ	professinal_occ	sales_occ	officeadmin_occ	bluecollar_occ	farmer_occ	retired_occ	EDUC_YEARS	MARRIED	LENGTH_OF_RESIDENCE	;
output out = collin.resid p = PUNITS r = RUNITS student = student;
run;quit;

*Deleting influential observation and placing data in clus3;

data collin.clus3;
set collin.resid;
if student > 3.00 then delete;
if student < -3.00 then delete;
run;

* Collinearity Diagnostics /Correction(s);

proc corr data = collin.clus; 
var QTY cluster PRICE DISCOUNT_AMT age size_hh	income_est	TENURE	sales_prop	spring_prop	fall_prop	holiday_prop clearance_pcnt	PROD_CATEGORY_COUNT	 pcnt_m_casual_bottoms	pcnt_m_knits	pcnt_m_shirts	pcnt_m_suits	pcnt_w_denim	pcnt_w_dress	pcnt_w_knit_tops	pcnt_w_pants	pcnt_w_sweaters	pcnt_w_woven_tops	prop_f_prod	product_category_count	em_received_ty	dm_received_ty	up_trans	management_occ	technical_occ	professinal_occ	sales_occ	officeadmin_occ	bluecollar_occ	farmer_occ	retired_occ	EDUC_YEARS	MARRIED	LENGTH_OF_RESIDENCE	;; run;

proc reg data = collin.clus2;
model QTY = cluster neg PRICE DISCOUNT_AMT age size_hh	income_est	TENURE	sales_prop	spring_prop	fall_prop	holiday_prop clearance_pcnt	PROD_CATEGORY_COUNT	 pcnt_m_casual_bottoms	pcnt_m_knits	pcnt_m_shirts	pcnt_m_suits	pcnt_w_denim	pcnt_w_dress	pcnt_w_knit_tops	pcnt_w_pants	pcnt_w_sweaters	pcnt_w_woven_tops	prop_f_prod	product_category_count	em_received_ty	dm_received_ty	up_trans	management_occ	technical_occ	professinal_occ	sales_occ	officeadmin_occ	bluecollar_occ	farmer_occ	retired_occ	EDUC_YEARS	MARRIED	LENGTH_OF_RESIDENCE	 /VIF COLLIN;
run;quit;

*******************************************;
* elasticity modeling *;




*Sorting data in clus3 to group by cluster;

proc sort data = collin.clus3; by cluster; run;


*Means qty and price of each cluster in clus3 to idenify current revenue;

proc means data = collin.clus3;
by cluster;
var qty price; run;


*Clusterwise regression olus3;

proc reg data = collin.clus3;
model QTY = cluster PRICE DISCOUNT_AMT age size_hh	income_est	TENURE	sales_prop clearance_pcnt	PROD_CATEGORY_COUNT	 pcnt_m_casual_bottoms	pcnt_m_knits	pcnt_m_shirts	pcnt_m_suits	pcnt_w_denim	pcnt_w_dress	pcnt_w_knit_tops	pcnt_w_pants	pcnt_w_sweaters	pcnt_w_woven_tops	prop_f_prod	product_category_count	em_received_ty	dm_received_ty	up_trans	management_occ	technical_occ	professinal_occ	sales_occ	officeadmin_occ	bluecollar_occ	farmer_occ	retired_occ	EDUC_YEARS	MARRIED	;
by cluster;
output out = resid2 p = PUNITS r = RUNITS student = student;
run;quit;










*******************************************;
* marcom value *;


proc reg data = collin.marcom;
model revenue = em1 em2 sms dm/vif collin;
output out = marcom_resid p = Prev r = Rrev student = student;
run;quit;


proc means data = collin.marcom; run;



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


