create database studentmng1;
use studentmng1;
create table dmkhoa (
makhoa varchar(20) primary key,
tenkhoa varchar(255)
);
insert into dmkhoa values 
("CNTT","Cong nghe thong tin"),
("KT","Ke toan"),
("SP","Su Pham");
create table dmnganh(
manganh int primary key,
tennganh varchar(255),
makhoa varchar(20) not null,
foreign key (makhoa) references dmkhoa(makhoa)
);
insert into dmnganh(manganh,tennganh,makhoa) values 
(140902,"Su pham toan tin","SP"),
(480202,"Tin hoc ung dung","CNTT");
create table dmlop(
malop varchar(20) primary key,
tenlop varchar(255),
manganh int not null,
khoahoc int,
hedt varchar(255),
namnhaphoc int,
foreign key (manganh) references dmnganh(manganh) 
);
insert into dmlop values 
("CT11","Cao dang tin hoc",480202,11,"TC",2013),
("CT12","Cao dang tin hoc",480202,12,"CD",2013),
("CT13","Cao dang tin hoc",480202,13,"TC",2014);
create table dmhocphan(
mahp int primary key,
tenhp varchar(255),
sodvht int,
manganh int not null,
hocky int,
foreign key (manganh) references dmnganh(manganh)
);
insert into dmhocphan values 
(1,"Toan cao cap A1",4,480202,1),
(2,"Tieng anh 1",3,480202,1),
(3,"Vat ly dai cuong",4,480202,1),
(4,"Tieng anh 2",7,480202,1),
(5,"Tieng anh 1",3,140902,2),
(6,"Xac suat thong ke",3,480202,2);
create table sinhvien(
masv int primary key,
hoten varchar(255),
malop varchar(20) not null,
gioitinh tinyint default 1,
ngaysinh date,
diachi varchar (255),
foreign key (malop) references dmlop(malop)
);
insert into sinhvien values
(1,"Phan Thanh", "CT12",0,"1990-09-12","Tuy Phuoc"),
(2,"Nguyen Thi Cam", "CT12",1,"1994-01-12","Quy Nhon"),
(3,"Vo Thi Ha", "CT12",1,"1990-07-02","An Nhon"),
(4,"Tran Hoai Nam", "CT12",0,"1994-04-05","Tay Son"),
(5,"Tran Van Hoang", "CT13",0,"1995-08-04","Vinh Thanh"),
(6,"Dang Thi Thao", "CT13",1,"1995-06-12","Quy Nhon"),
(7,"Le Thi Sen", "CT13",1,"1994-08-12","Phu My"),
(8,"Nguyen Van Huy", "CT11",0,"1995-06-04","Tuy Phuoc"),
(9,"Tran Thi Hoa", "CT11",1,"1994-08-09","Hoai Nhon");
create table diemhp(
masv int not null,
mahp int not null,
diemhp float,
foreign key (masv) references sinhvien(masv),
foreign key (mahp) references dmhocphan(mahp)
);
insert into diemhp values 
(2,2,5.9),
(2,3,4.5),
(3,1,4.3),
(3,2,6.7),
(3,3,7.3),
(4,1,4),
(4,2,5.2),
(4,3,3.5),
(5,1,9.8),
(5,2,7.9),
(5,3,7.5),
(6,1,6.1),
(6,2,5.6),
(6,3,4),
(7,1,6.2);


-- 1
select sv.masv,sv.hoten from sinhvien sv
left join diemhp dhp on dhp.masv = sv.masv where dhp.masv is null ;

-- 2
select sv.masv,sv.hoten from sinhvien sv
left join diemhp dhp on dhp.masv = sv.masv and dhp.mahp = 1 where dhp.masv is null  ;

-- 3
select dmhp.mahp,dmhp.tenhp from dmhocphan dmhp  left join diemhp dhp   on dmhp.mahp=dhp.mahp and dhp.diemhp<5  where dhp.masv is null;

-- 4
select sv.masv,sv.hoten from sinhvien sv left join diemhp dhp on dhp.masv = sv.masv and dhp.diemhp<5 where dhp.masv is null;

-- 5
select lop.tenlop from dmlop lop join sinhvien sv on sv.malop = lop.malop where sv.hoten like "%Hoa";

-- 6
select sv.hoten from sinhvien sv join diemhp dhp on dhp.masv = sv.masv and dhp.mahp = 1 where dhp.diemhp < 5;

-- 7
select * from dmhocphan where sodvht >= (select sodvht from dmhocphan where mahp =1);

-- 8 
select sv.masv,sv.hoten,dhp.mahp,dhp.diemhp from sinhvien sv 
join diemhp dhp on dhp.masv = sv.masv where diemhp = (select max(diemhp) from sinhvien sv 
join diemhp dhp on dhp.masv = sv.masv);

-- 9 
select sv.masv,sv.hoten from sinhvien sv 
join diemhp dhp on dhp.masv = sv.masv and dhp.mahp = 1 where diemhp = (select max(diemhp) from sinhvien sv 
join diemhp dhp on dhp.masv = sv.masv); 

-- 10 
select masv,mahp from diemhp dhp where dhp.diemhp > any (select diemhp from diemhp where masv = 3);

-- 11
select masv,hoten from sinhvien sv  where exists (select masv from diemhp where diemhp.masv = sv.masv );

-- 12 
select masv,hoten from sinhvien sv  where not exists (select masv from diemhp where diemhp.masv = sv.masv );

-- 13 
select masv from diemhp where  mahp = 1 
union
select masv from diemhp where  mahp = 2;

-- 14 
delimiter //
create procedure KIEM_TRA_LOP (Malop_input varchar(20))
begin
 declare lop_count int;
    select count(*) into lop_count from dmlop
    where MaLop = Malop_input;
    if lop_count = 0 then
        select 'Lớp này không có trong danh mục' as Message;
    else
        select sv.HoTen from sinhvien sv
        join diemhp hp on sv.MaSV = hp.MaSV
        where sv.MaLop = Malop_input and hp.DiemHP < 5;
    end if;
end;
// delimiter ;
call KIEM_TRA_LOP('CT12');

-- 15 
delimiter //
create trigger checkmsv  before insert on sinhvien for each row
begin 
if new.masv is null or new.masv = " " then
signal sqlstate "45000" set message_text = "Ma sinh vien phai duoc nhap";
end if;

end;
// delimiter ; 

-- insert into sinhvien values
-- ( NULL,"Phan Thanh", "CT12",0,"1990-09-12","Tuy Phuoc")


-- 16 
alter table dmlop add SiSo int not null default 0 

delimiter //
create trigger check_add 
after insert on sinhvien for each row
begin 
declare count int;
 select count(*) into count from dmlop 
 where malop = new.malop;
if count = 1 then update dmlop set SiSo = SiSo + 1 where malop = new.malop ;
    end if;
end;
// delimiter ;
insert into sinhvien values
( 11,"Phan Thanh", "CT12",0,"1990-09-12","Tuy Phuoc")
-- 17 
DELIMITER //

CREATE FUNCTION doc_diem(diemhp FLOAT) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE docdiem VARCHAR(255);
    DECLARE integer_part INT;
    DECLARE decimal_part INT;

    SET integer_part = FLOOR(diemhp);
    SET decimal_part = ROUND((diemhp - integer_part) * 10);

    SET docdiem =
        CASE
            WHEN integer_part = 10 THEN 'mười'
            ELSE CASE integer_part
                WHEN 9 THEN 'chín'
                WHEN 8 THEN 'tám'
                WHEN 7 THEN 'bảy'
                WHEN 6 THEN 'sáu'
                WHEN 5 THEN 'năm'
                WHEN 4 THEN 'bốn'
                WHEN 3 THEN 'ba'
                WHEN 2 THEN 'hai'
                WHEN 1 THEN 'một'
                ELSE ''
            END
        END;

    IF integer_part >= 0 AND integer_part <= 10 THEN
        SET docdiem = CONCAT(docdiem, ' phẩy ');
        
        IF decimal_part = 0 THEN
            SET docdiem = CONCAT(docdiem, 'không');
        ELSE
            SET docdiem =
                CASE decimal_part
                    WHEN 9 THEN CONCAT(docdiem, 'chín')
                    WHEN 8 THEN CONCAT(docdiem, 'tám')
                    WHEN 7 THEN CONCAT(docdiem, 'bảy')
                    WHEN 6 THEN CONCAT(docdiem, 'sáu')
                    WHEN 5 THEN CONCAT(docdiem, 'lăm')
                    WHEN 4 THEN CONCAT(docdiem, 'bốn')
                    WHEN 3 THEN CONCAT(docdiem, 'ba')
                    WHEN 2 THEN CONCAT(docdiem, 'hai')
                    WHEN 1 THEN CONCAT(docdiem, 'một')
                    ELSE ''
                END;
        END IF;
    END IF;

    RETURN docdiem;
END;
//

DELIMITER ;

SELECT
    sv.masv AS "Mã SV",
    sv.hoten AS "Tên SV",
    d.mahp AS "Mã HP",
    d.diemhp AS "Điểm HP",
    doc_diem(d.diemhp) AS "Điểm Chữ"
FROM
    sinhvien sv
join
    diemhp d ON sv.masv = d.masv;
-- 18 
delimiter //
create procedure HIEN_THI_DIEM (diemhp_input int)
begin
  declare  rowCount int;
  
  select COUNT(*) into rowCount
  from diemhp dhp
where dhp.diemhp < diemhp_input;
  
  if rowCount = 0 then
    select "Khong co sinh vien nao" as Message;
else
    select sv.masv, sv.hoten, sv.malop, dhp.diemhp, dhp.mahp
    from sinhvien sv
    join diemhp dhp on sv.masv = dhp.masv
    where dhp.diemhp < diemhp_input;
  end if;
end;
//
delimiter ;
call HIEN_THI_DIEM (5)

-- 19
delimiter //
create procedure HIEN_THI_MAHP (mahp_input int)
begin
  declare  rowCount int;
  
  select COUNT(*) into rowCount
  from diemhp dhp
where dhp.mahp = mahp_input;
  
  if rowCount = 0 then
    select "Khong co sinh vien nao" as Message;
else
    select sv.hoten
    from sinhvien sv
    join diemhp dhp on sv.masv = dhp.masv
    where dhp.mahp =  mahp_input;
  end if;
end;
//
delimiter ;
call HIEN_THI_MAHP (1);

-- 20 
delimiter //
create procedure HIEN_THI_TUOI (startage int,endage int)
begin
  declare  rowCount int;
  
  select COUNT(*) into rowCount
  from sinhvien sv
where year(now())-year(ngaysinh) between startage and endage;
  
  if rowCount = 0 then
    select "Khong co sinh vien nao" as Message;
else
    select sv.hoten
    from sinhvien sv
where year(now())-year(ngaysinh) between startage and endage;
  end if;
end;
//
delimiter ;
call HIEN_THI_TUOI (20,30)