-- 서브쿼리

-- 1 스칼라 서브쿼리

select 컬럼, (서브쿼리) 
from 테이블 
where 조건식;

-- 2 파생 테이블 
select 컬럼
from 테이블, (서브쿼리)
where 조건식;

-- 3 조건 서브쿼리

select 컬럼
from 테이블
where 값> (서브쿼리) ;


-- 연도별 1위 영화들의 평균 매출액보다 큰 영화만 조회
select year(release_date),count(*),movie_name, sale_amt, avg(sale_amt)
from box_office
where ranks=1
group by year(release_date),movie_name ;

-- avg(sale_amt) 컬럼값으로 조회된 평균 매출액은 16개 영화의 평균이 아님, 1위인 영화 한건의 평균임
-- 1단계 : 16 개 영화의 평균을 구한다

select avg(sale_amt)
from box_office
where ranks=1;


-- 2단계 1단계에서 구한 평균보다 큰 영화를 조회
select year(release_date),movie_name, sale_amt
from box_office
where ranks=1
and sale_amt> 81906468809.5;

-- 앞에서 1위들의 영화 평균보다 큰 영화를 조회하는 쿼리를 한단계로 만들기

-- 1 스칼라 서브쿼리 이용

select avg(sale_amt)
from box_office
where ranks=1;



select year(release_date),movie_name, sale_amt,
(
select avg(sale_amt)
from box_office
where ranks=1
) as aver 
from box_office
where ranks=1
having sale_amt> aver ;


-- 스칼라 값일 때는 스칼라 = 즉 단일값이 와야함 !


-- 2 파생 테이블 


select year(release_date),movie_name, sale_amt
from box_office a,
(
select avg(sale_amt) aver
from box_office
where ranks=1
) b
where ranks=1
and sale_amt> b.aver;



-- 3 조건 서브쿼리 

select year(release_date),movie_name, sale_amt
from box_office
where ranks=1
and sale_amt> (
select avg(sale_amt)
from box_office
where ranks=1
)
;

use world ;

-- 스칼라 서브쿼리 응용
-- city 테이블과 country 테이블을 내부 조인해서 country 에 있는 정보를 추가로 가져왔었음

select a.*,b.name
from city a
inner join country b
on a.countrycode= b.code;


-- 스칼라
select a.* ,(
select name from country b
where a.countrycode= b.code
) countryname
from city a;

-- 위에서 오류가 난 두 컬럼을 concat 함수를 써서 한 컬럼을 만들면 에러가 나지 않음
select a.* ,(
select concat(b.name,'/',b.continent) from country b
where a.countrycode= b.code
) countryname
from city a;


-- 파생 테이블 이용

use mywork;

-- 현재 관리자의 부서번호, 사번, 사원이름 조회 

select b.dept_no,b.emp_no,concat(c.first_name,' ',c.last_name)
from dept_manager b
inner join employees c 
on b.emp_no= c.emp_no
inner join departments a
on a.dept_no = b.dept_no
where sysdate() between b.from_date and b.to_date;


select a.dept_no,a.dept_name,manager.fullname
from departments a
inner join ( select b.dept_no,b.emp_no,concat(c.first_name,' ',c.last_name) fullname
from dept_manager b
inner join employees c 
on b.emp_no= c.emp_no
where sysdate() between b.from_date and b.to_date
) manager
on a.dept_no= manager.dept_no
;


-- 실습 box_office 테이블에서 2015년 이후 연도별 순위가 1~3위인 영화와 해당 영화의 매출액이
-- 연도별 전체 매출액에서 차지하는 비율을 구하는 쿼리 
-- 1단계 연도별 전체 매출액을 구하는 부분
-- 2단계 연도별 1~3위 영화의 정보와 매출액을 구한뒤 각영화의 매출액을 전체 매출액으로 나누는 부분


select year(a.release_date) ,a.ranks, a.movie_name, a.sale_amt, b.total_amt, (a.sale_amt/b.total_amt)*100 '퍼센트'
from box_office a,
(
select year(release_date) release_year,sum(sale_amt) total_amt
from box_office
where year(release_date)>=2015
group by 1 
order by 1
) b
where ranks<=3 and year(a.release_date)=b.release_year
group by 1,2
order by 1,2;

select year(release_date),sum(sale_amt)
from box_office
where year(release_date)>=2015
group by 1 
order by 1,2;
/*1657667127054
1719186452482
1808938584214
1734872210331
1870784163188
316011700
*/
-- 3 조건 서브쿼리 응용

-- 2019년 개봉한 영화의 매출액이 2018년도 최대 매출액보다 큰 영화
select movie_name, sale_amt 
from box_office
where year(release_date)=2019 and sale_amt >(select max(sale_amt)
from box_office
where year(release_date)=2018);


-- 102666146909
select max(sale_amt)
from box_office
where year(release_date)=2018;


select movie_name, sale_amt 
from box_office
where year(release_date)=2019 and sale_amt >(select max(sale_amt)
from box_office
where year(release_date)=2018);





select year(release_date),movie_name,sale_amt
from box_office 

where year(release_date)=2019
and sale_amt >= (select sale_amt    -- 1~3위인 3개의 행이 반환 되어 문제가 됨
from box_office
where year(release_date)=2018 and ranks between 1 and 3
);
-- All (서브쿼리의 결과로 나온 다수의 값 모두를 만족하는 결과를 조회) 
-- ANY (서브쿼리의 결과로 나온 다수의 값 중에 하나라도 만족하는 결과를 조회)

select year(release_date),movie_name,sale_amt
from box_office 

where year(release_date)=2019
and sale_amt >= Any(select sale_amt    -- 1~3위인 3개의 행이 반환 되어 문제가 됨
from box_office
where year(release_date)=2018 and ranks between 1 and 3
);

select movie_name, director
from box_office
where year(release_date) =2019
and (movie_name, director) in (select movie_name, director 
from box_office
where year(release_date)=2018);


-- not in 2019년도 1~100 순위안에 든 영화의 대표 국가 (rep_country) 1~100 순위권에 없었던 나라 

select movie_name ,ranks , release_date , rep_country 
from box_office 
where year(release_date)=2019
and ranks between 1 and 100 
and rep_country not in(
select rep_country from box_office
where year(release_Date)=2018 and ranks between 1 and 100
);

-- exists
select movie_name, director
from box_office a
where year(release_date) =2019
and exists (select *
from box_office b
where year(release_date)=2018 and a.movie_name= b.movie_name and a.director= b.director
);

-- not exitsts
select movie_name ,ranks , release_date , rep_country 
from box_office a
where year(release_date)=2019
and ranks between 1 and 100 
and not exists(
select * from box_office b
where year(release_Date)=2018 
and ranks between 1 and 100 and a.rep_country= b.rep_country
);

-- 실습alter
-- 현재를 기준으로 각 부서에서 급여를 가장 많이 받는 사원이 누구인지 찾는 쿼리 

 /* 사원 기존 정보를 이용한 테이블 조인 실습 */
-- 테이블명 : 설명
-- employees : 사원정보
-- dept_emp : 사원의 부서 할당정보
-- departments : 부서정보
-- dept_manager : 부서의 관리자 정보
-- titles : 사원의 직급 정보
-- salaries : 사원의 급여 정보
select * from salaries;
select a.dept_no, max(b.salary)
from dept_emp a 
inner join salaries b
on a.emp_no= b.emp_no
where sysdate() between a.from_date and a.to_date
and sysdate() between b.from_date and b.to_date
group by a.dept_no;


select c.emp_no,c.salary
from salaries c, 
(select a.dept_no, max(b.salary) max_salary
from dept_emp a 
inner join salaries b
on a.emp_no= b.emp_no
where sysdate() between a.from_date and a.to_date
and sysdate() between b.from_date and b.to_date
group by a.dept_no
)k
where c.salary = k.max_salary;





-- (실습) 현재를 기준으로 어느 부서에도 속하지 않는 사원은 모두 몇 명인지 구하는 쿼리 작성하기

select count(*) from employees a;
where sysdate() between from_date and to_date
and not exists(
select * from departments b
where a.dept_no=b.dept_no
);





-- (실습) box_office 테이블에서 2018년과 2019년에 개봉한 영화를 대상으로 연도별, 분기별 매출액을 구하되,
-- 아래와 같은 형식으로 조회되도록 쿼리 작성하기
-- (힌트 : case~end 구문 이용, sum(sale_amt)를 활용할 수 있는 서브쿼리 이용가능)
-- ----------------------------------------------
-- 연도  |    1분기  |   2분기  |   3분기  |  4분기
-- ----------------------------------------------
-- 2018 |          |         |         |
-- ----------------------------------------------
-- 2019 |          |         |         |
-- ----------------------------------------------

select year(a.release_date) 연도,case 
when month(a.release_date)<=3 then '1' 
when month(a.release_date)<=6 then '2' 
when month(a.release_date)<=9 then '3' 
when month(a.release_date)<=12 then '4' 
end as qurt ,a.movie_name, a.ranks, a.sale_amt
from box_office a,(

select year(release_date) 연도,case 
when month(release_date)<=3 then '1' 
when month(release_date)<=6 then '2' 
when month(release_date)<=9 then '3' 
when month(release_date)<=12 then '4' 
end qurt, sum(sale_amt) total from box_office where year(release_date) in (2018,2019)
group by 1,2


) where year(release_date) in (2018,2019) and a.qurt=b.qurt and a.release_date=b.release_date;


select count(*)
  from employees a
 where a.emp_no not in (select b.emp_no
                         from dept_emp b
						where sysdate() between b.from_date and b.to_date);

select a.years,
sum(case a.qtr when 1 then a.qt_sum_amt else 0 end) "1분기",
sum(case a.qtr when 2 then a.qt_sum_amt else 0 end) "2분기",
sum(case a.qtr when 3 then a.qt_sum_amt else 0 end) "3분기",
sum(case a.qtr when 4 then a.qt_sum_amt else 0 end) "4분기"

from (
select year(release_date) years, quarter(release_date) qtr,sum(sale_amt) qt_sum_amt
from box_office where year(release_date) in (2018,2019)
group by 1,2
order by 1,2


)a
group by 1;

drop table emp_test;
-- 테이블 생성하기
create table emp_test(
  emp_no int not null,
  emp_name varchar(30) not null,
  hire_date date null,
  salary int null,
  primary key (emp_no)
);

-- 단일 로우 입력 insert 문
insert into emp_test(emp_no, emp_name, hire_date, salary)
       values (1001, '아인슈타인', '2021-01-01', 1000);
select * from emp_test;

insert into emp_test(emp_no, emp_name, hire_date)
       values (1002, '아이작뉴턴', '2021-02-01');
select * from emp_test;     

insert into emp_test(hire_date, emp_no, emp_name)
       values ('2021-02-10', 1003, '갈릴레오');
select * from emp_test;

-- (오류 예) not null 옵션이 있는 emp_name 컬럼은 필히 입력
insert into emp_test(emp_no, hire_date)
       values (1004, '2021-02-10');
-- (오류 예) pk에 중복값 입력
insert into emp_test(emp_no, emp_name, hire_date)
       values (1003, '리처드파인만', '2021-01-10');
       
-- 컬럼명을 생략
insert into emp_test
       values (1004, '리처드파인만', '2021-01-10', 3000);       
select * from emp_test;

-- 다중 로우 입력 insert 문
insert into emp_test values
row (1005, '퀴리부인', '2021-03-01', 4000),
row (1006, '스티븐호킹', '2021-03-05', 5000);

select * from emp_test;
insert into emp_test values
(1007, '마이클패러데이', '2021-04-01', 2200),
(1008, '맥스웰', '2021-04-05', 3300),
(1009, '막스클랑크', '2021-04-05', 4400);

select * from emp_test;

-- select 문이 결합된 insert문
-- 테이블 생성
create table emp_test2(
  emp_no int not null,
  emp_name varchar(30) not null,
  hire_date date null,
  salary int null,
  primary key (emp_no)
);

select * from emp_test2;

insert into emp_test2
select *
  from emp_test
 where emp_no in (1003, 1004);
 
select * from emp_test2; -- 2행 추가

-- (오류 예) 중복된 키값 (1004) 입력
insert into emp_test2
select *
  from emp_test
 where emp_no >= 1004;
 
select * from emp_test;

insert into emp_test
select emp_no+10, emp_name, hire_date, 100
  from emp_test
 where emp_no >= 1008;
 
select * from emp_test; 

-- (실습) emp_test 테이블에 insert 문을 사용하여 아래와 같이 입력하세요.
-- --------------------------------------------------
-- 사번  |   이름   |      입사일     |   급여 
-- --------------------------------------------------
-- 2001 |  장영실  |   2020-01-01   |   1500
-- --------------------------------------------------
-- 2002 |  최무선  |   2020-01-31   |  
-- ---------------------------------------------------

insert into emp_test values
(2001, '장영실', '2021-01-01', 1500),
(2002, '최무선', '2021-01-31', null);

select * from emp_test;

insert into emp_test2
select *
  from emp_test
 where emp_no in (1001, 1002);
 
select * from emp_test2; 