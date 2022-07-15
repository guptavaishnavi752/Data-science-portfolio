show databases;
use project;
show tables;

select * from dataset1;
select count(*) as 'no_of_rows' from dataset1;
select * from dataset2;
select count(*) as 'no_of_rows' from dataset2;

select* from information_schema.columns where table_name='dataset1';
select count(*) as 'no_of_col' from information_schema.columns where table_name='dataset1';
select* from information_schema.columns where table_name='dataset2';
select count(*) as 'no_of_col' from information_schema.columns where table_name='dataset2';
select * from information_schema.tables;

select d1.state,d1.district, d1.growth,d1.literacy from dataset1 d1 where state in ('maharashtra','bihar') order by state;
select distinct state from dataset1 where state like 'a%';
select distinct state from dataset1 where state like 'a%' and state like '%h';
  
select count(distinct state) from dataset1;
select distinct state,count(*) from dataset1 group by state order by count(*) desc;

select state,district,max(growth) from dataset1 group by state;

select state,district,literacy from dataset1  order by literacy limit 3;

#combing the contents of both tables into 1
select d1.state,d1.district,d1.growth,d1.sex_ratio,d1.literacy,d2.population,d2.area_km2 from dataset1  d1 join dataset2 d2 on (d1.district=d2.district);

select sum(population) from dataset2;
select avg(growth)*100 as 'avg_growth' from dataset1;
select state, round(avg(growth)*100,0) as 'avg_growth'  from dataset1 group by state;
select state ,round(avg(literacy),0) as 'avg_literacy'  from dataset1 group by state having avg_literacy >90;

#TO CALCULATE NO. OF MALES AND FEMALES IN EVERY STATE FROM SEX RATIO:
select d4.state, sum(d4.males) as total_males, sum(d4.females) as total_females from(
select d3.state,d3.district,round((d3.population/(d3.sex_ratio+1)),0) as males,round(((d3.population*d3.sex_ratio)/(d3.sex_ratio+1)),0) as females from
(select d1.state,d1.district,d1.sex_ratio/1000 as sex_ratio,d2.population from dataset1 d1 join dataset2 d2 on d1.district=d2.district) as d3) as d4 group by d4.state;

#TO CALCULATE NO. OF LITERATES AND ILLITERATES IN EVERY STATE FROM LITERACY RATE:
select d4.state,sum(d4.literates) as total_literates,sum(d4.illiterates) as total_illiterates from (
select d3.state,d3.district,round((d3.literacy_ratio*d3.population),0) as literates,round((1-d3.literacy_ratio)*d3.population,0) as illiterates from(
select d1.state,d1.district,d1.literacy/100 as literacy_ratio,d2.population from dataset1 as d1 join dataset2 as d2 on d1.district=d2.district) as d3) as d4 group by state;

#TO CALCULATE POPULATION IN PREVIOUS CENSUS FROM GROWTH RATE:
select d4.state,sum(d4.prev_popln) as total_prev_pop,sum(d4.current_popln) as total_current_pop from(
select d3.state,d3.district,round(d3.population/(d3.growth+1),0) as prev_popln,d3.population as current_popln from(
select d1.district,d1.state,d2.population,d1.growth from dataset1 as d1 inner join dataset2 as d2 on d1.district = d2.district)as d3)as d4 group by state;

