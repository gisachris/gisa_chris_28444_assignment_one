-- =====================================================
-- PART C: WINDOW FUNCTIONS IMPLEMENTATION
-- Category 2: AGGREGATE WINDOW FUNCTIONS
-- =====================================================

-- =====================================================
-- AGGREGATE 1: SUM() OVER() - Running Total Revenue
-- =====================================================
WITH semester_revenue AS (
    SELECT 
        e.semester,
        e.academic_year,
        e.semester || ' ' || e.academic_year AS period,
        SUM(c.fee) AS semester_revenue
    FROM enrollments e
    INNER JOIN courses c ON e.course_id = c.course_id
    GROUP BY e.semester, e.academic_year
)
SELECT 
    period,
    semester_revenue,
    SUM(semester_revenue) OVER (
        ORDER BY academic_year, semester
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue,
    ROUND(
        semester_revenue * 100.0 / SUM(semester_revenue) OVER (), 
        2
    ) AS pct_of_total_revenue
FROM semester_revenue
ORDER BY academic_year, semester;


-- =====================================================
-- AGGREGATE 2: AVG() OVER() - 3-Semester Moving Average
-- =====================================================
WITH semester_stats AS (
    SELECT 
        semester,
        academic_year,
        semester || ' ' || academic_year AS period,
        COUNT(DISTINCT student_id) AS unique_students,
        COUNT(*) AS total_enrollments
    FROM enrollments
    GROUP BY semester, academic_year
)
SELECT 
    period,
    unique_students,
    total_enrollments,
    ROUND(
        AVG(total_enrollments) OVER (
            ORDER BY academic_year, semester
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS three_semester_moving_avg,
    ROUND(
        total_enrollments - AVG(total_enrollments) OVER (
            ORDER BY academic_year, semester
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS deviation_from_avg
FROM semester_stats
ORDER BY academic_year, semester;


-- =====================================================
-- AGGREGATE 3: MAX() and MIN() OVER() with RANGE
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    e.grade AS student_grade,
    ROUND(AVG(e.grade) OVER (PARTITION BY e.course_id), 2) AS course_avg,
    MAX(e.grade) OVER (PARTITION BY e.course_id) AS course_max,
    MIN(e.grade) OVER (PARTITION BY e.course_id) AS course_min,
    ROUND(e.grade - AVG(e.grade) OVER (PARTITION BY e.course_id), 2) AS deviation_from_avg,
    CASE 
        WHEN e.grade >= AVG(e.grade) OVER (PARTITION BY e.course_id) + 10 THEN 'Outstanding'
        WHEN e.grade >= AVG(e.grade) OVER (PARTITION BY e.course_id) THEN 'Above Average'
        WHEN e.grade >= AVG(e.grade) OVER (PARTITION BY e.course_id) - 10 THEN 'Below Average'
        ELSE 'Needs Support'
    END AS performance_category
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL 
    AND e.academic_year = 2025
ORDER BY c.course_code, e.grade DESC;


-- =====================================================
-- AGGREGATE 4: COUNT() OVER() - Student Engagement
-- =====================================================
WITH student_engagement AS (
    SELECT 
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        s.region,
        s.program,
        COUNT(e.enrollment_id) AS courses_enrolled,
        ROUND(AVG(e.grade), 2) AS avg_grade
    FROM students s
    LEFT JOIN enrollments e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.region, s.program
)
SELECT 
    student_id,
    student_name,
    region,
    program,
    courses_enrolled,
    avg_grade,
    AVG(courses_enrolled) OVER () AS institution_avg_courses,
    ROUND(
        (courses_enrolled - AVG(courses_enrolled) OVER ()) * 100.0 /
        NULLIF(AVG(courses_enrolled) OVER (), 0),
        2
    ) AS pct_deviation_from_avg,
    CASE 
        WHEN courses_enrolled = 0 THEN 'Inactive - No Enrollments'
        WHEN courses_enrolled >= AVG(courses_enrolled) OVER () * 1.5 THEN 'Highly Engaged'
        WHEN courses_enrolled >= AVG(courses_enrolled) OVER () THEN 'Active'
        ELSE 'Low Engagement'
    END AS engagement_level
FROM student_engagement
ORDER BY courses_enrolled DESC, avg_grade DESC;


-- =====================================================
-- AGGREGATE 5: Combined Aggregates - Department Dashboard
-- =====================================================
WITH dept_metrics AS (
    SELECT 
        c.department,
        COUNT(DISTINCT e.student_id) AS unique_students,
        COUNT(e.enrollment_id) AS total_enrollments,
        ROUND(AVG(c.fee), 2) AS avg_course_fee,
        SUM(c.fee) AS total_revenue,
        ROUND(AVG(e.grade), 2) AS dept_avg_grade
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    WHERE e.grade IS NOT NULL
    GROUP BY c.department
)
SELECT 
    department,
    unique_students,
    total_enrollments,
    avg_course_fee,
    total_revenue,
    dept_avg_grade,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS pct_of_total_revenue,
    ROUND(total_enrollments * 100.0 / SUM(total_enrollments) OVER (), 2) AS pct_of_total_enrollments,
    ROUND(dept_avg_grade - AVG(dept_avg_grade) OVER (), 2) AS grade_deviation_from_avg,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY dept_avg_grade DESC) AS academic_rank
FROM dept_metrics
ORDER BY total_revenue DESC;

-- =====================================================
-- END OF CATEGORY 2: AGGREGATE WINDOW FUNCTIONS
-- =====================================================
