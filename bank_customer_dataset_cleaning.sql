create database mini_bank_project;
use mini_bank_project;

-- before import I changed all datatype into text to import all messy data as it is

-- raw data
select * from github_bank_datasets;
select count(*) from github_bank_datasets;
drop table github_bank_datasets;

-- data cleaning

create table cleaning_bank like github_bank_datasets;
insert into cleaning_bank select * from github_bank_datasets;

select * from cleaning_bank;

select customer_id,max(`name`)as customer_name from cleaning_bank group by customer_id;
update cleaning_bank set `name` = null where `name` = ""; 
update cleaning_bank set `age` = replace(`age`,'_','') where `age` like '%_';
update cleaning_bank set `age` = replace(`age`,'-','') where `age` like '_%';
update cleaning_bank set SSN = null where SSN = '#F%$D@*&8';
update cleaning_bank set occupation = null where occupation = '_______';
update cleaning_bank set annual_income = replace(annual_income,'_','') where annual_income like '%_';
update cleaning_bank set monthly_inhand_salary = null where monthly_inhand_salary = '';
update cleaning_bank set num_of_loan = replace(num_of_loan,'-','') where num_of_loan like '_%';
update cleaning_bank set num_of_loan = replace(num_of_loan,'_','') where num_of_loan like '%_';
update cleaning_bank set type_of_loan = null where type_of_loan = '';
update cleaning_bank set num_of_delayed_payment = null where num_of_delayed_payment = '';
update cleaning_bank set num_of_delayed_payment = replace(num_of_delayed_payment,'_','') where num_of_delayed_payment like '%_';
update cleaning_bank set changed_credit_limit = null where changed_credit_limit = '_';
update cleaning_bank set num_credit_inquiries = null where num_credit_inquiries = '';
update cleaning_bank set credit_mix = null where credit_mix = '_';
update cleaning_bank set outstanding_debt = replace(outstanding_debt,'_','') where outstanding_debt like '%_';
update cleaning_bank set amount_invested_monthly = null where amount_invested_monthly in ('' , '__10000__');
update cleaning_bank set payment_behaviour = null where payment_behaviour = '!@9#%8';
update cleaning_bank set monthly_balance = null where monthly_balance = '';
update cleaning_bank set monthly_balance = null where monthly_balance = '__-333333333333333333333333333__';

select * from cleaning_bank where id = '0x21a49'; -- cheaking whether the last cleaning is worked or not

select * from cleaning_bank;

create table cleaning_bank2 like cleaning_bank;
insert into cleaning_bank2 select * from cleaning_bank;

select * from cleaning_bank2;

-- creating a new table to try because I never tried the further queries and I dont want to mess around the cleaned ones

-- replaced name using customer_id
-- name
update cleaning_bank2 cb 
join (select customer_id, max(`name`)as `name` from cleaning_bank2
where `name` is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.`name`=a.`name` where cb.`name` is null;

select count(*) as total_age, sum(case when age > 100 then 1 end) as invalid_age 
from cleaning_bank2;	-- 1401

with correct_age as 
(select customer_id,max(age) as proper_age from cleaning_bank2 
where age between 18 and 100 group by customer_id)
select * from correct_age ;	-- working

update cleaning_bank3 cb
join ( select customer_id, max(age) as proper_age from cleaning_bank3
where age between 18 and 100 group by customer_id) c
on cb.customer_id = c.customer_id
set cb.age = c.proper_age
where cb.age > 100;

-- SSN
update cleaning_bank2 cb 
join (select customer_id, max(SSN)as SSN from cleaning_bank2
where SSN is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.SSN = a.SSN where cb.SSN is null;

select * from cleaning_bank2;

-- checking nulls to fill
select count(*) from cleaning_bank2 where ssn is null;	-- 2828
select count(*) from cleaning_bank2 where occupation is null;	-- 3438
select count(*) from cleaning_bank2 where monthly_inhand_salary is null;	-- 7498		-- 7470 changed
select count(*) from cleaning_bank2 where type_of_loan is null;	-- 5704		-- not gonna to fill
select count(*) from cleaning_bank2 where num_of_delayed_payment is null;	-- 3498		-- 3494	changed
select count(*) from cleaning_bank2 where changed_credit_limit is null;	-- 1059	
select count(*) from cleaning_bank2 where num_credit_inquiries is null;	-- 1035
select count(*) from cleaning_bank2 where credit_mix is null; -- 9805	-- 9721 changed
select count(*) from cleaning_bank2 where amount_invested_monthly is null;	-- 4446		-- 4442 changed 
select count(*) from cleaning_bank2 where payment_behaviour is null;	-- 3800		-- none changed
select count(*) from cleaning_bank2 where monthly_balance is null;	-- 568		-- 564 changed

select * from cleaning_bank2;

-- -----------------------------------------
-- filling nulls

-- occupation
update cleaning_bank2 cb 
join (select customer_id, max(occupation)as occupation from cleaning_bank2
where occupation is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.occupation = a.occupation where cb.occupation is null;

-- monthly inhand salary
update cleaning_bank2 cb 
join (select customer_id, max(Monthly_Inhand_Salary)as Monthly_Inhand_Salary from cleaning_bank2
where Monthly_Inhand_Salary is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.Monthly_Inhand_Salary = a.Monthly_Inhand_Salary where cb.Monthly_Inhand_Salary is null;
-- no details on customer_id 'CUS_0x86a', 'CUS_0x5e53', 'CUS_0xa37', 'CUS_0x11c1', 'CUS_0x542c',
-- 'CUS_0x9435', 'CUS_0xc1a7' -- 8 customers


-- Num_of_Delayed_Payment
update cleaning_bank2 cb 
join (select customer_id, max(Num_of_Delayed_Payment)as Num_of_Delayed_Payment from cleaning_bank2
where Num_of_Delayed_Payment is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.Num_of_Delayed_Payment = a.Num_of_Delayed_Payment 
where cb.Num_of_Delayed_Payment is null;
-- no details on customer_id 'CUS_0x6620'

-- Changed_Credit_Limit
update cleaning_bank2 cb 
join (select customer_id, max(Changed_Credit_Limit)as Changed_Credit_Limit from cleaning_bank2
where Changed_Credit_Limit is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.Changed_Credit_Limit = a.Changed_Credit_Limit 
where cb.Changed_Credit_Limit is null;

-- Num_Credit_Inquiries
update cleaning_bank2 cb 
join (select customer_id, max(Num_Credit_Inquiries)as 
Num_Credit_Inquiries from cleaning_bank2
where Num_Credit_Inquiries is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.Num_Credit_Inquiries = a.Num_Credit_Inquiries 
where cb.Num_Credit_Inquiries is null;

-- Credit_Mix
update cleaning_bank2 cb 
join (select customer_id, max(Credit_Mix)as Credit_Mix from cleaning_bank2
where Credit_Mix is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.Credit_Mix = a.Credit_Mix
where cb.Credit_Mix is null;
-- details about the credit mix are not available for 84 customers

-- Amount_invested_monthly
update cleaning_bank2 cb 
join (select customer_id, max(Amount_invested_monthly)as 
Amount_invested_monthly from cleaning_bank2
where Amount_invested_monthly is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.Amount_invested_monthly = a.Amount_invested_monthly
where cb.Amount_invested_monthly is null;
-- no details on customer id 'CUS_0x311a'

-- Payment_Behaviour
update cleaning_bank2 cb 
join (select customer_id, max(Payment_Behaviour)as Payment_Behaviour from cleaning_bank2
where Payment_Behaviour is not null group by customer_id) a
on cb.Payment_Behaviour = a.Payment_Behaviour
set cb.Payment_Behaviour = a.Payment_Behaviour 
where cb.Payment_Behaviour is null;
-- details about the credit mix are not available for 3800 customers

-- Monthly_Balance
update cleaning_bank2 cb 
join (select customer_id, max(Monthly_Balance)as Monthly_Balance from cleaning_bank2
where Monthly_Balance is not null group by customer_id) a
on cb.customer_id = a.customer_id
set cb.Monthly_Balance = a.Monthly_Balance 
where cb.Monthly_Balance is null;
-- no details on customer_id 'CUS_0x7651'

select * from cleaning_bank2;
-- -------------------------------------------------
-- checking inappropriate values
/*
Checking conditions where values vary across different columns
due to inconsistent (illogical) values for a particular customer
*/

-- num_bank_accounts > 12
-- num_credit_card > 17
-- interest_rate > 35
-- num_of_loan > 10 (many 100 here)
-- num_of_delayed_payment > 29 (replacing with null)
-- num_credit_inquiries > 18;	-- 823

create table cleaning_bank3 like cleaning_bank2;
insert into cleaning_bank3 select * from cleaning_bank2;
describe cleaning_bank3;

drop table cleaning_bank3;

select * from cleaning_bank3;

-- checking
select * from cleaning_bank3 where customer_id = 'CUS_0x43e7';	
-- CUS_0xa7f3 -- CUS_0x9f3 -- CUS_0x402d -- CUS_0x3082 -- CUS_0x55c7	-- num_bank_accounts
-- CUS_0xb0ca	-- CUS_0x43e7 		-- num_credit_card
-- interest_rate

alter table cleaning_bank3 modify annual_income decimal(19,2);
alter table cleaning_bank3 modify Monthly_Inhand_Salary decimal(19,2);
alter table cleaning_bank3 modify num_credit_card int;
alter table cleaning_bank3 modify num_bank_accounts int;
alter table cleaning_bank3 modify interest_rate int;
alter table cleaning_bank3 modify num_of_loan int;
alter table cleaning_bank3 modify num_of_delayed_payment int null;
alter table cleaning_bank3 modify num_credit_inquiries int;

select max(annual_income) from cleaning_bank3;
select * from cleaning_bank3;
describe cleaning_bank3;

select * from cleaning_bank3 where num_bank_accounts > 12 order by num_bank_accounts desc;	-- 635 (count)	
select * from cleaning_bank3 where num_credit_card > 17 order by num_credit_card desc;	-- 1179		
select * from cleaning_bank3 where interest_rate > 35 order by interest_rate desc;	-- 966	
select * from cleaning_bank3 where num_of_loan > 10 order by num_of_loan desc;	-- (many 100)	-- 2232		
select * from cleaning_bank3 where num_of_delayed_payment > 29 order by num_of_delayed_payment desc;	-- 451
-- numbers are changing in num_of_delayed_payment. so it cant be changed blindly
-- I prefer to put null
select * from cleaning_bank3 where num_credit_inquiries >18 order by num_credit_inquiries desc;	-- 866

select * from cleaning_bank3 where customer_id = 'CUS_0xad53';

select customer_id,num_bank_accounts from cleaning_bank3;
select customer_id,num_credit_card from cleaning_bank3;
select customer_id,interest_rate from cleaning_bank3;
select customer_id,num_of_loan from cleaning_bank3;
select customer_id,num_of_delayed_payment from cleaning_bank3;
select customer_id,num_credit_inquiries from cleaning_bank3;

select * from cleaning_bank3;

-- updating using the condition logic

-- num_bank_accounts
update cleaning_bank3 cb 
join (select customer_id, min(num_bank_accounts)as num_bank_accounts 
from cleaning_bank3
group by customer_id) c
on cb.customer_id = c.customer_id
set cb.num_bank_accounts = c.num_bank_accounts 
where cb.num_bank_accounts >12;

-- num_credit_card
update cleaning_bank3 cb 
join (select customer_id, min(num_credit_card)as num_credit_card 
from cleaning_bank3
group by customer_id) c
on cb.customer_id = c.customer_id
set cb.num_credit_card = c.num_credit_card 
where cb.num_credit_card >17;

-- interest_rate
update cleaning_bank3 cb 
join (select customer_id, min(interest_rate)as interest_rate 
from cleaning_bank3
group by customer_id) c
on cb.customer_id = c.customer_id
set cb.interest_rate = c.interest_rate 
where cb.interest_rate >35;

-- num_of_loan
update cleaning_bank3 cb 
join (select customer_id, min(num_of_loan)as num_of_loan 
from cleaning_bank3
group by customer_id) c
on cb.customer_id = c.customer_id
set cb.num_of_loan = c.num_of_loan 
where cb.num_of_loan >10;

-- num_credit_inquiries
update cleaning_bank3 cb 
join (select customer_id, min(num_credit_inquiries)as num_credit_inquiries 
from cleaning_bank3
group by customer_id) c
on cb.customer_id = c.customer_id
set cb.num_credit_inquiries = c.num_credit_inquiries 
where cb.num_credit_inquiries >18;

select * from cleaning_bank3;
describe cleaning_bank3;

-- filling null in type_of_loan
select num_of_loan,type_of_loan from cleaning_bank3 where num_of_loan = 0;	-- 5704
update cleaning_bank3 set type_of_loan = 'None' where num_of_loan = 0;

-- oops forgot to update age below 18
alter table cleaning_bank3 modify age int;
select * from cleaning_bank3 where customer_id = 'CUS_0x47db';

-- age 
update cleaning_bank3 set age=null where age> 100;

update cleaning_bank3 cb
join ( select customer_id, max(age) as proper_age from cleaning_bank3
where age < 18 group by customer_id) c
on cb.customer_id = c.customer_id
set cb.age = c.proper_age
where cb.age is null;			-- 74 inappropriate values below age 18 account

select customer_id,age from cleaning_bank3 order by age asc;
select * from cleaning_bank3 where customer_id = 'CUS_0x4080';

select * from cleaning_bank3;

-- num_of_delayed_payment have different values in each customers 
	-- converting > 29 to null
update cleaning_bank3 set num_of_delayed_payment = null
where num_of_delayed_payment > 29;		-- 451

-- Here null/0 logic will not apply to changed_credit_limit
-- because it might decrease

-- ------------------------------------
-- NOTE:
-- null values exist in these columns and its reason
-- Because of data is not available:
-- name
-- monthly_inhand_salary
-- num_of_delayed_payment
-- credit_mix
-- amount_invested_monthly
-- payment_behaviour
-- monthly_balance

-- contains negative value
-- num_of_bank_account (not sure whether it is mistake or any other meaning)
-- delay_from_due_date
-- changed_credit_limit

-- ------------------------------------------------
-- CLEANING COMPLETED

