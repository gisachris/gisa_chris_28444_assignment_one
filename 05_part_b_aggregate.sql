-- =====================================================
-- PART B: WINDOW FUNCTIONS IMPLEMENTATION
-- Category 2: AGGREGATE WINDOW FUNCTIONS
-- =====================================================

-- =====================================================
-- AGGREGATE 1: SUM() OVER() - Running Total
-- Business Purpose: Calculate cumulative enrollment revenue by semester
-- Use Case: Track semester-by-semester revenue growth for financial planning
-- Frame: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- =====================================================
WITH semester_revenue AS (
    SELECT DISTINCT
        e.semester,
        e.year,
        e.semester || ' ' || e.year AS period,
        SUM(c.fee) AS semester_revenue
    FROM enrollments e
    INNER JOIN courses c ON e.course_id = c.course_id
    GROUP BY e.semester, e.year
)
SELECT 
    period,
    semester_revenue,
    SUM(semester_revenue) OVER (
        ORDER BY year, semester
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue,
    ROUND(
        semester_revenue * 100.0 / SUM(semester_revenue) OVER (), 
        2
    ) AS pct_of_total_revenue
FROM semester_revenue
ORDER BY year, semester;

-- Calculates running total revenue across semesters using a ROWS frame.


-- =====================================================
-- AGGREGATE 2: AVG() OVER() - Moving Average
-- Business Purpose: Calculate 3-semester moving average of enrollments
-- Use Case: Smooth enrollment trends to identify growth patterns
-- Frame: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
-- =====================================================
WITH semester_stats AS (
    SELECT 
        semester,
        year,
        semester || ' ' || year AS period,
        COUNT(DISTINCT student_id) AS unique_students,
        COUNT(*) AS total_enrollments
    FROM enrollments
    GROUP BY semester, year
)
SELECT 
    period,
    unique_students,
    total_enrollments,
    ROUND(
        AVG(total_enrollments) OVER (
            ORDER BY year, semester
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS three_semester_moving_avg,
    ROUND(
        total_enrollments - AVG(total_enrollments) OVER (
            ORDER BY year, semester
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS deviation_from_avg
FROM semester_stats
ORDER BY year, semester;

-- Moving average helps identify enrollment trends smoothly.
-- Using ROWS frame looks at exactly 3 data points (current + 2 preceding semesters).
-- Positive deviations indicate growing enrollment; negative suggests declining interest.


-- =====================================================
-- AGGREGATE 3: MAX() and MIN() OVER() with RANGE
-- Business Purpose: Compare student grades to cohort performance bounds
-- Use Case: Identify students significantly above/below peer performance
-- Frame: RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- =====================================================
SELECT 
    s.student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    e.grade AS student_grade,
    ROUND(AVG(e.grade) OVER (PARTITION BY e.course_id), 2) AS course_avg,
    MAX(e.grade) OVER (
        PARTITION BY e.course_id 
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS course_max,
    MIN(e.grade) OVER (
        PARTITION BY e.course_id 
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS course_min,
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
    AND e.year = 2025
ORDER BY c.course_code, e.grade DESC;

-- INTERPRETATION:
-- RANGE frame considers all rows with the same value (partition) for comparison.
-- This identifies outlier students performing significantly above/below course averages.
-- Students with +10 deviation are "Outstanding"; below -10 need academic intervention.


-- =====================================================
-- AGGREGATE 4: COUNT() OVER() - Student Engagement Level
-- Business Purpose: Count courses taken per student with percentile comparison
-- Use Case: Identify highly engaged vs. minimally engaged students
-- Frame: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
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
    AVG(courses_enrolled) OVER (
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS institution_avg_courses,
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

-- INTERPRETATION:
-- ROWS frame with UNBOUNDED calculates overall institution averages across all students.
-- Identifies students taking 50%+ more courses than average as "Highly Engaged".
-- Students with zero enrollments flagged as "Inactive" for retention interventions.


-- =====================================================
-- AGGREGATE 5: Combined Aggregates - Department Financial Analysis
-- Business Purpose: Multi-metric department performance dashboard
-- Use Case: Compare departments by revenue, enrollments, and efficiency
-- Frame: Multiple frames for comprehensive analysis
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
    ROUND(
        total_revenue * 100.0 / SUM(total_revenue) OVER (), 
        2
    ) AS pct_of_total_revenue,
    ROUND(
        total_enrollments * 100.0 / SUM(total_enrollments) OVER (), 
        2
    ) AS pct_of_total_enrollments,
    ROUND(
        dept_avg_grade - AVG(dept_avg_grade) OVER (), 
        2
    ) AS grade_deviation_from_avg,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY dept_avg_grade DESC) AS academic_rank
FROM dept_metrics
ORDER BY total_revenue DESC;

-- INTERPRETATION:
-- Comprehensive department comparison using multiple aggregate window functions.
-- Computer Science leads in revenue (29.8%) and enrollments (30.3%) but not grades.
-- Data Science shows highest academic performance despite lower enrollment share.

-- =====================================================
-- END OF CATEGORY 2: AGGREGATE WINDOW FUNCTIONS
-- =====================================================
