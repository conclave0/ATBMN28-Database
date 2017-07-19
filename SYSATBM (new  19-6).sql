
conn sys@ORCLPDB as sysdba;

alter session set "_ORACLE_SCRIPT"=true;

CREATE USER ATBMN28 IDENTIFIED BY ATBMN28;

GRANT CONNECT,RESOURCE,DBA TO ATBMN28;

GRANT UNLIMITED TABLESPACE TO ATBMN28;
GRANT CREATE SESSION  TO ATBMN28;
GRANT CREATE ANY TABLE TO ATBMN28;
connect ATBMN28/ATBMN28;
/

alter session set "_ORACLE_SCRIPT"=true;

create table ATBMN28.NGANH(
    MaNganh varchar(10) not null,
    TenNganh varchar(50) not null,
    SoCD int null,
    TSSV int null,
    constraint Check_SoCD check ( SoCD>0),
    constraint Check_TSSV check ( TSSV>=0),
    constraint NGANH_PK primary key (MaNganh)
)
/
create table ATBMN28.SINHVIEN(
    MaSV varchar(10) not null,
    HoTen varchar(50) not null,
    Phai varchar(3) not null,
    NgaySinh date null,
    DiaChi varchar(50) null,
    MaNganh varchar(10) not null,
    primary key (MaSV),
    constraint Check_Phai check ( Phai like 'nam' or Phai like 'nu'),
    foreign key (MaNganh) references ATBMN28.NGANH(MaNganh)
)
/
create table ATBMN28.MONHOC(
    MaMH varchar(10) not null,
    TenMH varchar(50) not null,
    MaNganh varchar(10) not null ,--update
    SoSVToiDa int null,
    LoaiMonHoc varchar(20),
    constraint Check_LoaiMonHoc check (LoaiMonHoc like 'TuChon' or (LoaiMonHoc like 'BatBuoc')),
    constraint MONHOC_PK primary key(MaMH),
    constraint Check_SoSVToiDa check (SoSVToiDa > 0),
    foreign key (MaNganh) references ATBMN28.NGANH(MaNganh)--update
)
/

create table ATBMN28.GIAOVIEN(
    MaGV varchar(10) not null,
    TenGV varchar(50) not null,
    MaNganh varchar(10) null,
    BoMon varchar(20) null,
    DiaChi varchar(50) null,
    SDT varchar(20) not null,
    --constraint Check_ChucVu check (ChucVu like 'GiaoVien' or (ChucVu like 'TruongPhoKhoa' or (ChucVu like 'TruongBoMon' or (ChucVu like ('GiaoVu'))))),
    constraint GIAOVIEN_PK primary key (MaGV),
    foreign key (MaNganh) references ATBMN28.NGANH(MaNganh)--update
)
/

create table ATBMN28.MONHOC_MO(
    MaMH varchar(10) not null,
    HocKy int not null,
    Nam int not null,
    ThoiGian varchar (20) null,  
    MaGV varchar(10) not null,--update
    constraint Check_HocKy check (HocKy>=1 and HocKy<=3),
    constraint Check_Nam check (Nam>=1900 ),
    constraint MONHOC_MO_MONHOC_FK foreign key (MaMH) references ATBMN28.MONHOC(MaMH),
    constraint MONHOC_MO_PK primary key (HocKy,Nam,MaMH,MaGV,ThoiGian),--update
    constraint MONHOC_MO_GIAOVIEN_FK foreign key (MaGV) references ATBMN28.GIAOVIEN(MaGV)
)
/



create table ATBMN28.DANGKY(
    MaSV varchar(10) not null,
    MaMH varchar(10) not null,
    HocKy int not null,
    Nam int not null,
    Diem int null,
    ThoiGian varchar (20) null,  
    MaGV varchar(10) not null,--update
    constraint DANGKY_PK primary key (MaSV,HocKy,Nam,MaMH,MaGV,ThoiGian),
    constraint DANGKY_SINHVIEN_FK foreign key (MaSV) references ATBMN28.SINHVIEN(MaSV),
    constraint DANGKY_MONHOC_HOCKY_FK foreign key (HocKy,Nam,MaMH,MaGV,ThoiGian) references ATBMN28.MONHOC_MO(HocKy,Nam,MaMH,MaGV,ThoiGian),
    constraint Check_Diem check (Diem >= 0 and Diem <= 10 )
)
/


create table  ATBMN28.THONGBAO
(
  ID int not null,
  ThongBao varchar(4000) not null,
  ChucVu varchar(20) not null,
  primary key(ID)
)
/

create table  ATBMN28.THONGBAO$Audit
(
  ID int not null,
  ThongBao varchar(4000) not null,
  ChucVu varchar(20) not null,
  LoaiThayDoi varchar(10),
  UserThayDoi varchar(20),
  ThoiGianThayDoi date
)
/
create table ATBMN28.MONHOC_MO_AUDIT(
    MaMH varchar(10) null,
    HocKy int null,
    Nam INT null,
    ThoiGian varchar (20) null,  
    MaGV varchar(10)null,
    LoaiThayDoi varchar(10),
    UserThayDoi varchar(20),
    ThoiGianThayDoi date
)
/


create table ATBMN28.Luong(
  MaGV varchar(10) primary key,
  Luong raw(2000),
  constraint Luong_GiaoVien foreign key (MaGV) references ATBMN28.GiaoVien(MaGV)
  );
  /
  
create table ATBMN28.Log_Luong(
  log_type varchar(10),
  user_name varchar(50),
  log_date date,
  MaGV varchar(10),
  old_value raw(2000)
  );
  /

GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.NGANH TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.SINHVIEN TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.MONHOC TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.MONHOC_MO TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.GIAOVIEN TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.DANGKY TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.THONGBAO$Audit TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.Luong TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.Log_Luong TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.Log_Luong TO ATBMN28OLS;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.THONGBAO TO ATBMN28;

INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('HTTT', 'He Thong Thong Tin', '15', '200');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('CNPM', 'Cong Nghe Phan Mem', '50', '500');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('TTNT', 'Tri Tue Nhan Tao', '10', '100');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('KHMT', 'Khoa Hoc May Tinh', '30', '200');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('MMT', 'Mang May Tinh', '50', '400');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('DCH', 'Dia Chat Hoc', '30', '420');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('CNVS', 'Cong Nghe Vi Sinh', '80', '1000');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('MTH', 'Moi Truong Hoc', '50', '2000');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('LSH', 'Lich Su Hoc', '140', '600');
INSERT INTO "ATBMN28"."NGANH" (MANGANH, TENNGANH, SOCD, TSSV) VALUES ('TUD', 'Toan Ung Dung', '60', '600');


INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1412185', 'Tran Thien Hoang', 'nam', TO_DATE('1996-07-30 02:58:20', 'YYYY-MM-DD HH24:MI:SS'), 'TP HCM', 'HTTT');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1411100', 'Le Thi Uyen', 'nu', TO_DATE('1996-06-14 02:59:04', 'YYYY-MM-DD HH24:MI:SS'), 'Quan 3', 'CNPM');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1410135', 'Nguyen Minh Tri', 'nam', TO_DATE('1996-02-07 03:00:40', 'YYYY-MM-DD HH24:MI:SS'), 'Quan 5', 'LSH');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1310259', 'Le Thuy Linh', 'nu', TO_DATE('1995-06-21 03:02:41', 'YYYY-MM-DD HH24:MI:SS'), 'Quan 12', 'TTNT');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1311059', 'Minh Nguyet Khoa', 'nam', TO_DATE('1994-12-29 03:03:32', 'YYYY-MM-DD HH24:MI:SS'), 'Quan 1', 'MMT');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1420212', 'Tran Le Minh Tu', 'nam', TO_DATE('1996-06-01 03:04:34', 'YYYY-MM-DD HH24:MI:SS'), 'Quan 1', 'CNPM');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1212121', 'Vo Thanh Liem', 'nam', TO_DATE('1994-05-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Tan Binh', 'HTTT');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1413135', 'Vo Tan Phat', 'nam', TO_DATE('1996-10-29 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Go Vap', 'TUD');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1312189', 'Le Thanh Phuong', 'nu', TO_DATE('1995-08-22 03:06:52', 'YYYY-MM-DD HH24:MI:SS'), 'Hoc Mon', 'DCH');
INSERT INTO "ATBMN28"."SINHVIEN" (MASV, HOTEN, PHAI, NGAYSINH, DIACHI, MANGANH) VALUES ('1312159', 'Ho Thanh Suong', 'nu', TO_DATE('1996-01-01 03:07:47', 'YYYY-MM-DD HH24:MI:SS'), 'Trang Bang', 'HTTT');


INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV01', 'Nguyen Thanh Linh', 'HTTT', 'TP HCM', '0156231123');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV02', 'Nguyen Tu Suong', 'CNPM', 'TP HCM', '0156231124');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV03', 'Le Thuy Linh', 'LSH', 'Hoc Mon', '0963233212');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV04', 'Tran Thanh Minh', 'DCH', 'Go Vap', '01693851524');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV05', 'Vo Minh Thanh', 'TUD', 'Quan 9', '0965011259');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV06', 'Tran Minh Khang', 'MMT', 'Quan 3', '0965023159');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV07', 'Tran Kim Dung', 'HTTT', 'TP HCM', '0698654111');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV08', 'Ho Minh Hai', 'CNPM', 'Nha Trang', '012542225641');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV09', 'Tran Le Kim Lien', 'LSH', 'Quan 9', '0693532128');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV10', 'Le Phuong Lien', '', 'Vung Tau', '0693532954');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV11', 'Nguyen Phuong Hien', '', 'Nha Trang', '0693124128');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV12', 'Tran Thanh Tam', '', 'Quan 1', '0693415128');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV13', 'Tran Thanh Hung', '', 'Quan 12', '0612332128');
INSERT INTO "ATBMN28"."GIAOVIEN" (MAGV, TENGV, MANGANH, DIACHI, SDT) VALUES ('GV14', 'Nguyen Phuc Khang', '', 'Quan 3', '06932128');

INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('UDPT', 'Ung Dung Phan Tan', 'HTTT', '100');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('BI', 'He Thong Thong Minh', 'HTTT', '50');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('LTJ', 'Lap Trinh Java', 'CNPM', '200');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('LTW', 'Lap Trinh Web', 'CNPM', '100');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('LSP', 'Lich Su Phap', 'LSH', '60');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('HQT', 'He Quan Tri', 'HTTT', '150');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('TTNT', 'Tri Tue Nhan Tao', 'KHMT', '70');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('TTNM', 'Tuong Tac Nguoi May', 'KHMT', '30');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('STH', 'Sinh Trac Hoc', 'KHMT', '35');
INSERT INTO "ATBMN28"."MONHOC" (MAMH, TENMH, MANGANH, SOSVTOIDA) VALUES ('HTM', 'Ha Tang Mang', 'MMT', '100');



INSERT INTO "ATBMN28"."MONHOC_MO" (MAMH, HOCKY, NAM, THOIGIAN, MAGV) VALUES ('BI', '2', '2016', 'T6 6,7,8', 'GV01');
INSERT INTO "ATBMN28"."MONHOC_MO" (MAMH, HOCKY, NAM, THOIGIAN, MAGV) VALUES ('LTJ', '1', '2016', 'T4 4,5,6', 'GV02');
INSERT INTO "ATBMN28"."MONHOC_MO" (MAMH, HOCKY, NAM, THOIGIAN, MAGV) VALUES ('LSP', '3', '2015', 'T2 1,2,3', 'GV03');

INSERT INTO "ATBMN28"."DANGKY" (MASV, MAMH, HOCKY, NAM, DIEM, THOIGIAN, MAGV) VALUES ('1410135', 'BI', '2', '2016', '9.5', 'T6 6,7,8', 'GV01');
INSERT INTO "ATBMN28"."DANGKY" (MASV, MAMH, HOCKY, NAM, DIEM, THOIGIAN, MAGV) VALUES ('1310259', 'BI', '2', '2016', '5', 'T6 6,7,8', 'GV01');
INSERT INTO "ATBMN28"."DANGKY" (MASV, MAMH, HOCKY, NAM, DIEM, THOIGIAN, MAGV) VALUES ('1212121', 'BI', '2', '2016', '7', 'T6 6,7,8', 'GV01');
INSERT INTO "ATBMN28"."DANGKY" (MASV, MAMH, HOCKY, NAM, THOIGIAN, MAGV) VALUES ('1413135', 'LTJ', '1', '2016', 'T4 4,5,6', 'GV02');
INSERT INTO "ATBMN28"."DANGKY" (MASV, MAMH, HOCKY, NAM, THOIGIAN, MAGV) VALUES ('1412185', 'LTJ', '1', '2016', 'T4 4,5,6', 'GV02');
INSERT INTO "ATBMN28"."DANGKY" (MASV, MAMH, HOCKY, NAM, DIEM, THOIGIAN, MAGV) VALUES ('1410135', 'LTJ', '1', '2016', '9', 'T4 4,5,6', 'GV02');

INSERT INTO "ATBMN28"."THONGBAO" (ID, THONGBAO, CHUCVU) VALUES ('1', 'Dong hoc phi HK1', 'Sinh Vien');
INSERT INTO "ATBMN28"."THONGBAO" (ID, THONGBAO, CHUCVU) VALUES ('2', 'lich dang ky hoc phan khoa cntt K14', 'Sinh Vien');
INSERT INTO "ATBMN28"."THONGBAO" (ID, THONGBAO, CHUCVU) VALUES ('3', 'Thong bao cham DRL nam hoc 2017', 'Sinh Vien');
INSERT INTO "ATBMN28"."THONGBAO" (ID, THONGBAO, CHUCVU) VALUES ('4', 'Hop Can Bo Toan Truong dinh ky  nam 2017', 'Can Bo');
INSERT INTO "ATBMN28"."THONGBAO" (ID, THONGBAO, CHUCVU) VALUES ('5', 'Hop Can Bo khoa CNTT', 'Can Bo');
INSERT INTO "ATBMN28"."THONGBAO" (ID, THONGBAO, CHUCVU) VALUES ('6', 'Doi phong hoc lop HTTT', 'Giao Vien');
INSERT INTO "ATBMN28"."THONGBAO" (ID, THONGBAO, CHUCVU) VALUES ('7', 'Hop giao vien toan truong ve nghi dinh moi trong thi dai hoc 2017', 'Giao Vien');

insert into ATBMN28.Luong values('GV01',enc_dec.encrypt('10000000','antoanbaomat'));
insert into ATBMN28.Luong values('GV02',enc_dec.encrypt('50000000','antoanbaomat'));
insert into ATBMN28.Luong values('GV03',enc_dec.encrypt('80000000','antoanbaomat'));
insert into ATBMN28.Luong values('GV04',enc_dec.encrypt('90000000','antoanbaomat'));

create user "1412185" identified by "1412185"
default tablespace users
temporary tablespace temp
account unlock;

create user "1411100" identified by "1411100"
default tablespace users
temporary tablespace temp
account unlock;

create user "1410135" identified by "1410135"
default tablespace users
temporary tablespace temp
account unlock;

create user "1310259" identified by "1310259"
default tablespace users
temporary tablespace temp
account unlock;

create user "1311059" identified by "1311059"
default tablespace users
temporary tablespace temp
account unlock;

create user "1420212" identified by "1420212"
default tablespace users
temporary tablespace temp
account unlock;

create user "1212121" identified by "1212121"
default tablespace users
temporary tablespace temp
account unlock;

create user "1413135" identified by "1413135"
default tablespace users
temporary tablespace temp
account unlock;

create user "1312189" identified by "1312189"
default tablespace users
temporary tablespace temp
account unlock;

create user "1312159" identified by "1312159"
default tablespace users
temporary tablespace temp
account unlock;

create user gv01 identified by gv01
default tablespace users
temporary tablespace temp
account unlock;

create user gv02 identified by gv02
default tablespace users
temporary tablespace temp
account unlock;

create user gv03 identified by gv03
default tablespace users
temporary tablespace temp
account unlock;

create user gv04 identified by gv04
default tablespace users
temporary tablespace temp
account unlock;

create user gv05 identified by gv05
default tablespace users
temporary tablespace temp
account unlock;

create user gv06 identified by gv06
default tablespace users
temporary tablespace temp
account unlock;

create user gv07 identified by gv07
default tablespace users
temporary tablespace temp
account unlock;

create user gv08 identified by gv08
default tablespace users
temporary tablespace temp
account unlock;

create user gv09 identified by gv09
default tablespace users
temporary tablespace temp
account unlock;

create user gv10 identified by gv10
default tablespace users
temporary tablespace temp
account unlock;

create user gv11 identified by gv11
default tablespace users
temporary tablespace temp
account unlock;

create user gv12 identified by gv12
default tablespace users
temporary tablespace temp
account unlock;

create user gv13 identified by gv13
default tablespace users
temporary tablespace temp
account unlock;

create user gv14 identified by gv14
default tablespace users
temporary tablespace temp
account unlock;

create role sinhvien;
create role giaovien;
create role truongphokhoa;
create role truongbomon;
create role giaovu;


grant create session to gv01;
grant create session to gv02;
grant create session to gv03;
grant create session to gv04;
grant create session to gv05;
grant create session to gv06;
grant create session to gv07;
grant create session to gv08;
grant create session to gv09;
grant create session to gv10;
grant create session to gv11;
grant create session to gv12;
grant create session to gv13;
grant create session to gv14;

grant create session to "1412185";
grant create session to "1411100";
grant create session to "1410135";
grant create session to "1310259";
grant create session to "1311059";
grant create session to "1420212";
grant create session to "1212121";
grant create session to "1413135";
grant create session to "1312189";
grant create session to "1312159";

create or replace procedure GetUserRole(
  username in varchar2,
  userrole out varchar2
)
is
begin
select GRANTED_ROLE into userrole from Dba_role_privs where GRANTEE=UPPER(username);
EXCEPTION WHEN NO_DATA_FOUND then
 DBMS_OUTPUT.PUT_LINE('Loi');
end;
/

create or replace procedure ATBMN28.XoaThongBao(
  inp_ID ATBMN28.THONGBAO.ID%TYPE
)
is
begin
  delete from ATBMN28.THONGBAO where ID=3;
  commit;
end;
/

create or replace procedure ATBMN28.ThemThongBao(
  inp_ID ATBMN28.THONGBAO.ID%TYPE,
  inp_THONGBAO ATBMN28.THONGBAO.THONGBAO%TYPE,
  inp_CHUCVU ATBMN28.THONGBAO.CHUCVU%TYPE
)
is
begin
  insert into ATBMN28.THONGBAO (ID,THONGBAO,CHUCVU,THONGBAO_LABEL) values (inp_ID,inp_THONGBAO,inp_CHUCVU,null);
  commit;
end;
/



grant execute on GetUserRole to public with grant option;
grant dba to lbacsys;
grant select,update on ATBMN28.THONGBAO to lbacsys;

grant truongphokhoa to gv01;
grant truongphokhoa to gv02;
grant truongphokhoa to gv03;
grant giaovien to gv04;
grant giaovien to gv05;
grant giaovien to gv06;
grant truongbomon to gv07;
grant truongbomon to gv08;
grant truongbomon to gv09;
grant giaovu to gv14;
grant giaovu to gv13;
grant giaovu to gv12;
grant giaovu to gv11;
grant giaovu to gv10;


grant sinhvien to "1412185";
grant sinhvien to "1411100";
grant sinhvien to "1410135";
grant sinhvien to "1310259";
grant sinhvien to "1311059";
grant sinhvien to "1420212";
grant sinhvien to "1212121";
grant sinhvien to "1413135";
grant sinhvien to "1312189";
grant sinhvien to "1312159";

GRANT SELECT ON ATBMN28.GIAOVIEN  TO giaovien,giaovu,truongphokhoa,truongbomon;
grant update(TenGV,SDT,DiaChi) on ATBMN28.GIAOVIEN to giaovien,giaovu,truongphokhoa,truongbomon;


grant select on ATBMN28.MONHOC_MO to giaovien;
grant select on ATBMN28.MONHOC to giaovien;
grant select on ATBMN28.THONGBAO to giaovien;
grant select on ATBMN28.DANGKY to giaovien;

grant select on ATBMN28.MONHOC to truongbomon;
grant select on ATBMN28.THONGBAO to truongbomon;
grant select on ATBMN28.DANGKY to truongbomon;

grant all on ATBMN28.MONHOC_MO to truongphokhoa;
grant select on ATBMN28.MONHOC to truongphokhoa;
grant select on ATBMN28.THONGBAO to truongphokhoa;
grant all on ATBMN28.LUONG to truongphokhoa;
grant select on ATBMN28.DANGKY to truongphokhoa;

grant all on ATBMN28.MONHOC_MO to giaovu;
grant select on ATBMN28.MONHOC to giaovu;
grant all on ATBMN28.DANGKY to giaovu;
grant select on ATBMN28.NGANH to giaovu;
grant select on ATBMN28.SINHVIEN to giaovu;
grant all on ATBMN28.THONGBAO to giaovu;
grant all on ATBMN28.LUONG to giaovu;


grant all on ATBMN28.DANGKY to sinhvien;
grant select on ATBMN28.MONHOC_MO to sinhvien;
grant select on ATBMN28.THONGBAO to sinhvien;
grant select on ATBMN28.MONHOC to sinhvien;

grant execute on dbms_crypto to ATBMN28;
grant execute on DBMS_RLS TO ATBMN28;
grant execute on ATBMN28.enc_dec to truongphokhoa;
grant execute on ATBMN28.enc_dec to gv01;
grant execute on dbms_crypto to truongphokhoa;
grant execute on DBMS_RLS TO truongphokhoa;
grant execute on enc_dec.decrypt to truongphokhoa;
grant execute on enc_dec.encrypt to truongphokhoa;
grant select on Dba_role_privs to public;
grant execute on ATBMN28.XoaThongBao to ATBMN28;
grant execute on ATBMN28.XoaThongBao to giaovu;
grant execute on ATBMN28.ThemThongBao to ATBMN28;
grant execute on ATBMN28.ThemThongBao to giaovu;
grant execute on SetThongBaoPolicy to ATBMN28OLS with grant option;

grant execute on decrypt_Luong to truongphokhoa;
grant execute on decrypt_Luong to ATBMN28;
grant execute on decrypt_Luong to ATBMN28OLS;
grant execute on encrypt_Luong to truongphokhoa;
revoke execute any procedure to truongphokhoa;
/* --dung procedure lay role dua tren usname
declare
usrole varchar2(20);
begin 
 GetUserRole('gv14',usrole);
 DBMS_OUTPUT.PUT_LINE(usrole);
 end;
 /
 */

drop trigger auditThongBao;

INSERT INTO "ATBMN28"."MONHOC_MO" (MAMH, HOCKY, NAM, THOIGIAN, MAGV) VALUES ('HQT', '1', '2017', 'T2 1,2,3', 'GV04');

delete from ATBMN28.MONHOC_MO where MAMH ='HQT';

grant select on ATBMN28.MONHOC_MO_AUDIT to ATBMN28;



select * from ATBMN28.MONHOC_MO_AUDIT;




