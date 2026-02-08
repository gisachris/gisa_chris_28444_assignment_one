-- =====================================================
-- PART A: SQL JOINS IMPLEMENTATION
-- Demonstrates INNER, LEFT, RIGHT, FULL, and SELF JOINs
-- =====================================================

-- =====================================================
-- JOIN 1: INNER JOIN
-- Active enrollments for a specific semester
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.region,
    c.course_code,
    c.course_name,
    c.department,
    e.semester,
    e.academic_year,
    e.grade,
    e.status
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE e.semester = 'Semester 2'
  AND e.academic_year = 2025
ORDER BY s.last_name, c.course_code;


-- =====================================================
-- JOIN 2: LEFT JOIN
-- Students with NO enrollments
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email,
    s.region,
    s.enrollment_date AS registration_date,
    s.program,
    COUNT(e.enrollment_id) AS total_enrollments,
    'NO ENROLLMENTS - NEEDS ADVISING' AS student_status
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY 
    s.student_id, s.first_name, s.last_name,
    s.email, s.region, s.enrollment_date, s.program
HAVING COUNT(e.enrollment_id) = 0
ORDER BY s.enrollment_date DESC;


-- =====================================================
-- JOIN 3: RIGHT JOIN
-- Courses with NO student enrollments
-- =====================================================
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.department,
    c.credits,
    c.fee,
    COUNT(e.enrollment_id) AS total_enrollments,
    'NO ENROLLMENTS - REVIEW NEEDED' AS course_status
FROM enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
GROUP BY 
    c.course_id, c.course_code, c.course_name,
    c.department, c.credits, c.fee
HAVING COUNT(e.enrollment_id) = 0
ORDER BY c.department, c.course_code;


-- =====================================================
-- JOIN 4: FULL OUTER JOIN
-- Students OR courses missing from enrollments
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_id,
    c.course_code,
    c.course_name,
    e.enrollment_id,
    CASE
        WHEN s.student_id IS NOT NULL AND e.enrollment_id IS NULL
            THEN 'Student with no enrollments'
        WHEN c.course_id IS NOT NULL AND e.enrollment_id IS NULL
            THEN 'Course with no students'
    END AS record_type
FROM students s
FULL OUTER JOIN enrollments e
    ON s.student_id = e.student_id
FULL OUTER JOIN courses c
    ON e.course_id = c.course_id
WHERE e.enrollment_id IS NULL
ORDER BY record_type, s.student_id, c.course_id;


-- =====================================================
-- JOIN 5: SELF JOIN
-- Students from SAME region enrolled in SAME course
-- =====================================================
SELECT *
FROM (
    SELECT DISTINCT
        s1.student_id AS student1_id,
        s1.first_name || ' ' || s1.last_name AS student1_name,
        s2.student_id AS student2_id,
        s2.first_name || ' ' || s2.last_name AS student2_name,
        s1.region AS shared_region,
        c.course_code,
        c.course_name,
        e1.semester || ' ' || e1.academic_year AS semester_period,
        s1.last_name AS sort_last_name
    FROM enrollments e1
    INNER JOIN enrollments e2
        ON e1.course_id = e2.course_id
       AND e1.semester = e2.semester
       AND e1.academic_year = e2.academic_year
       AND e1.student_id < e2.student_id
    INNER JOIN students s1 ON e1.student_id = s1.student_id
    INNER JOIN students s2 ON e2.student_id = s2.student_id
    INNER JOIN courses c ON e1.course_id = c.course_id
    WHERE s1.region = s2.region
      AND e1.semester = 'Semester 2'
      AND e1.academic_year = 2025
)
ORDER BY shared_region, course_code, sort_last_name;


-- =====================================================
-- ALTERNATIVE SELF JOIN
-- Students who improved grades over time
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    e1.semester || ' ' || e1.academic_year AS earlier_semester,
    e1.grade AS earlier_grade,
    e2.semester || ' ' || e2.academic_year AS later_semester,
    e2.grade AS later_grade,
    ROUND(e2.grade - e1.grade, 2) AS grade_improvement
FROM enrollments e1
INNER JOIN enrollments e2
    ON e1.student_id = e2.student_id
   AND e1.course_id = e2.course_id
   AND e1.enrollment_date < e2.enrollment_date
INNER JOIN students s ON e1.student_id = s.student_id
INNER JOIN courses c ON e1.course_id = c.course_id
WHERE e1.grade IS NOT NULL
  AND e2.grade IS NOT NULL
  AND e2.grade > e1.grade
ORDER BY grade_improvement DESC;

-- =====================================================
-- END OF SCRIPT 03
-- =====================================================
