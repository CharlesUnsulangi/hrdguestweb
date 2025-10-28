import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/validators.dart';
import '../view_models/application_view_model.dart';

class ApplicationFormScreen extends StatefulWidget {
  final String role;

  const ApplicationFormScreen({super.key, required this.role});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  // controllers for personal data
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  // keterangan diri
  final TextEditingController _jenisCtrl = TextEditingController();
  final TextEditingController _agamaCtrl = TextEditingController();
  final TextEditingController _tglLahirCtrl = TextEditingController();
  final TextEditingController _kotaLhrCtrl = TextEditingController();
  final TextEditingController _pendidikanCtrl = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // When using view model, initial population occurs there; keep local application for compatibility
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ApplicationViewModel>(
      create: (_) => ApplicationViewModel(role: widget.role),
      child: Consumer<ApplicationViewModel>(
        builder: (context, vm, _) {
          // Reuse existing controllers but sync to view model on page change/submit
          return Scaffold(
            appBar: AppBar(title: const Text('Form Aplikasi')),
            body: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              children: [
                _personalPage(vm),
                _keteranganPage(vm),
                _experiencePage(vm),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _personalPage(ApplicationViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Data Diri (Posisi: ${widget.role})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Nama'),
            onChanged: (v) => vm.updatePersonal(name: v),
            validator: (v) => isNotEmpty(v) ? null : 'Nama kosong',
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(labelText: 'HP'),
            keyboardType: TextInputType.phone,
            onChanged: (v) => vm.updatePersonal(phone: v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => vm.updatePersonal(email: v),
            validator: (v) => looksLikeEmail(v) ? null : 'Email tidak valid',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(onPressed: _next, child: const Text('Lanjut')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keteranganPage(ApplicationViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Keterangan Diri',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _jenisCtrl,
            decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
            onChanged: (v) => vm.updateKeterangan(jenis: v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _agamaCtrl,
            decoration: const InputDecoration(labelText: 'Agama'),
            onChanged: (v) => vm.updateKeterangan(agama: v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _tglLahirCtrl,
            decoration: const InputDecoration(
              labelText: 'Tanggal Lahir (YYYY-MM-DD)',
            ),
            onChanged: (v) => vm.updateKeterangan(tglLahir: v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _kotaLhrCtrl,
            decoration: const InputDecoration(labelText: 'Kota Lahir'),
            onChanged: (v) => vm.updateKeterangan(kota: v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _pendidikanCtrl,
            decoration: const InputDecoration(labelText: 'Pendidikan Terakhir'),
            onChanged: (v) => vm.updateKeterangan(pendidikan: v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: _previous,
                child: const Text('Kembali'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _next, child: const Text('Lanjut')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _experiencePage(ApplicationViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Pengalaman Kerja',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: vm.application.experiences.isEmpty
                ? Center(
                    child: TextButton(
                      onPressed: vm.addExperience,
                      child: const Text('Tambah Pengalaman'),
                    ),
                  )
                : ListView.builder(
                    itemCount: vm.application.experiences.length,
                    itemBuilder: (context, index) {
                      final exp = vm.application.experiences[index];
                      final resp = vm.application.interviewResponses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Perusahaan: ${exp.companyName.isEmpty ? '(belum diisi)' : exp.companyName}',
                                  ),
                                  IconButton(
                                    onPressed: () => vm.removeExperience(index),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                              TextFormField(
                                initialValue: exp.companyName,
                                decoration: const InputDecoration(
                                  labelText: 'Perusahaan',
                                ),
                                onChanged: (v) {
                                  exp.companyName = v;
                                  vm.updateExperience(index, exp);
                                },
                              ),
                              TextFormField(
                                initialValue: exp.hrdName,
                                decoration: const InputDecoration(
                                  labelText: 'Nama HRD',
                                ),
                                onChanged: (v) {
                                  exp.hrdName = v;
                                  vm.updateExperience(index, exp);
                                },
                              ),
                              TextFormField(
                                initialValue: exp.hrdPhone,
                                decoration: const InputDecoration(
                                  labelText: 'Tel HRD',
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (v) {
                                  exp.hrdPhone = v;
                                  vm.updateExperience(index, exp);
                                },
                              ),
                              TextFormField(
                                initialValue: exp.supervisorName,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Atasan',
                                ),
                                onChanged: (v) {
                                  exp.supervisorName = v;
                                  vm.updateExperience(index, exp);
                                },
                              ),
                              TextFormField(
                                initialValue: exp.supervisorPhone,
                                decoration: const InputDecoration(
                                  labelText: 'Tel Atasan',
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (v) {
                                  exp.supervisorPhone = v;
                                  vm.updateExperience(index, exp);
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: exp.startDate,
                                      decoration: const InputDecoration(
                                        labelText: 'Mulai Kerja (YYYY-MM-DD)',
                                      ),
                                      onChanged: (v) {
                                        exp.startDate = v;
                                        vm.updateExperience(index, exp);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: exp.endDate,
                                      decoration: const InputDecoration(
                                        labelText: 'Selesai Kerja (YYYY-MM-DD)',
                                      ),
                                      onChanged: (v) {
                                        exp.endDate = v;
                                        vm.updateExperience(index, exp);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: exp.initialPosition,
                                      decoration: const InputDecoration(
                                        labelText: 'Jabatan Awal',
                                      ),
                                      onChanged: (v) {
                                        exp.initialPosition = v;
                                        vm.updateExperience(index, exp);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: exp.finalPosition,
                                      decoration: const InputDecoration(
                                        labelText: 'Jabatan Akhir',
                                      ),
                                      onChanged: (v) {
                                        exp.finalPosition = v;
                                        vm.updateExperience(index, exp);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: exp.initialSalary,
                                      decoration: const InputDecoration(
                                        labelText: 'Gaji Awal',
                                      ),
                                      onChanged: (v) {
                                        exp.initialSalary = v;
                                        vm.updateExperience(index, exp);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: exp.finalSalary,
                                      decoration: const InputDecoration(
                                        labelText: 'Gaji Akhir',
                                      ),
                                      onChanged: (v) {
                                        exp.finalSalary = v;
                                        vm.updateExperience(index, exp);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                initialValue: exp.resignationReason,
                                decoration: const InputDecoration(
                                  labelText: 'Alasan Resign',
                                ),
                                onChanged: (v) {
                                  exp.resignationReason = v;
                                  vm.updateExperience(index, exp);
                                },
                              ),
                              TextFormField(
                                initialValue: exp.duties,
                                decoration: const InputDecoration(
                                  labelText: 'Ceritakan tugas Anda',
                                ),
                                maxLines: 3,
                                onChanged: (v) {
                                  exp.duties = v;
                                  vm.updateExperience(index, exp);
                                },
                              ),
                              const SizedBox(height: 8),
                              const Text('Rating (1-5)'),
                              Row(
                                children: [
                                  const Text('Kepuasan:'),
                                  Slider(
                                    value: exp.satisfactionRating.toDouble(),
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    label: exp.satisfactionRating.toString(),
                                    onChanged: (v) => setState(() {
                                      exp.satisfactionRating = v.toInt();
                                      vm.updateExperience(index, exp);
                                    }),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Kesuksesan:'),
                                  Slider(
                                    value: exp.successRating.toDouble(),
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    label: exp.successRating.toString(),
                                    onChanged: (v) => setState(() {
                                      exp.successRating = v.toInt();
                                      vm.updateExperience(index, exp);
                                    }),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Kualitas Perusahaan:'),
                                  Slider(
                                    value: exp.companyQualityRating.toDouble(),
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    label: exp.companyQualityRating.toString(),
                                    onChanged: (v) => setState(() {
                                      exp.companyQualityRating = v.toInt();
                                      vm.updateExperience(index, exp);
                                    }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () =>
                                    _showInterviewDialog(vm, index),
                                child: const Text(
                                  'Isi Interview untuk pengalaman ini',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: _previous,
                child: const Text('Kembali'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: vm.addExperience,
                child: const Text('Tambah Pengalaman'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final ok = await vm.submit();
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Aplikasi berhasil dikirim'),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal mengirim aplikasi')),
                    );
                  }
                },
                child: vm.loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Kirim Aplikasi'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInterviewDialog(ApplicationViewModel vm, int index) {
    final resp = vm.application.interviewResponses[index];
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController successCtrl = TextEditingController(
          text: resp.successDescription,
        );
        final TextEditingController challengeCtrl = TextEditingController(
          text: resp.challengeDescription,
        );
        final TextEditingController qualityCtrl = TextEditingController(
          text: resp.jobQualityDescription,
        );
        final TextEditingController negativeCtrl = TextEditingController(
          text: resp.negativeAspects,
        );
        final TextEditingController positiveCtrl = TextEditingController(
          text: resp.positiveAspects,
        );
        final TextEditingController conflictCtrl = TextEditingController(
          text: resp.conflictStory,
        );
        final TextEditingController lookingCtrl = TextEditingController(
          text: resp.whatAreYouLookingFor,
        );
        return AlertDialog(
          title: Text('Interview - Pengalaman ${index + 1}'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: successCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Ceritakan seberapa sukses Anda?',
                  ),
                  maxLines: 3,
                ),
                TextField(
                  controller: challengeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Seberapa sulit tantangan?',
                  ),
                  maxLines: 3,
                ),
                TextField(
                  controller: qualityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Seberapa bagus kualitas pekerjaan?',
                  ),
                  maxLines: 3,
                ),
                TextField(
                  controller: negativeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Apa yang kurang baik di sana?',
                  ),
                  maxLines: 3,
                ),
                TextField(
                  controller: positiveCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Apa yang baik di sana?',
                  ),
                  maxLines: 3,
                ),
                TextField(
                  controller: conflictCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Ceritakan satu konflik yang pernah terjadi',
                  ),
                  maxLines: 3,
                ),
                TextField(
                  controller: lookingCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Apa yang Anda cari sekarang?',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  resp.successDescription = successCtrl.text.trim();
                  resp.challengeDescription = challengeCtrl.text.trim();
                  resp.jobQualityDescription = qualityCtrl.text.trim();
                  resp.negativeAspects = negativeCtrl.text.trim();
                  resp.positiveAspects = positiveCtrl.text.trim();
                  resp.conflictStory = conflictCtrl.text.trim();
                  resp.whatAreYouLookingFor = lookingCtrl.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _next() {
    if (_pageIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previous() {
    if (_pageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
