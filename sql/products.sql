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