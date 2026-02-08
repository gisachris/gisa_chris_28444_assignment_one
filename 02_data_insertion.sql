-- =====================================================
-- SAMPLE DATA INSERTION
-- Realistic education management data
-- =====================================================

-- =====================================================
-- INSERT STUDENTS (30 students across 4 regions)
-- =====================================================
INSERT INTO students VALUES (1001, 'James', 'Uwimana', 'j.uwimana@student.ac.rw', 'Kigali', DATE '2023-09-01', 'Computer Science');
INSERT INTO students VALUES (1002, 'Marie', 'Mukamana', 'm.mukamana@student.ac.rw', 'Kigali', DATE '2023-09-01', 'Information Systems');
INSERT INTO students VALUES (1003, 'Eric', 'Nshimiyimana', 'e.nshimiyimana@student.ac.rw', 'Eastern', DATE '2023-09-05', 'Computer Science');
INSERT INTO students VALUES (1004, 'Grace', 'Umuhoza', 'g.umuhoza@student.ac.rw', 'Northern', DATE '2023-09-10', 'Data Science');
INSERT INTO students VALUES (1005, 'David', 'Habimana', 'd.habimana@student.ac.rw', 'Southern', DATE '2023-09-01', 'Information Systems');
INSERT INTO students VALUES (1006, 'Sarah', 'Ingabire', 's.ingabire@student.ac.rw', 'Kigali', DATE '2024-01-15', 'Computer Science');
INSERT INTO students VALUES (1007, 'Patrick', 'Mugisha', 'p.mugisha@student.ac.rw', 'Eastern', DATE '2024-01-15', 'Data Science');
INSERT INTO students VALUES (1008, 'Claire', 'Uwase', 'c.uwase@student.ac.rw', 'Northern', DATE '2024-01-20', 'Software Engineering');
INSERT INTO students VALUES (1009, 'Joseph', 'Bizimana', 'j.bizimana@student.ac.rw', 'Kigali', DATE '2024-01-15', 'Computer Science');
INSERT INTO students VALUES (1010, 'Alice', 'Mutesi', 'a.mutesi@student.ac.rw', 'Southern', DATE '2024-01-18', 'Information Systems');
INSERT INTO students VALUES (1011, 'Robert', 'Kayitesi', 'r.kayitesi@student.ac.rw', 'Kigali', DATE '2024-09-01', 'Data Science');
INSERT INTO students VALUES (1012, 'Agnes', 'Uwineza', 'a.uwineza@student.ac.rw', 'Eastern', DATE '2024-09-01', 'Computer Science');
INSERT INTO students VALUES (1013, 'Emmanuel', 'Nsengimana', 'e.nsengimana@student.ac.rw', 'Northern', DATE '2024-09-05', 'Software Engineering');
INSERT INTO students VALUES (1014, 'Diane', 'Kamikazi', 'd.kamikazi@student.ac.rw', 'Southern', DATE '2024-09-01', 'Information Systems');
INSERT INTO students VALUES (1015, 'Jean', 'Mutabazi', 'j.mutabazi@student.ac.rw', 'Kigali', DATE '2024-09-10', 'Computer Science');
INSERT INTO students VALUES (1016, 'Francine', 'Umutoni', 'f.umutoni@student.ac.rw', 'Eastern', DATE '2025-01-10', 'Data Science');
INSERT INTO students VALUES (1017, 'Bernard', 'Hakizimana', 'b.hakizimana@student.ac.rw', 'Northern', DATE '2025-01-10', 'Software Engineering');
INSERT INTO students VALUES (1018, 'Esther', 'Nizeyimana', 'e.nizeyimana@student.ac.rw', 'Kigali', DATE '2025-01-15', 'Computer Science');
INSERT INTO students VALUES (1019, 'Samuel', 'Uwizeye', 's.uwizeye@student.ac.rw', 'Southern', DATE '2025-01-10', 'Information Systems');
INSERT INTO students VALUES (1020, 'Beatrice', 'Nyiraneza', 'b.nyiraneza@student.ac.rw', 'Kigali', DATE '2025-01-20', 'Data Science');
-- Additional students without enrollments for LEFT JOIN demonstration
INSERT INTO students VALUES (1021, 'Moses', 'Niyonkuru', 'm.niyonkuru@student.ac.rw', 'Eastern', DATE '2025-01-25', 'Computer Science');
INSERT INTO students VALUES (1022, 'Chantal', 'Mukeshimana', 'c.mukeshimana@student.ac.rw', 'Northern', DATE '2025-01-25', 'Information Systems');
INSERT INTO students VALUES (1023, 'Kevin', 'Ishimwe', 'k.ishimwe@student.ac.rw', 'Southern', DATE '2025-01-28', 'Data Science');
INSERT INTO students VALUES (1024, 'Lydia', 'Uwamahoro', 'l.uwamahoro@student.ac.rw', 'Kigali', DATE '2025-01-30', 'Software Engineering');
INSERT INTO students VALUES (1025, 'Frank', 'Rutayisire', 'f.rutayisire@student.ac.rw', 'Eastern', DATE '2025-02-01', 'Computer Science');

-- =====================================================
-- INSERT COURSES (15 courses across departments)
-- =====================================================
INSERT INTO courses VALUES (2001, 'INSY8311', 'Database Development with PL/SQL', 'Information Systems', 3, 450000);
INSERT INTO courses VALUES (2002, 'CS2101', 'Data Structures and Algorithms', 'Computer Science', 4, 500000);
INSERT INTO courses VALUES (2003, 'MATH3201', 'Discrete Mathematics', 'Mathematics', 3, 400000);
INSERT INTO courses VALUES (2004, 'DS4301', 'Machine Learning Fundamentals', 'Data Science', 4, 550000);
INSERT INTO courses VALUES (2005, 'SE3401', 'Software Engineering Principles', 'Software Engineering', 3, 480000);
INSERT INTO courses VALUES (2006, 'INSY7201', 'Database Systems', 'Information Systems', 3, 450000);
INSERT INTO courses VALUES (2007, 'CS3301', 'Operating Systems', 'Computer Science', 4, 500000);
INSERT INTO courses VALUES (2008, 'DS5401', 'Deep Learning', 'Data Science', 4, 600000);
INSERT INTO courses VALUES (2009, 'SE4501', 'Web Application Development', 'Software Engineering', 3, 480000);
INSERT INTO courses VALUES (2010, 'INSY6101', 'Business Intelligence', 'Information Systems', 3, 450000);
INSERT INTO courses VALUES (2011, 'CS4401', 'Computer Networks', 'Computer Science', 3, 500000);
INSERT INTO courses VALUES (2012, 'DS3301', 'Statistical Analysis', 'Data Science', 3, 520000);
INSERT INTO courses VALUES (2013, 'SE2201', 'Object-Oriented Programming', 'Software Engineering', 4, 480000);
-- Courses with no enrollments for RIGHT JOIN demonstration
INSERT INTO courses VALUES (2014, 'CS5501', 'Quantum Computing', 'Computer Science', 3, 650000);
INSERT INTO courses VALUES (2015, 'DS6601', 'Advanced Neural Networks', 'Data Science', 4, 700000);

-- =====================================================
-- INSERT ENROLLMENTS (80+ enrollments across 3 years)
-- =====================================================
-- Semester 1 2023 enrollments
INSERT INTO enrollments VALUES (3001, 1001, 2001, DATE '2023-09-10', 'Semester 1', 2023, 85.5, 'Completed');
INSERT INTO enrollments VALUES (3002, 1001, 2002, DATE '2023-09-10', 'Semester 1', 2023, 78.0, 'Completed');
INSERT INTO enrollments VALUES (3003, 1002, 2001, DATE '2023-09-12', 'Semester 1', 2023, 92.0, 'Completed');
INSERT INTO enrollments VALUES (3004, 1002, 2006, DATE '2023-09-12', 'Semester 1', 2023, 88.5, 'Completed');
INSERT INTO enrollments VALUES (3005, 1003, 2002, DATE '2023-09-15', 'Semester 1', 2023, 75.0, 'Completed');
INSERT INTO enrollments VALUES (3006, 1003, 2003, DATE '2023-09-15', 'Semester 1', 2023, 82.0, 'Completed');
INSERT INTO enrollments VALUES (3007, 1004, 2004, DATE '2023-09-18', 'Semester 1', 2023, 90.0, 'Completed');
INSERT INTO enrollments VALUES (3008, 1004, 2012, DATE '2023-09-18', 'Semester 1', 2023, 87.5, 'Completed');
INSERT INTO enrollments VALUES (3009, 1005, 2001, DATE '2023-09-10', 'Semester 1', 2023, 80.0, 'Completed');
INSERT INTO enrollments VALUES (3010, 1005, 2006, DATE '2023-09-10', 'Semester 1', 2023, 83.0, 'Completed');

-- Semester 2 2024 enrollments
INSERT INTO enrollments VALUES (3011, 1001, 2007, DATE '2024-01-20', 'Semester 2', 2024, 88.0, 'Completed');
INSERT INTO enrollments VALUES (3012, 1001, 2011, DATE '2024-01-20', 'Semester 2', 2024, 82.5, 'Completed');
INSERT INTO enrollments VALUES (3013, 1002, 2010, DATE '2024-01-22', 'Semester 2', 2024, 91.0, 'Completed');
INSERT INTO enrollments VALUES (3014, 1003, 2007, DATE '2024-01-25', 'Semester 2', 2024, 79.0, 'Completed');
INSERT INTO enrollments VALUES (3015, 1004, 2008, DATE '2024-01-28', 'Semester 2', 2024, 93.5, 'Completed');
INSERT INTO enrollments VALUES (3016, 1005, 2010, DATE '2024-01-22', 'Semester 2', 2024, 85.0, 'Completed');
INSERT INTO enrollments VALUES (3017, 1006, 2001, DATE '2024-01-20', 'Semester 2', 2024, 87.0, 'Completed');
INSERT INTO enrollments VALUES (3018, 1006, 2002, DATE '2024-01-20', 'Semester 2', 2024, 84.5, 'Completed');
INSERT INTO enrollments VALUES (3019, 1007, 2004, DATE '2024-01-25', 'Semester 2', 2024, 89.0, 'Completed');
INSERT INTO enrollments VALUES (3020, 1008, 2005, DATE '2024-01-28', 'Semester 2', 2024, 86.0, 'Completed');
INSERT INTO enrollments VALUES (3021, 1009, 2002, DATE '2024-01-22', 'Semester 2', 2024, 77.5, 'Completed');
INSERT INTO enrollments VALUES (3022, 1010, 2006, DATE '2024-01-25', 'Semester 2', 2024, 90.5, 'Completed');

-- Semester 1 2024 enrollments
INSERT INTO enrollments VALUES (3023, 1001, 2005, DATE '2024-09-10', 'Semester 1', 2024, 90.0, 'Completed');
INSERT INTO enrollments VALUES (3024, 1002, 2013, DATE '2024-09-12', 'Semester 1', 2024, 94.0, 'Completed');
INSERT INTO enrollments VALUES (3025, 1003, 2011, DATE '2024-09-15', 'Semester 1', 2024, 81.0, 'Completed');
INSERT INTO enrollments VALUES (3026, 1004, 2012, DATE '2024-09-18', 'Semester 1', 2024, 92.5, 'Completed');
INSERT INTO enrollments VALUES (3027, 1005, 2009, DATE '2024-09-10', 'Semester 1', 2024, 88.5, 'Completed');
INSERT INTO enrollments VALUES (3028, 1006, 2003, DATE '2024-09-12', 'Semester 1', 2024, 85.0, 'Completed');
INSERT INTO enrollments VALUES (3029, 1007, 2012, DATE '2024-09-15', 'Semester 1', 2024, 91.0, 'Completed');
INSERT INTO enrollments VALUES (3030, 1008, 2009, DATE '2024-09-18', 'Semester 1', 2024, 87.5, 'Completed');
INSERT INTO enrollments VALUES (3031, 1009, 2007, DATE '2024-09-12', 'Semester 1', 2024, 80.0, 'Completed');
INSERT INTO enrollments VALUES (3032, 1010, 2010, DATE '2024-09-15', 'Semester 1', 2024, 89.0, 'Completed');
INSERT INTO enrollments VALUES (3033, 1011, 2004, DATE '2024-09-10', 'Semester 1', 2024, 88.0, 'Completed');
INSERT INTO enrollments VALUES (3034, 1011, 2012, DATE '2024-09-10', 'Semester 1', 2024, 90.5, 'Completed');
INSERT INTO enrollments VALUES (3035, 1012, 2002, DATE '2024-09-12', 'Semester 1', 2024, 83.0, 'Completed');
INSERT INTO enrollments VALUES (3036, 1013, 2005, DATE '2024-09-15', 'Semester 1', 2024, 86.5, 'Completed');
INSERT INTO enrollments VALUES (3037, 1014, 2006, DATE '2024-09-10', 'Semester 1', 2024, 91.5, 'Completed');
INSERT INTO enrollments VALUES (3038, 1015, 2002, DATE '2024-09-18', 'Semester 1', 2024, 84.0, 'Completed');

-- Semester 2 2025 enrollments (current semester - some active)
INSERT INTO enrollments VALUES (3039, 1001, 2013, DATE '2025-01-15', 'Semester 2', 2025, 92.0, 'Completed');
INSERT INTO enrollments VALUES (3040, 1002, 2009, DATE '2025-01-17', 'Semester 2', 2025, 95.5, 'Completed');
INSERT INTO enrollments VALUES (3041, 1003, 2005, DATE '2025-01-20', 'Semester 2', 2025, 82.5, 'Completed');
INSERT INTO enrollments VALUES (3042, 1004, 2004, DATE '2025-01-22', 'Semester 2', 2025, 94.0, 'Completed');
INSERT INTO enrollments VALUES (3043, 1005, 2013, DATE '2025-01-15', 'Semester 2', 2025, 87.0, 'Completed');
INSERT INTO enrollments VALUES (3044, 1006, 2007, DATE '2025-01-17', 'Semester 2', 2025, 89.5, 'Completed');
INSERT INTO enrollments VALUES (3045, 1007, 2008, DATE '2025-01-20', 'Semester 2', 2025, 93.0, 'Completed');
INSERT INTO enrollments VALUES (3046, 1008, 2013, DATE '2025-01-22', 'Semester 2', 2025, 88.5, 'Completed');
INSERT INTO enrollments VALUES (3047, 1009, 2011, DATE '2025-01-17', 'Semester 2', 2025, 81.0, 'Completed');
INSERT INTO enrollments VALUES (3048, 1010, 2013, DATE '2025-01-20', 'Semester 2', 2025, 90.5, 'Completed');
INSERT INTO enrollments VALUES (3049, 1011, 2008, DATE '2025-01-15', 'Semester 2', 2025, 91.5, 'Completed');
INSERT INTO enrollments VALUES (3050, 1012, 2007, DATE '2025-01-17', 'Semester 2', 2025, 84.5, 'Completed');
INSERT INTO enrollments VALUES (3051, 1013, 2009, DATE '2025-01-20', 'Semester 2', 2025, 87.0, 'Completed');
INSERT INTO enrollments VALUES (3052, 1014, 2010, DATE '2025-01-15', 'Semester 2', 2025, 92.5, 'Completed');
INSERT INTO enrollments VALUES (3053, 1015, 2011, DATE '2025-01-22', 'Semester 2', 2025, 85.0, 'Completed');
INSERT INTO enrollments VALUES (3054, 1016, 2004, DATE '2025-01-18', 'Semester 2', 2025, NULL, 'Active');
INSERT INTO enrollments VALUES (3055, 1016, 2012, DATE '2025-01-18', 'Semester 2', 2025, NULL, 'Active');
INSERT INTO enrollments VALUES (3056, 1017, 2005, DATE '2025-01-20', 'Semester 2', 2025, NULL, 'Active');
INSERT INTO enrollments VALUES (3057, 1017, 2009, DATE '2025-01-20', 'Semester 2', 2025, NULL, 'Active');
INSERT INTO enrollments VALUES (3058, 1018, 2002, DATE '2025-01-22', 'Semester 2', 2025, NULL, 'Active');
INSERT INTO enrollments VALUES (3059, 1019, 2006, DATE '2025-01-18', 'Semester 2', 2025, NULL, 'Active');
INSERT INTO enrollments VALUES (3060, 1020, 2004, DATE '2025-01-25', 'Semester 2', 2025, NULL, 'Active');
INSERT INTO enrollments VALUES (3061, 1020, 2008, DATE '2025-01-25', 'Semester 2', 2025, NULL, 'Active');

-- Additional historical enrollments for better analytics
INSERT INTO enrollments VALUES (3062, 1006, 2005, DATE '2024-09-12', 'Semester 1', 2024, 88.0, 'Completed');
INSERT INTO enrollments VALUES (3063, 1007, 2004, DATE '2024-09-15', 'Semester 1', 2024, 90.5, 'Completed');
INSERT INTO enrollments VALUES (3064, 1008, 2005, DATE '2024-09-18', 'Semester 1', 2024, 85.5, 'Completed');
INSERT INTO enrollments VALUES (3065, 1009, 2001, DATE '2024-09-12', 'Semester 1', 2024, 79.0, 'Completed');
INSERT INTO enrollments VALUES (3066, 1010, 2001, DATE '2024-09-15', 'Semester 1', 2024, 87.5, 'Completed');

COMMIT;

-- Display record counts
SELECT 'Students' AS table_name, COUNT(*) AS record_count FROM students
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM enrollments;
