-- =====================================================
-- PART B: WINDOW FUNCTIONS IMPLEMENTATION
-- Category 3: NAVIGATION FUNCTIONS (LAG, LEAD)
-- =====================================================

-- =====================================================
-- NAVIGATION 1: LAG() - Semester-over-Semester Enrollment Growth
-- Business Purpose: Calculate enrollment growth comparing each semester to previous
-- Use Case: Track institutional growth trends
-- =====================================================
WITH semester_enrollments AS (
    SELECT 
        semester,
        year,
        semester || ' ' || year AS period,
        COUNT(DISTINCT student_id) AS student_count,
        COUNT(*) AS enrollment_count
    FROM enrollments
    GROUP BY semester, year
)
SELECT 
    period,
    student_count,
    enrollment_count,
    LAG(enrollment_count, 1) OVER (
        ORDER BY year, semester
    ) AS previous_semester_enrollments,
    enrollment_count - LAG(enrollment_count, 1) OVER (
        ORDER BY year, semester
    ) AS enrollment_change,
    ROUND(
        (enrollment_count - LAG(enrollment_count, 1) OVER (
            ORDER BY year, semester
        )) * 100.0 / NULLIF(LAG(enrollment_count, 1) OVER (
            ORDER BY year, semester
        ), 0), 
        2
    ) AS pct_growth
FROM semester_enrollments
ORDER BY year, semester;

-- Uses LAG() to compare each semester's enrollments with the previous one.


-- =====================================================
-- NAVIGATION 2: LEAD() - Anticipate Next Semester Trends
-- Business Purpose: Compare current performance to next semester
-- Use Case: Early warning system for enrollment changes
-- =====================================================
WITH semester_revenue AS (
    SELECT 
        semester,
        year,
        semester || ' ' || year AS period,
        COUNT(*) AS enrollments,
        SUM(c.fee) AS revenue
    FROM enrollments e
    INNER JOIN courses c ON e.course_id = c.course_id
    GROUP BY semester, year
)
SELECT 
    period,
    enrollments,
    revenue,
    LEAD(enrollments, 1) OVER (
        ORDER BY year, semester
    ) AS next_semester_enrollments,
    LEAD(revenue, 1) OVER (
        ORDER BY year, semester
    ) AS next_semester_revenue,
    CASE 
        WHEN LEAD(enrollments, 1) OVER (
            ORDER BY year, semester
        ) > enrollments THEN 'Growing'
        WHEN LEAD(enrollments, 1) OVER (
            ORDER BY year, semester
        ) < enrollments THEN 'Declining'
        ELSE 'Stable'
    END AS trend
FROM semester_revenue
ORDER BY year, semester;

-- Uses LEAD() to anticipate the next semester's performance.


-- =====================================================
-- NAVIGATION 3: LAG() - Student Grade Improvement Tracking
-- Business Purpose: Track student performance changes over time
-- Use Case: Identify improving or declining students
-- =====================================================
WITH student_grades_timeline AS (
    SELECT 
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        e.semester,
        e.year,
        e.semester || ' ' || e.year AS period,
        ROUND(AVG(e.grade), 2) AS semester_gpa
    FROM students s
    INNER JOIN enrollments e ON s.student_id = e.student_id
    WHERE e.grade IS NOT NULL
    GROUP BY s.student_id, s.first_name, s.last_name, e.semester, e.year
)
SELECT 
    student_id,
    student_name,
    period,
    semester_gpa,
    LAG(semester_gpa, 1) OVER (
        PARTITION BY student_id 
        ORDER BY year, semester
    ) AS previous_semester_gpa,
    ROUND(
        semester_gpa - LAG(semester_gpa, 1) OVER (
            PARTITION BY student_id 
            ORDER BY year, semester
        ), 
        2
    ) AS gpa_change
FROM student_grades_timeline
ORDER BY student_id, year, semester;

-- Tracks each student's semester-to-semester GPA changes.


-- =====================================================
-- NAVIGATION 4: LEAD() - Course Popularity Trends
-- Business Purpose: Analyze course enrollment trends
-- Use Case: Plan course capacity increases/decreases
-- =====================================================
WITH course_semester_stats AS (
    SELECT 
        c.course_code,
        c.course_name,
        e.semester,
        e.year,
        e.semester || ' ' || e.year AS period,
        COUNT(e.enrollment_id) AS enrollments
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_code, c.course_name, e.semester, e.year
    HAVING COUNT(e.enrollment_id) > 0
)
SELECT 
    course_code,
    course_name,
    period,
    enrollments AS current_enrollments,
    LAG(enrollments, 1) OVER (
        PARTITION BY course_code 
        ORDER BY year, semester
    ) AS previous_semester,
    LEAD(enrollments, 1) OVER (
        PARTITION BY course_code 
        ORDER BY year, semester
    ) AS next_semester,
    ROUND(
        (enrollments - LAG(enrollments, 1) OVER (
            PARTITION BY course_code 
            ORDER BY year, semester
        )) * 100.0 / NULLIF(LAG(enrollments, 1) OVER (
            PARTITION BY course_code 
            ORDER BY year, semester
        ), 0), 
        2
    ) AS growth_rate_pct
FROM course_semester_stats
ORDER BY course_code, year, semester;

-- Shows how enrollment changes for each course over time.


-- =====================================================
-- NAVIGATION 5: Multi-Period LAG - Year-over-Year Comparison
-- Business Purpose: Compare same semester across different years
-- Use Case: Identify long-term growth patterns
-- =====================================================
WITH semester_metrics AS (
    SELECT 
        semester,
        year,
        COUNT(DISTINCT student_id) AS unique_students,
        COUNT(*) AS total_enrollments,
        ROUND(AVG(grade), 2) AS avg_grade
    FROM enrollments
    WHERE grade IS NOT NULL
    GROUP BY semester, year
)
SELECT 
    semester,
    year,
    unique_students,
    total_enrollments,
    avg_grade,
    LAG(total_enrollments, 2) OVER (
        PARTITION BY semester 
        ORDER BY year
    ) AS same_semester_last_year,
    ROUND(
        (total_enrollments - LAG(total_enrollments, 2) OVER (
            PARTITION BY semester 
            ORDER BY year
        )) * 100.0 / NULLIF(LAG(total_enrollments, 2) OVER (
            PARTITION BY semester 
            ORDER BY year
        ), 0), 
        2
    ) AS yoy_growth_pct
FROM semester_metrics
ORDER BY semester, year;

-- Compares same semester across different years to find growth patterns.

-- =====================================================
-- END OF CATEGORY 3: NAVIGATION FUNCTIONS
-- =====================================================

