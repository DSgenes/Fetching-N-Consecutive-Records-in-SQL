/*

Practicing to Fetch N Consecutive Records in Sql

*/
drop table weather;
create table weather
            (id int primary key, city varchar(50), temperature int, day date);

insert into weather
values      (1, 'London', -1, '2021-01-01'),
            (2, 'London', -2, '2021-01-02'),
			(3, 'London', 4, '2021-01-03'),
			(4, 'London', 1, '2021-01-04'),
			(5, 'London', -2, '2021-01-05'),
			(6, 'London', -5, '2021-01-06'),
			(7, 'London', -7, '2021-01-07'),
			(8, 'London', 5, '2021-01-08'),
			(9, 'London', -20, '2021-01-09'),
			(10, 'London', 20, '2021-01-10'),
			(11, 'London', 22, '2021-01-11'), 
			(12, 'London', -1, '2021-01-12'),
			(13, 'London', -2, '2021-01-13'),
			(14, 'London', -2, '2021-01-14'),
			(15, 'London', -4, '2021-01-15'),
			(16, 'London', -9, '2021-01-16'),
			(17, 'London', 0, '2021-01-17'),
			(18, 'London', -10, '2021-01-18'),
			(19, 'London', -11, '2021-01-19'),
			(20, 'London', -12, '2021-01-20'),
			(21, 'London', -11, '2021-01-21');
select * from weather;
--Sql query to fetch "N" consecutive records when temperature is below 0
with t1 as
       (select * ,
       row_number() over(order by id) as rn,
       id -(row_number() over(order by id)) as difference
       from weather
       where temperature < 0),
	t2 as 
	   (select *, count(*) over(partition by difference) as no_of_records
	   from t1)
select id, city, temperature, day
from t2
where no_of_records >= 4;
--------------------------------------------------------------------------------------------------
--Fetch the N consecutive records from a table but the table is only going to have only two different columns.
create table vw_weather
             (city varchar(50), temperature int);
insert into vw_weather
values       ('London', -1),
             ('London', -2),
			 ('London', 4),
			 ('London', 1),
			 ('London', -2),
			 ('London', -5),
			 ('London', -7),
			 ('London', 5),
			 ('London', -20),
			 ('London', 20),
			 ('London', 22),
			 ('London', -1),
			 ('London', -2),
			 ('London', -2),
			 ('London', -4),
			 ('London', -9),
			 ('London', 0),
			 ('London', -10),
			 ('London', -11),
			 ('London', -12),
			 ('London', -11);
select * from vw_weather;

with w as
       (select *, row_number() over() as id 
	   from vw_weather),
	t1 as
       (select * ,
       row_number() over(order by id) as rn,
       id -(row_number() over(order by id)) as difference
       from w
       where temperature < 0),
	t2 as 
	   (select *, count(*) over(partition by difference) as no_of_records
	   from t1)
select id, city, temperature
from t2
where no_of_records >= 4;
---------------------------------------------------------------------------------------------------
--Fetch records from table where there are orders for three consecutive days
drop table orders;
create table orders 
            (order_id varchar(20) primary key, order_date date);
insert into orders
values      ('ORD1001', '2021-01-01'),
            ('ORD1002', '2021-02-01'),
			('ORD1003', '2021-02-02'),
			('ORD1004', '2021-02-03'),
			('ORD1005', '2021-03-01'),
			('ORD1006', '2021-06-01'),
			('ORD1007', '2021-12-25'),
			('ORD1008', '2021-12-26');
with t1 as
     (select *,
	 row_number() over(order by order_id) as rn,
	 order_date - cast(row_number() over(order by order_id) as int) as difference
	 from orders),
  t2 as 
     (select *, count(*) over(partition by difference) as no_of_records
	 from t1)
select *
from t2
where no_of_records = 3;
------------------------------------------------------------------------------------------------------