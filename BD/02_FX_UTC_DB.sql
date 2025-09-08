--Consultar los nombres de los estudiantes que pertenecen a una carrera específica

SELECT  s.code AS student_code,
        p.names || ' ' || p.father_last_name || ' ' || p.mother_last_name AS full_name,
        f.name AS faculty
FROM    students s
        JOIN persons p  
            ON s.person_id = p.id
        JOIN enrollments e
            ON e.student_id = s.id
        JOIN enrollment_details ed
            ON ed.enrollment_id = e.id
        JOIN course_assignments ca
            ON ca.id = ed.course_assignment_id
        JOIN faculties f
            ON f.id = ca.faculty_id
WHERE   f.name = 'Ingeniería de Sistemas';

--Listar los cursos con sus prerrequisitos
SELECT  c1.name AS course,
        c2.name AS prerequisite
FROM    course_assignments ca
        JOIN courses c1
            ON c1.id = ca.course_id
        LEFT JOIN course_assignments pre
            ON ca.prerequisites = pre.id
        LEFT JOIN courses c2
            ON c2.id = pre.course_id
ORDER   BY c1.name;

--Obtener los estudiantes matriculados en un curso en un ciclo determinado
SELECT  DISTINCT s.code AS student_code,
        p.names || ' ' || p.father_last_name || ' ' || p.mother_last_name AS full_name,
        c.name AS course,
        cy.name AS cycle
FROM    students s
        JOIN persons p
            ON p.id = s.person_id
        JOIN enrollments e
            ON e.student_id = s.id
        JOIN enrollment_details ed
            ON ed.enrollment_id = e.id
        JOIN course_assignments ca
            ON ca.id = ed.course_assignment_id
        JOIN courses c
            ON c.id = ca.course_id
        JOIN cycles cy
            ON cy.id = ca.cycle_id
WHERE   c.name = 'Base de Datos'
        AND cy.name = '2025-I';

--Calcular el promedio de notas de un estudiante en todos sus cursos
SELECT  s.code AS student_code,
        p.names || ' ' || p.father_last_name || ' ' || p.mother_last_name AS full_name,
       ROUND(AVG(eva.score), 2) AS average_score
FROM    students s
        JOIN persons p
            ON p.id = s.person_id
        JOIN enrollments en
            ON en.student_id = s.id
        JOIN enrollment_details ed
            ON ed.enrollment_id = en.id
        JOIN course_assignments ca
            ON ca.id = ed.course_assignment_id
        JOIN courses c
            ON c.id = ca.course_id
        JOIN evaluations eva
            ON eva.course_id = c.id
WHERE   s.code = 'STU001'
GROUP   BY s.code, p.names, p.father_last_name, p.mother_last_name;

--Identificar a los docentes que dictan más de un curso en un ciclo
SELECT  st.code AS teacher_code,
        p.names || ' ' || p.father_last_name || ' ' || p.mother_last_name AS teacher_name,
        cy.name AS cycle,
        COUNT(DISTINCT ca.course_id) AS total_courses
FROM    teachers_by_course_assignments tca
        JOIN staffs st
            ON st.id = tca.teacher_id
        JOIN persons p
            ON p.id = st.person_id
        JOIN course_assignments ca
            ON ca.id = tca.course_assignment_id
        JOIN cycles cy
            ON cy.id = ca.cycle_id
GROUP   BY st.code, p.names, p.father_last_name, p.mother_last_name, cy.name
HAVING  COUNT(DISTINCT ca.course_id) > 1
ORDER   BY total_courses DESC;