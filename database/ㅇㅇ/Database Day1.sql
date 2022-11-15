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


-- (실습) 
-- my_first_table 이라는 테이블을 만들려고 합니다
-- (1) 각 컬럼의 내용을 보고 어떤 데이터 타입을 사용하면 될지 데이터 타입 항목을 채우세요.
--