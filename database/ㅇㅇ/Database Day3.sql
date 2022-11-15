/* SQL 함수 사용하기 */
-- 수식 연산자 

select ceil(6.5);
select floor(6.5);
select mod(7,2), 7%2;
select power(4,3);
select sqrt(25);
select round(1153.456,1);
select round(1153.456,-1);
select rand(2); -- 0~1사의 무작위수가 추출됨

-- 문자형 함수 
select char_length('sql');
select char_length('홍길동');
select length('sql');
select length('홍길동');

select concat('this ','is','mysql'); -- 실제로는 컬럼명을 적으면 될듯 !
select concat('this ',null,'mysql');   -- 연결 자체가 안됬음
select concat_ws('**','this ','is','mysql');

select format(5550000,0); -- 무조건 3자리씩 끊어줌 뒤에 패러미터는 실수부

select lower('ABCD'), upper('abcd');

select lpad('sql',7,'#');
select rpad('sql',7,'$');

select left('thisismysql',4);
select right('thisismysql',4);

select reverse('sql');
select replace('생일 축하해 철수야', '철수', '영희');

select instr('abc','c');
select locate('c','abcabcabc',7);
select position('c' in 'abc');

select substr('this is mysql',6,2);
select substring('this is mysql',6,2);
select substr('this is mysql',-8,2);
select mid('this is mysql', 6 , 2) as mid함수의결과 ;


select trim('      mysql     ');
select trim(both '*' from '****mysql*****');

select trim(leading '*' from '****mysql*****');

select trim(trailing '*' from '****mysql*****');

select strcmp('mysql', 'mysql1');  -- 앞이 더 크면 1 뒤가 더크면 -1 같으면 0 

-- 실습 문제 문자형 함수 사용 
-- world 데이터베이스에 접속해서 country 테이블에서 인구가 4,500만명에서 5,500만명 사이에 있는 국가를
-- 조회하되 국가명과 대륙명을 연결해서 '국가명(대륙명)' 형태로 조회하기 

use world;

select code,name,continent, concat(name,'(',continent,')') as '국가명(대륙명)'  from country where population>=45000000 and population<=55000000 ;

-- (실습) 숫자형 함수 사용
-- mywork 데이터베이스에 접속해 box_office 테이블에서 2019년 개봉한 한국 영화 중 관객수가 500만 명 이상인 영화를 조회
-- 이 때 매출액은 1억으로 나눈 후 소수점 없이 반올림 한 결과를 표시하기
-- 표시될 컬럼명(4개) : years, ranks, movie_name, release_date, audience_num, sales_amt(1억단위)

use mywork;
select years, ranks, movie_name, release_date, audience_num, round(sale_amt/100000000,0) as 'sales_amt(1억)'  from box_office where release_date like "2019%"  and audience_num>=5000000 and rep_country='한국';



-- (실습) 문자형 함수 사용
-- (실습) 문자형 함수 사용
-- 현재 box_office 테이블에 영화감독(director)이 두명 이상이면 ','로 연결되어 있음
-- 감독이 1명이면 그대로 두고, 두명 이상이면 ',' 대신 '/' 값으로 대체해 조회

select years,ranks,movie_name,replace(director,',','/') as '감독' from box_office;

select current_date();
select current_time();
select now();
select current_timestamp(), now();
select dayname('2022-11-02');
select dayofmonth(now());
select dayofweek(now()); -- 일요일 기준으로 몇번째 날인지 
select dayofyear(now());
select last_day(now());
select year(now());
select month(now());
select quarter(now());
select weekofyear(now()); -- 52주중 몇주차인지 알려줌

select adddate(now(),10);
select date_add(now(),interval 10 day);
select date_sub('2022-11-02', interval 10 day);
select date_add('2022-11-22', interval '1 3' day_hour);

select extract(year_month from '2022-11-02 12:08:32');
select extract(minute_second from '2022-11-02 12:08:32');
select datediff('2022-11-02', '2021-11-02');
select yearweek('2021-11-02');

-- date_format 에서 사용하는 
select date_format('2022-11-02', '%d%b%y');

select dayname(last_day(now()));

select date_add('2021-05-12',interval 100 day); -- 500 1000

use mywork;
select * from box_office where year(release_date) ='2019' and movie_name like '%:%' ;

select if (2<1 , 1,0);

select ifnull(null, 'null 입니다');
select ifnull(1, 'null입니다');
select nullif(1,2);


select case 1 when 1 then '1입니다'
			  when 2 then '2입니다'
when 3 then '3입니다'
when 4 then '4입니다'
when 5 then '5입니다'
else 'none' 
end case1,
case 2 when 1 then '1입니다'
when 2 then '2입니다'
when 3 then '3입니다'
when 4 then '4입니다'
when 5 then '5입니다'
else 'none' 
end case2 ;


-- (실습) 날짜형 함수
-- box_office 테이블에서 2019년 개봉한 영화 중 순위(ranks) 기준 상위 10위까지의 영화 조회하되,
-- 이 때 개봉일이 무슨 요일인지와 개봉일이 어떤 분기에 속해 있는지도 조회하기
-- 표시할 컬럼 : 영화 이름, 개봉일, 개봉요일, 분기
select movie_name,release_date,dayname(release_date) as '요일', quarter(release_date) as 분기  from box_office where year(release_date) ='2019' and ranks<=10
order by ranks;




-- (실습) 흐름제어 함수
-- 위의 결과를 활용하여 분기를 상반기, 하반기로 바꾸어 표현해보자.
-- (예: 1,2분기이면 상반기, 3,4분기이면 하반기)
     
select movie_name,release_date,dayname(release_date) as '요일', 

case when quarter(release_date) in (1,2) then '상반기' 
	when quarter(release_date) in (3,4) then '하반기'
else 'none' end as 분기분석 from box_office where year(release_date) ='2019';


-- world 데이터베이스에 있는 country  테이블에 있는 indepyear 라는 컬럼에는 독립연도 저장
-- 이때 각 국가명과 독립연도를 조회 독립연도의 값이 없으면 없음 있으면 해당 독립연도가 조회되도록

use world;

select name, ifnull(indepyear,"없음") as 독립연도 from country;

-- 실습 mywork 데이터 베이스의 box_oofice 테이블에서 2019년 개봉한 영화중 ranks 1-10중 상위1 표기 그 외 '나머지' 표기
use mywork;
select case when ranks<=10 then '상위10' else '나머지' end as 순위,ranks, movie_name from box_office where year(release_date)='2019' order by ranks ;


/* 데이터 집계하기 */ 
-- (1) 그룹화 하기 (2) 집계함수 사용 (3) 집계쿼리 (1)+(2)

-- (1) 그룹화 하기
use world;
select continent,region from country group by continent,region order by continent,region;


select name,district, substring(district,1,3) as dist
from city
where countrycode='kor' group by 3  ;

-- note group by 한 대상(컬럼, 표현식, 순번)이 select 에 나와야 의미가 있음
select count(name), count(continent), count(distinct continent) from country;

select min(population), max(population),avg(population) from country 
where continent = 'europe';
select b.name,b.population from 
(
select min(population) as min_population
from country 
where continent = 'europe'
)a, country b
where b.population=a.min_population;