CREATE USER netocourier WITH PASSWORD 'NetoSQL2022';
GRANT SELECT, UPDATE, insert, delete, truncate, references, trigger ON ALL TABLES IN SCHEMA public TO netocourier
GRANT EXECUTE ON ALL functions  IN SCHEMA public TO netocourier;
GRANT EXECUTE ON ALL procedures IN SCHEMA public TO netocourier;
GRANT SELECT ON all views IN SCHEMA public TO netocourier;
grant all on schema public to netocourier
grant USAGE on schema information_schema to netocourier
grant USAGE on schema pg_catalog to netocourier

GRANT select on courier_statistic TO netocourier

create table account
(
	id UUID not null primary key default uuid_generate_v4(),
	name varchar(250) --название контрагента
)

create table contact
(
	id UUID not null primary key default uuid_generate_v4(),
	last_name varchar(250), --фамилия контакта
	first_name varchar(250), --имя контакта
	account_id uuid references account(id) 
)

create table "user"
(
	id UUID not null primary key default uuid_generate_v4(),
	last_name varchar(250), --фамилия сотрудника
	first_name varchar(250), --имя сотрудника
	dismissed boolean default false --уволен или нет, значение по умолчанию "нет"
)

create type Status as enum ('В очереди', 'Выполняется', 'Выполнено', 'Отменен')

create table courier 
(
	id UUID not null primary key default uuid_generate_v4(),
	from_place varchar(250),
	where_place varchar(250), 
	name varchar(250),
	account_id uuid references account(id), 
	contact_id uuid references contact(id), 
	description text,
	user_id uuid references "user"(id), --id сотрудника отправителя
	status STATUS default  'В очереди',-- статусы 'В очереди', 'Выполняется', 'Выполнено', 'Отменен'. По умолчанию 'В очереди'
	created_date date default now() --дата создания заявки, значение по умолчанию now()
)




-- Задание 6 
-- Создание функции charlenght. используется для динамического определения длинны строки
CREATE OR REPLACE FUNCTION charlenght(tablename varchar, ordinalposition int) RETURNS integer AS $$
        declare 
        	result int;
		BEGIN
        	select 
				character_maximum_length
			from information_schema.columns 
			where table_catalog = 'postgres' and 
				table_schema = 'public' and 
				table_name = tablename and 
				ordinal_position = ordinalposition into result;
			return result;
		END;
$$ LANGUAGE plpgsql;

-- Функция возвращает случайную строку из таблицы
CREATE OR REPLACE FUNCTION getrandomrow(tablename varchar) RETURNS uuid 
as $$
	declare 
		result uuid;
	begin  
		EXECUTE 'SELECT id FROM public.' || tablename || ' order by random() limit 1' into result;	
		return result;
	end;
$$ LANGUAGE plpgsql;

-- Процедура выполняет генерацию случайных данных в захардкоженных таблицах по захардкоженным алгоритмам
create or replace procedure insert_test_data(value int) 
as $$
	declare 
		RowsInAccount int;
		RowsInContact int;
		RowsInuser int;
		RowsIncourier int;
		i int;
		dismiss boolean;
	begin 
		RowsInAccount = value * 1;
		RowsIncontact = value * 2;
		RowsInuser = value * 1;
		RowsIncourier = value * 5;
		
		-- Таблица account
		i = 0;
		while i < RowsInAccount loop
			insert into account values (default, (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('account', 2))::integer)));
			i = i + 1;
		end loop;
		
		-- Таблица Contact
		i = 0;
		while i < RowsInContact loop
			insert into Contact values 
				(default, 
				 (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('contact', 2))::integer)),
				 (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя',1,((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('contact', 3))::integer)),
				 (SELECT * from getrandomrow('account'))				 
				 );
			i = i + 1;
		end loop;	
	
	
		-- Таблица user
		i = 0;
		while i < RowsInuser loop
			
			insert into public."user" values
						(default, 
						 (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя', 1, ((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('user', 2))::integer)),
						 (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя', 1, ((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('user', 3))::integer)),
						 (select case when (random() * (1 - 0) + 0) > 0.5 then true else false end)
						);
			i = i + 1;
		end loop;
	
		-- Таблица courier
		i = 0;
		while i < RowsIncourier loop
			insert into courier values
						(default, 
						 (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя', 1, ((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('courier', 2))::integer)),
						 (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя', 1, ((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('courier', 3))::integer)),
						 (SELECT SUBSTRING((SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя', 1, ((random() * (1 - 0) + 0) * 33)::integer), ((random() + 1)::integer))), 1, (SELECT * FROM charlenght('courier', 4))::integer)),
						 (SELECT * from getrandomrow('account')),
						 (SELECT * from getrandomrow('contact')),
						 (SELECT repeat(substring('абвгдеёжзийклмнопрстуфхцчшщьыъэюя', 1, ((random() * (1 - 0) + 0) * 33)::integer), (random() * 33 )::integer)),
						 (SELECT * from getrandomrow('user')),
						 (SELECT enum_range[(select floor(random() * (4.9 - 1) + 1))] from (select enum_range(null::status)) as range),
						 (SELECT now() - interval '1 day' * round(random() * 1000) as timestamp)
						);
			i = i + 1;
		end loop;

	end;
$$ LANGUAGE plpgsql;


call insert_test_data(500)


-- Процедура выполняет очистку таблиц
create or replace procedure erase_test_data() 
as $$
	declare 

	begin
		TRUNCATE public.account CASCADE;
		TRUNCATE public.contact CASCADE;
		TRUNCATE public.courier CASCADE;
		TRUNCATE public.user CASCADE;
	end;
$$ LANGUAGE plpgsql;


call erase_test_data()

-- задача 8
create or replace procedure add_courier(from_place varchar(250), 
										where_place varchar(250), 
										name varchar(250), 
										account_id uuid, 
										contact_id uuid, 
										description text, 
										user_id uuid) 
as $$
	begin
	insert into courier values
	(
	 	default,
	 	from_place,
	 	where_place,
	 	name,
	 	account_id,
	 	contact_id,
	 	description,
	 	user_id,
	 	'В очереди',
	 	(select now()) 
	);
	EXCEPTION WHEN OTHERS  
	THEN
    	RAISE NOTICE 'Не удалось добавить значение. Переданые следующие значения: from_place - %, \n 
																					where_place - %, \n 
																					name - %, \n 
																					account_id - %, \n 
																					contact_id - %, \n 
																					description - %, \n 
																					user_id - %', from_place, where_place, name, account_id, contact_id, description, user_id;	
	end;
$$ LANGUAGE plpgsql;


-- задача 9
create or replace function get_courier() returns table(
														id uuid,
														from_place varchar(250),
														where_place varchar(250),
														name varchar(250),
														account_id uuid,
														account varchar(250),
														contact_id uuid,
														contact varchar(1000),
														description text,
														user_id uuid,
														"user" varchar(1000),
														status status,
														created_date timestamp
														) 
as $$
	select 
		courier.id,
		courier.from_place,
		courier.where_place,
		courier.name,
		courier.account_id,
		account.id ,
		courier.contact_id,
		contact.first_name || ' ' || contact.last_name,
		courier.description,
		courier.user_id,
		public.user.first_name || ' ' || public.user.last_name,
		courier.status,
		courier.created_date
	from courier
	left join contact on courier.contact_id = contact.id 
	left join public.user on courier.user_id = public.user.id 
	left join account on courier.account_id = account.id
	order by courier.status, courier.created_date desc
$$ LANGUAGE sql;

-- Задача 10
create or replace procedure change_status(newstatus status, id uuid) 
as $$
	begin
		update courier
		set status = newstatus
		where id = id;		
	end;
$$ LANGUAGE plpgsql;

-- Задача 11
create or replace function get_users() returns table("user" varchar(1000))
as $$
	select 
		concat(first_name, ' ', last_name) as "User"
	from public."user"
	where dismissed = false
	order by public."user" .last_name 
$$ LANGUAGE sql;


-- Задача 12
create or replace function get_accounts() returns table(account varchar(1000))
as $$
	select 
		"name" as account
	from public.account
	order by "name" 
$$ LANGUAGE sql;

-- Задача 13
create or replace function get_contacts(account_id uuid) returns table(contact varchar(500))
as $$
	declare
		resultifnull varchar(500);
	begin
		resultifnull = 'Выберите контрагента';
		if $1 is null then
			return query select resultifnull;
		else			
			return query select cast(Concat(first_name, ' ', last_name) as varchar(500)) from contact where contact.account_id = $1 order by contact.last_name;
		end if;
	end;
$$ LANGUAGE plpgsql;

-- Задача 14
create view courier_statistic as
with cte_BaseWithoutpercent as
	(select *
	 from (select
			courier.account_id as account_id,
			account."name" as name, 
			count(courier.id) over (partition by courier.account_id order by courier.account_id) as count_courier, --количество заказов на курьера для каждого контрагента
			(select count(*) from courier as t1 where status = 'Выполнено' and t1.account_id = courier.account_id) as count_complete, --количество завершенных заказов для каждого контрагента
			(select count(*) from courier as t2 where status = 'Отменен' and t2.account_id = courier.account_id) as count_canceled, --количество отмененных заказов для каждого контрагента
			count(courier.id) over (partition by courier.account_id, date_trunc('month', courier.created_date)) as "КоличествоЗаказовВТекущемПериоде",
			count(courier.where_place) over (partition by courier.account_id) as count_where_place,
			count(courier.contact_id) over (partition by courier.account_id) as count_contact,
			(SELECT ARRAY(select user_id from courier as courier2 where status = 'Отменен' and courier2.account_id = courier.account_id)) as cansel_user_array,
			date_trunc('month', courier.created_date) as month 
	from courier
	left join account on courier.account_id = account.id) as BaseTable
),
cte_BaswWithLagLead as 
(
	select 
		*,
		Lag("КоличествоЗаказовВТекущемПериоде", 1) over (partition by account_id order by "КоличествоЗаказовВТекущемПериоде",  month) prev
	from cte_BaseWithoutpercent
	order by account_id, month
)
select 
	account_id,
	name,
	count_courier,
	count_complete,
	count_canceled,
	count_where_place,
	count_contact,
	cansel_user_array,
	coalesce(("КоличествоЗаказовВТекущемПериоде"/nullif(prev, 0) * 100 ), 0) as percent_relative_prev_month
from cte_BaswWithLagLead

select * from courier_statistic

