select * from User_tab_privs;
select * from Dba_sys_privs;
select * from Dba_role_privs;
select * from all_users where username like '1%' or username like '%GV%';
select distinct Granted_Role from Dba_role_privs where grantee like '1%' or grantee like'GV%';
select * from Dba_sys_privs where grantee like 'GV%';
select * from Dba_role_privs where grantee like '1%' or grantee like '%GV%';
select * from all_users where username like '1%' or username like '%GV%';

select ust.TABLE_NAME,ust.PRIVILEGE,ust.Type, dbr.GRANTED_ROLE from all_users al, User_tab_privs ust, Dba_sys_privs dbs, Dba_role_privs dbr
where al.USERNAME = dbs.grantee and al.USERNAME = dbr.grantee and dbr.GRANTED_ROLE = ust.GRANTEE and al.USERNAME='GV14';


select al.USERNAME ,ust.PRIVILEGE, ust.TABLE_NAME,ust.Type, dbr.GRANTED_ROLE from all_users al, User_tab_privs ust, Dba_sys_privs dbs, Dba_role_privs dbr
where al.USERNAME = dbs.grantee and al.USERNAME = dbr.grantee and dbr.GRANTED_ROLE = ust.GRANTEE and (al.USERNAME like 'GV%' or al.USERNAME like '1%')
and (ust.PRIVILEGE like 'INSERT' or ust.PRIVILEGE like 'UPDATE' or ust.PRIVILEGE like 'DELETE' or ust.PRIVILEGE like 'SELECT' or ust.PRIVILEGE like 'EXECUTE') 
order by al.USERNAME;

select distinct al.USERNAME from all_users al, User_tab_privs ust, Dba_sys_privs dbs, Dba_role_privs dbr
where al.USERNAME = dbs.grantee and al.USERNAME = dbr.grantee and dbr.GRANTED_ROLE = ust.GRANTEE and (al.USERNAME like 'GV%' or al.USERNAME like '1%')
and (ust.PRIVILEGE like 'INSERT' or ust.PRIVILEGE like 'UPDATE' or ust.PRIVILEGE like 'DELETE' or ust.PRIVILEGE like 'SELECT' or ust.PRIVILEGE like 'EXECUTE') 
order by al.USERNAME;

select distinct al.USERNAME from all_users al where al.USERNAME like 'GV%' or al.USERNAME like '1%';

select distinct Granted_Role from Dba_role_privs where grantee like '1%' or grantee like'GV%';

select distinct uts.TABLE_NAME,uts.Type from User_tab_privs uts where (uts.PRIVILEGE like 'INSERT' or uts.PRIVILEGE like 'UPDATE' or uts.PRIVILEGE like 'DELETE' or uts.PRIVILEGE like 'SELECT' or uts.PRIVILEGE like 'EXECUTE')
 and uts.Grantee = 'GIAOVU' order by uts.TABLE_NAME;

select al.USERNAME ,ust.PRIVILEGE, ust.TABLE_NAME,ust.Type, dbr.GRANTED_ROLE from all_users al, User_tab_privs ust, Dba_sys_privs dbs, Dba_role_privs dbr
where al.USERNAME = dbs.grantee and al.USERNAME = dbr.grantee and dbr.GRANTED_ROLE = ust.GRANTEE and (al.USERNAME like 'GV%' or al.USERNAME like '1%')
and (ust.PRIVILEGE like 'INSERT' or ust.PRIVILEGE like 'UPDATE' or ust.PRIVILEGE like 'DELETE' or ust.PRIVILEGE like 'SELECT' or ust.PRIVILEGE like 'EXECUTE') 
order by al.USERNAME;



revoke SINHVIEN from "1312189";
grant SINHVIEN to "1312189";
grant GIAOVU to gv14;


select * from User_tab_privs;
select * from all_users;
select distinct utp.GRANTEE,utp.TABLE_NAME, utp.PRIVILEGE, utp.TYPE from User_tab_privs utp, all_users au where utp.GRANTEE = au.USERNAME or (au.username like '1%' or au.username like '%GV%') order by utp.GRANTEE;

select * from Dba_role_privs;

select distinct Granted_Role, GRANTEE from Dba_role_privs where grantee like '1%' or grantee like'GV%' or grantee like 'ATBM%' order by GRANTED_ROLE;

grant all on ATBMN28.THONGBAO to "1412185";

grant GIAOVU to GV01;