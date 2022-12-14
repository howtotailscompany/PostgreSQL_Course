-- Topic: create non-unique and unique indexes


-- drop table if exists menu;

-- สร้างตาราง menu
create table menu (
	id int primary key,
	descr varchar,
	descr_en varchar,
	category varchar,
	price int
);

-- ใส่ข้อมูลสำหรับทดสอบ
insert into menu values
	(1, 'มอคค่า', 'mocha', 'coffee', 40),
	(2, 'ลาเต้', 'latte', 'coffee', 50);
	
select * from menu;

-- ใส่ข้อมูลที่มีชื่อเมนูซ้ำกับที่มีอยู่ก่อนหน้า
insert into menu values
	(99, 'มอคค่า', 'mocha', 'coffee', 55);

select * from menu;

-- สร้าง unique index ให้กับคอลัมน์ descr
-- สังเกตว่าไม่สามารถสร้างได้เนื่องจากข้อมูลในคอลัมน์ descr มีค่า มอคค่า ซ้ำกันอยู่
create unique index uidx_menu_descr on menu(descr);

-- ทำการลบแถว id=99
delete from menu where id=99;

-- สร้าง unique index ให้กับคอลัมน์ descr
-- คราวนี้สามารถสร้าง unique index ได้
create unique index uidx_menu_descr on menu(descr);

select * from menu;

-- ทดสอบการใส่ค่าในคอลัมน์ descr ที่เคยมีอยู่ในตาราง
insert into menu values
	(99, 'มอคค่า', 'mocha', 'coffee', 55);
	
-- สร้าง non-unique index ให้กับคอลัมน์ category
create index idx_menu_category on menu(category);

insert into menu values
	(70, 'ชาเขียว', 'green tea', 'tea', 50),
	(71, 'ชามะลิ', '่jasmine tea', 'tea', 35);
	
select * from menu;

-- ลบ index uidx_menu_descr ที่สร้างขึ้น
drop index uidx_menu_descr;

insert into menu values
	(55, 'ชาเขียว', 'green tea', 'tea', 50);

select * from menu;