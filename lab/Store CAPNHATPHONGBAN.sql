create or replace procedure CapNhatPhongBan(
  p_maphong in BT1N28.PHONGBAN_1312366_1312454_1412185.MAPHONG%type,
  p_tenphong in BT1N28.PHONGBAN_1312366_1312454_1412185.TENPHONG%type,
  p_ngaynhanchuc in BT1N28.PHONGBAN_1312366_1312454_1412185.NGAYNHANCHUC%type,
  p_sonhanvien in BT1N28.PHONGBAN_1312366_1312454_1412185.SONHANVIEN%type,
  p_manv in BT1N28.PHONGBAN_1312366_1312454_1412185.TRUONGPHONG%type,
  p_chucvu in BT1N28.PHONGBAN_1312366_1312454_1412185.TRUONGPHONG%type
)
is
begin
  if(p_chucvu = 'TRUONG_PHONG') then
  
    update BT1N28.PHONGBAN_1312366_1312454_1412185 set TENPHONG = p_tenphong, SONHANVIEN = p_sonhanvien, NGAYNHANCHUC = p_ngaynhanchuc
    where UPPER(TRUONGPHONG) = UPPER(p_manv) and UPPER(MAPHONG) = UPPER(p_maphong) ;
  
  elsif (p_chucvu = 'TRUONG_CHI_NHANH') then
    update BT1N28.PHONGBAN_1312366_1312454_1412185 set TENPHONG = p_tenphong, SONHANVIEN = p_sonhanvien, NGAYNHANCHUC = p_ngaynhanchuc 
    where UPPER(CHINHANH) = (
      select UPPER(MACN) from BT1N28.CHINHANH_1312366_1312454_1412185 where UPPER(TRUONGCHINHANH) = UPPER(p_manv)) and UPPER(MAPHONG) = UPPER(p_maphong) ;
  else Raise_Application_Error(-20001,'Incorrect MAPHONG | USER | CHUCVU');
  end if;
  commit;
end;
