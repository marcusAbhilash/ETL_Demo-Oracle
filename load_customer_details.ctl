load data
infile 'C:\group5\customer_input_file_20180817.txt'
replace
into table stg_inbd_customer fields terminated by '|' optionally enclosed by '"'
(STG_CUSTOMER_NUM,STG_TITLE,STG_FIRST_NAME,STG_LAST_NAME,STG_EMAIL)