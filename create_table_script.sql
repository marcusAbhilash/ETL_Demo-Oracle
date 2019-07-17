--Stage customer table
create table stg_inbd_customer(
STG_CUSTOMER_NUM number(9),
STG_TITLE VARCHAR2(10),
STG_FIRST_NAME VARCHAR2(250),
STG_LAST_NAME VARCHAR2(250),
STG_EMAIL varchar2(250)
);



--Stage address table
create table stg_inbd_address (
STG_CUSTOMER_NUM number(9),
STG_ADDR1 varchar2(250),
STG_ADDR2 varchar2(250),
STG_ADDR3 varchar2(250),
STG_CITY varchar2(100),
STG_STATE_CODE varchar2(5),
STG_ZIP_CODE varchar2(5)
);



--Production drop table
create table prod_inbd_drop_list_table(
PRD_CUSTOMER_NUM number(9)
);

--Production seed table
create table prod_seed_list_table(
PRD_CUSTOMER_NUM number(9),
PRD_TITLE varchar2(10),
PRD_FIRST_NAME varchar2(250),
PRD_LAST_NAME varchar2(250),
PRD_EMAIL varchar2(250),
PRD_ADDRESS_LINE1 varchar2(250),
PRD_ADDRESS_LINE2 varchar2(250),
PRD_ADDRESS_LINE3 varchar2(250),
PRD_CITY varchar2(100),
PRD_STATE_CODE varchar2(2),
PRD_ZIP_CODE varchar2(5)
);




--Production campaign work table
create table prod_campaign_work(
IN_CUSTOMER_NUM number(9) constraint c_num_pk primary key,
STG_TITLE VARCHAR2(10),
STG_FIRST_NAME VARCHAR2(250),
STG_LAST_NAME VARCHAR2(250),
STG_EMAIL varchar2(250),
IN_ADDR1 varchar2(250),
IN_ADDR2 varchar2(250),
IN_ADDR3 varchar2(250),
IN_CITY varchar2(100),
IN_STATE_CODE varchar2(2),
IN_ZIP_CODE varchar2(5)
);




--Production campaign final table
create table prod_campaign_final(
IN_CUSTOMER_NUM number(9) constraint cf_num_pk primary key,
STG_TITLE VARCHAR2(10),
STG_FIRST_NAME VARCHAR2(250),
STG_LAST_NAME VARCHAR2(250),
STG_EMAIL varchar2(250),
IN_ADDR1 varchar2(250),
IN_ADDR2 varchar2(250),
IN_ADDR3 varchar2(250),
IN_CITY varchar2(100),
IN_STATE_CODE varchar2(2),
IN_ZIP_CODE varchar2(5)
);









