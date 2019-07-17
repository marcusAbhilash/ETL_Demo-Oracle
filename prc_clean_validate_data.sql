create or replace procedure proc_clean_validate_data is
    --Cursor to join data from customer and address table to prod_campaign_work
    cursor cust_rec is select c.*,a.STG_ADDR1,a.STG_ADDR2,a.STG_ADDR3,a.STG_CITY,a.STG_STATE_CODE,a.STG_ZIP_CODE from stg_inbd_customer c join stg_inbd_address a on a.STG_CUSTOMER_NUM=c.STG_CUSTOMER_NUM;
begin
    for i in cust_rec loop
        if length(i.STG_CUSTOMER_NUM)>9 then    --Customer Number having more that 9 characters should be rejected
            dbms_output.put_line(i.STG_CUSTOMER_NUM||' has a Customer number greater than 9.');
        elsif i.STG_FIRST_NAME='null' then  --Records having this field null will be rejected.
            dbms_output.put_line(i.STG_CUSTOMER_NUM||' has no first name.');
        elsif i.STG_LAST_NAME='null' then   --Records having this field null will be rejected.
            dbms_output.put_line(i.STG_CUSTOMER_NUM||' has no last name.');
        elsif i.STG_ADDR1='null' then   --Records having this field null will be rejected.
            dbms_output.put_line(i.STG_CUSTOMER_NUM||' has no address.');
        elsif i.STG_CITY='null' then    --Records having this field null will be rejected.
            dbms_output.put_line(i.STG_CUSTOMER_NUM||' has no city.');
        elsif i.STG_STATE_CODE='null' or length(i.STG_STATE_CODE)!=2 then   --Records having this field null or length lesser than 2 will be rejected.
            dbms_output.put_line(i.STG_CUSTOMER_NUM||' has invalid state code.');
        elsif i.STG_ZIP_CODE='null' or length(i.STG_ZIP_CODE)!=5 then   --Records having this field null or length lesser than 5 will be rejected.
            dbms_output.put_line(i.STG_CUSTOMER_NUM||' has invalid zip code.');                 
        else    
            insert into prod_campaign_work values (i.STG_CUSTOMER_NUM,i.STG_TITLE,i.STG_FIRST_NAME,i.STG_LAST_NAME,i.STG_EMAIL,i.STG_ADDR1,i.STG_ADDR2,i.STG_ADDR3,i.STG_CITY,i.STG_STATE_CODE,i.STG_ZIP_CODE);
        end if;
    end loop;
    
    --Delete duplicate rows based on first name and last name
    delete from prod_campaign_work where rowid not in(select min(rowid) from prod_campaign_work group by STG_FIRST_NAME, STG_LAST_NAME);
    dbms_output.put_line(sql%rowcount||' duplicate rows deleted');
    
    --Commit the changes
    commit;
    
    --Exception Block
    Exception
    when others then
        dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

--------EXECUTE proc_clean_validate_data---------
exec proc_clean_validate_data;





create or replace procedure prc_suppress_append_data is 
begin
    --Supress records that are present in drop list using exists clause
    delete from prod_campaign_work a where exists (select PRD_CUSTOMER_NUM from prod_inbd_drop_list_table b where a.in_customer_num=b.PRD_CUSTOMER_NUM ); 
    dbms_output.put_line(sql%rowcount||' rows deleted matching the drop list');
    
    --Append records present in the seed list using not exists
    insert into prod_campaign_work
    select * from prod_seed_list_table t2 where not exists(select * from prod_campaign_work t1 where t1.IN_CUSTOMER_NUM=t2.PRD_CUSTOMER_NUM);
    
    --Commit the changes of drop list and seed list
    commit;
    
    --Dump data from prod_campaign_work to prod_campaign_final
    insert into prod_campaign_final select * from prod_campaign_work;
    
    --Commit changes of prod_campaign_final
    commit;
    
    --Exception block
    Exception
    when others then
        dbms_output.put_line(sqlcode||' '||sqlerrm);
end;


--------EXECUTE prc_suppress_append_data---------
exec prc_suppress_append_data;





connect system/admin;
create directory extdir as 'C:\group5';
grant all on directory extdir to scott;



create or replace procedure prc_extract_campaign_file is
    fhandle utl_file.file_type;     --File handler
    cursor final_rec is select * from prod_campaign_final;  --Cursor to read records from prod_campaign_final table
begin
    --Open the destination file in write mode
    fhandle:= utl_file.fopen('EXTDIR', 'output_campaign_file.txt' , 'W' );
    
    --Header columns for the output_campaign_file.txt file
    utl_file.put(fhandle, 'CUSTOMER_NUMBER|TITLE|FRST_NM_MID_INIT|LAST_NM|EMAIL|ADDR_LINE_1|ADDR_LINE_2|ADDR_LINE_3|CITY|ST_CD|ZIP_CD'||chr(10));
    
    --Entering the records in the output_campaign_file.txt file using the cursor
    for i in final_rec loop
        utl_file.put(fhandle,i.IN_CUSTOMER_NUM||'|'||i.STG_TITLE||'|'||i.STG_FIRST_NAME||'|'||i.STG_LAST_NAME||'|'||i.STG_EMAIL||'|'||i.IN_ADDR1||'|'||i.IN_ADDR2||'|'||i.IN_ADDR3||'|'||i.IN_CITY||'|'||i.IN_STATE_CODE||'|'||i.IN_ZIP_CODE||chr(10));
    end loop;
    
    --Closing the file handler
    utl_file.fclose(fhandle);
    
    --Exception block
    exception
    when others then
        dbms_output.put_line(sqlcode||' '||sqlerrm);
end;


--------EXECUTE prc_extract_campaign_file---------
exec prc_extract_campaign_file;








select * from prod_campaign_work;
truncate table prod_campaign_work;
select * from prod_campaign_final;
truncate table prod_campaign_final;

