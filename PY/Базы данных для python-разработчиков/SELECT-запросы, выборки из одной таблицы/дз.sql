create database dz_2
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Создание структуры БД

CREATE TABLE Albums(

	uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	name character(250),
	year date

);

CREATE TABLE tracks(

	uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	name character(250),
	INTERVAL integer,
	album uuid,	
	FOREIGN KEY (album) REFERENCES Albums(uuid)

);

CREATE TABLE compilations(

	uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	name character(250),
	year date

);

CREATE TABLE tracksincollection(

	compilation UUID,
	track uuid,
	FOREIGN KEY(compilation) REFERENCES compilations(uuid),
	FOREIGN KEY(track) REFERENCES tracks(uuid),
	PRIMARY KEY (compilation, track)

);

CREATE TABLE genres(

	uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	name character(250)

);

CREATE TABLE performers(

	uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	name character(250)

);

CREATE TABLE performersgenres(

	genre UUID,
	performer uuid,
	FOREIGN KEY(genre) REFERENCES genres(uuid),
	FOREIGN KEY(performer) REFERENCES performers(uuid),
	PRIMARY KEY (genre, performer)

);

CREATE TABLE performersAlbums(

	Album UUID,
	performer uuid,
	FOREIGN KEY(Album) REFERENCES Albums(uuid),
	FOREIGN KEY(performer) REFERENCES performers(uuid),
	PRIMARY KEY (Album, performer)

);

-- Заполнение БД ДЗ «SELECT-запросы, выборки из одной таблицы». Отборов нет, так как идёт наполнение базы.
-- Задание 1 ------------------------------------

-- Функция возвращает случайную строку из таблицы -- Зачем ? Прост =)
CREATE OR REPLACE FUNCTION getrandomrow(tablename varchar) RETURNS uuid 
as $$
	declare 
		result uuid;
	begin  
		EXECUTE 'SELECT uuid FROM public.' || tablename || ' order by random() limit 1' into result;	
		return result;
	end;
$$ LANGUAGE plpgsql;


INSERT INTO performers(name) 
VALUES('Николай Носков'), 
		('Александр Пистолетов'), 
		('Чайф'), 
		('Че́стер'), 
		('Михаил Круг'), 
		('Дэ́ни Филт'), 
		('Paramore'),
		('Slipknot');
		
INSERT INTO genres(name) 
VALUES('Русский поп'), 
		('black metal'), 
		('Русский рок'), 
		('Эмо'), 
		('Ню-метал');	
		
INSERT INTO Albums(name, year) 
VALUES('Альбом 1', '2018-10-05'), 
		('Альбом 2', '2018-03-15'), 
		('Альбом 3', '2016-12-05'), 
		('Альбом 4', '2017-01-04'), 
		('Альбом 5', '2020-07-05'), 
		('Альбом 6', '2016-12-05'), 
		('Альбом 7', '2017-01-14'), 
		('Альбом 8', '2019-10-05');	
				
INSERT INTO tracks(name, INTERVAL, album) 
VALUES('Мой Трек 1', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))), 
		('Трек 2', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 3', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 4', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 5', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 6', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Мой Трек 7', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 8', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 9', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 10', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 11', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 12', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 13', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 14', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums'))),
		('Трек 15', (SELECT floor(random()*(240-120)+120)), (SELECT getrandomrow('Albums')));
				
INSERT INTO compilations(name, year) -- сборники
VALUES('Сборник 1', '2018-10-05'), 
		('Сборник 2', '2018-03-15'), 
		('Сборник 3', '2016-12-05'), 
		('Сборник 4', '2017-01-04'), 
		('Сборник 5', '2020-07-05');
	
INSERT INTO tracksincollection -- треки в сборниках
VALUES((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Мой Трек 1')), 
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 2')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 3')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 4')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 5')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 6')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Мой Трек 7')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 8')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 9')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 10')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 11')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 12')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 13')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 14')),
		((SELECT getrandomrow('compilations')), (SELECT UUID FROM tracks WHERE name ='Трек 15'));
	
INSERT INTO performersgenres(genre, performer) 
VALUES((SELECT UUID FROM genres WHERE name ='Русский поп'), (SELECT UUID FROM performers WHERE name ='Николай Носков')), 
		((SELECT UUID FROM genres WHERE name ='black metal'), (SELECT UUID FROM performers WHERE name ='Дэ́ни Филт')),
		((SELECT UUID FROM genres WHERE name ='Русский рок'), (SELECT UUID FROM performers WHERE name ='Чайф')),
		((SELECT UUID FROM genres WHERE name ='Эмо'), (SELECT UUID FROM performers WHERE name ='Александр Пистолетов')),
		((SELECT UUID FROM genres WHERE name ='Эмо'), (SELECT UUID FROM performers WHERE name ='Paramore')),
		((SELECT UUID FROM genres WHERE name ='Ню-метал'), (SELECT UUID FROM performers WHERE name ='Че́стер')),
		((SELECT UUID FROM genres WHERE name ='Русский рок'), (SELECT UUID FROM performers WHERE name ='Михаил Круг')),
		((SELECT UUID FROM genres WHERE name ='Ню-метал'), (SELECT UUID FROM performers WHERE name ='Slipknot'));
		
		
INSERT INTO performersAlbums(album, performer) 
VALUES((SELECT UUID FROM albums WHERE name ='Альбом 1'), (SELECT UUID FROM performers WHERE name ='Николай Носков')), 
		((SELECT UUID FROM albums WHERE name ='Альбом 2'), (SELECT UUID FROM performers WHERE name ='Дэ́ни Филт')),
		((SELECT UUID FROM albums WHERE name ='Альбом 3'), (SELECT UUID FROM performers WHERE name ='Чайф')),
		((SELECT UUID FROM albums WHERE name ='Альбом 4'), (SELECT UUID FROM performers WHERE name ='Александр Пистолетов')),
		((SELECT UUID FROM albums WHERE name ='Альбом 5'), (SELECT UUID FROM performers WHERE name ='Paramore')),
		((SELECT UUID FROM albums WHERE name ='Альбом 6'), (SELECT UUID FROM performers WHERE name ='Че́стер')),
		((SELECT UUID FROM albums WHERE name ='Альбом 7'), (SELECT UUID FROM performers WHERE name ='Михаил Круг')),
		((SELECT UUID FROM albums WHERE name ='Альбом 8'), (SELECT UUID FROM performers WHERE name ='Slipknot'))
		
		
-- Задание 2 ------------------------------------

-- 1 Название и год выхода альбомов, вышедших в 2018 году. 		
SELECT 
	name,
	YEAR 
FROM albums
WHERE date_part('year', albums."year") = 2018

-- 2 Название и продолжительность самого длительного трека.
SELECT 
	name,
	INTERVAL
FROM tracks 
ORDER BY tracks."interval" 
LIMIT 1

-- 3 Название треков, продолжительность которых не менее 3,5 минут.
-- ну как бэ с учётом рандома результат непредсказуем )
SELECT 
	name
FROM tracks
WHERE tracks."interval" > (3.5*60)

-- 4 Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT 
	name
FROM compilations
WHERE compilations."year" BETWEEN date('2018-01-01') AND date('2020-12-31')

-- 5 Исполнители, чьё имя состоит из одного слова
SELECT 
	name
FROM performers
WHERE (SELECT position(' ' in name)) = 0


-- 6 Название треков, которые содержат слово «мой» или «my».
SELECT 
	name 
FROM tracks
WHERE name LIKE '%Мой%'
