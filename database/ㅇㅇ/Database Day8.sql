

create table emp_hierarchy(
employee_id int,
emp_name varchar(80),
manager_id int,
salary int, 
dept_name varchar(80)

);


 insert into emp_hierarchy values
(200,'Jennifer Whalen',101,4400,'Administration'),
(203,'Susan Mavris',101,6500,'Human Resources'),
(103,'Alexander Hunold',102,9000,'IT'),
(104,'Bruce Ernst',103,6000,'IT'),
(105,'David Austin',103,4800,'IT'),
(107,'Diana Lorentz',103,4200,'IT'),
(106,'Valli Pataballa',103,4800,'IT'),
(204,'Hermann Baer',101,10000,'Public Relations'),
(100,'Steven King',null,24000,'Executive'),
(101,'Neena Kochhar',100,17000,'Executive'),
(102,'Lex De Haan',100,17000,'Executive'),
(113,'Luis Popp',108,6900,'Finance'),
(112,'Jose Manuel Urman',108,7800,'Finance'),
(111,'Ismael Sciarra',108,7700,'Finance'),
(110,'John Chen',108,8200,'Finance'),
(108,'Nancy Greenberg',101,12008,'Finance'),
(109,'Daniel Faviet',108,9000,'Finance'),
(205,'Shelley Higgins',101,12008,'Accounting'),
(206,'William Gietz',205,8300,'Accounting');

select * from emp_hierarchy;



select employee_id,emp_name,manager_id,salary,dept_name,
row_number() over(partition by dept_name order by salary desc) total   -- order by 가 붙으면 unbounded preceed에서 current row 까지 
from emp_hierarchy ;


-- rank() 순위
-- row_number() 행을 보여줌
-- dense_rank() 누적 순위
-- percent_rank() : 비율순위 (rank()-1)/(row-1)) 상위 
-- 해당 파티션에서 sum 값이 동일하게 지정되게 하고자 한다면 rows between unbounded preceding and unbounder following


select employee_id,emp_name,manager_id,salary,dept_name,
lag(salary) over(partition by dept_name order by salary asc) lag_, -- lag 12008의 뒤 x 9000의 뒤 12008 바로 앞의 값
lead(salary) over(partition by dept_name order by salary asc) lead_ -- lead 바로 앞의 값 9000  
from emp_hierarchy ;

-- lag (컬럼명) 또는 lag(컬럼명,n,'값') 현재 로우 기준으로 n번째 뒤의 컬럼 값을 가져오기
-- lead (컬럼명) lead(컬럼명,n,'값') 현재 로우 기준으로 n번째 앞의 컬럼 값을 가져오기

select employee_id,emp_name,manager_id,salary,dept_name,
lag(salary) over(partition by dept_name order by salary asc) lag_, -- lag 12008의 뒤 x 9000의 뒤 12008 바로 앞의 값
lead(salary) over(partition by dept_name order by salary asc) lead_ -- lead 바로 앞의 값 9000  
from emp_hierarchy ;

-- 실습 box office 테이블에서 해마다 1위 였던 영화들에 대해 전년도 기준으로 다음년도 매출의 증감율 구하기


select years,ranks,movie_name,sale_amt,
ifnull(lag(sale_amt) over(partition by ranks order by years),0) as lag_
from box_office
where ranks=1
order by 1;


with info as ( 

select years,ranks,movie_name,sale_amt,
ifnull(lag(sale_amt) over(partition by ranks order by years),0) as lag_
from box_office
where ranks=1
order by 1

)
select a.years,a.ranks,a.movie_name,a.sale_amt,a.lag_, ifnull((a.sale_amt-a.lag_)/a.lag_*100,0) 매증
from info a;


-- 실습 box office 테이블에서 2019 년 개봉 월별 총 매출액과 전월 대비 증감율을 구하는 쿼리 작성하기
-- 월별 매출 합
-- (2)

select year(release_date) years,month(release_date) months,sum(sale_amt) sums, 
lag(sum(sale_amt)) over (partition by year(release_date)  order by month(release_date)) as lag_
from box_office 
where year(release_date)=2019
group by 2
order by 2;

with totals as 
(
select year(release_date) years,month(release_date) months,sum(sale_amt) sums, 
lag(sum(sale_amt)) over (partition by year(release_date)  order by month(release_date)) as lags
from box_office 
where year(release_date)=2019
group by 2
order by 2
)

select a. years, a.months, a.sums, a.lags, 
round((a.sums-a.lags)/a.lags*100,2) 증감
from totals a; 






select employee_id,emp_name,manager_id,salary,dept_name,
sum(salary) over(partition by dept_name order by salary rows between 1 preceding and 1 following) tt, -- 앞으로 1칸 뒤로 1칸 윈도우 기준 그룹기준
sum(salary) over(partition by dept_name order by salary range between 1000 preceding and 1000 following)  tttt   -- 범위 기준 앞으로 1000 뒤로 1000
from emp_hierarchy ;



select * 
from dept_emp 
where sysdate() between from_date and to_date;

create or replace view dept_emp_v as 
select * 
from dept_emp 
where sysdate() between from_date and to_date;

select * from dept_emp_v;

create or replace view dept_emp_v as 
select *
from dept_emp 
where sysdate() between from_date and to_date;


select * 
from dept_emp_v;


alter view dept_emp_v as 
select *
from dept_emp 
where sysdate() between from_date and to_date;

drop view dept_emp_v;