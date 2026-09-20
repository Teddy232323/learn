-- 建表
create table products(
 name varchar(16) primary key,
 price int not null
);
-- 插入数据
insert into products(name,price)
values
('苹果',50),
('橘子',100),
('香蕉',80);

select * from products;

--26-09-17，练习题>SQL基础教程2版
--1.1
create table addressbook3( 
	regist_no int not null,
	name varchar(128) not null,
	address varchar(256) not null,
	tel_no char(10),
	mail_address char(20)
	);
alter table addressbook3 add constraint a_pk primary  key (regist_no);
--1.2
alter table addressbook3 add column postal_code char(8) not null;
select * from addressbook3;
--1.3
drop table addressbook3;
alter table addressbook rename to addressbook3;
--2.1
select product_name,regist_date
	from product
	where regist_date > '2009-04-28';
--2.2
select * from product where purchase_price is null;
select * from product where purchase_price is not null;
--2.3
--answer1:
select product_name,sale_price,purchase_price
	from product 
	where sale_price >= purchase_price+500;
--answer2:
select product_name,sale_price,purchase_price
	from product p 
	where purchase_price+500 <=sale_price; 
--2.4
select product_name,product_type,0.9*sale_price-purchase_price as profit
	from product p 
	where 0.9*sale_price-purchase_price>100
		and product_type in ('办公用品','厨房用具');
--3.1
select product_type,sum(sale_price )
	from product p
	where regist_date > '2009-09-01'
	group by p.product_type;
--3.2
select product_type,sum(sale_price) as sum1,sum(purchase_price ) as sum2
	from product
	group by product_type 
	having sum(sale_price ) >=1.5*sum(purchase_price );
--3.3
select * from product p 
	order by regist_date desc,sale_price;
select * from product;
--4.1
begin transaction;
	insert into product values
	('0009','T恤衫','衣服',1000,500,'2008-09-20'),
	('0010','打孔器','办公用品',500,320,'2008-09-11'),
	('0011','运动T恤','衣服',4000,2800,null);
rollback;
select * from product;
--4.2
insert into product 
	select * from product;
alter table product drop constraint product_pkey;
--4.3
select  * from productmargin;
create table productmargin1(
product_id char(4) not null,
product_name varchar(100) not null,
sale_price integer,
purchase_price integer,
maigin integer,
primary key(product_id));
insert into productmargin1(product_id,product_name,sale_price,purchase_price,margin)
values 
('0001','T恤衫',1000,500,500),
('0002','打孔器',500,320,180),
('0003','运动T恤',4000,2800,1200);
alter table productmargin1 rename column maigin to margin; 
select * from productmargin;
--4.4
update  productmargin1
set sale_price=3000
where product_id='0003';
select * from productmargin1;
update productmargin1
set margin=sale_price-purchase_price;
--5.1


select * from products;--模块1：演示完整提交流程
select max(price),min(price) from products;

