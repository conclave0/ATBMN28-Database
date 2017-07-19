declare
  usname char(100);
  usrole char(100);
begin
SELECT distinct USERNAME, GRANTED_ROLE into usname,usrole FROM USER_ROLE_PRIVS;
BT1N28.CAPNHATPHONGBAN('P23','TestNV18',null,15,usname,usrole);
end;
