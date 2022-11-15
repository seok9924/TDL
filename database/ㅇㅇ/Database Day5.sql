/* 테이블간 관계 맺기 */
-- (1) 내부 조인 

-- (실습) world 데이터베이스에서 country와 city 테이블을 내부 조인해 국가별 도시 수를 구하되
-- 국가 코드가 아닌 국가명이 표시되도록 조회하고,
-- 마지막에는 전체 도시수의 합을 구하는 쿼리 작성하기 (with rollup)
desc country;
desc city;
select * from country;
select if(grouping(a.code),"통계",a.name) as 통계, count(*)
from country a
inner join city b
on a.code= b.countrycode
group by a.code with rollup 
order by 2 desc;


-- (실습) world 데이터베이스에서 country, city, countrylanguage 테이블을 조인해서
-- countryode가 'kor'인 경우로 한정해
-- 국가코드, 국가명, 대륙명, 인구수, 국가언어, 도시명, 도시인구가 출력되게 쿼리 작성하기
desc countrylanguage;
desc city;
select a.code 국가코드, a.name 국가명, a.continent 대륙명 , 
a.population 인구수,b.name 도시명, b.population 도시인구 
from country a
inner join city b
on a.code=b.countrycode 
inner join countrylanguage c
on b.countrycode= c.countrycode
where a.code='kor';


select a.code 국가코드, a.name 국가명, a.continent 대륙명 , 
a.population 인구수,b.name 도시명, b.population 도시인구 
from country a
join city b  join countrylanguage c
on a.code=b.countrycode and  b.countrycode= c.countrycode
where a.code='kor';
--  from 테이블 1 join 테이블2 b join 테이블3 c on a.col1=b.col1 and b.col1= c.col1


-- (2) 외부 조인 

select continent from country
group by continent;


-- 외부조인으로 누락된 대륙까지 조회되도록 할 수 있다
select a.continent,count(b.name)
from country a
left join city b
on a.code= b.countrycode
group by a.continent ;


-- 실습 아프리카 대륙에 속한 국가중 사용 언어가 없는 국가가 있음 
-- country 테이블과 countrylanguage 테이블을 조인해서 이 국가의 이름이 무엇인지 찾는 쿼리 
desc  countrylanguage;
select a.name, b.language
from country a
left join countrylanguage b
on a.code= b.countrycode
where a.continent='africa'
group by a.name ;


-- (3) 기타 조인 
-- (3-1) 자연조인
select count(*)
from city a 
natural inner join countrylanguageb;



-- (3-2) 카티전곱(크로스 조인)
select count(*) from country;

select count(*) 
from  country a
cross join  city b;

-- (4) Union

use mywork;
create table tbl1( 
col1 int, 
col2 varchar(20)
);

create table tbl2(
col1 int, 
col2 varchar(20)
);

insert into tbl1 values(1,"가");
insert into tbl1 values(2,"나");
insert into tbl1 values(3,"다");
select * from tbl1;

insert into tbl2 values(1,"A");
insert into tbl2 values(2,"B");
select * from tbl2;

select col1 ,col2
from tbl1 
union distinct -- distinct 의 기준 두컬럼의 조합으로 판단 
select col1 ,col2
from tbl2;

-- union 된 집합체의 정렬
(select col1 ,col2
from tbl1
order by 1 desc
limit 3
) 
union distinct -- distinct 의 기준 두컬럼의 조합으로 판단 
select col1 ,col2
from tbl2;

-- 실습 tbl1 과 tbl2 에서 tbl1은 전체 tbl2는 col1 값이 1인 건만 조회하기

select col1 ,col2
from tbl1 
union distinct -- distinct 의 기준 두컬럼의 조합으로 판단 
select col1 ,col2
from tbl2
where col1 = 1
;

use mywork;
  select * from employees;
  select * from  dept_emp;
  select count(*) from dept_emp where dept_no='d010';
  
 /* 사원 기존 정보를 이용한 테이블 조인 실습 */
-- 테이블명 : 설명
-- employees : 사원정보
-- dept_emp : 사원의 부서 할당정보
-- departments : 부서정보
-- dept_manager : 부서의 관리자 정보
-- titles : 사원의 직급 정보
-- salaries : 사원의 급여 정보

-- (실습) 사원의 사번, 이름, 부서명 조회하기
select a.emp_no 사번, concat(a.first_name,a.last_name) 이름, c.dept_name 부서명
from employees a
inner join dept_emp b join departments  c
on a.emp_no=b.emp_no and b.dept_no= c.dept_no ;

-- (실습) Marketing과 Finance 부서의 현재 관리자 (직원)정보 조회하기

select * 
from employees a 
inner join dept_manager b join departments  c
on a.emp_no=b.emp_no and b.dept_no= c.dept_no
where c.dept_name in("Marketing","Finance") and now() between b.from_date and b. to_date;

select dept_name from  departments;

-- (실습 3) 모든 부서의 이름과 현재 관리자의 사번 조회하기
-- 모든 부서의 이름과 현재 관리자의 사번 조회하기 + 관리자 이름까지
select  c.dept_name 부서이름 , ifnull(a.emp_no,"없음") 사번, if(isnull(concat(a.first_name,a.last_name)),"없음",concat(a.first_name,a.last_name)) 이름
from employees a
inner join dept_manager b 
on  a.emp_no=b.emp_no
right join  departments c
on b.dept_no= c.dept_no
where sysdate() between b.from_date and b. to_date or b.from_date is null
; 

-- (실습 4) 부서별 사원 수와 전체 부서의 총 사원 수 구하기   

select if(grouping(c.dept_name),"총합",c.dept_name) 부서명, count(a.emp_no)
from employees a
inner join dept_emp b right join departments  c
on a.emp_no=b.emp_no and b.dept_no= c.dept_no 
where sysdate() between b.from_date and b. to_date or b.from_date is null
group by c.dept_name with rollup;
  
  
-- option 2 union 사용 
-- 부서별 사원수
-- 총사원수 
select a.dept_name 부서명, count(*)
from departments a
inner join dept_emp b 
on a.dept_no= b.dept_no 
where sysdate() between b.from_date and b. to_date 
group by a.dept_name
union
select "총사원수",count(*)
from dept_emp
where sysdate() between from_date and to_date ;

-- (실습) 모든 부서의 이름과 현재 관리자의 사번 조회하기 + 관리자 이름까지
select  c.dept_name 부서이름 , ifnull(a.emp_no,"없음") 사번, if(isnull(concat(a.first_name,a.last_name)),"없음",concat(a.first_name,a.last_name)) 이름
from employees a
inner join dept_manager b 
on  a.emp_no=b.emp_no
right join  departments c
on b.dept_no= c.dept_no
where sysdate() between b.from_date and b. to_date or b.from_date is null
; 

-- (실습) employees 테이블에서 1965년 2월 이후 출생자의 사번, 이름, 생일, 부서명을 조회하는 쿼리를
-- Natural 조인으로 작성하기

select a.emp_no, concat(a.first_name, ' ', a.last_name), a.birth_date, c.dept_name
from employees a 
natural join dept_emp b
natural join departments c
where extract(year_month from a.birth_date) >= '196502';

-- (실습) departments 테이블에서 Sales 부서의 코드(dept_no) 값은 'd007'임
-- 이 부서에 속한 "관리자의 사번과 급여", 이 부서에 속한 "사원의 사번과 급여"를 구하는 쿼리 작성하기

select '관리자' job_title, a.emp_no , b.salary
from dept_manager a
inner join salaries b
on a.emp_no= b.emp_no 
where a.dept_no='d007'
and sysdate() between a.from_date and a.to_date
union all
select '사원' job_title, a.emp_no, b.salary 
from dept_emp a
inner join salaries b
on a.emp_no= b.emp_no 
where a.dept_no='d007'
and sysdate() between a.from_date and a.to_date
and sysdate() between b.from_date and b.to_date
;