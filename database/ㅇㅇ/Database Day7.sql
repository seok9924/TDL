-- update 문으로 데이터 입력하기
--  emp_update1 테이블을 생성
-- primary key 지정 

/*
alter table emp_update1
add constraint primary key (emp_no);

컬럼 추가 (Add)
ALTER TABLE table_name ADD COLUMN ex_column varchar(32) NOT NULL;
컬럼 변경 (Modify)
ALTER TABLE table_name MODIFY COLUMN ex_column varchar(16) NULL;
컬럼 이름까지 변경 (Change)
ALTER TABLE table_name CHANGE COLUMN ex_column ex_column2 varchar(16) NULL;
컬럼 삭제 (Drop)
ALTER TABLE table_name DROP COLUMN ex_column;
테이블 이름 변경 (RENAME)
ALTER TABLE table_name1 RENAME table_name2;
*/


create table emp_update1
select * from emp_test;

select * from  emp_update1;
desc emp_update1;
desc emp_test;

create table emp_update2 
select * from emp_test2;

alter table emp_update2
add constraint primary key(emp_no);

select * from emp_update1;

-- 단일 테이블 데이터 수정하기 

update emp_update1 
 set emp_name = concat(emp_name,'2'),
	 salary= salary +100;
select * from emp_update1;

update emp_update1 
 set emp_no = emp_no+1
 where emp_no>=1018;
 
 
 -- 다중 테이블 수정하기 
 
 -- 두 테이블 관계를 이용해서 업데이트 
 -- 한 테이블 a의 컬럼 값을 참조해서 다른테이블 b의 컬럼 값을 변경
 

 update emp_update1 a, emp_update2 b
 set a.salary=b.salary +1000
 where a.emp_no=b.emp_no;
 
 select * from emp_update2;
 select * from emp_update1;
 
 -- null 값으로 인해 연산이 이루어지지 않을때는 0으로 바뀐뒤 다시 시도 
 
  update emp_update1 a, emp_update2 b
 set a.salary= ifnull(a.salary,0)
   --   b.salary= a.salary+2000
 where a.emp_no=b.emp_no;
 
  update emp_update1 a, emp_update2 b
 set b.salary= a.salary+2000
  where a.emp_no=b.emp_no;
  
  
  update emp_update1 
 set salary= salary +1999
 where emp_no in (1001,1004);
select * from emp_update2;
 
 
 -- 입력과 수정 동시에 처리하기
 -- on duplicate key
 -- emp_update2 테이블에 pk가 1003,1004,1005번인 데이터를 입력
 -- 수정/입력 데이터는 emp_name 컬럼
 -- 1003,1004 는 수정, 1005는 입력alter
 
 
 select * from emp_update2;
 insert into emp_update2
 select * from emp_update1 a
  where emp_no between 1003 and 1005
  on duplicate key update emp_name= a.emp_name, salary= a.salary;
  
  
  -- 실습 emp update2 테이블 에서 사번이 1001과 1002인 사원명을 emp_update1의 동일 사번을 가진 사원명으로 변경
  
insert into emp_update2
select * from emp_update1 a
where emp_no between 1001 and 1002 
on duplicate key update emp_name=a.emp_name ;

select * from emp_update2;


create table emp_delete
select * from emp_test;

alter table emp_delete
add constraint primary key(emp_no);

desc emp_delete;
select * from emp_delete;

create table emp_delete2
select * from emp_test2;

alter table emp_delete2
add constraint primary key(emp_no);

select * from emp_delete2;

-- 단일 테이블 삭제
-- 조건(where)을 넣어서 삭제
select * from emp_delete;
delete from emp_delete
where salary is null;

-- 모두삭제
delete from emp_delete;

-- 데이터 복구
insert into emp_delete 
select * from emp_test;

-- order by , limit의 조합 추가 

select * from emp_delete;

delete from emp_delete
where emp_name='맥스웰' 
order by emp_no desc limit 1;

-- 2 모두삭제 웨어절 없으면
delete a,b
from emp_delete a , emp_delete2 b 
where a.emp_no= b.emp_no;

select * from emp_delete2;

select * from emp_delete;

insert into emp_delete
select * from emp_test
where emp_no<> 1018;

insert into emp_delete2
select * from emp_test;

delete from b
using emp_delete a, emp_delete2 b
where a.emp_no=b.emp_no;    -- b테이블 




-- (실습) emp_delete 테이블에서 사원명이 막스플랑크인 데이터를 삭제하는데,
-- 이번에는 사번이 빠른 1건만 삭제하는 쿼리 작성하기

delete from emp_delete
where emp_name='막스플랑크' 
order by emp_no asc limit 1;

-- (실습) box_office 테이블을 참조해 box_office_copy 테이블을 만들기 (create ~ select ~)
-- 이 때 box_office 테이블에서 2019년 개봉 영화 중 관객수가 800만명 이상인 데이터만 들어가야 함

create table box_office_copy
select * from box_office
where year(release_date)=2019 and audience_num>=8000000;
select * from box_office_copy;
desc box_office;
desc box_office_copy;
alter table box_office_copy
add constraint primary key (seq_no);


-- 실습 box_office_copy 테이블에 last_year_audi_num 이라는 컬럼을 추가한후 
-- box_office 테이블에서 2018년도 개봉영화와 box_office_copy(2019) 테이블 순위가 같은 건에 대해 
-- last__ year__audi__num에 2018년도의 관객수를 설정 

ALTER TABLE box_office_copy ADD COLUMN last_year_audi_num Int NULL;

update (
select * from box_office where year(release_date)=2018
) a, box_office_copy b
set b.last_year_audi_num= a.audience_num
where a.ranks=b.ranks ;

select * from box_office where year(release_date)=2018 order by 3;
select audience_num,last_year_audi_num from box_office_copy;


-- 실습 사원의 부서 할당 정보가 들어있는 dept_emp 테이블에서 
-- 현재 일하고 있지 않은 사람의 삭제하는 쿼리 작성하기

desc dept_emp;
select * from employees;
select * from dept_emp_test b;
select * from dept_emp_test order by 1 asc;
delete from dept_emp
where sysdate() between from_date and to_date;

update dept_emp a,dept_emp_test b
 set a.emp_no = b.emp_no,
	 a.dept_no= b.dept_no,
     a.from_date=b.from_date,
     a.to_date=b.to_date;

create table dept_emp
select * from dept_emp_test;
select @@autocommit;

create table emp_tran1
select * from emp_test;

alter table emp_tran1
add constraint primary key(emp_no);

create table emp_tran2 
select * from emp_test;

alter table emp_tran2
add constraint primary key(emp_no);

-- DDL Data Definition Language 트랜잭션에 영향 받지 않음 커밋 롤백 사용 x

-- DML Data Manipulation Language 트랜잭션에 영향 받은 commit rollback 사용 가능

-- 자동 커밋 모드 비활성화 상태에서 트랜잭션 처리하기

set autocommit= 1;
select @@autocommit;
-- 데이터 삭제
delete from emp_tran1;
-- 데이터 확인

select * from emp_tran1;

drop table emp_tran1;

rollback;

commit;

-- > 커밋이나 롤백문을 만나게 되면 이 지점까지가 한 트랜잭션 종료


alter table dept_emp
add constraint primary key (emp_no,dept_no);
desc dept_emp;





-- 현재 시점을 기준으로 각 부서에 속한 사원들의 총 급여에 대한 부서별 평균을 구하는 쿼리 작성하기 
-- 1서브 쿼리 방식

select a.dept_no,a.dept_name,sum(c.salary) dept_sum_salary,avg(c.salary)
from departments a, dept_emp b ,salaries c 
where a.dept_no =b.dept_no 
and b.emp_no = c.emp_no
and sysdate() between b.from_date and b.to_date
and sysdate() between c.from_date and c.to_date
group by a.dept_no;
 
-- 2 cte 방식 

with dept_info as  (
select a.dept_no,a.dept_name,sum(c.salary) dept_sum_salary,avg(c.salary)
from departments a, dept_emp b ,salaries c 
where a.dept_no =b.dept_no 
and b.emp_no = c.emp_no
and sysdate() between b.from_date and b.to_date
and sysdate() between c.from_date and c.to_date
group by a.dept_no),
dept_avg as
(
select avg(f.dept_sum_salary)
from dept_info f
)
select a.dept_no, a.dept_sum_salary 
from dept_info a, dept_avg b;


-- box office 테이블에서 2018년 이후 개봉된 영화 중에서 랭킹 10위 안에 든 영화들의 연도별 총 매출액과
-- 평균 매출액을 구하되
-- 집계되기 전의 개별 영화이름, 랭킹 매출액도 함께 표시하기

with summary as(

select year(release_date)release_year, sum(sale_amt) sum_amt ,avg(sale_amt) avg_amt
from box_office where year(release_date)>=2018 and ranks<=10
group by 1 

)
select year(a.release_date),a.movie_name,a.ranks,a.sale_amt, b.sum_amt, b.avg_amt
from box_office a
inner join summary b 
on year(a.release_date)=b.release_year
where a.ranks<=10
order by 1;


-- (2) 윈도우 함수 사용 

select year(release_date), movie_name, ranks,sale_amt,
sum(sale_amt) over(partition by year(release_date)) sum_amt,
avg(sale_amt) over(partition by year(release_date)) avg_amt
from box_office
where year(release_date)>= 2018
and ranks<=10;

with avg_first as
(
select avg(sale_amt) avg_amt
from box_office
where ranks=1
)
select a.movie_name,a.sale_amt,b.avg_amt
from box_office a, avg_first b
where a.ranks=1; 

select year(release_date),ranks, movie_name,sale_amt,
avg(sale_amt) over(partition by ranks) avg_amt 
from box_office
where ranks=1
order by 1; 


-- 윈도우 함수에서는 평균보다 큰 매출이 안 구해짐 
with cap_info as
(
select year(release_date),ranks, movie_name,sale_amt,
avg(sale_amt) over(partition by ranks) avg_amt 
from box_office
where ranks=1
)
select year(a.release_date),a.ranks,a.movie_name,a.sale_amt,b.avg_amt
from box_office a
inner join cap_info b 
on a.ranks= b.ranks and a.movie_name=b.movie_name
where a.ranks=1
order by 1;
