load data
infile 'C:\group5\seed_list_file_20180817.txt'
replace
into table prod_seed_list_table fields terminated by '|' optionally enclosed by '"'
(PRD_CUSTOMER_NUM,PRD_TITLE,PRD_FIRST_NAME,
PRD_LAST_NAME,PRD_EMAIL,PRD_ADDRESS_LINE1,PRD_ADDRESS_LINE2,
PRD_ADDRESS_LINE3,PRD_CITY,PRD_STATE_CODE,PRD_ZIP_CODE)