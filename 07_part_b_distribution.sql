-- =====================================================
-- PART B: WINDOW FUNCTIONS IMPLEMENTATION
-- Category 4: DISTRIBUTION FUNCTIONS (NTILE, CUME_DIST)
-- =====================================================

-- =====================================================
-- DISTRIBUTION 1: NTILE(4) - Student Performance Quartiles
-- Business Purpose: Segment students into 4 performance quartiles
-- Use Case: Targeted academic interventions and scholarship allocation
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

-- INTERPRETATION:
-- NTILE(4) divides students into 4 equal-sized groups based on GPA.
-- Q1 (top 25%) qualifies for presidential scholarships; Q4 (bottom 25%) needs tutoring.
-- This ensures equitable resource distribution across all performance levels.


-- =====================================================
-- DISTRIBUTION 2: NTILE(3) - Course Fee Pricing Tiers
-- Business Purpose: Categorize courses into low/medium/high price tiers
-- Use Case: Financial aid allocation and affordability analysis
-- =====================================================
SELECT 
    course_id,
    course_code,
    course_name,
    department,
    credits,
    fee,
    NTILE(3) OVER (ORDER BY fee) AS price_tier,
    CASE NTILE(3) OVER (ORDER BY fee)
        WHEN 1 THEN 'Low-Cost Tier'
        WHEN 2 THEN 'Mid-Cost Tier'
        WHEN 3 THEN 'High-Cost Tier'
    END AS tier_name,
    CASE NTILE(3) OVER (ORDER BY fee)
        WHEN 1 THEN 'Prioritize for students on financial aid'
        WHEN 2 THEN 'Balanced accessibility'
        WHEN 3 THEN 'May require special scholarships or payment plans'
    END AS financial_recommendation,
    COUNT(*) OVER (PARTITION BY NTILE(3) OVER (ORDER BY fee)) AS courses_in_tier
FROM courses
ORDER BY price_tier, fee;

-- INTERPRETATION:
-- NTILE(3) creates three equal pricing tiers to guide financial aid decisions.
-- High-cost tier courses (Tier 3) like Deep Learning and Quantum Computing may need
-- payment plans. Low-cost tier (Tier 1) courses are more accessible to aid recipients.


-- =====================================================
-- DISTRIBUTION 3: CUME_DIST() - Cumulative Grade Distribution
-- Business Purpose: Calculate cumulative percentile distribution of student grades
-- Use Case: Determine grade cutoffs for honors and academic probation
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

-- INTERPRETATION:
-- CUME_DIST() calculates the proportion of students with GPA ≤ current student's GPA.
-- Students in top 10% (≥90th percentile) earn Summa Cum Laude honors.
-- Bottom 15% receive mandatory counseling; bottom 30% are offered tutoring.


-- =====================================================
-- DISTRIBUTION 4: NTILE() by Region - Regional Performance Equity
-- Business Purpose: Divide students into quartiles WITHIN each region
-- Use Case: Ensure regional equity in scholarship distribution
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

-- INTERPRETATION:
-- NTILE(4) with PARTITION BY region ensures each region gets top performers identified.
-- Prevents all scholarships going to students from one high-performing region.
-- A student might be Q1 regionally but Q2 nationally - still earns regional scholarship.


-- =====================================================
-- DISTRIBUTION 5: CUME_DIST() for Enrollment Timing
-- Business Purpose: Analyze how early/late students register each semester
-- Use Case: Optimize registration periods and identify priority registration needs
-- =====================================================
WITH registration_timing AS (
    SELECT 
        e.enrollment_id,
        s.student_id,
        s.first_name || ' ' || s.last_name AS student_name,
        e.semester || ' ' || e.year AS period,
        e.enrollment_date,
        e.enrollment_date - MIN(e.enrollment_date) OVER (
            PARTITION BY e.semester, e.year
        ) AS days_after_registration_opens
    FROM enrollments e
    INNER JOIN students s ON e.student_id = s.student_id
    WHERE e.year = 2025
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

-- INTERPRETATION:
-- CUME_DIST() shows what percentage of students registered before each student.
-- Early registrants (top 25%) could receive priority add/drop or course selection.
-- Late registrants (bottom 25%) face closed courses - system could send reminders.


-- =====================================================
-- DISTRIBUTION 6: Combined NTILE and CUME_DIST - Comprehensive Student Segmentation
-- Business Purpose: Multi-dimensional student classification for holistic support
-- Use Case: Integrated academic and engagement intervention strategies
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

-- INTERPRETATION:
-- Combines NTILE and CUME_DIST to create a 2-dimensional student classification matrix.
-- "Star Students" (Q1 performance + Q1 engagement) get leadership opportunities.
-- "At-Risk" students (Q4 + Q4) need immediate multi-layered intervention.
-- This holistic view prevents one-size-fits-all support and targets specific needs.

-- =====================================================
-- END OF CATEGORY 4: DISTRIBUTION FUNCTIONS
-- =====================================================
