select 0 as Zero;
DROP TABLE loc_country_m IF EXISTS;

create table loc_country_m
(
	id serial not null primary key,
	country_code varchar(3),
	colors text[] 		--color text array types
);

insert into loc_country_m(country_code, colors) 
values 
('USA', ARRAY['red', 'white', 'blue']), 
('ATA', ARRAY['blue', 'white']),
('BRA', ARRAY['green','yellow','blue']),
('DEU', ARRAY['black', 'red', 'yellow']),
('IND', ARRAY['orange', 'green', 'white']);

insert into loc_country_m(country_code, colors) 
values ('COL', '{"yellow", "blue", "red"}');


select * from loc_country_m;

--get the first COLUMN
select country_code, colors[1]  --postgres arrays start with index 1
from loc_country_m;

--Return the total number of elements in the array or 0 if the array is empty.
select country_code, cardinality(colors) 
from loc_country_m;

--Return the length of the requested array dimension.
select country_code, array_length(colors,1)
from loc_country_m;

--Expands an array into a set of rows.
--The array's elements are read out in storage order.
--Allows processing the array's content as if it were table object relationship.
select country_code, unnest(colors)
from loc_country_m 
where country_code = 'USA';

--Show the row which contain 'red' value at the first position of array 
select country_code, colors 
from loc_country_m 
where colors[1] = 'red';

--Show the data 'red' is compose of it in all the arrays
select country_code, colors
from loc_country_m 
where 'red' = ANY (colors);

--Show the position's no of elements in the array which has data 'red'.
select country_code, array_position(colors,'red')
from loc_country_m;

--Show the position's no of elements in the array which especially has data 'red'.
--The NULL value cannot showing.
select country_code, array_position(colors,'red')
from loc_country_m
where 'red' = ANY (colors);

--Contains
select country_code, colors
from loc_country_m 
where colors @> '{"black"}';

--Selecting a range of data items
--[Starting index:ending index]
select country_code, colors[1:2] 
from loc_country_m;

--Show selecting data of positioning at array[1:3]
select country_code, colors[1:3] 
from loc_country_m;

--When require to restart SERIAL or BIGSERIAL 
--ALTER SEQUENCE person_id_seq RESTART WITH 10;

--How to use the update statement.
--array_prepend
--array_append
--array_remove
--array_cat

DROP TABLE flags IF EXISTS;

CREATE TABLE flags {
	id serial PRIMARY KEY,
	country_code varchar(3),
	--colors text[]
	colors text ARRAY
);

insert into flags(country_code, colors)
values 
('USA', ARRAY['red', 'white', 'blue']), 	--united states
('ATA', ARRAY['blue', 'white']),			--antarctica
('BRA', ARRAY['green','yellow','blue']),	--braxil
('DEU', ARRAY['black', 'red', 'yellow']),	--germany
('IND', ARRAY['orange', 'green', 'white']);	--india

insert into flags(country_code, colors) 
values ('COL', '{"yellow", "blue", "red"}');


select * from flags;

--test colors
insert into flags(country_code, colors) 
values ('TST', array['red']);

--update color red to white
update flags 
set colors = '{white}' 
where id=7;

select * from flags;

--set the colors to yellow and green
update flags 
set colors = '{yellow,green}' 
where id=7;

select * from flags;

--update color array at first is brown
update flags 
set colors[1]='brown'
where id=7;

--update color array both is gray and black
update flags 
set colors[1]='gray', colors[2]='black'
where id=7;

--update with array_append
update flags 
set clors = array_append(colors,'c3')
where id=7;

--select with append new data into column
select colors, array_append(colors,'dark blue')
from flags 
where id=7;

--update with append new data first into column
update flags 
set colors = array_prepend('red',colors)
where id=7;

--UPDATE specify array position
update flags 
set colors[1]='orange',
	colors[2]='purple',colors[3]='cyan'
where id=7;

--remove element from array 
update flags 
set colors = array_remove(colors,'cyan')
where id=7;

update flags 
set colors = array_remove(colors,'c3')
where id=7;

--update array concat 
update flags 
set colors = array_cat(colors,'{c1,c2,c3}')
where id=7;

--select to update/insert data 
select array_cat(colors,'{a,b,c}')
from flags 
where id=7;

--update to reset color back
update flags 
set colors = '{yellow,green}'
where id=7;

update flags 
set colors[1]='brown'
where id=7;

--How to use the update an array value when don't know the Index Position.

DROP TABLE months IF EXISTS;

CREATE TABLE months {
	country_code varchar(3) PRIMARY KEY,
	month_name text ARRAY
);

insert into months (country_code, month_name)
VALUES
('USA', ARRAY['january','february','march','april','may','june','july','august','septmeber','october','november','december']),   --united states
('USA', ARRAY['enero','eebrero','marzo','abril','mayo','junio','augosto','septiembre','octubre','noviembre','diciembre']);  	 --mexico

select * from months;

select country_code, array_position(month_name,'septmeber')
from months
where country_code = 'USA';

--update
update months 
set month_name[9] = 'september'
where country_code = 'USA';

--later 
select country_code, array_position(month_name,'september')
from months
where country_code = 'USA';

--update in once TIME
update months
set month_name[
	array_position(month_name,'eebrero')
	] = 'febrero'
where country_code = 'MEX';


--Json : Working with JSON in PostgreSQL vs MongoDB
--https://youtu.be/O9zNbPuX2sk

--regexp_replace() เพื่อแทนที่ข้อความตาม pattern
--https://drive.google.com/file/d/1nC9XCOOn7jtfXtdzdjj0JH8-Fy-muunN/view

--saturn database (saturn.tar) 
--https://drive.google.com/file/d/1ccFIfX35QIpUYyJKa8Ss7cvgz5B-51XB/view

--regexp_split_to_array
--https://drive.google.com/file/d/12Gj--m8Jz34zeRJgJcANYKv62rcwiobI/view

--regexp_split_to_table
--https://drive.google.com/file/d/1e-hQnv89gQiz6nxeuof6ie8hsKMZhnGp/view