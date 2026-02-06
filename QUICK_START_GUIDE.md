# 🚀 QUICK START GUIDE
## How to Customize and Submit This Assignment

### ⏰ DEADLINE: Friday, February 06, 2026 at 12:00 PM (NO LATE SUBMISSIONS)

---

## 📋 STEP-BY-STEP INSTRUCTIONS

### STEP 1: Set Up Your Oracle Database

**Option A: Using Oracle SQL Developer**
1. Download Oracle SQL Developer from oracle.com
2. Install and create a new connection
3. Use your university database credentials

**Option B: Using Oracle Express Edition (XE)**
1. Download Oracle XE (free version)
2. Install on your local machine
3. Connect via SQL*Plus or SQL Developer

**Option C: Using Oracle Cloud Free Tier**
1. Sign up at cloud.oracle.com (free tier)
2. Create an Autonomous Database
3. Use SQL Developer Web interface

---

### STEP 2: Execute the SQL Files IN ORDER

```sql
-- 1. Create the database schema
@01_schema_creation.sql

-- 2. Insert sample data
@02_data_insertion.sql

-- 3. Verify data loaded correctly
SELECT 'Students' AS table_name, COUNT(*) FROM students
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM enrollments;

-- Expected Results:
-- Students: 25 rows
-- Courses: 15 rows
-- Enrollments: 66 rows

-- 4. Run Part A (JOINs)
@03_part_a_joins.sql

-- 5. Run Part B (Window Functions)
@04_part_b_ranking.sql
@05_part_b_aggregate.sql
@06_part_b_navigation.sql
@07_part_b_distribution.sql
```

---

### STEP 3: Take Screenshots

For each query category, take clear screenshots showing:
- The SQL query itself
- Complete result set (all columns visible)
- No errors in execution

**Required Screenshots:**
1. `join_inner.png` - INNER JOIN results
2. `join_left.png` - LEFT JOIN results (students with no enrollments)
3. `join_right.png` - RIGHT JOIN results (courses with no students)
4. `join_full_outer.png` - FULL OUTER JOIN results
5. `join_self.png` - SELF JOIN results (study groups)
6. `ranking_row_number.png` - ROW_NUMBER() results
7. `ranking_rank.png` - RANK() results
8. `ranking_dense_rank.png` - DENSE_RANK() results
9. `ranking_percent_rank.png` - PERCENT_RANK() results
10. `aggregate_sum.png` - Running total revenue
11. `aggregate_avg.png` - Moving average enrollments
12. `aggregate_max_min.png` - Grade deviation analysis
13. `navigation_lag.png` - Semester-over-semester growth
14. `navigation_lead.png` - Forward-looking trends
15. `distribution_ntile.png` - Performance quartiles
16. `distribution_cume_dist.png` - Cumulative distribution

**Screenshot Best Practices:**
- Use high resolution (at least 1920x1080)
- Ensure text is readable
- Show full query and complete results
- No cropping that cuts off important data
- Save as PNG format

---

### STEP 4: Create Your GitHub Repository

```bash
# Repository name: plsql_window_functions_28444_Gisa
# Example: plsql_window_functions_2024001_john

# 2. Make it PUBLIC (not private!)

# 3. Clone to your local machine
git clone https://github.com/yourusername/plsql_window_functions_[studentId]_[firstname].git
cd plsql_window_functions_[studentId]_[firstname]

# 4. Copy all SQL files to the repository
# (The files from /home/claude/ in this project)

# 5. Create a screenshots folder
mkdir screenshots

# 6. Add all your screenshots to the screenshots/ folder

# 7. Create or copy the README.md file

# 8. Add, commit, and push
git add .
git commit -m "Initial commit - SQL Assignment I"
git push origin main
```

---

### STEP 5: Customize the README.md

**REQUIRED Personalizations:**

1. **Replace placeholders in Academic Integrity Statement:**
```markdown
**Student Signature (Digital):** John Doe  
**Date:** February 6, 2026  
**Student ID:** 2024001
```

2. **Update Contact section:**
```markdown
**Student:** John Doe  
**Email:** john.doe@student.ac.rw  
**GitHub:** github.com/johndoe  
**Repository:** plsql_window_functions_2024001_john
```

3. **Add your ER Diagram:**
   - Draw using draw.io, Lucidchart, or any tool
   - Save as `erd_diagram.png`
   - Add to repository
   - Reference in README

4. **Optional: Customize the business scenario**
   - If you want to change from Education to another domain
   - Update table names and sample data accordingly
   - Ensure all queries still work

---

### STEP 6: Test Everything

**Critical Tests:**

```sql
-- Test 1: All tables exist
SELECT table_name FROM user_tables 
WHERE table_name IN ('STUDENTS', 'COURSES', 'ENROLLMENTS');
-- Should return 3 rows

-- Test 2: Foreign keys are working
SELECT constraint_name, constraint_type 
FROM user_constraints 
WHERE table_name = 'ENROLLMENTS';
-- Should show PRIMARY KEY and 2 FOREIGN KEYs

-- Test 3: Sample JOIN query runs
SELECT COUNT(*) FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id;
-- Should return 66 (total enrollments)

-- Test 4: Sample window function runs
SELECT student_id, 
       COUNT(*) AS total_courses,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS enrollment_rank
FROM enrollments
GROUP BY student_id;
-- Should execute without errors
```

---

### STEP 7: Prepare Email Submission

**Copy this template and fill in your details:**

```
To: eric.maniraguha@auca.ac.rw
Subject: INSY 8311 SQL Assignment I – [Your Full Name] – Group [X]

Dear Professor Maniraguha,

I am pleased to submit my Individual Assignment I on SQL JOINs & Window Functions for INSY 8311.

Repository Link: https://github.com/[yourusername]/plsql_window_functions_[studentId]_[firstname]

Business Problem: 
An educational institution needs comprehensive analytical insights to optimize student academic support, resource allocation, course offerings, and enrollment forecasting across multiple regions and academic programs.

Key Findings:
1. [Your first key finding from the analysis]
2. [Your second key finding from the analysis]

Sources Consulted: [Number]

Best regards,
[Your Full Name]
Student ID: [Your ID]
Group: [Your Group]
```

---

## 🎯 COMMON CUSTOMIZATION POINTS

### If You Want to Change the Business Domain:

**Current:** Education/Student Management  
**Alternative Options:**
- E-commerce (Customers, Products, Orders)
- Healthcare (Patients, Doctors, Appointments)
- Banking (Customers, Accounts, Transactions)

**What to Update:**
1. Table names in `01_schema_creation.sql`
2. Sample data in `02_data_insertion.sql`
3. Business interpretations in all query files
4. README.md business problem section
5. All query comments and descriptions

### If You Want to Add More Data:

```sql
-- Add more students
INSERT INTO students VALUES (1026, 'NewFirst', 'NewLast', 'new.email@student.ac.rw', 'Region', DATE '2025-02-01', 'Program');

-- Add more courses
INSERT INTO courses VALUES (2016, 'NEW101', 'New Course Name', 'Department', 3, 450000);

-- Add more enrollments
INSERT INTO enrollments VALUES (3067, 1026, 2016, DATE '2025-02-05', 'Spring', 2025, NULL, 'Active');

COMMIT;
```

---

## ⚠️ COMMON MISTAKES TO AVOID

1. **Repository is Private**
   - ❌ WRONG: Setting repository to private
   - ✅ CORRECT: Repository must be PUBLIC

2. **Missing Interpretations**
   - ❌ WRONG: Just SQL query without explanation
   - ✅ CORRECT: Every query has 2-3 sentence business interpretation

3. **Screenshots Unclear**
   - ❌ WRONG: Blurry, cropped, or low-resolution images
   - ✅ CORRECT: Clear, high-resolution screenshots with full results visible

4. **SQL Errors**
   - ❌ WRONG: Queries that don't run or have syntax errors
   - ✅ CORRECT: Test every single query before submission

5. **Late Submission**
   - ❌ WRONG: Submitting after 12:00 PM = ZERO MARKS
   - ✅ CORRECT: Submit at least 30 minutes before deadline

6. **Plagiarism**
   - ❌ WRONG: Copy-paste from classmates or online sources
   - ✅ CORRECT: Write your own queries and interpretations

7. **No References**
   - ❌ WRONG: Missing references section
   - ✅ CORRECT: Cite all sources consulted (at least 3-5)

8. **Missing Academic Integrity Statement**
   - ❌ WRONG: No declaration of original work
   - ✅ CORRECT: Complete integrity statement with name and date

---

## 🏆 GRADING CHECKLIST (10 Points Total)

| Category | Points | What to Check |
|----------|--------|---------------|
| **Problem Definition** | 2 pts | Business context, data challenge, expected outcomes clearly stated; 5 success criteria linked to window functions |
| **SQL JOINs** | 2 pts | All 5 JOIN types working correctly with meaningful interpretations |
| **Window Functions** | 4 pts | All 4 categories (Ranking, Aggregate, Navigation, Distribution) implemented correctly (1 pt each) |
| **Analysis** | 1 pt | Descriptive, Diagnostic, and Prescriptive insights provided |
| **Technical Quality** | 1 pt | GitHub setup, clean code, professional README, references, integrity statement |

---

## 💡 PRO TIPS FOR SUCCESS

1. **Start Early**: Don't wait until deadline day
2. **Test Incrementally**: Run each query as you write it
3. **Document as You Go**: Write interpretations immediately after writing queries
4. **Use Comments**: Add comments to explain complex SQL logic
5. **Version Control**: Commit frequently to GitHub with meaningful messages
6. **Ask for Help**: If stuck, review Oracle documentation or class notes
7. **Peer Review**: Have a friend check your README for clarity (but don't share code!)
8. **Backup Everything**: Keep copies of all files locally and on GitHub

---

## 📞 TROUBLESHOOTING

**Problem:** "Table or view does not exist"
**Solution:** Run `01_schema_creation.sql` first

**Problem:** "Foreign key constraint violated"
**Solution:** Insert data in correct order: Students → Courses → Enrollments

**Problem:** "Invalid window function syntax"
**Solution:** Check Oracle version (should be 12c or later for all window functions)

**Problem:** "GitHub repository not accessible"
**Solution:** Verify repository is set to PUBLIC in settings

**Problem:** "Screenshots too large to upload"
**Solution:** Compress PNG files or use smaller resolution (but keep text readable)

---

## ✅ FINAL PRE-SUBMISSION VERIFICATION

Run this checklist 30 minutes before deadline:

```
☐ All SQL files execute without errors
☐ All screenshots are clear and labeled
☐ README.md is complete with no [placeholders]
☐ GitHub repository is PUBLIC
☐ Academic integrity statement has my name and date
☐ References section has at least 3 sources
☐ Email template is ready with correct repository link
☐ Repository name follows format: plsql_window_functions_[studentId]_[firstname]
```

---

## 🎓 GOOD LUCK!

Remember: "Whoever is faithful in very little is also faithful in much." — Luke 16:10

This assignment tests your technical skills, analytical thinking, and professional documentation abilities. Take pride in your work and submit something you're proud of!

---

**Questions?** Review the assignment PDF, Oracle documentation, or class notes. Do NOT use ChatGPT or AI tools - this violates academic integrity and will result in zero marks.

**Time Management:** 
- Schema & Data: 30 minutes
- JOINs: 1 hour
- Window Functions: 2 hours
- Screenshots: 30 minutes
- README: 1 hour
- **Total: ~5 hours** (spread over 2-3 days)

**Deadline:** Friday, February 06, 2026 at 12:00 PM
**Submission:** eric.maniraguha@auca.ac.rw
