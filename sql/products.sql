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
--2.1
select product_name,regist_date
	from product
	where regist_date > '2009-04-28';
--2.2
select * from product where purchase_price is null;
select * from product where purchase_price is not null;
--2.3
select product_name,sale_price,purchase_price
	from product 
	where sale_price >= purchase_price+500;

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





