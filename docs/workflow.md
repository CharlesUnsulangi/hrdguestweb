# Workflow: Pelamar & Interview (HRD Guest Web)

Dokumentasi alur kerja aplikasi pendaftaran pelamar, termasuk top-level flows, layar yang terlibat,
data utama, dan acceptance criteria.

Tujuan

- Menyediakan referensi teknis & fungsional untuk pengembangan fitur pendaftaran pelamar, undangan,
  konfirmasi interview, dan check-in.
- Menjaga agar implementasi sesuai kebutuhan bisnis dan mudah divalidasi oleh QA.

Ringkasan alur utama

1. Apply (Pelamar baru)
    - Halaman: Landing → Pilih posisi (driver / staff) → ApplyForm (multi-step)
    - Data dikumpulkan: Data diri, Keterangan diri, Pengalaman kerja (n entries), Interview
      responses (per pengalaman)
    - Output: Application record (status: `applied`)
    - Notifikasi: Tampilkan success, kirim email konfirmasi (opsional)

2. Invite & Complete (Pelamar yang diundang)
    - Admin membuat invite (email atau token)
    - Pelamar membuka link / memasukkan kode → login (magic link atau one-time code)
    - Pelamar melihat prefilling email, melengkapi data ↦ Application updated (status:
      `completing` → `completed`)

3. Schedule & Confirm Interview
    - Admin jadwalkan interview untuk applicant (create Interview document)
    - Pelamar menerima notifikasi/link → opens InterviewConfirmationScreen
    - Pelamar pilih opsi tanggal/waktu yang tersedia → konfirmasi (status interview: `confirmed`)

4. Check-in on site
    - Saat hari H, pelamar buka link/login atau scan QR → tekan "Check In"
    - App records check-in timestamp ± lokasi (opsional)
    - Update Interview status: `checked_in` dan catat attendance data

Layar (screens) utama

- LandingScreen
    - Tombol: Melamar Driver, Melamar Staff, Login undangan, Konfirmasi Interview, Check-in
- ApplicationFormScreen (multi-step)
    - Step 1: Data Diri (nama, hp, email, posisi)
    - Step 2: Keterangan Diri (jenis kelamin, agama, tgl lahir, kota lahir, pendidikan)
    - Step 3: Pengalaman Kerja (dynamic list) — tiap item punya tombol untuk membuka
      InterviewResponse dialog
- ContactFormScreen (support)
- InviteLoginScreen / MagicLinkScreen (untuk pelamar yang diundang)
- InterviewConfirmationScreen (lihat & konfirmasi slot)
- CheckInScreen (bukti kedatangan)
- Admin screens (opsional, web or separate app)

Model data (intinya)

- Applicant / Application
    - id, fullName, email, phone, position, jenisKelamin, agama, tanggalLahir, kotaLahir,
      pendidikanTerakhir
    - experiences: list of WorkExperience
    - interviewResponses: list of InterviewResponse (parallel per experience)
    - status: enum (applied, invited, completing, completed, scheduled, confirmed, checked_in,
      rejected, hired)
    - timestamps: appliedAt, updatedAt

- WorkExperience
    - companyName, hrdName, hrdPhone, supervisorName, supervisorPhone,
      startDate, endDate, initialPosition, finalPosition, initialSalary, finalSalary,
      resignationReason, duties, satisfactionRating, successRating, companyQualityRating

- Interview
    - id, applicantId, scheduledAt, status (scheduled/confirmed/cancelled/done), location, notes

- Checkin
    - id, interviewId, applicantId, checkinAt, method (qr/manual), locationCoordinates

Acceptance Criteria (per fitur)

- Apply
    - Form harus menyimpan data minimal (nama, email valid, posisi)
    - Pengalaman kerja dapat ditambah/dihapus (0..n)
    - Interview responses dapat diisi per pengalaman
    - Setelah submit, backend menerima payload yang cocok dengan Application.toJson()

- Invite & Complete
    - Invite token hanya berlaku sesuai expiry
    - Pelamar hanya bisa memperbarui data mereka sendiri (auth/claim)

- Schedule & Confirm
    - Pelamar menerima informasi tanggal & lokasi interview
    - Setelah konfirmasi, interview entry mengubah status dan mengunci slot jika perlu

- Check-in
    - Check-in mencatat waktu server
    - Jika geolocation dipakai, masukan validasi (within radius) atau gunakan QR

Edge cases & Validasi

- Tanggal: simpan UTC, tampilkan lokal; validasi format YYYY-MM-DD
- File upload: batasi ukuran & tipe (pdf/jpg/png) — gunakan Storage dengan rules
- Duplicates: deteksi duplikasi aplikasi berdasarkan email + posisi
- Network failures: implement retries / show clear error; gunakan safeAsync wrapper
- Race conditions: always check mounted before calling context after await

Security & Privacy notes

- Jangan log PII (nama/email/phone) ke console di production
- Simpan files dengan access rules (Firebase Storage) dan atur lifecycle policy
- Gunakan HTTPS untuk API; validasi server-side

Instrumentation & Observability

- Integrate Crashlytics only if needed (free tier vs paid—Crashlytics is part of Firebase;
  storage/analytics usage may incur costs at scale but Crashlytics itself is free on Firebase
  Spark/Blaze plans)
- Log key events (application submitted, interview confirmed, check-in) to analytics/event store

Next steps (actions, per priority)

1. Create backend API / Firestore schema and Cloud Function for invite email (MVP)
2. Implement Apply flow with validations and file uploads (frontend + ApiService)
3. Implement Invite login/magic link and CompleteProfile screen
4. Implement Interview scheduling + confirmation
5. Implement Check-in (QR/Geo) + attendance reports
6. Add tests: unit tests for view-models, widget tests for forms, integration test to simulate full
   flow
7. Setup CI (Actions) to run analyze & tests and build web

(Optional) Quick diagram suggestions

- Sequence diagram: Apply -> submit -> store Application -> Admin schedule Interview -> Applicant
  confirm -> Applicant check-in
- ER diagram: Application --< WorkExperience; Application --< Interview; Interview --< Checkin

If you want, saya bisa lanjut dan membuat:

- `docs/implementation_plan.md` (task list with issues/actions per sprint)
- `docs/er_diagram.png` (simple generated diagram) atau text-based mermaid diagram in a `.md` file
- Generate GitHub Issues from top-priority tasks

Konfirmasi: mau saya lanjut buat file rencana implementasi dan task breakdown sekarang? Jika ya,
saya akan membuat `docs/implementation_plan.md` dan (opsional) menambah `docs/mermaid_workflow.md`
berisi diagram mermaid untuk visualisasi.

