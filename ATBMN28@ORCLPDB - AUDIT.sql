create or replace trigger auditThongBao after 
insert or update or delete on ATBMN28.THONGBAO for each row
declare
my THONGBAO$AUDIT%rowtype;
begin
  if inserting then my.loaithaydoi := 'INSERT';
  elsif updating then my.loaithaydoi :='UPDATE';
  else my.loaithaydoi := 'DELETE';
  end if;
  
  my.userthaydoi := SYS_CONTEXT('USERENV','SESSION_USER');
  my.ThoiGianThayDoi := sysdate;
  
  case my.loaithaydoi
  when 'INSERT' then
  begin
  my.ID := :new.ID;
  my.ThongBao := :new.ThongBao;
  my.ChucVu := :new.ChucVu;
  end;
  when 'DELETE' then
  begin
  my.ID := :old.ID;
  my.ThongBao := :old.ThongBao;
  my.ChucVu := :old.ChucVu;
  end;
  when 'UPDATE' then
  begin
  my.ID := :old.ID;
  my.ThongBao := :old.ThongBao;
  my.ChucVu := :old.ChucVu;
  end;
  end case;
  
  insert into ATBMN28.THONGBAO$AUDIT values my;
end;
/

create or replace trigger auditMonHocMo after 
insert or update or delete on ATBMN28.MONHOC_MO for each row
declare
my ATBMN28.MONHOC_MO_AUDIT%rowtype;
begin
  if inserting then my.loaithaydoi := 'INSERT';
  elsif updating then my.loaithaydoi :='UPDATE';
  else my.loaithaydoi := 'DELETE';
  end if;
  
  my.userthaydoi := SYS_CONTEXT('USERENV','SESSION_USER');
  my.ThoiGianThayDoi := sysdate;
  
  case my.loaithaydoi
  when 'INSERT' then
  begin
  my.MAMH := :new.MAMH;
  my.HOCKY := :new.HOCKY;
  my.NAM := :new.NAM;
  my.MAGV := :new.MAGV;
  my.ThoiGian := :new.THOIGIAN;
  end;
  when 'DELETE' then
  begin
  my.MAMH := :old.MAMH;
  my.HOCKY := :old.HOCKY;
  my.NAM := :old.NAM;
  my.MAGV := :old.MAGV;
  my.ThoiGian := :old.THOIGIAN;
  end;
  when 'UPDATE' then
  begin
  my.MAMH := :old.MAMH;
  my.HOCKY := :old.HOCKY;
  my.NAM := :old.NAM;
  my.MAGV := :old.MAGV;
  my.ThoiGian := :old.THOIGIAN;
  end;
  end case;
  insert into ATBMN28.MONHOC_MO_AUDIT values my;
end;
/


select * from THONGBAO;
select * from THONGBAO$AUDIT;

connect;