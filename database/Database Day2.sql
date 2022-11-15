-- 데이터베이스 생성 
create database mywork;
create database if not exists mywork;

-- 데이터 베이스 삭제
drop database mywork;
drop database	if exists myworks;

-- 데이터 베이스 진입
use mywork;
-- 기본키 설정 방법( 방법1)
create table if not exists highschool_students(
student_no varchar(20) not null primary key,
student_name varchar(100),
grade tinyint,
class varchar(20),
gender varchar(20),
age smallint,
enter_date date



);
-- 기본키 설정 방법( 방법2)
create table if not exists highschool_students(
student_no varchar(20) not null ,
student_name varchar(100),
grade tinyint,
class varchar(20),
gender varchar(20),
age smallint,
enter_date date,
constraint primary key (student_no)



);
-- 생성된 테이블 정보 확인 

-- 기본키 설정 방법( 방법3)
create table if not exists highschool_students(
student_no varchar(20) not null ,
student_name varchar(100) not null,
grade tinyint,
class varchar(20),
gender varchar(20),
age smallint,
enter_date date



);

desc highschool_students;
alter table highschool_students
add primary key (student_no);

drop table if exists highschool_students;


-- my_first_table 이라는 테이블을 만들려고 합니다.
-- (1) 각 컬럼의 내용을 보고 어떤 데이터 타입을 사용하면 될지 데이터 타입 항목을 채우세요.
-- 항목		컬럼명			컬럼설명				데이터 타입
-- 사번		employee_id		숫자 1에서 300까지 할당	 smallint
-- 이름		employee_name	문자					 varchar(100)
-- 급여		salary			사원의 급여			int	
-- 입사일자	hire_date		날짜                  date	
-- (2) 위 데이터 타입을 기준으로 my_first_table 이라는 SQL문을 작성하세요.
-- (3) 위에서 생성한 테이블을 삭제하는 SQL문을 작성하세요.
-- (4) (2)에서 작성한 테이블 생성 문장을 참고해 사전 컬럼(employee_id)을 기본 키로 하는 테이블을 다시 만드세요

create table if not exists my_first_table(
employee_id varchar(5) not null primary key,
employee_name varchar(100) ,
slary Int,
hire_date date



);
drop table if exists my_first_table;
desc my_first_table;

desc box_office ;
select * from box_office;
select count(*) as amount from box_office;

select * from world.city;
select * from world.city where countrycode='kor';
select * from world.city where population > 1000000 ;

use world;

select  * from city where district like 'k%';

select * from city where countrycode= 'kor' and population > 500000 order by population desc;

select * from city where district = 'seoul' or district = 'Kyonggi';
select * from city where district in('seoul', 'Kyonggi');

select * from country;
select * from country where population >=45000000 and population<=55000000;
use mywork;

/*
여러줄 주석 달기
(테이블) box_office table : 2004~2019년까지 개봉된 영화 정보
-- seq_no : 일련번호, 기본키
-- years : 제작연도
-- ranks : 순위
-- movie_name : 영화명
-- release_date : 개봉일
-- sale_amt : 매출액
-- share_rate : 점유율(매출액 기준)
-- audience_num : 관객수
-- screen_num : 스크린수
-- showing_count : 상영횟수
-- rep_country : 대표국적
-- countries : 국적
-- distributor : 배급사
-- movie_type : 유형(장편, 단편, ...)
-- genre : 장르(스릴러, 액션..)
-- director : 감독




*/


desc box_office;
-- (실습) 
-- 2018년 개봉한 한국 영화 조회하기 -- 
select * from box_office;
select * from box_office where years=2018 and countries='한국';
select * from box_office where release_date between '2018-01-01' and '2018-12-31' and rep_country='한국';
select * from box_office where release_date like '2019%' and audience_num>=5000000;
select * from box_office where release_date like '2019%' and (audience_num>=5000000 or sale_amt);

use world;


-- 컬럼명 대신 순번(5)으로 대체해서 정렬 가능하다
select code, name, continent, region, population  from country where population >=100000000 order by 5 desc;


select name, continent, region from country where population >=50000000 order by 2 asc, 3 desc;
desc country;

-- 실습 
-- city 테이블에서 우리나라에 속한 도시에 대해 
-- 도시명은 오름차순, 인구는 내림차순으로 조회하기 
select * from city where countrycode='kor' order by 2 asc, 5 desc;

use mywork;

select * from box_office where release_date like '2019%' and audience_num>=5000000 limit 10;


-- (실습)
-- 2019년 개봉영화중에 관객이 500만명 이상인 데이터에 대해
-- 매출액 기준 내림차순 정렬한 뒤, 상위 5건만 가져오기
select * from box_office where release_date like '2019%' and audience_num>=5000000 order by sale_amt desc limit 5;
-- (실습)
-- world database의 countrylanguage table에 국가별 사용 언어가 있고,
-- 이 테이블 percentage 컬럼에는 해당 언어가 사용되는 비율값이 들어 있음
-- 이 비율이 99% 이상인 것을 국가코드 순으로 조회하기
use world;
desc countrylanguage;
select * from countrylanguage where percentage>=99 order by countrycode;
-- (실습)
-- world database에 접속된 상태에서 mywork database에 있는 box_office 테이블에서
-- 2019년 제작된 영화중 순위(ranks)가 1위에서 10위까지인 영화를 순위(ranks)로 조회하기
select * from mywork.box_office where release_date like '2019%' order by ranks limit 10; 
-- (실습)
-- mywork database로 이동해 box_office 테이블에서
-- 2019년 제작된 영화중 영화유형(movie_type)이 장편이 아닌 영화를 순위(ranks)대로 조회하기
use mywork;
select * from box_office where release_date like '2019%' and movie_type!='장편' order by ranks;
-- (실습)
-- box_office 테이블에서 2019년 제작된 영화 중 스크린수 기준 상위 10개 영화 조회하기
select * from box_office where release_date like '2019%' order by screen_num desc limit 10;