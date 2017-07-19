EXECUTE SA_SYSDBA.CREATE_POLICY('ACCESS_CHITIEU','OLS_CHITIEU');

EXEC LBACSYS.OLS_ENFORCEMENT.ENABLE_OLS;

EXECUTE sa_components.create_LEVEL ('ACCESS_CHITIEU',1000,'KNC','KHONGNHAYCAM');
EXECUTE sa_components.create_LEVEL ('ACCESS_CHITIEU',2000,'NC','NHAYCAM');
EXECUTE sa_components.create_LEVEL ('ACCESS_CHITIEU',3000,'BM','BIMAT');

EXECUTE sa_components.create_COMPARTMENT ('ACCESS_CHITIEU',1000,'LU','LUONG');
EXECUTE sa_components.create_COMPARTMENT ('ACCESS_CHITIEU',2000,'QL','QUANLY');
EXECUTE sa_components.create_COMPARTMENT ('ACCESS_CHITIEU',3000,'VL','VATLIEU');

EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',11000,'KNC:LU:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',12000,'KNC:QL:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',13000,'KNC:VL:');

EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',21000,'NC:LU:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',22000,'NC:QL:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',23000,'NC:VL:');

EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',31000,'BM:LU:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',32000,'BM:QL:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',33000,'BM:VL:');

EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',41000,'KNC:LU,QL,VL:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',42000,'NC:LU,QL,VL:');
EXECUTE sa_label_admin.create_label ('ACCESS_CHITIEU',43000,'BM:LU,QL,VL:');

col version for a12
col comp_name for a30
select comp_name, version, status from dba_registry
 where comp_name in ('Oracle Database Vault', 'Oracle Label Security’');