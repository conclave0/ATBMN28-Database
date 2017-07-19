create or replace function SV_XEM_DIEM(
  p_schema in varchar2,
  p_object in varchar2
)
return varchar2
as
  user varchar2(20);
  mamonhoc varchar(20);
  userrole varchar(20);
begin 
  user := SYS_CONTEXT('USERENV','SESSION_USER');
  if (user = 'ATBMN28') then
    return '';
  else
    select GRANTED_ROLE into userrole from Dba_role_privs where GRANTEE=UPPER(user);
    if (userrole = 'GIAOVU') then
    return '';
    elsif (userrole= 'GIAOVIEN') then
    return '';
    elsif (userrole= 'TRUONGPHOKHOA') then
    return '';
    elsif (userrole= 'TRUONGBOMON') then
    return '';
    elsif (userrole = 'SINHVIEN') then
      begin
        return 'MASV = '|| user ;
      end;
    end if;
  end if;
end;
/

begin
 DBMS_RLS.ADD_POLICY
( OBJECT_SCHEMA => 'ATBMN28',
  OBJECT_NAME =>'DANGKY',
  POLICY_NAME =>'SVDOCDIEM',
  FUNCTION_SCHEMA =>'SYS',
  POLICY_FUNCTION =>'SV_XEM_DIEM',
  STATEMENT_TYPES =>'SELECT',
  sec_relevant_cols => 'DIEM',
  sec_relevant_cols_opt=>dbms_rls.ALL_ROWS,
  UPDATE_CHECK =>true);
end;

begin
  DBMS_RLS.DROP_POLICY
  (
  'ATBMN28',
  'DANGKY',
  'DOCTHONGTIN'
  );
end;
