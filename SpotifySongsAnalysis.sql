create database songs;
show databases;
use songs;
CREATE TABLE spotify (
	artist VARCHAR(41) NOT NULL, 
	song VARCHAR(114) NOT NULL, 
	duration_ms DECIMAL(38, 0) NOT NULL, 
	explicit varchar(15)  NULL, 
	year_no varchar(39) NOT NULL, 
	popularity DECIMAL(38, 0) NOT NULL, 
	danceability DECIMAL(38, 3) NOT NULL, 
	energy DECIMAL(38, 4) NOT NULL, 
	key_name DECIMAL(38, 0) NOT NULL, 
	loudness DECIMAL(38, 3) NOT NULL, 
	mode_name BOOL NOT NULL, 
	speechiness DECIMAL(38, 4) NOT NULL, 
	acousticness DECIMAL(38, 7) NOT NULL, 
	instrumentalness DECIMAL(38, 8) NOT NULL, 
	liveness DECIMAL(38, 4) NOT NULL, 
	valence DECIMAL(38, 4) NOT NULL, 
	tempo DECIMAL(38, 3) NOT NULL, 
	genre VARCHAR(37) NOT NULL
);

drop table spotify;

set session sql_mode = " ";

load data infile 
'D:\songs_normalize.csv'
into table spotify
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

-- checking the records in the table 

select * from spotify;

-- no of songs by each artist

select artist , count(artist) as no_of_songs from spotify 
group by artist 
order by no_of_songs desc;

-- top 10 song based on popularity

with cte as(
select artist , song , year_no,popularity ,dense_rank() over( order by popularity desc) as pop_rank from spotify)
select artist , song , year_no,popularity from cte where pop_rank <= 10;

-- total no of songs based on year

select year_no , count(*) as no_of_song_in_the_year from spotify 
group by year_no 
order by year_no desc;


-- top song for each year (1998 - 2020) based on popularity 

with cte as(
select artist , song , year_no,popularity ,dense_rank() over( partition by year_no order by popularity desc) as pop_rank from spotify)
select artist , song , year_no,popularity from cte where pop_rank=1;


-- analysis based on tempo

select avg(tempo) from spotify;

select artist , song , year_no, tempo , case when tempo > 120 then "Above Average tempo" 
										  when tempo = 120 then "Average tempo"
                                          when tempo < 120 then "Below Average tempo" end as  TempoAverage
from spotify;

-- songs with highest tempo

select artist , song , year_no, tempo  from spotify order by tempo desc limit 10;

-- number of songs for different tempo ranges

select sum(case when tempo between 0 and 100.00 then 1 else 0 end) as classical_music ,
sum(case when tempo between 100.01 and 120.00 then 1 else 0 end) as modren_nusic,
sum(case when tempo between 120.01 and 150.00 then 1 else 0 end) as dance_music,
sum(case when tempo > 150.001 then 1 else 0 end) as highTempoMusic
from spotify;

-- energy analysis
select avg(energy) from spotify;

select artist , song , year_no, energy , case when energy between 0.1 and 0.3 then 'Calm music'
										  when energy between 0.3 and 0.6 then 'Moderate music'
                                          else 'Energitic Music' end as  EnergyAnalysis
from spotify;


select sum(case when energy between 0.1 and 0.3 then 1 else 0 end)  as 'CalmMusic',
sum(case when energy between 0.3 and 0.6 then 1 else 0 end)  as 'Moderate music',
sum(case when energy >0.6 then 1 else 0 end) as 'Energitic Music' from spotify;

