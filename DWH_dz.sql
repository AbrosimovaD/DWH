-- Создание таблиц справочников

create table dim_passengers(
	passenger_id varchar(20) NOT NULL,
	passenger_name text NOT NULL,
	contact_data jsonb NULL);

create table Dim_Aircrafts(
	aircraft_code bpchar(3) NOT NULL,
	model jsonb NOT NULL,
	"range" int4 NOT NULL);
	
create table Dim_Airports (
	airport_code bpchar(3) NOT NULL,
	airport_name jsonb NOT NULL,
	city jsonb NOT NULL,
	coordinates point NOT NULL,
	timezone text NOT NULL)	;
	
create table Dim_Tariff (
	tariff_id serial4 NOT null,
	tariff text not null);	
	
	create table dim_calendar 
(
  date_id              INT NOT NULL,
  date_actual              DATE NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  month_actual             INT NOT NULL,
  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_actual           INT NOT NULL,
  year_actual              INT NOT NULL
);
	
INSERT INTO dim_calendar
SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS date_id,
       datum AS date_actual,
       EXTRACT(ISODOW FROM datum) AS day_of_week,
       EXTRACT(DAY FROM datum) AS day_of_month,
       datum - DATE_TRUNC('quarter', datum)::DATE + 1 AS day_of_quarter,
       EXTRACT(DOY FROM datum) AS day_of_year,
       TO_CHAR(datum, 'W')::INT AS week_of_month,
       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_actual,
       EXTRACT(YEAR FROM datum) AS year_actual
FROM (SELECT '2017-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;

COMMIT;

-- Создание таблицы фактов
CREATE TABLE fact_flights (
	passenger varchar(20) NULL,
	date_dep timestamp NULL,
	date_arr timestamp NULL,
	diff_dep int4 NULL,
	diff_arr int4 NULL,
	aircraft text NULL,
	airport_dep varchar(50) NULL,
	airport_arr varchar(50) NULL,
	tariff varchar(20) NULL,
	amount numeric(10, 2) NULL
);