# IMP-STEP-1: System Architecture & Tech Stack

## 1. Purpose

This document defines the approved system architecture and technology stack for the Internship Management Portal (IMP). It serves as the technical foundation for all subsequent design and development steps.

---

## 2. High-Level Architecture

The system follows a modular, API-first, client–server architecture.

**Architecture Overview:**

- Frontend communicates with Backend via REST APIs
- Backend handles business logic, RBAC, persistence, and integrations
- Database stores all academic, evaluation, and workflow data
- File Storage manages internship-related documents
- Analytics & NLP services are introduced incrementally

```
[ React + TypeScript Frontend ]
            |
            | REST APIs (JSON)
            v
[ Backend API (NestJS) ]
     |              |
     |              |
[ PostgreSQL ]   [ File Storage ]
                       |
                 [ NLP / Analytics Services ] (Phase 3+)
```

---

## 3. Backend Stack

**Framework:** NestJS (Node.js + TypeScript)

**Rationale:**

- Strong modular architecture
- Built-in dependency injection
- First-class support for RBAC, guards, interceptors
- Clean separation of concerns
- Scales well for analytics and NLP microservices

**Core Backend Components:**

- NestJS Modules
- Controllers (REST endpoints)
- Services (business logic)
- DTOs with validation
- Guards for authentication & authorization

---

## 4. Frontend Stack

**Framework:** React + TypeScript

**Rationale:**

- Suitable for complex, role-based dashboards
- Handles large dynamic forms and workflows
- Strong ecosystem for analytics and charts

**Planned Supporting Libraries (later stages):**

- React Query (data fetching)
- React Hook Form (form handling)
- Charting libraries for analytics

---

## 5. Database

**Database:** PostgreSQL

**Rationale:**

- Strong relational integrity
- Advanced querying and indexing
- JSONB support for feedback and analytics
- Better long-term scalability compared to MySQL

**Note:**

- Database schema will be redesigned from scratch
- Legacy DB is used only as a functional reference

---

## 6. Authentication & Authorization

**Authentication:**

- JWT-based authentication

**Authorization:**

- Role-Based Access Control (RBAC)
- Role guards at API level

**Primary Roles:**

- Superuser / Internship Coordinator
- College Supervisor
- Company Supervisor
- Student

(Role definitions are derived from approved project documents)

---

## 7. File Storage

**Purpose:**

- Internship documents
- Reports, PPTs, PDFs, DOC/DOCX, ODT, ODS
- Approval emails and proofs

**Strategy:**

- Phase 1–2: Local storage (development)
- Phase 3+: S3-compatible object storage (AWS S3 / MinIO)

---

## 8. Analytics & NLP (Planned)

- Introduced incrementally in later phases
- Implemented as separate services if required
- Keyword extraction, feedback analysis, JD analysis

---

## 9. Repository Structure

```
internship-management-portal/
├── backend/
├── frontend/
├── docs/
│   └── architecture.md
└── README.md
```

---

## 10. GitHub Milestone

**Milestone:** Architecture & Tech Stack Finalized

**Suggested Commit Message:**

```
chore: finalize system architecture and tech stack
```

This milestone represents a stable foundation for database and API design.