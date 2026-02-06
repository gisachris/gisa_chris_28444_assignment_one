-- =====================================================
-- PART B: WINDOW FUNCTIONS IMPLEMENTATION
-- Category 1: RANKING FUNCTIONS
-- =====================================================

-- =====================================================
-- RANKING 1: ROW_NUMBER()
-- Business Purpose: Assign unique sequential numbers to student enrollments per semester
-- Use Case: Track enrollment sequence for registration priority analysis
-- =====================================================
SELECT 
    student_id,
    course_id,
    enrollment_date,
    semester || ' ' || year AS semester_period,
    ROW_NUMBER() OVER (
        PARTITION BY semester, year 
        ORDER BY enrollment_date, enrollment_id
    ) AS enrollment_sequence_number
FROM enrollments
WHERE year = 2025
ORDER BY semester, enrollment_sequence_number;

-- Assigns unique sequence numbers by registration order within each semester.


-- =====================================================
-- RANKING 2: RANK()
-- Business Purpose: Rank students by GPA within their region
-- Use Case: Identify top performers per region for regional scholarships
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
GROUP BY s.student_id, s.first_name, s.last_name, s.region, s.program
ORDER BY s.region, regional_rank;

-- Ranks students by GPA within their home region.


-- =====================================================
-- RANKING 3: DENSE_RANK()
-- Business Purpose: Rank courses by total enrollment without rank gaps
-- Use Case: Identify most popular courses for capacity planning
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
GROUP BY c.course_id, c.course_code, c.course_name, c.department
ORDER BY popularity_rank, c.course_code;

-- Ranks courses by enrollment without rank gaps for capacity planning.


-- =====================================================
-- RANKING 4: PERCENT_RANK()
-- Business Purpose: Calculate percentile ranking of student performance
-- Use Case: Identify top percentile students for honors programs
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
        WHEN PERCENT_RANK() OVER (ORDER BY AVG(e.grade) DESC) <= 0.10 THEN 'Top 10% - Honors'
        WHEN PERCENT_RANK() OVER (ORDER BY AVG(e.grade) DESC) <= 0.25 THEN 'Top 25% - Dean''s List'
        WHEN PERCENT_RANK() OVER (ORDER BY AVG(e.grade) DESC) <= 0.50 THEN 'Top 50% - Good Standing'
        ELSE 'Bottom 50% - Academic Support Needed'
    END AS academic_standing
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade IS NOT NULL
GROUP BY s.student_id, s.first_name, s.last_name, s.program
ORDER BY percentile_rank;

-- INTERPRETATION:
-- PERCENT_RANK calculates relative position (0-1 scale) of each student's GPA.
-- This enables percentile-based recognition (top 10% for honors, top 25% for Dean's List)
-- and helps identify students needing academic support in the bottom 50%.


-- =====================================================
-- RANKING 5: Combined Ranking - Top 5 Students per Department
-- Business Purpose: Identify top performers in each academic department
-- Use Case: Department-specific awards and recognition
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
    GROUP BY s.student_id, s.first_name, s.last_name, c.department
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

-- INTERPRETATION:
-- This identifies the top 5 students in each department based on average grades
-- and course completion count. Useful for department-specific scholarships,
-- teaching assistant selection, and recognizing academic excellence by discipline.

-- =====================================================
-- END OF CATEGORY 1: RANKING FUNCTIONS
-- =====================================================
