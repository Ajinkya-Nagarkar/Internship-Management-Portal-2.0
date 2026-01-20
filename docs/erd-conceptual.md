# IMP-DB-1: Core ERD Design (Conceptual)

This document defines the **conceptual Entity–Relationship Design (ERD)** for the Internship Management Portal (IMP). It is derived strictly from approved project documents and locked architecture decisions.

> Scope: Conceptual + Logical entities (no SQL, no implementation details)

---

## 1. User & Role Domain

### Entities

**User**

- user_id (PK)
- first_name
- middle_name
- last_name
- email (official / login)
- phone
- is_active
- created_at

**Role**

- role_id (PK)
- role_name
  (STUDENT, COLLEGE_SUPERVISOR, COMPANY_SUPERVISOR, COORDINATOR)

**UserRole**

- user_id (FK → User)
- role_id (FK → Role)

**Relationships**

- User ⟷ Role : Many-to-Many (via UserRole)

---

## 2. Academic Structure Domain

### Entities

**Program**

- program_id (PK)
- program_name
  (e.g., B.Tech Computer Science & Engineering)

**AcademicYear**

- academic_year_id (PK)
- year_label
  (e.g., 2024–25)

**Trimester**

- trimester_id (PK)
- trimester_code
  (T9 / T10 / T11)

**Course**

- course_id (PK)
- course_code
  (INT300 / INT400)
- course_name (Internship)

**StudentAcademicProfile**

- profile_id (PK)
- student_id (FK → User)
- program_id (FK → Program)
- academic_year_id (FK → AcademicYear)
- trimester_id (FK → Trimester)
- course_id (FK → Course)
- aggregate_marks
- live_backlogs
- closed_backlogs

**Relationships**

- Student → StudentAcademicProfile : One-to-Many

---

## 3. Internship Domain

### Entities

**Company**

- company_id (PK)
- company_name
- domain
- industry_type

**CompanySupervisor**

- company_supervisor_id (PK)
- user_id (FK → User)
- company_id (FK → Company)

**Internship**

- internship_id (PK)
- internship_title
- mode_of_work
  (WFH / Onsite / Hybrid)
- start_date
- end_date

**InternshipAssignment**

- assignment_id (PK)
- student_id (FK → User)
- internship_id (FK → Internship)
- company_id (FK → Company)
- college_supervisor_id (FK → User)
- company_supervisor_id (FK → CompanySupervisor)
- status
  (Assigned / Ongoing / Completed)

**Relationships**

- Student ⟷ Internship : One-to-One (per trimester)
- Internship ⟷ Company : Many-to-One

---

## 4. Evaluation & Grading Domain

### Entities

**EvaluationType**

- evaluation_type_id (PK)
- type_name
  (Periodic-I, Periodic-II, Midterm, Endterm)
- total_marks

**Evaluation**

- evaluation_id (PK)
- assignment_id (FK → InternshipAssignment)
- evaluation_type_id (FK → EvaluationType)
- filled_by
  (College / Company Supervisor)
- total_score
- is_locked
- filled_date

**EvaluationCriteria**

- criteria_id (PK)
- evaluation_type_id (FK → EvaluationType)
- criteria_name
- max_marks

**EvaluationScore**

- score_id (PK)
- evaluation_id (FK → Evaluation)
- criteria_id (FK → EvaluationCriteria)
- marks_obtained

**Relationships**

- Evaluation ⟷ EvaluationCriteria : One-to-Many (via EvaluationScore)

---

## 5. Feedback & Analytics Domain

### Entities

**FeedbackType**

- feedback_type_id (PK)
- type_name
  (StudentFeedback, CompanyStudentFeedback, CompanyProcessFeedback)

**Feedback**

- feedback_id (PK)
- assignment_id (FK → InternshipAssignment)
- feedback_type_id (FK → FeedbackType)
- submitted_by (FK → User)
- submitted_date

**FeedbackResponse**

- response_id (PK)
- feedback_id (FK → Feedback)
- question_key
- response_value

**Relationships**

- Feedback ⟷ FeedbackResponse : One-to-Many

---

## 6. Document & File Domain

### Entities

**DocumentType**

- document_type_id (PK)
- type_name
  (Weekly Report, PPT, Offer Letter, Completion Letter, Logbook)
- is_mandatory

**Document**

- document_id (PK)
- assignment_id (FK → InternshipAssignment)
- document_type_id (FK → DocumentType)
- file_path
- uploaded_by (FK → User)
- uploaded_at
- approval_required
- approval_status

**Relationships**

- InternshipAssignment ⟷ Document : One-to-Many

---

## 7. ERD Design Principles

- All users are normalized into a single User table
- Evaluations are extensible via EvaluationType & Criteria
- Feedback supports both structured and NLP-based responses
- Documents are decoupled from storage implementation

---

## 8. Next Step

This conceptual ERD will now be:

1. Reviewed & approved
2. Converted into a **Logical ERD**
3. Then mapped to PostgreSQL tables

**Suggested Next Milestone:**
IMP-DB-2: Logical ERD & Table Mapping