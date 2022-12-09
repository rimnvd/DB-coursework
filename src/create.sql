--Создание всех таблиц БД

--Инструктор
create table instructor (
    id serial primary key,
    name varchar(50) not null,
    phone_number varchar(12),
    information text
);

--Абонемент
create table subscription (
    id serial primary key,
    description varchar(255),
    number_of_classes integer,
    cost integer not null,
    number_of_days integer not null,
    check (number_of_classes > 0),
    check (cost > 0)
);

--Клиент
create table client (
    id serial primary key,
    name varchar(50) not null,
    phone_number varchar(12) not null,
    email varchar(50),
    number_of_remaining_classes integer,
    start_date date not null,
    end_date date not null,
    check (number_of_remaining_classes >= 0 or number_of_remaining_classes is null)
);

--Отзыв
create table review (
    id serial primary key,
    client_id integer references client,
    content text,
    mark integer not null,
    review_date date,
    check (mark > 0)
);


--Направление
create table dance_direction (
    name varchar(50) primary key,
    description text
);


--Курс
create table course (
    name varchar(100) primary key,
    description text,
    instructor_id integer not null references instructor on delete set null,
    number_of_free_places integer not null,
    cost integer not null,
    check (number_of_free_places >= 0),
    check (cost > 0)
);

--Расписание занятий
create table class_schedule (
    group_number serial primary key,
    dance_direction_name varchar(50) not null references dance_direction on delete cascade,
    classes_date date not null,
    start_time time not null,
    end_time time not null,
    instructor_id integer references instructor on delete set null,
    number_of_free_places integer not null,
    difficulty_level varchar(30),
    check (number_of_free_places >= 0)
);


--Расписание индивидуальных занятий
create table individual_class_schedule (
    id serial primary key,
    instructor_id integer not null references instructor on delete set null,
    classes_date date,
    start_time time,
    end_time time,
    enrolling boolean not null default false
);

--Приобретение услуг
create table acquisition_of_services (
    id serial primary key,
    client_id integer not null references client on delete cascade,
    subscription_id integer not null references subscription(id) on delete cascade
);


--Запись на занятия
create table signing_up_for_classes (
    id serial primary key,
    client_id integer not null references client(id) on delete cascade,
    group_number integer not null references class_schedule(group_number) on delete cascade
);

--Запись на курсы
create table signing_up_for_courses (
    id serial primary key,
    client_id integer not null references client(id) on delete cascade,
    course_name varchar(100) not null references course(name) on delete cascade
);

--Запись на индивидуальные занятия
create table signing_up_for_individual_classes (
    slot_id integer not null references individual_class_schedule(id) on delete cascade,
    client_id integer not null references client(id) on delete cascade
);