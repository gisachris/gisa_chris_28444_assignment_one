-- =====================================================
-- PART A: SQL JOINS IMPLEMENTATION
-- All 5 required JOIN types with business interpretations
-- =====================================================

-- =====================================================
-- JOIN 1: INNER JOIN
-- Business Purpose: Retrieve all active enrollments with student and course details
-- Use Case: Generate current semester course rosters
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.region,
    c.course_code,
    c.course_name,
    c.department,
    e.semester,
    e.year,
    e.grade,
    e.status
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE e.semester = 'Semester 2' AND e.year = 2025
ORDER BY s.last_name, c.course_code;

-- Shows all currently enrolled students in this semester.


-- =====================================================
-- JOIN 2: LEFT JOIN (LEFT OUTER JOIN)
-- Business Purpose: Identify students who have NOT enrolled in any courses
-- Use Case: Find at-risk students needing academic advising
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.email,
    s.region,
    s.enrollment_date AS registration_date,
    s.program,
    COUNT(e.enrollment_id) AS total_enrollments,
    CASE 
        WHEN COUNT(e.enrollment_id) = 0 THEN 'NO ENROLLMENTS - NEEDS ADVISING'
        ELSE 'Active Student'
    END AS student_status
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name, s.email, s.region, s.enrollment_date, s.program
HAVING COUNT(e.enrollment_id) = 0
ORDER BY s.enrollment_date DESC;

-- Identifies students who registered but never took any courses.


-- =====================================================
-- JOIN 3: RIGHT JOIN (RIGHT OUTER JOIN)
-- Business Purpose: Find courses with NO student enrollments
-- Use Case: Identify underutilized courses for curriculum review
-- =====================================================
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.department,
    c.credits,
    c.fee,
    COUNT(e.enrollment_id) AS total_enrollments,
    CASE 
        WHEN COUNT(e.enrollment_id) = 0 THEN 'NO ENROLLMENTS - REVIEW NEEDED'
        ELSE 'Active Course'
    END AS course_status
FROM enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_code, c.course_name, c.department, c.credits, c.fee
HAVING COUNT(e.enrollment_id) = 0
ORDER BY c.department, c.course_code;

-- Shows courses with no enrolled students, useful for curriculum review.


-- =====================================================
-- JOIN 4: FULL OUTER JOIN
-- Business Purpose: Complete view of students AND courses including unmatched records
-- Use Case: Comprehensive institutional planning and gap analysis
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.region,
    c.course_id,
    c.course_code,
    c.course_name,
    c.department,
    e.enrollment_id,
    CASE 
        WHEN e.enrollment_id IS NULL AND s.student_id IS NOT NULL THEN 'Student with no enrollments'
        WHEN e.enrollment_id IS NULL AND c.course_id IS NOT NULL THEN 'Course with no students'
        ELSE 'Active enrollment'
    END AS record_type
FROM students s
FULL OUTER JOIN enrollments e ON s.student_id = e.student_id
FULL OUTER JOIN courses c ON e.course_id = c.course_id
WHERE e.enrollment_id IS NULL
ORDER BY record_type, s.student_id, c.course_id;

-- Shows which students and courses are missing from enrollments.


-- =====================================================
-- JOIN 5: SELF JOIN
-- Business Purpose: Find students from the SAME REGION enrolled in the SAME COURSE
-- Use Case: Create study groups based on geographic proximity
-- =====================================================
SELECT DISTINCT
    s1.student_id AS student1_id,
    s1.first_name || ' ' || s1.last_name AS student1_name,
    s2.student_id AS student2_id,
    s2.first_name || ' ' || s2.last_name AS student2_name,
    s1.region AS shared_region,
    c.course_code,
    c.course_name,
    e1.semester || ' ' || e1.year AS semester_period
FROM enrollments e1
INNER JOIN enrollments e2 ON e1.course_id = e2.course_id 
    AND e1.semester = e2.semester 
    AND e1.year = e2.year
    AND e1.student_id < e2.student_id  -- Avoid duplicate pairs and self-comparison
INNER JOIN students s1 ON e1.student_id = s1.student_id
INNER JOIN students s2 ON e2.student_id = s2.student_id
INNER JOIN courses c ON e1.course_id = c.course_id
WHERE s1.region = s2.region  -- Same region
    AND e1.semester = 'Semester 2' 
    AND e1.year = 2025
ORDER BY s1.region, c.course_code, s1.last_name;

-- Groups students from the same region for study collaborations.


-- =====================================================
-- ALTERNATIVE SELF JOIN: Students who improved grades
-- Business Purpose: Track student academic progress over time
-- Use Case: Identify improving students for recognition/scholarships
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_name,
    e1.semester || ' ' || e1.year AS earlier_semester,
    e1.grade AS earlier_grade,
    e2.semester || ' ' || e2.year AS later_semester,
    e2.grade AS later_grade,
    ROUND(e2.grade - e1.grade, 2) AS grade_improvement
FROM enrollments e1
INNER JOIN enrollments e2 ON e1.student_id = e2.student_id 
    AND e1.course_id = e2.course_id
    AND e1.enrollment_date < e2.enrollment_date
INNER JOIN students s ON e1.student_id = s.student_id
INNER JOIN courses c ON e1.course_id = c.course_id
WHERE e1.grade IS NOT NULL 
    AND e2.grade IS NOT NULL
    AND e2.grade > e1.grade
ORDER BY grade_improvement DESC;

-- Identifies students who improved grades when retaking courses.

-- =====================================================
-- END OF PART A: SQL JOINS
-- =====================================================
