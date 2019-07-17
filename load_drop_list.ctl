load data
infile 'C:\group5\drop_list_file_20180817.txt'
replace
into table prod_inbd_drop_list_table fields terminated by '|' optionally enclosed by '"'
(prd_customer_num)