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
--p186，标量子查询，
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
	from product
	order by product_id;
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
--p188,关联子查询,子查询添加where子句的条件
select product_name,product_type,sale_price
	from product p1 
	where sale_price>=(select avg(sale_price) 
									from product p2
									where p1.product_type=p2.product_type
									);
--p247
select product_id,product_name
	from product 
union
select product_id,cast(regist_date as varchar)
	from product2;
select * from product2;
--	union all**重复部分**
select product_id,product_name
	from product 
union all 
select product_id,product_name
	from product2;
--intersect intersect all
select product_id,product_name
	from product 
intersect 
select product_id,product_name
	from product2 
order by product_id;
--except **位置**
select product_id,product_name
	from product  
except 
select product_id,product_name
	from product2 
order by product_id;
--from  inner join on **join**
select sp.shop_id,sp.shop_name,sp.product_id,
		p.product_name,p.sale_price
	from shopproduct  as sp 
		inner join product as p 
			on sp.product_id=p.product_id
	where sp.shop_id='000A'; 
--from left/right outer join on**外联接**
 select sp.shop_id,sp.shop_name,sp.product_id,
 		p.product_name,p.sale_price
 	from  shopproduct as sp 
 		right outer join product as p
 			on sp.product_id=p.product_id;
 select * from empskills;
select distinct emp 
	from empskills es1
	where not exists ( 
		select skill  from skills 
		except 
		select skill from empskills es2
		where es1.emp=es2.emp 
		);
/*
 * select avg(sale_price) from product p2
 * 			where p1.product_type=p2.product_type
 * 			group by product_type
 */

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
--t1
create view viewpractice5_1("商品名称","售价","日期")
	as 
	select product_name,sale_price,regist_date
		from product p 
		where sale_price>=1000 and regist_date='2009-09-20';
select * from viewpractice5_1;
drop view if exists viewpractice5_5;
--t2
create view viewpractice5_2(product_name,sale_price,regist_date)
	as 
	select product_name,sale_price,regist_date
		from product 
		where sale_price>=1000 and 
			regist_date='2009-09-20';
select * from viewpractice5_1;
--5.2
--t1
insert into viewpractice5_1 
	values
	('刀子',300,'2009-11-02');
select * from product;
--t2
insert into viewpractice5_2
	values
	('刀子',300,'2009-11-02');
select * from viewpractice5_2;
select * from product;
delete 
	from product 
	where product_id is null;
--5.3
--t1
delete from product 
	where sale_price=300;
select product_id,product_name,product_type,sale_price,
		(select avg(sale_price) from product) as sale_price_all
	from product;
--t2
select product_id,product_name,product_type,sale_price,
		(select avg(sale_price) from product) as sale_price_all
	from product;
--t3
select product_id,product_name,product_type,sale_price,
		avg(sale_price) over () 
	from product;
--5.4
--t1**关联子查询**
select p1.product_id,p1.product_name,p1.product_type,p1.sale_price,
		(select avg(sale_price) 
			from product p2 
			where p1.product_type=p2.product_type)  
			as avg_sale_price
	from product p1;
--t2**avg()窗口函数**
select product_id,product_name,product_type,sale_price,
		avg(sale_price) over ( partition by product_type)
	from product
	order by sale_price;
--6.1
select * from product;
--1
select product_name,purchase_price
	from product
	where purchase_price not in(500,2800,5000);
--2**null表达式使用**
select product_name,purchase_price
	from product
	where purchase_price not in(500,2800,5000,null);
--**is nul or is not null**
select product_name,purchase_price
	from product 
	where purchase_price is not null;
--6.2
--t1**sum()聚合函数+case()语句**+case语句与聚合函数优先级
select sum(case when sale_price <=1000 then 1 else 0 end) 
			as low_price,
		sum(case when sale_price<=3000 and sale_price>1000 then 1 else 0 end) 
			as mid_price,
		sum(case when sale_price>3000 then 1 else 0 end)
			as high_price
	from product;
--t2**count()聚合函数+case()语句**
select 
		count(case when sale_price<=1000 then 1 else null end )
			as low_price
		count(case when sale_price>1000 and sale_price<=3000 then 1 else null end) 
			as mid_price,
		count(case when sale_price>3000 then 1 else null end) 
			as high_price
	from product;
--7.1
select  * 
	from product 
union 
select *
	from product 
intersect 
select *
	from product 
order by product_id;
--7.2
select 
		case when sp.shop_id is not null then sp.shop_id else '不确定' end,
		case when sp.shop_name  is null then '不确定' else sp.shop_name end,
		sp.product_id,	p.product_name,p.sale_price
	from shopproduct as sp 
		right outer join product as p 
		on sp.product_id=p.product_id;
	
	
/*
 * 
 # **2. advanced SQL tutorial**
 *
 */ 
--##2.1 textbook study##
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
select case when pref_name in('德岛','香川','爱媛','高知')
					then '四国'
					when pref_name in ('福冈','佐贺','长崎')
					then '九州'
					else '其他'  end as "地区名",
			sum(population) as "人口"
	from poptbl
	group by "地区名"
	order by "人口" desc;
--p20
select pref_name as "县名",
		sum(case sex when 1 then population
			else 0 end) as "男",
		sum(case sex when 2 then population
			else 0 end) as "女"
	from poptbl2
	group by pref_name
	order by "县名";
select current_database();
/*
--constraint check_salary check
		(case when sex='2' 
			then 
					case when salary<=20000
						then 1 else 0 end
			else 1 end =1	)
*/
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
--p23
select * from salaries;
--
update salaries 
	set salary=300000
	where name='相田';
--
update salaries s 
	set salary=case 
						when name ='神崎' then 270000
						when name='木村' then 220000
						when name='相田' then 300000
						else 290000 
					end
	where name in('相田','神崎','木村','齐藤');
--
update salaries s 
	set 
	name='神崎'
	where name='神琦';
update salaries 
	set 
	salary=case when salary>=300000 
							then salary*0.9
						when salary>=250000 and salary<280000
							then salary*1.2
						else salary 
						end
	;
---
--p25
select * from sometable;
update sometable
	set p_key=case 
						when p_key='a'
							then 'b'
						when p_key='b'
							then 'a'
						else p_key 
						end 
	where p_key in ('a','b');
--p27
select * from coursemaster;
select * from opencourses;
--**case语句+in谓语**
select coursemaster as course_name,
	case when course_id in 
					(select course_id 
							from opencourses 
							where  month=200706)
				then 'o' else 'x' 
				end
	as "6月",
	case when course_id in 
					(select course_id 
							from opencourses 
							where  month=200707)
				then 'o' else 'x' 
				end
	as "7月",
	case when course_id in 
					(select course_id 
							from opencourses 
							where  month=200708)
				then 'o' else 'x' 
				end
	as "8月"
	from coursemaster;
--**关联子查询+exists谓语**
select course_name,
		case when exists (select course_id 
											from opencourses op 
											where op.course_id=co.course_id
											and month=200706)
				then 'o' else 'x' end
		as "6月",
		case when exists (select course_id 
											from opencourses op 
											where op.course_id=co.course_id
											and month=200707) 
				then 'o' else 'x' end
		as "7月",
		case when exists (select course_id 
											from opencourses op 
											where op.course_id=co.course_id
											and month=200708) 
				then 'o' else 'x' end
		as "8月"
	from coursemaster co;
--p28
select * from studentclub;
create table studentclub( 
std_id int not null,
club_id int not null,
club_name varchar(4) not null,
main_club_flg varchar(2) not null);
alter table studentclub add constraint 
	p_key primary key(std_id,club_id);
insert into studentclub 
values
	(100,1,'棒球','Y'),
	(100,2,'管弦乐','N'),
	(200,2,'管弦乐','N'),
	(200,3,'羽毛球','Y'),
	(200,4,'足球','N'),
	(300,4,'足球','N'),
	(400,5,'游泳','N'),
	(500,6,'围棋','N');
--29
/*select std_id,club_id 
	from studentclub
except
select std_id,club_id
	from studentclub 
	where main_club_flg='Y' ;	
	end
	studentclub 
	*/
select std_id,max(club_id) as main_club
	from studentclub 
	group by std_id 
	having count(*)=1;
--
select std_id,club_id as main_club
	from studentclub 
	where main_club_flg='Y';
select std_id,
		case when count(*)=1 then max(club_id)
				else max(case when main_club_flg='Y'
										then club_id
										else null end)
				end as main_club
from studentclub s 
group by std_id
order by std_id;
---
--p32**exercise 1-1-1**
select * from greatests;
select key,case when x>=y and x>=z then x 
							when y>=x and y>=z then y 
							else z end as greatest 
	from greatests;
select key,max(col ) as greatest
	from (select key,x as col from greatests 
			  union all
			  select key,y as col from greatests 
			  union all
			  select key,z as col from greatests 
			  ) as tmp
	group by key
	order by key;
--p33**e1-1-2**
select * from poptbl2;
--**关联子查询，扫描整张表
select case sex when 1 then '男' 
						 else '女' end as "性别",
		sum(population) as "全国",
		(select sum(population) from poptbl2 p2
					where pref_name='德岛'
						and p1.sex=p2.sex) as "德岛",
		(select sum(population) from poptbl2 p2
					where pref_name='香川'
						and p1.sex=p2.sex) as "香川",
		(select sum(population) from poptbl2 p2
					where pref_name='爱媛'
						and p1.sex=p2.sex) as "爱媛",
		(select sum(population) from poptbl2 p2
					where pref_name='高知'
						and p1.sex=p2.sex) as "高知",
		(select sum(population) from poptbl2 p2
					where pref_name in ('德岛','香川','爱媛','高知')
						and p1.sex=p2.sex) as "四国(再揭)"
	from poptbl2 p1
	group by sex
	order by sex asc;
--**sum(case)条件聚合**
select 
		case sex when 1 then '男' 
						else '女' end as "性别",
		sum(population) as "全国",
		sum(case when pref_name='德岛' then population
						else 0 end ) as "德岛",
		sum(case when pref_name='香川' then population
						else 0 end ) as "香川",
		sum(case when pref_name='爱媛' then population
						else 0 end) as "爱媛",
		sum(case when pref_name='高知' then population
						else 0 end) as "高知",
		sum(case when pref_name in('德岛','香川','爱媛','高知')
						then population else 0 end) as "四国（再揭）"
		from poptbl2
		group by sex;
--p33**e1-1-3
select * from greatests;
select  key,max(col) as max_col
	from (select key,x as col from greatests
			 union all 
			 select key,y as col from greatests
			 union all
			 select key,z as col from greatests
			 ) as g1
	group  by key
	order by key;
select * from greatests 
	order by case when key='A' then 2
							when key='B' then 1
							when key='C' then 4
							else 3 end;
/*
 * 1-2 自连接的用法**usage of self-join**
 */	
--p35
select * from products;
select p1.name as name_1,p2.name as name_2
	from products p1,products p2;
select distinct p1.name as name_1,p2.name as name_2
	from products p1,products p2
	where p1.name>p2.name;
select p1.name as name_1,p2.name as name_2,p3.name as name_3
	from products p1,products p2,products p3
	where p1.name>p2.name 
		and p2.name>p3.name;
--p39**oracle rowid**
/*
 * oracle 中rowid命令，非postgresql命令，
** delete from products p1
	where rowid < (select max(p2.rowid)
								from product p2
								where p1.name=p2.name 
									and p1.price=p2.price);
**delete from products p1 
	where exists ( select *
								from products p2
								where p1.name =p2.name 
									and p1.price=p2.price 
									and p1.rowid < p2.rowid);
*/
--p40
create table addresses(
	name varchar(4) not null,
	family_id int not null,
	address varchar(20) not null);
insert into addresses
values
	('前田义明',100,'东京都港区虎之门3-2-29'),
	('前田由美',100,'东京都港区虎之门3-2-92'),
	('加藤茶',200,'东京都 新宿区西新宿2-8-1'),
	('加藤胜',200,'东京都新宿区西新宿2-8-1'),
	('福尔摩斯',300,'贝克街221B'),
	('华生',400,'贝克街221B');
select * from addresses;
select a1.name,a1.family_id,a1.address
	from addresses a1,addresses a2
	where a1.family_id=a2.family_id
		and a1.address<>a2.address;
update addresses
set address='东京都新宿区西新宿2-8-1'
where name='加藤茶';
--p41
select * from products;
insert into products 
values 
('葡萄',50),
('西瓜',80),
('柠檬',30),
('草莓',100);
update products 
set 
	price=100
where name='香蕉';
--**self-join,
select p1.name,p1.price
	from products p1,products p2
	where p1.price=p2.price 
		and p1.name<>p2.name;
select p1.name,p1.price
	from products p1
	inner join products p2 
	on p1.price=p2.price 
		and p1.name<>p2.name;
----**关联子查询，找出价格相等的商品**
select name,price 
	from products p1
	where exists  (select 1  
					from products p2 
					where  p1.price=p2.price
						and p1.name<>p2.name); 
--p43**窗口函数实现排序**
select name,price,rank() over (order by price ) as rank_1,
		dense_rank() over (order by price) as dense_rank_2
	from products ;
--**使用非等值自连接实现排序**
select p1.name,p1.price,
		(select count(p2.price) 
			from products p2
			where p2.price<p1.price) +1 
			as rank_1,
			--rank()
		(select count(distinct p2.price) 
			from products p2
			where p2.price<p1.price)+1 
			as dense_rank_2
			--dense_rank()
	from products p1
	order by rank_1;
--**排序，使用自连接**
select p1.name,
		max(p1.price ) as price,
		count(p2.name ) +1 as rank_1
		--max()的使用，count()不统计null
	from products p1 left join products p2 
		on p1.price>p2.price
		--left join on 指定连接的配对条件
	group by p1.name
	order by rank_1;
select p1.name,
		p1.price as price,
		--取消max()的使用
		count(p2.name )+1 as rank_1
	from products p1 left outer join products p2 
		on p1.price>p2.price 
	group by p1.name,p1.price 
	order by rank_1;
/*
 * select p1.name,p2.name
 * 	      from products p1 left join products p2
 * 				on p1.price<p2.price;
 */
select p1.name,p1.price,p2.name,p2.price 
	from products p1 inner join products p2
		on p1.price<p2.price;
----
--p48
--exercise 1-2-1 **textbook**
select * from products ;
select p1.name,p2.name 
	from products p1 inner join products p2
		on p1.price =100 and p2.price =100;
--exercise 1-2-2
create table districtproducts( 
	district varchar(2) not null,
	name varchar(4) not null,
	price int not null,
	primary key(district,name)
	);
select * from districtproducts;
insert into districtproducts
values
('东北','橘子',100),
('东北','苹果',50),
('东北','葡萄',50),
('东北','柠檬',30),
('关东','柠檬',100),
('关东','菠萝',100),
('关东','苹果',100),
('关东','葡萄',70),
('关西','柠檬',70),
('关西','西瓜',30),
('关西','苹果',20);
--answer1 窗口函数rank() over (partition by group by)
select district,name,price,
		rank() over 
			(partition by district order by price desc)
			as rank_1
	from districtproducts
	order by district,rank;
--answer2 **左外+自连接  left join on**
select p1.district,p1.name,p1.price,
		count(p2.name)+1 	as rank_1
	from districtproducts p1 left join
		districtproducts p2 
		on p1.district=p2.district
			and p1.price<p2.price
	group by p1.district,p1.name,p1.price
	order by p1.district,rank_1;
--answer3 **标量子查询**
select district,name,max(price) as price,
		(select count(p2.price)
			from districtproducts p2
			where p1.district=p2.district 
			and p1.price<p2.price)+1
			as rank_1
		from districtproducts  p1
		order by district,rank_1;
--exercise 1-2-3	
create table districtproduct2
	as
	select district,name,price
		from districtproducts;
alter table districtproduct2 rename to districtproducts2;
alter table districtproducts2 add column ranking int;
select * from districtproducts2;
----
--answer1**自连接1----select子查询**
select district,name,price,
		(select count(p2.name) +1 from districtproducts2 p2 
			where p2.price < p1.price and 
				p2.district=p1.district)
			as ranking_1
	from districtproducts2 p1
	order by district,ranking_1;
--answer2**左连接----left join on **
select p1.district,p1.name,p1.price,
		count(p2.name)+1 as ranking_2
	from districtproducts2 p1 left join 
		districtproducts2 p2 on 
		p1.district=p2.district and 
		p1.price>p2.price 
	group by p1.district,p1.name,p1.price 
	order by p1.district,ranking_2;
--answer3**窗口函数----rank() over (partition by order by)**
select district,name,price,
		rank() over 
			(partition by district order by price) 
		as ranking_3
	from districtproducts2 d 
	order by district,ranking_3;
--answer1**
update districtproducts2 p1 
set 
	ranking=(select count(p2.name)+1 
						from districtproducts2 p2
						where p1.district=p2.district 
							and p2.price<p1.price);
select * from districtproducts2;
--answer2**update语句增加from临时表，并where连接内外两表并赋值主表**
update districtproducts2 p1
set ranking=sub.ranking
from(select district,name,rank() over(partition by district
															order by price desc)
				as ranking
			from districtproducts2
		) sub
where p1.district=sub.district and p1.name=sub.name;
--answer2**标准MYSQL写法，join**
update districtproducts2 d 
join(
	select district,name,
		rank() over(partition by district order by price)
		as ranking
		from districtproducts2 
) sub 
on d.district=sub.district and d.name=sub.name 
set 
d.ranking=sub.ranking;
--P59
create table class_a(
name varchar(4) not null,
age int not null,
city varchar(4) not null,
primary key(name)
);
insert into class_a
values
('布朗',22,'东京'),
('拉里',19,'琦玉'),
('伯杰',21,'千叶');
create table class_b(
name varchar(2) not null,
age int,
city varchar(4) not null,
primary key(name)
);
insert into class_b
values
('齐藤',22,'东京'),
('田尻',23,'东京'),
('山田',null,'东京'),
('和泉',18,'千叶'),
('武田',20,'千叶'),
('石川',19,'神奈川');
select * from class_b;
--p60
--answer1
select name,age,city 
	from class_a a
	where age not in (select age from class_b b where city='东京'
							and b.age is not null
							);
--answer2
select * from class_a a
	where not exists(select * from class_b b
										where a.age=b.age and
											b.city='东京')
	order by age desc;
--p63
update class_b
set age=20
where name='山田';
--answer1
select * from class_a
	where age<(select min(age) from class_b
								where city='东京');
--answer2
select name,age,city
	from class_a
	where age<all(select age from class_b where city='东京');
--p69
create table seqtbl(
seq int not null,
name varchar(4) not null,
primary key (seq)
);
insert into seqtbl
values
(1,'迪克'),
(2,'安'),
(3,'莱露'),
(5,'卡'),
(6,'玛丽'),
(8,'本');
select * from seqtbl;
----
--answer1
select '存在缺失的编号' as gap_1
	from seqtbl
	having count(*)<>max(seq);
--answer 2
select case when count(*) <> max(seq) then '存在缺失的编号' 
						else '编号连续无缺失' end as gap_2
	from seqtbl;
--answer 3**缺失一个**
select s1.seq+1 as missing_gap
	from seqtbl s1
	left join seqtbl s2
		on s1.seq+1=s2.seq
	where s2.seq is null and s1.seq<>(select max(seq) from seqtbl);
--answer 4**缺失多个**
select gs as missing_gap
	from (select min(seq) as min_gap,max(seq) as max_gap from seqtbl) t
	cross join generate_series(t.min_gap,t.max_gap) gs
	where not exists (select 1 from seqtbl s where s.seq=gs);
----
select min(seq+1) as gap
	from seqtbl
	where  (seq+1) not in (select seq from seqtbl);
--p72
create table graduates(
name varchar(4) not null,
income int not null,
primary key (name));
insert into graduates
values
('桑普森',400000),
('迈克',30000),
('怀特',20000),
('阿诺德',20000),
('史密斯',20000),
('劳伦斯',15000),
('哈德逊',15000),
('肯特',10000),
('贝克',10000),
('斯科特',10000);
select * from graduates;
--answer **众值**
select income as "众值",count(*) as times
	from graduates
	group by income
	order by times desc;
--answer2
select income as common_value,count(*) as times
	from graduates
	group by income
	having count(*)=(
								select max(cnt) 
								from (select count(*) cnt from graduates 
										group by income) t1
								);
--answer**textbook**--**all,any,some的用法**
select income,count(*) as cnt 
	from graduates g 
	group by income 
	having count(*) >= all(select count(*) from graduates group by income);
--answer**textbook**--**避免all关于空集和null的干扰，使用max()聚合函数**
select income,count(*) as cnt
	from graduates g
	group by g.income 
	having count(*) >= (select max(cnt) 
										from (select count(*) cnt 
													from graduates group by income) t1
						   			);
--p74**having子句自连接求median中位数**
select avg(distinct income)
	from (select t1.income from graduates t1,graduates t2 
				group by t1.income 
				having sum(case when t2.income>=t1.income then 1 else 0 end)
								>=count(*)/2
					and sum(case when t2.income <=t1.income then 1 else 0 end)
								>=count(*)/2
			) tmp;
select avg(income)
	from(
		select income,
			row_number() over (order by income) as rn,
			count(*) over() as total
		from graduates
		   ) t
	where rn in  ((total+1)/2,(total+2)/2);
/*
 * CTE common table express- with语法
 * with 别名1 as(
 * 		--子查询，生成第一张虚拟表
 * 		select ...
 * 		),
 * 		别名2 as(
 * 		--可以引用前面定义的别名1
 * 		select... from 别名1
 * 		）
 * ---主查询，使用上面定义的CTE
 * 		select * from 别名2；
 */
with ranked as (
	select income,row_number() over (order by income) as rn,
			count(*) over () as total_rows
		from graduates
	)
	select avg(income) as median
		from ranked
		where rn between(tatal_rows+1)/2 and (total_rows+2)/2;
 --学习with语法练习
with income_cnt as (
	select income,count(*) as cnt  
	from graduates
	group by income
	)
	select * from income_cnt
		order by cnt  desc;
with income_cnt as (
	select income,count(*) as cnt 
	from graduates
	group by income 
	),
	max_count as(
	select max(cnt) max_cnt from income_cnt
	)
	select ic.income,ic.cnt 
	from income_cnt ic,max_cnt mc
	where ic.cnt=mc.max_cnt;
with t as (select * from graduates g )
	select * from t where income>300000
	union all 
	select * from t where income<20000;
/*递归CTE学习
 * with recursive cte_name as (
 * 		--锚点成员 anchor，初始数据集，只执行一次，递归起点
 * 		select ...
 * 		union all
 * 		--递归成员 recursive,引用cte_name自己，循环迭代
 * 		select ... from cte_name ...
 * 		)
 * 		select * from cte_name; 
 */
with recursive nums(n) as (
	--锚点
	select 1
	union all
	--递归
	select n+1 from nums where n<10
	)
	select n from  nums;








