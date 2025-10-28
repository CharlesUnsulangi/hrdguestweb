# Implementation Plan — HRD Guest Web

This document breaks down the work into prioritized tasks (MVP → iterative milestones), acceptance
criteria, estimates, and testing/CI steps. Use this as a checklist while developing features.

Goal (MVP)

- Allow applicants to submit an application (multi-step form) with 0..n work experiences, store
  application to backend, and show success page.

Sprint 1 — Core Apply Flow (MVP)

- Tasks
    1. Finalize API contract for `POST /applications` (payload shape). (Owner: Product)
    2. Create DTOs + domain models: `ApplicationDto`, `WorkExperienceDto`, `InterviewResponseDto`. (
       1d)
    3. Implement `ApiService.submitApplication(ApplicationDto)` (HTTP client). (1d)
    4. Implement `ApplicationRepository` (abstract + mock + real). (1d)
    5. Wire `ApplicationViewModel` to use repository and implement `submit()` (0.5d)
    6. Build `ApplicationFormScreen` steps + validation + interview dialogs (1.5d)
    7. Add widget test for form happy path and unit test for view-model mapping (0.5d)
    8. CI: configure GitHub Actions to run `flutter analyze` and `flutter test`. (0.5d)
- Acceptance criteria
    - Form validates required fields, can add/delete experiences, and `submit()` sends expected JSON
      to ApiService.
    - Tests pass on CI.

Sprint 2 — File Uploads + Invite Flow

- Tasks
    1. Add document upload UI (CV, photo) with client-side constraints (size, type). (1d)
    2. Implement `POST /applications/{id}/documents` (multipart) in `ApiService`. (1d)
    3. Implement invite flow: `InviteLoginScreen`, magic-link or OTP entry, token verification
       endpoint. (1.5d)
    4. Persist draft locally (shared_preferences or local DB) to autosave partial forms. (1d)
    5. Tests for upload and invite token flows. (1d)
- Acceptance criteria
    - Upload enforces limits and returns success; invite token lets invited applicant edit the
      application linked to email.

Sprint 3 — Interview Scheduling + Check-in

- Tasks
    1. API endpoints support interview scheduling and confirmation; design schemas if backend
       missing. (0.5d)
    2. Implement `InterviewConfirmationScreen` & booking UI. (1d)
    3. Implement check-in screen (QR/Manual) and `POST /interviews/{id}/checkin`. (1d)
    4. Admin UI (optional): simple interface to view applicants & schedule. (2d)
    5. Tests + E2E flow (simulate schedule → confirm → check-in). (1d)
- Acceptance criteria
    - Applicant can confirm schedule and perform check-in; server records timestamps and status
      updates.

Cross-cutting tasks (happen across sprints)

- Add proper logging & error reporting (safeAsync, show friendly messages). (ongoing)
- Add analytics events (application_submitted, interview_confirmed, checkin). (0.5d)
- Add localization placeholders (text in strings). (0.5d)
- Harden form validations (phone, date formats). (0.5d)
- Security: do not log PII, ensure HTTPS usage. (ongoing)

Testing plan

- Unit tests: DTO ↔ Domain mapping, ViewModel behavior (happy path + error handling)
- Widget tests: ApplicationForm basic flow and interview dialog
- Integration / E2E: optional (use `integration_test` or script) to simulate form submission to
  staging API

CI / Workflow

- GitHub Actions file should run on push/PR to `main`:
    - flutter pub get
    - flutter analyze
    - flutter test --coverage
    - flutter build web --release (optional smoke build)
- Require green CI before merging feature branches.

Deliverables by end of MVP

- Working apply form on web with basic validations
- DTOs, repository, ApiService wired to backend (or mock)
- Unit & widget tests, CI verifying analyze/test
- Docs: `docs/workflow.md`, `docs/implementation_plan.md`, diagrams

How I can help next (pick one)

- Scaffold the DTOs + repository + mapper + update view-model to use repository (mock mode). (
  Recommended next step)
- Generate GitHub Issues from the Sprint 1 tasks (I can create a checklist you can create issues
  from).
- Implement CI workflow file (`.github/workflows/flutter-ci.yml`) and push to repo.

If you want the scaffold, say “Scaffold MVP now” and I’ll create the DTOs, mapper, repository (
mock), and update the view-model wiring.
