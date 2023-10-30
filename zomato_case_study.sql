create database swiggy;
use swiggy;

create table users(
user_id int not null,
name varchar(20) not null,
email varchar(20),
password varchar(20)
);
select * from users;

-- insert into users values(1,'Nitish','nitish@gmail.com', 'p252h');
-- insert into users values(2, 'Khushboo', 'khushboo@gmail.com', 'hxn9b');
-- insert into users values(3, 'Vartika','vartika@gmail.com', '9hu7j');
-- insert into users values(4, 'Ankit', 'ankit@gmail.com', 'lkko3');
-- insert into users values(5,'Neha','neha@gmail.com', '3i7qm');
-- insert into users values(6,'Anupama','anupama@gmail.com', '46rdw2');
-- insert into users values(7,'Rishabh','rishabh@gmail.com', '4sw123');

drop table `zomato-schema - restaurants`;

select * from restaurants;

-- 1. Find customers who have never ordered
select name from users where user_id not in (select user_id from orders); 

-- 2.Average Price/dish?

select f.f_name, avg(m.price) as avg_price
from menu m
join food f
on m.f_id = f.f_id
group by f.f_name;

-- 3. Find the top restaurant in terms of the number of orders for a given month

select r.r_name , count(*) as `month`
 from orders o
 join restaurants r
 on o.r_id = r.r_id
 where monthname(`date`) = 'June'
 group by r.r_name
 order by month desc
 limit 1;

-- select count(*) from orders;
-- select monthname(date) from orders;
-- Error Code: 1052. Column 'r_id' in field list is ambiguous


-- 4. restaurants with monthly sales greater than x for 

select  r.r_name,sum(amount) reveneu
from orders o
join restaurants r
on o.r_id = r.r_id
where  monthname(date) = 'June'
group by r.r_name
Having reveneu>500;


-- 5. Show all orders with order details for a particular customer in a particular date range?

-- select * from orders
-- where user_id = (select user_id from users where name = 'Ankit')
-- and (date > '2022-05-30' and date <'2022-07-10');

select o.order_id, r.r_name,od.f_id,f.f_name
from orders o 
join restaurants r
on o.r_id = r.r_id
join order_details od
on 
o.order_id = od.order_id
join food f
on 
od.f_id = f.f_id
where user_id = (select user_id from users where name = 'Ankit')
and (date > '2022-05-30' and date <'2022-07-10')


-- 6. Find restaurants with max repeated customers 

-- select r_id, user_id, count(*) as visits
-- from orders
-- group by r_id,user_id
-- having visits>1;

select r.r_name, count(*) as loyal_customer
from (select r_id, user_id, count(*) as visits
	  from orders
	   group by r_id,user_id
       having visits>1) as t
 JOIN restaurants r
on 
t.r_id= r.r_id
 group by r.r_name
 order by loyal_customer desc limit 1;      
 
-- 7. Month over month revenue growth of swiggy   
select month, revenue,prev_month,((revenue-prev_month)/prev_month)*100 as percentage_growth from
(
with sales as 
(
select monthname(date)  month, sum(amount) revenue
from orders
group by month
order by month desc
)
select month, revenue, lag(revenue,1) over (order by revenue) as prev_month
from sales) t

   
-- 8. Customer - favorite food
with temp as
(
SELECT o.user_id, od.f_id,count(*) as frequency
from orders o
join order_details od
on o.order_id = od.order_id
group by o.user_id,od.f_id
)
select u.name, f.f_name,t1.frequency 
from temp t1
JOIN users u
on t1.user_id = u.user_id
join food f
on f.f_id = t1.f_id 
where t1.frequency = (select max(frequency) from temp t2 where t1.user_id= t2.user_id)



   