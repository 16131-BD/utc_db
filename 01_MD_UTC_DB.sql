drop  table if exists evaluations;
drop  table if exists enrollments;
drop  table if exists enrollment_details;
drop  table if exists payments;

-- evaluations
create table evaluations(
	id number generated always as identity primary key,
	course_id number not null,
        constraint fk_course FOREIGN KEY (course_id)references courses(id),
	score numeric(5,2),
	obs varchar2(500),
	status number,
	created_at timestamp with time zone default current_date,
	created_by int references persons(id),
	updated_at timestamp with time zone
);

-- enrollment
create table enrollments(
	id number generated always as identity primary key,
	student_id number not null,
        constraint fk_student FOREIGN KEY (student_id)references students(id),
    charge NUMBER (6,2)not null,
    status number,
    created_at timestamp with time zone default current_date,
    created_by int references persons(id),
	updated_at timestamp with time zone
);    
        
-- enrollment_details        
create table enrollment_details(
	id number generated always as identity primary key,
    enrollment_id number not null,
        constraint fk_enrollment FOREIGN KEY (enrollment_id)references enrollments(id),
	course_assignment_id number not null,
        constraint fk_course_assignment FOREIGN KEY (course_assignment_id)references course_assignments(id),
    payment_per_course NUMBER (6,2) not null,
    created_at timestamp with time zone default current_date,
	created_by int references persons(id),
	updated_at timestamp with time zone
);    	

-- payments
create table payments(
	id number generated always as identity primary key,
    enrollment_id number not null,
        constraint fk_enrollment FOREIGN KEY (enrollment_id)references enrollments(id),
    student_id number not null,
        constraint fk_student FOREIGN KEY (student_id)references students(id),
	charge NUMBER (6,2) not null,
    discharge NUMBER (6,2) not null,
    pending NUMBER (6,2) not null,
    payment_date DATE not null,
    ticket_code STRING not null,
    payment_method varchar2 (50), 
    created_at timestamp with time zone default current_date,
	created_by int references persons(id),
	updated_at timestamp with time zone
);  