-- ## 1. Users & Roles
CREATE TABLE
    users (
        id BIGSERIAL PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        middle_name VARCHAR(100),
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(150) UNIQUE NOT NULL,
        phone VARCHAR(20),
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE
    roles (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(50) UNIQUE NOT NULL
    );

CREATE TABLE
    user_roles (
        user_id BIGINT NOT NULL,
        role_id BIGINT NOT NULL,
        PRIMARY KEY (user_id, role_id),
        CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE RESTRICT
    );

-- ## 2. Academic Structure
CREATE TABLE
    programs (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(150) NOT NULL
    );

CREATE TABLE
    academic_years (
        id BIGSERIAL PRIMARY KEY,
        year_label VARCHAR(20) NOT NULL
    );

CREATE TABLE
    courses (
        id BIGSERIAL PRIMARY KEY,
        course_code VARCHAR(20) NOT NULL,
        name VARCHAR(100) NOT NULL
    );

CREATE TABLE
    student_academic_profiles (
        id BIGSERIAL PRIMARY KEY,
        student_id BIGINT NOT NULL,
        program_id BIGINT NOT NULL,
        academic_year_id BIGINT NOT NULL,
        trimester VARCHAR(10) NOT NULL,
        course_id BIGINT NOT NULL,
        aggregate_marks FLOAT,
        live_backlogs INT DEFAULT 0,
        closed_backlogs INT DEFAULT 0,
        CONSTRAINT fk_sap_student FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE RESTRICT,
        CONSTRAINT fk_sap_program FOREIGN KEY (program_id) REFERENCES programs (id) ON DELETE RESTRICT,
        CONSTRAINT fk_sap_year FOREIGN KEY (academic_year_id) REFERENCES academic_years (id) ON DELETE RESTRICT,
        CONSTRAINT fk_sap_course FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE RESTRICT
    );

-- ## 3. Internship Domain
CREATE TABLE
    companies (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        domain VARCHAR(100),
        industry_type VARCHAR(100)
    );

CREATE TABLE
    company_supervisors (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGINT NOT NULL,
        company_id BIGINT NOT NULL,
        CONSTRAINT fk_cs_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
        CONSTRAINT fk_cs_company FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT
    );

CREATE TABLE
    internship_assignments (
        id BIGSERIAL PRIMARY KEY,
        student_id BIGINT NOT NULL,
        company_id BIGINT NOT NULL,
        college_supervisor_id BIGINT NOT NULL,
        company_supervisor_id BIGINT NOT NULL,
        status VARCHAR(30) NOT NULL,
        start_date DATE,
        end_date DATE,
        CONSTRAINT fk_ia_student FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE RESTRICT,
        CONSTRAINT fk_ia_company FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT,
        CONSTRAINT fk_ia_college_supervisor FOREIGN KEY (college_supervisor_id) REFERENCES users (id) ON DELETE RESTRICT,
        CONSTRAINT fk_ia_company_supervisor FOREIGN KEY (company_supervisor_id) REFERENCES company_supervisors (id) ON DELETE RESTRICT
    );

-- ## 4. Evaluation & Grading
CREATE TABLE
    evaluation_types (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        total_marks INT NOT NULL
    );

CREATE TABLE
    evaluations (
        id BIGSERIAL PRIMARY KEY,
        assignment_id BIGINT NOT NULL,
        evaluation_type_id BIGINT NOT NULL,
        filled_by VARCHAR(50) NOT NULL,
        total_score INT,
        is_locked BOOLEAN DEFAULT FALSE,
        filled_date DATE,
        CONSTRAINT fk_eval_assignment FOREIGN KEY (assignment_id) REFERENCES internship_assignments (id) ON DELETE CASCADE,
        CONSTRAINT fk_eval_type FOREIGN KEY (evaluation_type_id) REFERENCES evaluation_types (id) ON DELETE RESTRICT
    );

CREATE TABLE
    evaluation_criteria (
        id BIGSERIAL PRIMARY KEY,
        evaluation_type_id BIGINT NOT NULL,
        name VARCHAR(200) NOT NULL,
        max_marks INT NOT NULL,
        CONSTRAINT fk_criteria_type FOREIGN KEY (evaluation_type_id) REFERENCES evaluation_types (id) ON DELETE CASCADE
    );

CREATE TABLE
    evaluation_scores (
        id BIGSERIAL PRIMARY KEY,
        evaluation_id BIGINT NOT NULL,
        criteria_id BIGINT NOT NULL,
        marks_obtained INT NOT NULL,
        CONSTRAINT fk_score_eval FOREIGN KEY (evaluation_id) REFERENCES evaluations (id) ON DELETE CASCADE,
        CONSTRAINT fk_score_criteria FOREIGN KEY (criteria_id) REFERENCES evaluation_criteria (id) ON DELETE RESTRICT
    );

-- ## 5. Feedback & Analytics
CREATE TABLE
    feedback_types (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL
    );

CREATE TABLE
    feedback (
        id BIGSERIAL PRIMARY KEY,
        assignment_id BIGINT NOT NULL,
        feedback_type_id BIGINT NOT NULL,
        submitted_by BIGINT NOT NULL,
        submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_feedback_assignment FOREIGN KEY (assignment_id) REFERENCES internship_assignments (id) ON DELETE CASCADE,
        CONSTRAINT fk_feedback_type FOREIGN KEY (feedback_type_id) REFERENCES feedback_types (id) ON DELETE RESTRICT,
        CONSTRAINT fk_feedback_user FOREIGN KEY (submitted_by) REFERENCES users (id) ON DELETE RESTRICT
    );

CREATE TABLE
    feedback_responses (
        id BIGSERIAL PRIMARY KEY,
        feedback_id BIGINT NOT NULL,
        question_key VARCHAR(200) NOT NULL,
        response_value TEXT,
        CONSTRAINT fk_fr_feedback FOREIGN KEY (feedback_id) REFERENCES feedback (id) ON DELETE CASCADE
    );

---
-- ## 6. Documents & Files
CREATE TABLE
    document_types (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(150) NOT NULL,
        is_mandatory BOOLEAN DEFAULT FALSE
    );

CREATE TABLE
    documents (
        id BIGSERIAL PRIMARY KEY,
        assignment_id BIGINT NOT NULL,
        document_type_id BIGINT NOT NULL,
        file_path TEXT NOT NULL,
        uploaded_by BIGINT NOT NULL,
        uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        approval_status VARCHAR(50),
        CONSTRAINT fk_doc_assignment FOREIGN KEY (assignment_id) REFERENCES internship_assignments (id) ON DELETE CASCADE,
        CONSTRAINT fk_doc_type FOREIGN KEY (document_type_id) REFERENCES document_types (id) ON DELETE RESTRICT,
        CONSTRAINT fk_doc_user FOREIGN KEY (uploaded_by) REFERENCES users (id) ON DELETE RESTRICT
    );