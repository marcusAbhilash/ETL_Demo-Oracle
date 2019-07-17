load data
infile 'C:\group5\address_input_file_20180817.txt'
replace
into table stg_inbd_address fields terminated by '|' optionally enclosed by '"'
(STG_CUSTOMER_NUM,STG_ADDR1,STG_ADDR2,STG_ADDR3,STG_CITY,STG_STATE_CODE,STG_ZIP_CODE)