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
create table ATBMN28.Luong(
  MaGV varchar(10) primary key,
  Luong raw(2000),
  constraint Luong_GiaoVien foreign key (MaGV) references ATBMN28.GiaoVien(MaGV)
  )
  /
  
create table ATBMN28.Log_Luong(
  log_type varchar(10),
  user_name varchar(50),
  log_date date,
  MaGV varchar(10),
  old_value raw(2000)
  )
  /

insert into ATBMN28.Luong values('GV01',enc_dec.encrypt('10000000','antoanbaomat'));
insert into ATBMN28.Luong values('GV02',enc_dec.encrypt('50000000','antoanbaomat'));
insert into ATBMN28.Luong values('GV03',enc_dec.encrypt('80000000','antoanbaomat'));
update ATBMN28.Luong set Luong= enc_dec.encrypt('10000','antoanbaomat') where MaGv='GV01'
select MAGV , enc_dec.decrypt(LUONG,'antoanbaomat') Luong from ATBMN28.Luong
select * from ATBMN28.Log_luong



GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.NGANH TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.SINHVIEN TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.MONHOC TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.MONHOC_MO TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.GIAOVIEN TO ATBMN28;
GRANT SELECT , INSERT, UPDATE , DELETE on ATBMN28.DANGKY TO ATBMN28;

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

create user gv15 identified by gv15
default tablespace ATBMN28
temporary tablespace ATBMN28
account unlock;

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




