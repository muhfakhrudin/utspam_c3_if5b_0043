import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/db_helper.dart'; // Import Database
import '../models/user.dart'; // Import Model User
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller sesuai kebutuhan Soal Rental Mobil [cite: 59-66]
  final _namaCtr = TextEditingController();
  final _nikCtr = TextEditingController(); // Tambahan wajib
  final _alamatCtr = TextEditingController();
  final _noHpCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _usernameCtr = TextEditingController(); // Tambahan wajib
  final _passwordCtr = TextEditingController();

  // Variabel UI
  bool _isObscure = true;

  @override
  void dispose() {
    _namaCtr.dispose();
    _nikCtr.dispose();
    _alamatCtr.dispose();
    _noHpCtr.dispose();
    _emailCtr.dispose();
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  void _prosesRegister() async {
    if (_formKey.currentState!.validate()) {
      User userBaru = User(
        nama: _namaCtr.text,
        nik: _nikCtr.text,
        email: _emailCtr.text,
        telepon: _noHpCtr.text,
        alamat: _alamatCtr.text,
        username: _usernameCtr.text,
        password: _passwordCtr.text,
      );

      await DBHelper.instance.registerUser(userBaru.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi Berhasil! Silakan Login")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // JUDUL
                  const Center(
                    child: Text(
                      'Buat Akun Baru',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo, // Tema Indigo
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      'Silakan daftar untuk mulai menyewa mobil impian Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _namaCtr,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Nama tidak boleh kosong'
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _nikCtr,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'NIK wajib diisi'
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'NIK',
                          prefixIcon: Icon(Icons.badge, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _alamatCtr,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Alamat tidak boleh kosong'
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          prefixIcon: Icon(Icons.home, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _noHpCtr,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'No HP tidak boleh kosong';
                          if (value.length < 10) return 'Minimal 10 digit';
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'No. Telepon',
                          prefixIcon: Icon(Icons.phone, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _emailCtr,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Email kosong';
                          if (!value.contains('@')) return 'Email tidak valid';
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _usernameCtr,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Username wajib diisi'
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.indigo,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _passwordCtr,
                        obscureText: _isObscure,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Password kosong';
                          if (value.length < 6) return 'Minimal 6 karakter';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.indigo,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                setState(() => _isObscure = !_isObscure),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _prosesRegister, 
                      child: const Text(
                        'DAFTAR SEKARANG',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sudah punya akun? ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Masuk disini",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
