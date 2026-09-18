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





select * from products;--模块1：演示完整提交流程
select max(price),min(price) from products;

