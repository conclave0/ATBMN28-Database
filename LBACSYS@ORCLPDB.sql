
alter session set "_ORACLE_SCRIPT"=true;

--Drop Policy OLS

drop role thongbao_policy_DBA;
drop user ATBMN28OLS;
begin
SA_SYSDBA.DROP_POLICY('thongbao_policy',true);
end;
/

--Tao Policy OLS

begin
SA_SYSDBA.CREATE_POLICY('thongbao_policy','thongbao_label', 'no_control');
end;
/
create user ATBMN28OLS IDENTIFIED by ATBMN28OLS container = current;
/
--grant select on ATBMN28.THONGBAO to public;
grant thongbao_policy_dba to ATBMN28OLS;
--grant all on ATBMN28.THONGBAO to ATBMN28;
grant execute on sa_components to ATBMN28OLS;
grant execute on sa_label_admin to ATBMN28OLS;
grant execute on sa_user_admin to ATBMN28OLS;
grant execute on char_to_label to ATBMN28OLS;
grant execute on sa_sysdba to ATBMN28OLS;
grant execute on sa_policy_admin to ATBMN28OLS;
grant create session to ATBMN28OLS;
--grant all privileges to ATBMN28 with admin option;
--grant LBAC_DBA to ATBMN28;



--Tao Level, Compartment,Group
begin
SA_COMPONENTS.CREATE_LEVEL('thongbao_policy',10,'BT','Binh_Thuong');
SA_COMPONENTS.CREATE_LEVEL('thongbao_policy',20,'QT','Quan_Trong');
SA_COMPONENTS.CREATE_COMPARTMENT('thongbao_policy',10,'TT','Toan_Truong');
SA_COMPONENTS.CREATE_COMPARTMENT('thongbao_policy',20,'BM','Bo_Mon');
SA_COMPONENTS.CREATE_COMPARTMENT('thongbao_policy',30,'K','Khoa');
SA_COMPONENTS.CREATE_GROUP('thongbao_policy',10,'CB','Can_Bo');
SA_COMPONENTS.CREATE_GROUP('thongbao_policy',30,'SV','Sinh_Vien','CB');
SA_COMPONENTS.CREATE_GROUP('thongbao_policy',20,'GV','Giao_Vien','CB');
end;
/

--Tao Label
begin
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',1000,'BT:TT:CB');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',1010,'QT:TT:CB');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',1100,'BT:BM:CB');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',1110,'QT:BM:CB');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',1200,'BT:K:CB');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',1210,'QT:K:CB');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',2000,'BT:TT:GV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',2010,'QT:TT:GV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',2100,'BT:BM:GV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',2110,'QT:BM:GV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',2200,'BT:K:GV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',2210,'QT:K:GV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',3000,'BT:TT:SV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',3010,'QT:TT:SV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',3100,'BT:BM:SV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',3110,'QT:BM:SV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',3200,'BT:K:SV');
  SA_LABEL_ADMIN.CREATE_LABEL('thongbao_policy',3210,'QT:K:SV');
  
  SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
  policy_name       => 'thongbao_policy',
  schema_name       => 'ATBMN28',
  table_name        => 'THONGBAO',
  table_options  => null,
  label_function => null,
  predicate         => null
);



end;
/

--Ap dung OLS policy tren bang THONGBAO
begin
update ATBMN28.THONGBAO set thongbao_label = char_to_label('thongbao_policy','BT:TT:GV') where chucvu ='Giao Vien';
update ATBMN28.THONGBAO set thongbao_label = char_to_label('thongbao_policy','QT:K:CB') where id =5;
update ATBMN28.THONGBAO set thongbao_label = char_to_label('thongbao_policy','BT:K:CB') where id =4;
update ATBMN28.THONGBAO set thongbao_label = char_to_label('thongbao_policy','BT:TT:SV') where id = 3;
update ATBMN28.THONGBAO set thongbao_label = char_to_label('thongbao_policy','QT:TT:SV') where id = 2 or id = 1;
end;
/


BEGIN
 SA_USER_ADMIN.SET_USER_PRIVS(
  policy_name   => 'thongbao_policy',
  user_name     => 'ATBMN28OLS', 
  privileges    => 'FULL');
END;
/
--Ap dung chinh sach truy cap du lieu tren GV01
begin
SA_USER_ADMIN.SET_LEVELS (
  policy_name   => 'thongbao_policy',
  user_name     => 'GV01',
  max_level     => 'QT',
  min_level     => 'BT',
  def_level     => 'QT',
  row_level     => 'QT');
 SA_USER_ADMIN.SET_COMPARTMENTS (
  policy_name   => 'thongbao_policy',
  user_name     => 'GV01',
  read_comps    => 'TT,BM,K',
  write_comps   => 'TT,BM,K',
  def_comps     => 'TT,BM,K',
  row_comps     => 'TT,BM,K');
 SA_USER_ADMIN.SET_GROUPS (
  policy_name   => 'thongbao_policy',
  user_name     => 'GV01',
  read_groups   => 'GV',
  write_groups  => 'GV',
  def_groups    => 'GV',
  row_groups    => 'GV');
end;
/

--Ap dung chinh sach truy cap du lieu tren GV14
begin
SA_USER_ADMIN.SET_LEVELS (
  policy_name   => 'thongbao_policy',
  user_name     => 'GV14',
  max_level     => 'QT',
  min_level     => 'BT',
  def_level     => 'QT',
  row_level     => 'QT');
 SA_USER_ADMIN.SET_COMPARTMENTS (
  policy_name   => 'thongbao_policy',
  user_name     => 'GV14',
  read_comps    => 'TT,BM,K',
  write_comps   => 'TT,BM,K',
  def_comps     => 'TT,BM,K',
  row_comps     => 'TT,BM,K');
 SA_USER_ADMIN.SET_GROUPS (
  policy_name   => 'thongbao_policy',
  user_name     => 'GV14',
  read_groups   => 'CB',
  write_groups  => 'CB',
  def_groups    => 'CB',
  row_groups    => 'CB');
end;
/



--Ap dung chinh sach truy cap du lieu tren sinh vien 1412185
begin
SA_USER_ADMIN.SET_LEVELS (
  policy_name   => 'thongbao_policy',
  user_name     => '1412185',
  max_level     => 'QT',
  min_level     => 'BT',
  def_level     => 'QT',
  row_level     => 'QT');
 SA_USER_ADMIN.SET_COMPARTMENTS (
  policy_name   => 'thongbao_policy',
  user_name     => '1412185',
  read_comps    => 'TT,BM',
  write_comps   => '',
  def_comps     => 'TT,BM',
  row_comps     => 'TT,BM');
 SA_USER_ADMIN.SET_GROUPS (
  policy_name   => 'thongbao_policy',
  user_name     => '1412185',
  read_groups   => 'SV',
  write_groups  => '',
  def_groups    => 'SV',
  row_groups    => 'SV');
end;
/

--Ap dung chinh sach truy cap du lieu tren sinh vien 1410135
begin
SA_USER_ADMIN.SET_LEVELS (
  policy_name   => 'thongbao_policy',
  user_name     => '1410135',
  max_level     => 'BT',
  min_level     => 'BT',
  def_level     => 'BT',
  row_level     => 'BT');
 SA_USER_ADMIN.SET_COMPARTMENTS (
  policy_name   => 'thongbao_policy',
  user_name     => '1410135',
  read_comps    => 'TT',
  write_comps   => '',
  def_comps     => 'TT',
  row_comps     => 'TT');
 SA_USER_ADMIN.SET_GROUPS (
  policy_name   => 'thongbao_policy',
  user_name     => '1410135',
  read_groups   => 'SV',
  write_groups  => '',
  def_groups    => 'SV',
  row_groups    => 'SV');
end;
/

create or replace procedure GrantAccessThongBao
(
  username in varchar,
  ip_max_level in varchar,
  ip_min_level in varchar,
  ip_def_level in varchar,
  ip_row_level in varchar,
  ip_read_comps in varchar,
  ip_write_comps in varchar,
  ip_def_comps in varchar,
  ip_row_comps in varchar,
  ip_read_groups in varchar,
  ip_write_groups in varchar,
  ip_def_groups in varchar,
  ip_row_groups in varchar
)
as
begin
  SA_USER_ADMIN.SET_LEVELS (
  policy_name   => 'thongbao_policy',
  user_name     => username,
  max_level     => ip_max_level,
  min_level     => ip_min_level,
  def_level     => ip_def_level,
  row_level     => ip_row_level);
 SA_USER_ADMIN.SET_COMPARTMENTS (
  policy_name   => 'thongbao_policy',
  user_name     => username,
  read_comps    => ip_read_comps,
  write_comps   => ip_write_comps,
  def_comps     => ip_def_comps,
  row_comps     => ip_row_comps);
 SA_USER_ADMIN.SET_GROUPS (
  policy_name   => 'thongbao_policy',
  user_name     => username,
  read_groups   => ip_read_groups,
  write_groups  => ip_write_groups,
  def_groups    => ip_def_groups,
  row_groups    => ip_row_groups);
end GrantAccessThongBao;
/

create or replace procedure ApplyThongBaoPolicy
as
begin
SA_SYSDBA.ALTER_POLICY(
  policy_name => 'thongbao_policy',
  default_options => 'read_control, label_default'
);
SA_POLICY_ADMIN.REMOVE_TABLE_POLICY(
  policy_name => 'thongbao_policy',
  schema_name => 'ATBMN28',
  table_name  => 'thongbao',
  drop_column => false
);

SA_POLICY_ADMIN.APPLY_TABLE_POLICY(
  policy_name       => 'thongbao_policy',
  schema_name       => 'ATBMN28',
  table_name        => 'THONGBAO'
);
end ApplyThongBaoPolicy;
/

create or replace procedure SetThongBaoPolicy(
  ip_id in ATBMN28.THONGBAO.ID%Type,
  ip_policy in varchar
)
is
begin
update ATBMN28.THONGBAO set thongbao_label = char_to_label('thongbao_policy',ip_policy) where id = ip_id;
commit;
end SetThongBaoPolicy;

grant execute on ATBMN28.SetThongBaoPolicy to ATBMN28OLS with grant option;
/*
begin 
SetThongBaoPolicy(1,'BT:TT:SV');
end;
/

begin 
applyThongBaoPolicy;
end;
/

begin 
GrantAccessThongBao('1312189','BT','BT','BT','BT','TT','','TT','TT','SV','SV','SV','SV');
end;
*/

select * from ATBMN28.THONGBAO;
