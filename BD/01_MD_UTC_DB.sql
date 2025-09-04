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
    constraint fk_faculty foreign key(faculty_id) references periods(id),
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