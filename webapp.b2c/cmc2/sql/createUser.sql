drop user cmc2_dev1_schema cascade;
create user cmc2_dev1_schema
identified by amehcs_1ved_2cmc 
default tablespace cmc2_data
temporary tablespace temp;

grant dba,connect,resource to cmc2_dev1_schema;
