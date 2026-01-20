# IMP-DB-2: Logical ERD & PostgreSQL Table Design

This document finalizes the **logical database design** for the Internship Management Portal (IMP), based on:

* Approved Architecture (IMP-STEP-1)
* Approved Conceptual ERD (IMP-DB-1)
* Primary Key strategy: **BIGSERIAL** (approved)

> Scope: Logical schema (PostgreSQL-ready), no ORM or migration tooling yet.

---

## 1. Design Conventions (Locked)

* **Primary Keys:** BIGSERIAL
* **Foreign Keys:** Explicit, enforced
* **Timestamps:** `created_at`, `updated_at` where relevant
* **Delete Rules:**

  * RESTRICT for academic/core data
  * CASCADE for dependent child records (scores, responses)

---

## 2. User & Role Tables

### users

* id (BIGSERIAL, PK)
* first_name (VARCHAR)
* middle_name (VARCHAR, NULLABLE)
* last_name (VARCHAR)
* email (VARCHAR, UNIQUE, NOT NULL)
* phone (VARCHAR)
* is_active (BOOLEAN, DEFAULT TRUE)
* created_at (TIMESTAMP)

---

### roles

* id (BIGSERIAL, PK)
* name (VARCHAR, UNIQUE)

---

### user_roles

* user_id (BIGINT, FK → users.id)
* role_id (BIGINT, FK → roles.id)

**Primary Key:** (user_id, role_id)

---

## 3. Academic Structure Tables

### programs

* id (BIGSERIAL, PK)
* name (VARCHAR)

---

### academic_years

* id (BIGSERIAL, PK)
* year_label (VARCHAR)

---

### courses

* id (BIGSERIAL, PK)
* course_code (VARCHAR)
* name (VARCHAR)

---

### student_academic_profiles

* id (BIGSERIAL, PK)
* student_id (BIGINT, FK → users.id)
* program_id (BIGINT, FK → programs.id)
* academic_year_id (BIGINT, FK → academic_years.id)
* trimester (VARCHAR)
* course_id (BIGINT, FK → courses.id)
* aggregate_marks (FLOAT)
* live_backlogs (INT)
* closed_backlogs (INT)

---

## 4. Internship Tables

### companies

* id (BIGSERIAL, PK)
* name (VARCHAR)
* domain (VARCHAR)
* industry_type (VARCHAR)

---

### company_supervisors

* id (BIGSERIAL, PK)
* user_id (BIGINT, FK → users.id)
* company_id (BIGINT, FK → companies.id)

---

### internship_assignments

> Central table controlling the internship lifecycle

* id (BIGSERIAL, PK)
* student_id (BIGINT, FK → users.id)
* company_id (BIGINT, FK → companies.id)
* college_supervisor_id (BIGINT, FK → users.id)
* company_supervisor_id (BIGINT, FK → company_supervisors.id)
* status (VARCHAR)
* start_date (DATE)
* end_date (DATE)

---

## 5. Evaluation & Grading Tables

### evaluation_types

* id (BIGSERIAL, PK)
* name (VARCHAR)
* total_marks (INT)

---

### evaluations

* id (BIGSERIAL, PK)
* assignment_id (BIGINT, FK → internship_assignments.id)
* evaluation_type_id (BIGINT, FK → evaluation_types.id)
* filled_by (VARCHAR)
* total_score (INT)
* is_locked (BOOLEAN, DEFAULT FALSE)
* filled_date (DATE)

---

### evaluation_criteria

* id (BIGSERIAL, PK)
* evaluation_type_id (BIGINT, FK → evaluation_types.id)
* name (VARCHAR)
* max_marks (INT)

---

### evaluation_scores

* id (BIGSERIAL, PK)
* evaluation_id (BIGINT, FK → evaluations.id)
* criteria_id (BIGINT, FK → evaluation_criteria.id)
* marks_obtained (INT)

---

## 6. Feedback & Analytics Tables

### feedback_types

* id (BIGSERIAL, PK)
* name (VARCHAR)

---

### feedback

* id (BIGSERIAL, PK)
* assignment_id (BIGINT, FK → internship_assignments.id)
* feedback_type_id (BIGINT, FK → feedback_types.id)
* submitted_by (BIGINT, FK → users.id)
* submitted_at (TIMESTAMP)

---

### feedback_responses

* id (BIGSERIAL, PK)
* feedback_id (BIGINT, FK → feedback.id)
* question_key (VARCHAR)
* response_value (TEXT)

---

## 7. Document & File Tables

### document_types

* id (BIGSERIAL, PK)
* name (VARCHAR)
* is_mandatory (BOOLEAN)

---

### documents

* id (BIGSERIAL, PK)
* assignment_id (BIGINT, FK → internship_assignments.id)
* document_type_id (BIGINT, FK → document_types.id)
* file_path (TEXT)
* uploaded_by (BIGINT, FK → users.id)
* uploaded_at (TIMESTAMP)
* approval_status (VARCHAR)

---

## 8. Status of This Step

* Logical ERD finalized
* PostgreSQL-compatible
* Ready for SQL schema generation

**Next Milestone:** IMP-DB-3 — SQL Schema & Constraints
