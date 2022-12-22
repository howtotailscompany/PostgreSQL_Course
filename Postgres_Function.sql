
create or replace function fn_mid(varchar, integer, integer)
return varchar
as 
$$
begin
		return substring($1, $2, $3);
end;
$$
language plpgsql;

select fn_mid('software',5,3);


--use alias
create or replace function fn_mid1(varchar, integer, integer)
return varchar
as 
$$
declare word ALIAS for $1;
		startPos ALIAS for $2;
		cnt ALIAS for $3;
begin
		return substring(word, startPos, cnt);
end;
$$
language plpgsql;

select fn_mid1('software',1,4);


--use parameter name and fatatype 
create or replace function fn_mid2(buffer varchar, startPos integer, cntlen integer)
return varchar
as 
$$
begin
		return substring(buffer, startPos, cntlen);
end;
$$
language plpgsql;

select fn_mid2('software',1,4);


--Function Template
--parameter type{in*|out|inout|VARIADIC**}  **default  **variable number of arguments
--create or replace function func_name({parameter type} fieldName datatype)
create or replace function func_name(fieldName datatype)
return <return_datatype>
as 
$$
begin
	<type in function body here>
end;
$$
language plpgsql;

if <condition> then
		<statements>
elsif <condition> then
		<statements>
else
		<statements>
end if;


--fnMakeFull later
create or replace function firstName(firstName varchar, lastName varchar)
returns varchar
as 
$$
begin
	if firstName is null and lastName is null then
			return null;
	elsif firstName is null and lastName is not null then
			return lastName;
	elsif firstName is not null and lastName is null then
			return firstName;
	else
			return concat(initCap(firstName),' ', initCap(lastName));
			--return concat(firstName,' ',lastName);
			--return concat_ws(' ',firstName, lastName);
			--return firstName || ' ' || lastName;
	end if;
end;
$$
language plpgsql;

select * from firstName('fred','sanford');


--Use InOut Parameter Type
create or replace function fnSwap(inout num1 int, inout num2 int)
as 
$$
begin
	select num1,num2 into num2,num1;
end;
$$
language plpgsql;

select * from fnSwap(10,20);


--Use ARRAY input parameter 
create or replace function fnMean(numeric[])
return numeric
as 
$$
declare total numeric := 0;
		val numeric;
		cnt int := 0;
		n_array ALIAS for $1;
begin
	foreach val in array n_array
	loop
		total := total + val;
		cnt := cnt +1;
	end loop;
	
	return total/cnt;
end;
$$
language plpgsql;

select fnMean(ARRAY[10,20,30,40,50]);


--Return Query 
--template
create or replace function fn<table_event>(fieldName datatype)
returns table
(
	field_name1 integer,
	field_name2 character varying(60),
	field_name3 varchar
)
as 
$$
begin 
		--table alias is mandatory, or use tablename as alias 
		RETURN QUERY
		select alias.field1,
			   alias.field2,
			   alias.field3
		from table alias 
		where alias.field1 = inputParameter;
end;
$$
language plpgsql;


--later
create or replace function fnGetMoviesByYear(yr integer)
returns table
(
	movie_id integer,
	movie_name character varying(60),
	year_released integer
)
as 
$$
begin 
		--table alias is mandatory, or use tablename as alias 
		RETURN QUERY
		select m.movie_id, m.movie_name, m.year_released 
		from movies m 
		where m.year_released = yr;
end;
$$
language plpgsql;

select * from fnGetMoviesByYear(2022);


