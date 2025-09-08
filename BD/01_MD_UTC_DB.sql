drop table payments;
drop table evaluations;
drop table enrollments;
drop table enrollment_details;
drop table teachers_by_course_assignments;
drop table course_assignments;
drop table courses;
drop table staff_assignments;
drop table students;
drop table areas;
drop table faculties;
drop table cycles;
drop table periods;
drop table staffs;
drop table record_types;
drop table persons;

create table persons(
    id number generated always as identity primary key,
    names varchar2(500) not null,
    father_last_name varchar2(500) not null,
    mother_last_name varchar2(500) not null,
    gender number(1),
    birth_date timestamp,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_person_creator foreign key(created_by) references persons(id),
    constraint fx_person_updater foreign key(updated_by) references persons(id)
);

create table record_types(
    id number generated always as identity primary key,
    type varchar2(50) not null,
    name varchar2(500) not null,
    description varchar2(500),
    additional_info varchar2(4000),
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

create table areas(
    id number generated always as identity primary key,
    code varchar2(500) not null,
    description varchar2(500) not null,
    status number,
    constraint fk_status_area foreign key(status) references record_types(id),
    created_at timestamp default current_timestamp,
    updated_at timestamp
);


create table staffs(
    id number generated always as identity primary key,
    code varchar2(25) not null,
    person_id number not null,
    email varchar2(500) not null,
    staff_type number not null,
    additional_info varchar2(4000),
    employment_info varchar2(4000),
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_staff_type foreign key(staff_type) references record_types(id),
    constraint fx_person foreign key(person_id) references persons(id),
    constraint fk_staff_creator foreign key(created_by) references persons(id),
    constraint fx_staff_updater foreign key(updated_by) references persons(id)
);

create table periods(
    id number generated always as identity primary key,
    code varchar2(500) not null,
    name varchar2(500) not null,
    description varchar2(500),
    start_date date not null,
    finish_date date not null,
    status number,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_status_period foreign key(status) references record_types(id),
    constraint fk_staff_creator_period foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_period foreign key(updated_by) references staffs(id)
);

create table cycles(
    id number generated always as identity primary key,
    abbr varchar2(50) not null,
    name varchar2(100) not null,
    description varchar2(500),
    status number,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_record_type foreign key(status) references record_types(id),
    constraint fk_staff_creator_cycle foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_cycle foreign key(updated_by) references staffs(id)
);

create table faculties(
    id number generated always as identity primary key,
    code varchar2(50) not null,
    name varchar2(500) not null,
    description varchar2(500) not null,
    status number,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_status_faculty foreign key(status) references record_types(id),
    constraint fk_staff_creator_faculty foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_faculty foreign key(updated_by) references staffs(id)
);


create table staff_assignments(
    id number generated always as identity primary key,
    area_id number not null,
    staff_id number not null,
    is_main number(1) default 0,
    position number,
    status number,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_status_staff_assignment foreign key(status) references record_types(id),
    constraint fk_position foreign key(position) references record_types(id),
    constraint fk_staff_creator_staff_assignment foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_staff_assignment foreign key(updated_by) references staffs(id)
);

create table students(
    id number generated always as identity primary key,
    code varchar2(25) not null,
    person_id number not null,
    email varchar2(500) not null,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_staff_creator_student foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_student foreign key(updated_by) references staffs(id)
);

create table courses(
    id number generated always as identity primary key,
    name varchar2(500),
    description varchar2(500),
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_staff_creator_course foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_course foreign key(updated_by) references staffs(id)
);

create table course_assignments(
    id number generated always as identity primary key,
    period_id number not null,
    faculty_id number not null,
    cycle_id number not null,
    code varchar2(100) not null,
    course_id number not null,
    credits number default 0,
    prerequisites number,
    course_type number not null,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_period foreign key(period_id) references periods(id),
    constraint fk_faculty foreign key(faculty_id) references faculties(id),
    constraint fk_cycle foreign key(cycle_id) references cycles(id),
    constraint fk_course foreign key(course_id) references courses(id),
    constraint fk_course_type foreign key(course_type) references record_types(id),
    constraint fx_prerequisite foreign key(prerequisites) references course_assignments(id),
    constraint fk_staff_creator_course_assignment foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_course_assignment foreign key(updated_by) references staffs(id)
);

create table teachers_by_course_assignments(
    id number generated always as identity primary key,
    course_assignment_id number not null,
    teacher_id number not null,
    teacher_type number,
    created_at timestamp default current_timestamp,
    created_by number,
    updated_at timestamp,
    updated_by number,
    constraint fk_teacher_type foreign key(teacher_type) references record_types(id),
    constraint fk_course_assignment foreign key(course_assignment_id) references course_assignments(id),
    constraint fk_staff_creator_teacher_by_course_assignment foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_teacher_by_course_assignment foreign key(updated_by) references staffs(id)
);

-- evaluations
create table evaluations(
	id number generated always as identity primary key,
	course_id number not null,
    constraint fk_course_evaluation FOREIGN KEY (course_id)references courses(id),
	score numeric(5,2),
	obs varchar2(500),
	status number,
	created_at timestamp with time zone default current_timestamp,
	created_by number,
	updated_at timestamp with time zone,
    updated_by number,
    constraint fk_staff_creator_evaluation foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_evaluation foreign key(updated_by) references staffs(id)
);

-- enrollment
create table enrollments(
	id number generated always as identity primary key,
	student_id number not null,
    charge NUMBER (6,2)not null,
    status number,
    created_at timestamp with time zone default current_date,
    created_by number,
	updated_at timestamp with time zone,
    updated_by number,
    constraint fk_student_enrollment foreign key(student_id) references students(id),
    constraint fk_staff_creator_enrollment foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_enrollment foreign key(updated_by) references staffs(id)
);    
        
-- enrollment_details        
create table enrollment_details(
	id number generated always as identity primary key,
    enrollment_id number not null,
	course_assignment_id number not null,
    payment_per_course NUMBER (6,2) not null,
    created_at timestamp with time zone default current_date,
	created_by number,
	updated_at timestamp with time zone,
    updated_by number,
    constraint fk_enrollment_detail FOREIGN KEY (enrollment_id)references enrollments(id),
    constraint fk_course_assignment_enrollment_detail FOREIGN KEY (course_assignment_id)references course_assignments(id),
    constraint fk_staff_creator_enrollment_detail foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_enrollment_detail foreign key(updated_by) references staffs(id)
);

-- payments
create table payments(
	id number generated always as identity primary key,
    enrollment_id number not null,
    student_id number not null,
	charge NUMBER(6,2) not null,
    discharge NUMBER(6,2) not null,
    pending NUMBER(6,2) not null,
    payment_date DATE not null,
    ticket_code varchar2(250) not null,
    payment_method varchar2 (50), 
    created_at timestamp with time zone default current_date,
	created_by number,
	updated_at timestamp with time zone,
    updated_by number,
    constraint fk_enrollment_payment FOREIGN KEY (enrollment_id)references enrollments(id),
    constraint fk_student_payment FOREIGN KEY (student_id)references students(id),
    constraint fk_staff_creator_payment foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_payment foreign key(updated_by) references staffs(id)
);  

-- Tablas para el RETO:
-- 1. BIBLIOTECA
drop table books;
drop table book_stocks;
drop table loans;

CREATE TABLE books(
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR2(255) NOT NULL,
    author VARCHAR2(255) NOT NULL,
    publisher VARCHAR2(255),
    publication_year NUMBER(4),
    isbn VARCHAR2(20) UNIQUE,
    genre VARCHAR2(100),
    language VARCHAR2(50),
    pages NUMBER,
    edition VARCHAR2(50),
    format VARCHAR2(50),
    description CLOB,
    cover_url VARCHAR2(500),
    created_at timestamp with time zone default current_date,
	created_by number,
	updated_at timestamp with time zone,
    updated_by number,
    constraint fk_staff_register_book foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_book foreign key(updated_by) references staffs(id)
);

CREATE TABLE book_stocks(
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    book_id NUMBER NOT NULL,
    quantity NUMBER DEFAULT 0,
    available NUMBER DEFAULT 0,
    location VARCHAR2(100),
    status NUMBER,
    created_at timestamp with time zone default current_date,
	created_by number,
	updated_at timestamp with time zone,
    updated_by number,
    CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES books(id),
    CONSTRAINT fk_status_book FOREIGN KEY (status) REFERENCES record_types(id),
    constraint fk_staff_register_stock_book foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_stock_book foreign key(updated_by) references staffs(id)
);

CREATE TABLE loans(
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id NUMBER NOT NULL,
    book_id NUMBER NOT NULL,
    loan_date DATE DEFAULT SYSDATE,
    due_date DATE,
    return_date DATE,
    status NUMBER,
    CONSTRAINT fk_status_loan FOREIGN  KEY (status) REFERENCES record_types(id),
    CONSTRAINT fk_applicant_student FOREIGN KEY (student_id) REFERENCES students(id),
    CONSTRAINT fk_book_loaned FOREIGN KEY (book_id) REFERENCES books(id)
);


-- 2. INFRAESTRUCTURA
CREATE TABLE infraestructures (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    code VARCHAR2(20) UNIQUE NOT NULL,
    name VARCHAR2(100),
    capacity NUMBER,
    type NUMBER,
    location VARCHAR2(255),
    status NUMBER,
    created_at timestamp with time zone default current_date,
	created_by number,
	updated_at timestamp with time zone,
    updated_by number,
    CONSTRAINT fk_type_infraestructure FOREIGN KEY(type) REFERENCES record_types(id),
    CONSTRAINT fk_status_infraestructure FOREIGN KEY(status) REFERENCES record_types(id),
    constraint fk_staff_register_infraestructure foreign key(created_by) references staffs(id),
    constraint fx_staff_updater_infraestructure foreign key(updated_by) references staffs(id)
);

CREATE TABLE course_infraestructure_assignments (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    course_assigned_id NUMBER NOT NULL,
    infraestructure_id NUMBER NOT NULL,
    start_hour TIMESTAMP,
    finish_hour TIMESTAMP,
    start_date DATE,
    end_date DATE,
    CONSTRAINT fk_course_assigned FOREIGN KEY (course_assigned_id) REFERENCES courses_assigned(id),
    CONSTRAINT fk_infraestructure FOREIGN KEY (infraestructure_id) REFERENCES infraestructures(id)
);