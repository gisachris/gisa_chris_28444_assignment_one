-- =====================================================
-- PART B: WINDOW FUNCTIONS IMPLEMENTATION
-- Category 1: RANKING FUNCTIONS
-- =====================================================

-- =====================================================
-- RANKING 1: ROW_NUMBER()
-- Assign unique enrollment sequence per semester
-- =====================================================
SELECT 
    student_id,
    course_id,
    enrollment_date,
    semester || ' ' || academic_year AS semester_period,
    ROW_NUMBER() OVER (
        PARTITION BY semester, academic_year
        ORDER BY enrollment_date, enrollment_id
    ) AS enrollment_sequence_number
FROM enrollments
WHERE academic_year = 2025
ORDER BY semester, enrollment_sequence_number;


-- =====================================================
-- RANKING 2: RANK()
-- Rank students by GPA within each region
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.region,
    s.program,
    ROUND(AVG(e.grade), 2) AS gpa,
    RANK() OVER (
        PARTITION BY s.region
        ORDER BY AVG(e.grade) DESC
    ) AS regional_rank
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade IS NOT NULL
GROUP BY 
    s.student_id, s.first_name, s.last_name, 
    s.region, s.program
ORDER BY s.region, regional_rank;


-- =====================================================
-- RANKING 3: DENSE_RANK()
-- Rank courses by total enrollment (no gaps)
-- =====================================================
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.department,
    COUNT(e.enrollment_id) AS total_enrollments,
    DENSE_RANK() OVER (
        ORDER BY COUNT(e.enrollment_id) DESC
    ) AS popularity_rank
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY 
    c.course_id, c.course_code, 
    c.course_name, c.department
ORDER BY popularity_rank, c.course_code;


-- =====================================================
-- RANKING 4: PERCENT_RANK()
-- Percentile ranking of students by GPA
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    s.program,
    ROUND(AVG(e.grade), 2) AS gpa,
    ROUND(
        PERCENT_RANK() OVER (ORDER BY AVG(e.grade) DESC) * 100,
        2
    ) AS percentile_rank,
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY AVG(e.grade) DESC) <= 0.10
            THEN 'Top 10% - Honors'
        WHEN PERCENT_RANK() OVER (ORDER BY AVG(e.grade) DESC) <= 0.25
            THEN 'Top 25% - Dean''s List'
        WHEN PERCENT_RANK() OVER (ORDER BY AVG(e.grade) DESC) <= 0.50
            THEN 'Top 50% - Good Standing'
        ELSE 'Bottom 50% - Academic Support Needed'
    END AS academic_standing
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade IS NOT NULL
GROUP BY 
    s.student_id, s.first_name, s.last_name, s.program
ORDER BY percentile_rank;


-- =====================================================
-- RANKING 5: Top 5 Students per Department
-- =====================================================
WITH student_performance AS (
    SELECT 
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        c.department,
        ROUND(AVG(e.grade), 2) AS avg_grade,
        COUNT(e.enrollment_id) AS courses_taken,
        ROW_NUMBER() OVER (
            PARTITION BY c.department
            ORDER BY AVG(e.grade) DESC, COUNT(e.enrollment_id) DESC
        ) AS dept_rank
    FROM students s
    INNER JOIN enrollments e ON s.student_id = e.student_id
    INNER JOIN courses c ON e.course_id = c.course_id
    WHERE e.grade IS NOT NULL
    GROUP BY 
        s.student_id, s.first_name, s.last_name, c.department
)
SELECT 
    department,
    student_id,
    student_name,
    avg_grade,
    courses_taken,
    dept_rank
FROM student_performance
WHERE dept_rank <= 5
ORDER BY department, dept_rank;

-- =====================================================
-- END OF PART B: WINDOW FUNCTIONS
-- =====================================================