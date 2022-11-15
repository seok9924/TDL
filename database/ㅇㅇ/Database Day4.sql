use mywork;
/* 데이터 집계하기 */ 
-- (1) 그룹화 하기 (2) 집계함수 사용 (3) 집계쿼리 (1)+(2)

-- 연도별 개봉 영화 수의 합 집계
select year(release_date), count(*) from box_office group by year(release_date) order by year(release_date) ;


-- (실습) 2019년 개봉 영화의 "유형"별로 매출액의 최대값, 최소값, 전체합을 집계  
desc box_office;
select movie_type, max(sale_amt) as 최대, min(sale_amt)as 최소, sum(sale_amt) as 전체합계
from box_office where year(release_date)='2019' group by 1; 

-- (실습) 2019년 개봉영화중 매출액이 1억원 이상인 영화의 분기별 배급사별 개봉 영화수와 매출액 합계 집계하기 

select quarter(release_date) 분기,distributor,count(*) as 영화수,  sum(sale_amt) as 전체매출액 
from box_office where year(release_date)='2019' and sale_amt>=100000000
group by 1,2
order by 1 desc; 

use world;


-- (실습) world 데이터베이스의 city 테이블에서 국가코드별 도시수 집계하기

-- (실습) world 데이터베이스의 country 테이블에서 대륙별 면적이(surfacearea)  가장 큰 순 정렬


select countrycode, count(*) from city group by 1 order by 2 desc; 

desc country;
select continent,count(*), sum(surfacearea) from country group by 1 order by 2 desc;

-- (실습) mywork 데이터베이스의 box_office 테이블에서 2019년 개봉 영화중 1~10위 영화 , 나머지 영화를 구분화되 
-- 두 그룹의 매출액 합계를 구하는 쿼르 작성하기


use mywork;
select if(ranks<=10,'상','하') as 상, sum(sale_amt) from box_office where year(release_date)='2019' group by 1 order by 1 ;
select if(ranks<=10,'상','하') as 상,count(*), sum(sale_amt) from box_office where year(release_date)='2019' group by 1 with rollup;


-- 월별, 영화유형별, 매출액을 집계하기 

select month(release_date),movie_type, count(*),sum(sale_amt) from box_office where year(release_date)=2019 and sale_amt>10000000 group by month(release_date),2 with rollup;


-- grouping 을 응용하여 총합에 해당하는 null값을 적당한 단어("합계")로 교체 
select if(grouping(movie_type)=0,movie_type,"합계") as '총계', count(*) 
from box_office 
where year(release_date)=2019
group by movie_type with rollup;

-- having 절 사용하기  
-- box_offcie 테이블에서 순위가 1~10위에 있는 영화를 조회하되 
-- 개봉연월별로 순위가 1~10위에 있는 영화 편수 구하기 
select month(release_date), count(*) as 영화수 from box_office where ranks<=10 group by 1 having count(month(release_date))>=10 order by 1;


-- 아래와 같이 집계함수를 where 절에 쓰면 에러
select extract(year_month from  release_date ) 개봉연월 , count(*) 
as 영화수 from box_office where ranks<=10 group by 1 having count(*)>=2 order by 1;


-- 실습 개봉연월 별로 순위가 1~10위에 있는 영화 편수와 매출액 합 구하기 
-- 이 때 개봉연월 별로 매출액이 1500억 이상인 경우만 조회하기 
select extract(year_month from  release_date ) 개봉연월 , count(*) 
as 영화수,sum(sale_amt) from box_office where ranks<=10  group by 1 having count(*)>=2 and sum(sale_amt)>150000000000 order by 1;


-- 실습 2019 년 개봉영화중 매출액이 1000만원 이상인것을 골라 유형별로 매출액 합 구하기 

select movie_type, round(sum(sale_amt)/100000000,1) as 매출액합 from box_office where year(release_date)=2019 and sale_amt > 10000000 group by movie_type with rollup ;


select movie_type, round(sum(sale_amt)/100000000,1) as 매출액합 from box_office where year(release_date)=2019 and sale_amt > 10000000 group by movie_type with rollup having grouping(movie_type) =1;



-- (실습) 2019년 개봉 영화 중 매출액이 1000만원 이상인것을 골라 "월"별, "영화유형"별로 매출액합 집계하기 (with rollup)
-- 이 때 "월"별, "영화유형"별 매출액 합계(유형별소계, 월별총계)로 나온 결과 행만 조회하기 (having 절)

select month(release_date), movie_type, sum(sale_amt) 
from box_office where year(release_date)=2019
 group by 1,2 having sum(sale_amt)>=1000000 order by 1;
 
 select if(grouping(month(release_date))=0,month(release_date),"총합") 월, 
 if (grouping(movie_type)=0, movie_type,"소계") 영화유형, round(sum(sale_amt)/100000000,2) '매출합(억단위)'
 from box_office
 where year(release_date) =2019 and sale_amt>1000000
 group by month(release_date), movie_type with rollup
 having grouping(movie_type) =1
 order by month(release_date);
 ;
 
 
-- (실습) box_office 테이블에서 2019년 개봉영화 중 "국가(rep_country)"별 관객수(audience_num)의 합이 50만명 이상인 것을 조회하기 

select rep_country 국가,count(*) 영퐈현수, sum(audience_num) 관객수합 
from box_office 
where year(release_date)=2019 
group by 1 with rollup having sum(audience_num)>=500000  ;
-- 이때 "국가"별 합계까지 구하는 쿼리 작성하기 (with rollup)
 
  -- box_office 테이블에서 2015년 이후 개봉한 영화 중 
  -- 관객수가 100만을 넘긴 영화의 감독과 관객수, 개봉편수를 "연도"별 "감독"별로 집계하기
  
  desc box_office;
  
  select year(release_date), director, sum(audience_num), count(*) as 영화편수
  from box_office
  where  audience_num>=1000000 and year(release_date)>=2015
  group by 1,2 having 영화편수>=2 order by 4 desc ;
  
  
  use world;
  
  
  -- 내부조인 
  select count(*) from city;  -- 4079
  select count(*) from country; -- 239
  
  -- city 테이블과 country 테이블을 조인해서 국가명 대륙명 인구까지 조회하기 
  select *
  from city a
  inner join country b 
  on a.countrycode=b.code;
  
  select a.*, b.name , b.continent, a.population
  from city a
  inner join country b 
  on a.countrycode= b.code
  where a.countrycode='kor';
  
  -- 실급 country 테이블과 countylanguage 테이블 내부조인 
  
  desc countrylanguage;
  desc country;
  select count(*) from countrylanguage;
  
  select * 
  from country a 
  inner join countrylanguage b
  on a.code=b.countrycode;
 -- where a.code='kor';
  