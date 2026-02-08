-- =====================================================
-- EDUCATION MANAGEMENT SYSTEM - DATABASE SCHEMA
-- Course: INSY 8311 - Database Development with PL/SQL
-- Assignment: SQL JOINs & Window Functions
-- =====================================================

-- Drop tables safely (Oracle style)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE enrollments CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE students CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE courses CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- =====================================================
-- TABLE 1: STUDENTS
-- =====================================================
CREATE TABLE students (
    student_id NUMBER(10) PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    region VARCHAR2(50) NOT NULL,
    enrollment_date DATE NOT NULL,
    program VARCHAR2(100) NOT NULL,
    CONSTRAINT chk_email CHECK (email LIKE '%@%')
);

-- =====================================================
-- TABLE 2: COURSES
-- =====================================================
CREATE TABLE courses (
    course_id NUMBER(10) PRIMARY KEY,
    course_code VARCHAR2(20) UNIQUE NOT NULL,
    course_name VARCHAR2(100) NOT NULL,
    department VARCHAR2(50) NOT NULL,
    credits NUMBER(2) NOT NULL,
    fee NUMBER(10,2) NOT NULL,
    CONSTRAINT chk_credits CHECK (credits BETWEEN 1 AND 6),
    CONSTRAINT chk_fee CHECK (fee >= 0)
);

-- =====================================================
-- TABLE 3: ENROLLMENTS
-- =====================================================
CREATE TABLE enrollments (
    enrollment_id NUMBER(10) PRIMARY KEY,
    student_id NUMBER(10) NOT NULL,
    course_id NUMBER(10) NOT NULL,
    enrollment_date DATE NOT NULL,
    semester VARCHAR2(20) NOT NULL,
    academic_year NUMBER(4) NOT NULL,
    grade NUMBER(5,2),
    status VARCHAR2(20) DEFAULT 'Active',

    CONSTRAINT fk_enr_student FOREIGN KEY (student_id)
        REFERENCES students(student_id) ON DELETE CASCADE,

    CONSTRAINT fk_enr_course FOREIGN KEY (course_id)
        REFERENCES courses(course_id) ON DELETE CASCADE,

    CONSTRAINT chk_grade CHECK (grade BETWEEN 0 AND 100),
    CONSTRAINT chk_status CHECK (status IN ('Active', 'Completed', 'Withdrawn', 'Failed'))
);

-- =====================================================
-- SEQUENCES
-- =====================================================
CREATE SEQUENCE seq_student_id START WITH 1001 INCREMENT BY 1;
CREATE SEQUENCE seq_course_id START WITH 2001 INCREMENT BY 1;
CREATE SEQUENCE seq_enrollment_id START WITH 3001 INCREMENT BY 1;

-- =====================================================
-- INDEXES
-- =====================================================
CREATE INDEX idx_student_region ON students(region);
CREATE INDEX idx_enrollment_sem_year ON enrollments(semester, academic_year);
CREATE INDEX idx_course_department ON courses(department);

COMMIT;
