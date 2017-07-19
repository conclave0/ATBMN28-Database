/* run script F5 then copy reuslt and run again */
select 'drop table ', table_name, 'cascade constraints;' from user_tables;