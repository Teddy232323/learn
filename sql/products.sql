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

select * from product;

/*
 * 
 #**1. SQL basics tutorial 2nd edition**
*
*/
--#1.1 learn book
--p186
select product_id,product_name,sale_price,
		(select avg(sale_price) from product )
			as avg_price
	from product;
delete  
	from product 
	where product_id not in (select min(product_id) 
												from product 
												group by product_name);
/*
 * 从 product 表按 product_id 去重，
 * 把去重后的全部数据生成新表 product_1，
 *然后查询新表看结果
 */
create table product_1 as
	select distinct on (product_id) *
	from product;
select * from product_1;
drop table product cascade ;
alter table product_1 rename to product;
select * from product;
---
/*
 * 找出 product_name 名称重复的多余记录（只查询，不会删除数据）
 */
with t as (
	select  product_id,product_name,
		row_number() over(partition by product_name order by product_id) as rn
	from product
)
select * from t where rn>1;
---
--p188
select product_name,product_type,sale_price
	from product p1 
	where sale_price>=(select avg(sale_price) 
									from product p2
									where p1.product_type=p2.product_type
									group by product_type);



--##1.2 exercises 
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
create view viewpractice5_1("商品名称","售价","日期")
	as 
	select product_name,sale_price,regist_date
		from product p 
		where sale_price>=1000 and regist_date='2009-09-20';
select * from viewpractice5_1;
drop view if exists viewpractice5_5;
--5.2
insert into viewpractice5_1 
	values
	('刀子',300,'2009-11-02');
select * from product;
--5.3
delete from product 
	where sale_price=300;
select product_id,product_name,product_type,sale_price,
		(select avg(sale_price) from product) as sale_price_all
	from product;
--5.4

/*
 * 
 # **2. advanced SQL tutorial**
 *
 */ 
--2.1 textbook study
--p17
select * from poptbl;
create table poptbl(
	pref_name char(2) not null ,
	population int not null,
	primary key(pref_name)
	);
insert  into poptbl(pref_name,population)
values 
	('德岛',100),
	('香川',200),
	('爱媛',150),
	('高知',200),
	('福冈',300),
	('佐贺',100),
	('长崎',200),
	('东京',400),
	('群马',50);
select 
	case when pref_name in ('德岛','香川','爱媛','高知') then '四国'
		when pref_name in('福冈','佐贺','长崎') then '九州'
		else '其他' end 
		as "地区名",
	sum(population) as "人口"
	from poptbl 
	group by "地区名"
	order by "人口" desc;
select * from poptbl;
--answer to the example 
--1.1 case expression
select 
	case pref_name
		when '德岛' then '四国'
		when '香川' then '四国'
		when '爱媛' then '四国'
		when '高知' then '四国'
		when '福冈' then '九州'
		when '佐贺' then '九州'
		when '长崎' then '九州'
		else '其他' end 
		as district,
	sum(population)
	from poptbl
	group by 
		case pref_name
		when '德岛' then '四国'
		when '香川' then '四国'
		when '爱媛' then '四国'
		when '高知' then '四国'
		when '福冈' then '九州'
		when '佐贺' then '九州'
		when '长崎' then '九州'
		else '其他' end;
---
--p18
select  
	case 
		when population<100 then '01'
		when population>=100 and population<200 then '02'
		when population>=200 and population<300 then '03'
		else '04' end 
		as pop_class,
	count(*) as cnt  
	from poptbl 
	group by pop_class
	order by pop_class;
---
--p20
select * from poptbl2;
select  pref_name as "县名",
		sum(case when sex=1 then population else 0 end ) as "男",
		sum(case when sex=2 then population else 0 end ) as "女"
	from poptbl2
	group by "县名";
--**left outer join**
select  p1.pref_name,p1."男",p2."女"
	from (select pref_name,sum(population) as "男"
				from poptbl2 where sex=1 group by pref_name) as p1
			 left outer join
			(select pref_name,sum(population) as "女"
				from poptbl2 p2 where sex=2 group by pref_name) as p2
			on p1.pref_name=p2.pref_name;




--2.2 exercises

select * from products;--模块1：演示完整提交流程
select max(price),min(price) from products;

