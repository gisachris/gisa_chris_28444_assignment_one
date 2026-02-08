-- =====================================================
-- PART B: WINDOW FUNCTIONS IMPLEMENTATION
-- Category 4: DISTRIBUTION FUNCTIONS (NTILE, CUME_DIST)
-- =====================================================

-- =====================================================
-- DISTRIBUTION 1: NTILE(4) - Student Performance Quartiles
-- =====================================================
WITH student_performance AS (
    SELECT 
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        s.region,
        s.program,
        COUNT(e.enrollment_id) AS courses_taken,
        ROUND(AVG(e.grade), 2) AS gpa
    FROM students s
    INNER JOIN enrollments e ON s.student_id = e.student_id
    WHERE e.grade IS NOT NULL
    GROUP BY s.student_id, s.first_name, s.last_name, s.region, s.program
)
SELECT 
    student_id,
    student_name,
    region,
    program,
    courses_taken,
    gpa,
    NTILE(4) OVER (ORDER BY gpa DESC) AS performance_quartile,
    CASE NTILE(4) OVER (ORDER BY gpa DESC)
        WHEN 1 THEN 'Q1 - Top 25% - Full Scholarship Eligible'
        WHEN 2 THEN 'Q2 - Above Average - Partial Scholarship'
        WHEN 3 THEN 'Q3 - Average - Standard Support'
        WHEN 4 THEN 'Q4 - Bottom 25% - Academic Intervention Required'
    END AS quartile_description,
    CASE NTILE(4) OVER (ORDER BY gpa DESC)
        WHEN 1 THEN 'Presidential Scholarship (100%)'
        WHEN 2 THEN 'Merit Scholarship (50%)'
        WHEN 3 THEN 'Standard Aid (25%)'
        WHEN 4 THEN 'Academic Support Program + Tutoring'
    END AS recommended_action
FROM student_performance
ORDER BY performance_quartile, gpa DESC;


-- =====================================================
-- DISTRIBUTION 2: NTILE(3) - Course Fee Pricing Tiers
-- =====================================================
WITH price_tiers AS (
    SELECT 
        course_id,
        course_code,
        course_name,
        department,
        credits,
        fee,
        NTILE(3) OVER (ORDER BY fee) AS price_tier
    FROM courses
)
SELECT 
    course_id,
    course_code,
    course_name,
    department,
    credits,
    fee,
    price_tier,
    CASE price_tier
        WHEN 1 THEN 'Low-Cost Tier'
        WHEN 2 THEN 'Mid-Cost Tier'
        WHEN 3 THEN 'High-Cost Tier'
    END AS tier_name,
    CASE price_tier
        WHEN 1 THEN 'Prioritize for students on financial aid'
        WHEN 2 THEN 'Balanced accessibility'
        WHEN 3 THEN 'May require special scholarships or payment plans'
    END AS financial_recommendation,
    COUNT(*) OVER (PARTITION BY price_tier) AS courses_in_tier
FROM price_tiers
ORDER BY price_tier, fee;


-- =====================================================
-- DISTRIBUTION 3: CUME_DIST() - Cumulative Grade Distribution
-- =====================================================
WITH grade_distribution AS (
    SELECT 
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        ROUND(AVG(e.grade), 2) AS gpa,
        COUNT(e.enrollment_id) AS courses_completed
    FROM students s
    INNER JOIN enrollments e ON s.student_id = e.student_id
    WHERE e.grade IS NOT NULL
    GROUP BY s.student_id, s.first_name, s.last_name
)
SELECT 
    student_id,
    student_name,
    gpa,
    courses_completed,
    ROUND(CUME_DIST() OVER (ORDER BY gpa) * 100, 2) AS cumulative_pct,
    CASE 
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.90 THEN 'Top 10% - Summa Cum Laude'
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.75 THEN 'Top 25% - Magna Cum Laude'
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.50 THEN 'Top 50% - Cum Laude'
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.25 THEN 'Bottom 50% - Good Standing'
        ELSE 'Bottom 25% - Academic Probation'
    END AS academic_honors,
    CASE 
        WHEN CUME_DIST() OVER (ORDER BY gpa) <= 0.15 THEN 'Mandatory Academic Counseling'
        WHEN CUME_DIST() OVER (ORDER BY gpa) <= 0.30 THEN 'Recommend Tutoring Services'
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.85 THEN 'Eligible for Graduate Programs'
        ELSE 'Standard Academic Path'
    END AS intervention_recommendation
FROM grade_distribution
ORDER BY gpa DESC;


-- =====================================================
-- DISTRIBUTION 4: NTILE() by Region - Regional Performance Equity
-- =====================================================
WITH regional_performance AS (
    SELECT 
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        s.region,
        s.program,
        ROUND(AVG(e.grade), 2) AS gpa
    FROM students s
    INNER JOIN enrollments e ON s.student_id = e.student_id
    WHERE e.grade IS NOT NULL
    GROUP BY s.student_id, s.first_name, s.last_name, s.region, s.program
)
SELECT 
    region,
    student_id,
    student_name,
    program,
    gpa,
    NTILE(4) OVER (PARTITION BY region ORDER BY gpa DESC) AS regional_quartile,
    NTILE(4) OVER (ORDER BY gpa DESC) AS national_quartile,
    CASE NTILE(4) OVER (PARTITION BY region ORDER BY gpa DESC)
        WHEN 1 THEN 'Regional Top 25% - Regional Scholarship'
        WHEN 2 THEN 'Regional Above Average'
        WHEN 3 THEN 'Regional Average'
        WHEN 4 THEN 'Regional Bottom 25% - Local Support Program'
    END AS regional_standing,
    COUNT(*) OVER (PARTITION BY region) AS total_students_in_region
FROM regional_performance
ORDER BY region, regional_quartile, gpa DESC;


-- =====================================================
-- DISTRIBUTION 5: CUME_DIST() for Enrollment Timing
-- =====================================================
WITH registration_timing AS (
    SELECT 
        e.enrollment_id,
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        e.semester || ' ' || e.academic_year AS period,
        e.enrollment_date,
        e.enrollment_date - MIN(e.enrollment_date) OVER (
            PARTITION BY e.semester, e.academic_year
        ) AS days_after_registration_opens
    FROM enrollments e
    INNER JOIN students s ON e.student_id = s.student_id
    WHERE e.academic_year = 2025
)
SELECT 
    student_id,
    student_name,
    period,
    enrollment_date,
    days_after_registration_opens,
    ROUND(CUME_DIST() OVER (
        PARTITION BY period 
        ORDER BY enrollment_date
    ) * 100, 2) AS registration_percentile,
    CASE 
        WHEN CUME_DIST() OVER (PARTITION BY period ORDER BY enrollment_date) <= 0.25 
            THEN 'Early Bird (First 25%) - Priority Benefits'
        WHEN CUME_DIST() OVER (PARTITION BY period ORDER BY enrollment_date) <= 0.50 
            THEN 'On-Time (26-50%)'
        WHEN CUME_DIST() OVER (PARTITION BY period ORDER BY enrollment_date) <= 0.75 
            THEN 'Late (51-75%)'
        ELSE 'Very Late (Bottom 25%) - May Face Course Closures'
    END AS registration_timing_category,
    COUNT(*) OVER (PARTITION BY period) AS total_registrations_in_semester
FROM registration_timing
ORDER BY period, registration_percentile;


-- =====================================================
-- DISTRIBUTION 6: Combined NTILE and CUME_DIST - Student Segmentation
-- =====================================================
WITH student_metrics AS (
    SELECT 
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        s.region,
        COUNT(e.enrollment_id) AS courses_taken,
        ROUND(AVG(e.grade), 2) AS gpa
    FROM students s
    INNER JOIN enrollments e ON s.student_id = e.student_id
    WHERE e.grade IS NOT NULL
    GROUP BY s.student_id, s.first_name, s.last_name, s.region
)
SELECT 
    student_id,
    student_name,
    region,
    courses_taken,
    gpa,
    NTILE(4) OVER (ORDER BY gpa DESC) AS performance_quartile,
    NTILE(4) OVER (ORDER BY courses_taken DESC) AS engagement_quartile,
    ROUND(CUME_DIST() OVER (ORDER BY gpa) * 100, 2) AS performance_percentile,
    ROUND(CUME_DIST() OVER (ORDER BY courses_taken) * 100, 2) AS engagement_percentile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 1 
            AND NTILE(4) OVER (ORDER BY courses_taken DESC) = 1 
            THEN 'Star Student - Leadership Opportunities'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 1 
            AND NTILE(4) OVER (ORDER BY courses_taken DESC) = 4 
            THEN 'High Achiever, Low Engagement - Encourage Participation'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 4 
            AND NTILE(4) OVER (ORDER BY courses_taken DESC) = 1 
            THEN 'Highly Engaged, Struggling - Intensive Tutoring'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 4 
            AND NTILE(4) OVER (ORDER BY courses_taken DESC) = 4 
            THEN 'At-Risk Student - Immediate Intervention'
        ELSE 'Standard Support'
    END AS student_segment,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 1 
            AND NTILE(4) OVER (ORDER BY courses_taken DESC) = 1 
            THEN 'Peer Mentor, TA Positions, Research Opportunities'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 4 
            AND NTILE(4) OVER (ORDER BY courses_taken DESC) = 4 
            THEN 'Academic Probation, Reduced Course Load, Weekly Counseling'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 1 
            THEN 'Honors Program, Advanced Courses'
        WHEN NTILE(4) OVER (ORDER BY courses_taken DESC) = 4 
            THEN 'Encourage More Course Enrollment'
        ELSE 'Continue Standard Academic Path'
    END AS recommended_intervention
FROM student_metrics
ORDER BY performance_quartile, engagement_quartile;
