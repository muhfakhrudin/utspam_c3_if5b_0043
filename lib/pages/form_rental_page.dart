import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utspam_c3_if5b_0043/db/db_helper.dart';
import 'package:utspam_c3_if5b_0043/models/car.dart';
import 'package:utspam_c3_if5b_0043/pages/home_page.dart';

class FormRentalPage extends StatefulWidget {
  final Car car;
  final String username;

  const FormRentalPage({
    super.key,
    required this.car,
    this.username = "Pengguna",
  });

  @override
  State<FormRentalPage> createState() => _FormRentalPageState();
}

class _FormRentalPageState extends State<FormRentalPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaCtrl = TextEditingController();
  final _lamaCtrl = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _totalBiaya = 0;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _lamaCtrl.dispose();
    super.dispose();
  }

  void _hitungTotal() {
    if (_lamaCtrl.text.isNotEmpty) {
      int lama = int.tryParse(_lamaCtrl.text) ?? 0;
      setState(() {
        _totalBiaya = lama * widget.car.harga;
      });
    }
  }

  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _simpanTransaksi() async {
    if (_formKey.currentState!.validate()) {
      if (_totalBiaya <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Masukkan lama sewa dengan benar")),
        );
        return;
      }

      Map<String, dynamic> dataTransaksi = {
        'carName': widget.car.nama,
        'penyewa': _namaCtrl.text,
        'lamaSewa': int.parse(_lamaCtrl.text),
        'tglSewa': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'totalBiaya': _totalBiaya,
        'status': 'Aktif',
      };

      await DBHelper.instance.addTransaction(dataTransaksi);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sewa Berhasil! Masuk ke Riwayat.")),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(username: widget.username, initialIndex: 2),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Formulir Sewa"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.car.gambar,
                        width: 90,
                        height: 65,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.car_rental,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.car.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Rp ${widget.car.harga} / hari",
                          style: const TextStyle(color: Colors.indigo),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              TextFormField(
                controller: _namaCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Penyewa",
                  prefixIcon: const Icon(Icons.person, color: Colors.indigo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) => val!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _lamaCtrl,
                keyboardType: TextInputType.number,
                onChanged: (val) => _hitungTotal(),
                decoration: InputDecoration(
                  labelText: "Lama Sewa (Hari)",
                  prefixIcon: const Icon(Icons.timer, color: Colors.indigo),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixText: "Hari",
                ),
                validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 15),

              InkWell(
                onTap: _pilihTanggal,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Tanggal Mulai",
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.indigo,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Biaya:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Rp $_totalBiaya",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _simpanTransaksi,
                  child: const Text(
                    "KONFIRMASI SEWA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
