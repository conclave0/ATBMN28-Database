CREATE USER GV001 IDENTIFIED BY GV001;
CREATE USER GV002 IDENTIFIED BY GV002;
CREATE USER GV003 IDENTIFIED BY GV003;
CREATE USER GV004 IDENTIFIED BY GV004;
CREATE USER GV005 IDENTIFIED BY GV005;
CREATE USER GV006 IDENTIFIED BY GV006;
CREATE USER GV007 IDENTIFIED BY GV007;
CREATE USER GV008 IDENTIFIED BY GV008;
CREATE USER GV009 IDENTIFIED BY GV009;
CREATE USER GV010 IDENTIFIED BY GV010;
CREATE USER GV011 IDENTIFIED BY GV011;
GRANT CREATE SESSION  TO GV001;
---RBAC---------------------------------------------------------------
GRANT SELECT ON ATBMN28.GIAOVIEN  TO giaovien,giaovu,truongphokhoa,truongbomon;
grant update(TenGV,SDT,DiaChi) on ATBMN28.GIAOVIEN to giaovien,giaovu,truongphokhoa,truongbomon;
grant select on ATBMN28.MONHOC_MO to giaovien,giaovu,truongphokhoa,truongbomon;
grant insert,update, delete on ATBMN28.MONHOC_MO to giaovu,truongphokhoa;
grant giaovien to gv01
grant truongphokhoa to gv01
--

select * from ATBMN28.GIAOVIEN;
-------VPD---------------------------------------------------------------

create or replace context ATBMN28_Context using ATBMN28_Context_pak;
/
create or replace package ATBMN28_Context_pak 
as
  procedure LaGiaoVien;
  procedure LaGiaoVu;
  procedure LaTruongBomon;
  procedure LaTruongPhoKhoa;
  procedure LaSinhVien;
  procedure ThuocKhoa;
  procedure ThuocBoMon;
end;
/
create or replace package body ATBMN28_Context_pak 
as
  procedure ThuocBoMon
  as
  bm varchar(20);
  begin
    select BoMon into bm
    from ATBMN28.GIAOVIEN
    where GIAOVIEN.MaGv=sys_context('userenv','SESSION_USER');
    dbms_session.set_context('ATBMN28_Context','ThuocBoMon',bm);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;  
  end;
  procedure ThuocKhoa
  as
  khoa varchar(10);
  begin
    select MaNganh into khoa
    from ATBMN28.GIAOVIEN
    where GIAOVIEN.MaGv=sys_context('userenv','SESSION_USER');
    dbms_session.set_context('ATBMN28_Context','ThuocKhoa',khoa);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;  
  end;
  procedure LaGiaoVien
  as
  CV int;
    begin
      select count(*)
      into CV
      from DBA_ROLE_PRIVS where GRANTEE=sys_context('userenv','SESSION_USER') and GRANTED_ROLE='GIAOVIEN';    
      dbms_session.set_context('ATBMN28_Context','LaGiaoVien',CV);
    end;
  procedure LaGiaoVu
  as
  CV int;
    begin
      select count(*)
      into CV
      from DBA_ROLE_PRIVS where GRANTEE=sys_context('userenv','SESSION_USER') and GRANTED_ROLE='GIAOVU';    
      dbms_session.set_context('ATBMN28_Context','LaGiaoVu',CV);
    end;
  procedure LaTruongBoMon
  as
  CV int;
    begin
      select count(*)
      into CV
      from DBA_ROLE_PRIVS where GRANTEE=sys_context('userenv','SESSION_USER') and GRANTED_ROLE='TRUONGBOMON';    
      dbms_session.set_context('ATBMN28_Context','LaTruongBoMon',CV);
    end;
  procedure LaTruongPhoKhoa
  as
  CV int;
    begin
      select count(*)
      into CV
      from DBA_ROLE_PRIVS where GRANTEE=sys_context('userenv','SESSION_USER') and GRANTED_ROLE='TRUONGPHOKHOA';    
      dbms_session.set_context('ATBMN28_Context','LaTruongPhoKhoa',CV);
    end;
  procedure LaSinhVien
  as
  CV int;
    begin
      select count(*)
      into CV
      from DBA_ROLE_PRIVS where GRANTEE=sys_context('userenv','SESSION_USER') and GRANTED_ROLE='SINHVIEN';    
      dbms_session.set_context('ATBMN28_Context','LaSinhVien',CV);
    end; 
end;
/

create or replace trigger ATBMN28_Context_trg after logon on database
  begin
  atbmn28.ATBMN28_Context_pak.LaGiaoVien;
  atbmn28.ATBMN28_Context_pak.LaGiaoVu;
  atbmn28.ATBMN28_Context_pak.LaTruongBomon;
  atbmn28.ATBMN28_Context_pak.LaTruongPhoKhoa;
  atbmn28.ATBMN28_Context_pak.LaSinhVien;
  END;
/

drop trigger Set_ChucVu_Context_trg;

create or replace package ATBMN28_Policy as
  function GiaoVien_Select_sec(D1 varchar2,d2 varchar2 ) return varchar2;
  function GiaoVien_InsertUpdate_sec(D1 varchar2,d2 varchar2 ) return varchar2;
  function MonHocMo_Select_Sec(D1 varchar2,d2 varchar2 ) return varchar2;
end;
/

create or replace package body ATBMN28_Policy as
  function MonHocMo_InsertUpdate_sec(D1 varchar2,d2 varchar2 ) return varchar2 
  as
  predicate varchar(2000);
  begin
    predicate:='0=1';
    if( sys_context('ATBMN28_Context','LaGiaoVu')=1 or sys_context('ATBMN28_Context','LaTruongPhoKhoa')=1 or sys_context('userenv','SESSION_USER')= 'ATBMN28') then 
      predicate:='1=1';
    end if;
    return predicate;
  end;
  
  function MonHocMo_Select_Sec(D1 varchar2,d2 varchar2 ) return varchar2 
  as
  predicate varchar(2000);
  begin
    if(sys_context('ATBMN28_Context','LaGiaoVien')=1 or sys_context('ATBMN28_Context','LaTruongBoMon')=1  ) then 
      predicate:='MONHOC_MO.MaGV=sys_context(''userenv'',''SESSION_USER'')';
    end if;
    if(sys_context('ATBMN28_Context','LaTruongPhoKhoa')=1 or sys_context('ATBMN28_Context','LaSinhVien')=1 or sys_context('ATBMN28_Context','LaGiaoVu')=1) then 
      predicate:= '1=1';
    end if;
    if(sys_context('userenv','SESSION_USER')= 'ATBMN28') then
      return '1=1';
    end if;
    return predicate;
  end;
  function GiaoVien_InsertUpdate_sec(D1 varchar2,d2 varchar2 ) return varchar2 
  as
  predicate varchar(2000);
  begin
    if(sys_context('ATBMN28_Context','LaGiaoVien')=1 or sys_context('ATBMN28_Context','LaGiaoVu')=1 or sys_context('ATBMN28_Context','LaTruongBoMon')=1 or sys_context('ATBMN28_Context','LaTruongPhoKhoa')=1) then 
      predicate:='GIAOVIEN.MaGV=sys_context(''userenv'',''SESSION_USER'')';
    end if;
    if(sys_context('userenv','SESSION_USER')= 'ATBMN28') then
      return '1=1';
    end if;
    return predicate;
  end;
  function GiaoVien_Select_sec(D1 varchar2,d2 varchar2 ) return varchar2 
  as
  predicate varchar(2000);
  begin
    if(sys_context('ATBMN28_Context','LaGiaoVien')=1 or sys_context('ATBMN28_Context','LaGiaoVu')=1 or sys_context('ATBMN28_Context','LaTruongBoMon')=1 ) then 
      predicate:='GIAOVIEN.MaGV=sys_context(''userenv'',''SESSION_USER'')';
    end if;
    if(sys_context('ATBMN28_Context','LaTruongPhoKhoa')=1) then 
      predicate:= '1=1';
    end if;
    if(sys_context('userenv','SESSION_USER')= 'ATBMN28') then
      return '1=1';
    end if;
    return predicate;
  end;
end;

/

ALTER SYSTEM SET "_allow_insert_with_update_check"=TRUE;

execute DBMS_RLS.ADD_POLICY(OBJECT_SCHEMA => 'ATBMN28',OBJECT_NAME => 'GIAOVIEN',POLICY_NAME => 'GiaoVien_Select_sec' ,FUNCTION_SCHEMA => 'ATBMN28' ,POLICY_FUNCTION => 'ATBMN28_Policy.GiaoVien_Select_sec',STATEMENT_TYPES => 'select',sec_relevant_cols=>'DiaChi,SDT',sec_relevant_cols_opt=>dbms_rls.ALL_ROWS);
execute DBMS_RLS.ADD_POLICY(OBJECT_SCHEMA => 'ATBMN28',OBJECT_NAME => 'GIAOVIEN',POLICY_NAME => 'GiaoVien_InsertUpdate_sec' ,FUNCTION_SCHEMA => 'ATBMN28' ,POLICY_FUNCTION => 'ATBMN28_Policy.GiaoVien_InsertUpdate_sec',STATEMENT_TYPES => 'insert,update');
execute DBMS_RLS.ADD_POLICY(OBJECT_SCHEMA => 'ATBMN28',OBJECT_NAME => 'MONHOC_MO',POLICY_NAME => 'MonHocMo_Select_Sec' ,FUNCTION_SCHEMA => 'ATBMN28' ,POLICY_FUNCTION => 'ATBMN28_Policy.MonHocMo_Select_Sec',STATEMENT_TYPES => 'select',sec_relevant_cols=>'ThoiGian',sec_relevant_cols_opt=>dbms_rls.ALL_ROWS);

execute DBMS_RLS.DROP_POLICY('ATBMN28', 'GIAOVIEN', 'GiaoVien_Select_sec');
/
--Crypto



CREATE OR REPLACE PACKAGE enc_dec
AS
   FUNCTION encrypt (p_plainText VARCHAR2,enKey varchar2) RETURN RAW DETERMINISTIC;
   FUNCTION decrypt (p_encryptedText RAW,deKey varchar2) RETURN VARCHAR2 DETERMINISTIC;
END;
/

CREATE OR REPLACE PACKAGE BODY enc_dec
AS
     encryption_type    PLS_INTEGER := DBMS_CRYPTO.ENCRYPT_DES+ DBMS_CRYPTO.CHAIN_CBC+ DBMS_CRYPTO.PAD_PKCS5;
     /*
       ENCRYPT_DES is the encryption algorithem. Data Encryption Standard. Block cipher. 
       Uses key length of 56 bits.
       CHAIN_CBC Cipher Block Chaining. Plaintext is XORed with the previous ciphertext 
       block before it is encrypted.
       PAD_PKCS5 Provides padding which complies with the PKCS #5: Password-Based 
       Cryptography Standard
     */
     encryption_key     RAW (32);
     -- The encryption key for DES algorithem, should be 8 bytes or more.

     FUNCTION encrypt (p_plainText VARCHAR2,enKey varchar2) RETURN RAW DETERMINISTIC
     IS
        encrypted_raw      RAW (2000);
        
     BEGIN
        encryption_key:= UTL_RAW.cast_to_raw(enKey);
        encrypted_raw := DBMS_CRYPTO.ENCRYPT
        (
           src => UTL_RAW.CAST_TO_RAW (p_plainText),
           typ => encryption_type,
           key => encryption_key
        );
       RETURN encrypted_raw;
     END encrypt;
     FUNCTION decrypt (p_encryptedText RAW,deKey varchar2) RETURN VARCHAR2 DETERMINISTIC
     IS
        decrypted_raw      RAW (2000);
     BEGIN
        encryption_key := UTL_RAW.cast_to_raw(deKey);
        decrypted_raw := DBMS_CRYPTO.DECRYPT
        (
            src => p_encryptedText,
            typ => encryption_type,
            key => encryption_key
        );
        RETURN (UTL_RAW.CAST_TO_VARCHAR2 (decrypted_raw));
     END decrypt;
END;


create  FUNCTION encrypt_Luong (p_plainText VARCHAR2,enKey varchar2) RETURN RAW DETERMINISTIC
     IS
        encrypted_raw      RAW (2000);
        encryption_type    PLS_INTEGER := DBMS_CRYPTO.ENCRYPT_DES+ DBMS_CRYPTO.CHAIN_CBC+ DBMS_CRYPTO.PAD_PKCS5;
        encryption_key     RAW (32);
        
     BEGIN
        encryption_key:= UTL_RAW.cast_to_raw(enKey);
        encrypted_raw := DBMS_CRYPTO.ENCRYPT
        (
           src => UTL_RAW.CAST_TO_RAW (p_plainText),
           typ => encryption_type,
           key => encryption_key
        );
       RETURN encrypted_raw;
     END encrypt_Luong;

create function decrypt_Luong
(p_encryptedText RAW,deKey varchar2) RETURN VARCHAR2 DETERMINISTIC
     IS
        decrypted_raw      RAW (2000);
        encryption_type    PLS_INTEGER := DBMS_CRYPTO.ENCRYPT_DES+ DBMS_CRYPTO.CHAIN_CBC+ DBMS_CRYPTO.PAD_PKCS5;
        encryption_key     RAW (32);
     BEGIN
        encryption_key := UTL_RAW.cast_to_raw(deKey);
        decrypted_raw := DBMS_CRYPTO.DECRYPT
        (
            src => p_encryptedText,
            typ => encryption_type,
            key => encryption_key
        );
        RETURN (UTL_RAW.CAST_TO_VARCHAR2 (decrypted_raw));
     END decrypt_Luong;

create or replace trigger Luong_before_update
after insert OR UPDATE OR DELETE on ATBMN28.LUONG
FOR EACH ROW
begin
  IF UPDATING then
    insert into ATBMN28.Log_Luong values('Update',sys_context('userenv','SESSION_USER'),sysdate,:old.MaGV,:old.Luong);
  end if;
  if inserting then
    insert into ATBMN28.Log_Luong values('Insert',sys_context('userenv','SESSION_USER'),sysdate,:new.MaGV,:new.Luong);
  end if;
  if deleting then
    insert into ATBMN28.Log_Luong values('Delete',sys_context('userenv','SESSION_USER'),sysdate,:old.MaGV,:old.Luong);
  end if;
end;
/

