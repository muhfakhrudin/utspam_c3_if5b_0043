import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utspam_c3_if5b_0043/db/db_helper.dart';

class EditRentalPage extends StatefulWidget {
  final Map<String, dynamic> transaksi;

  const EditRentalPage({super.key, required this.transaksi});

  @override
  State<EditRentalPage> createState() => _EditRentalPageState();
}

class _EditRentalPageState extends State<EditRentalPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaCtrl;
  late TextEditingController _lamaCtrl;

  late DateTime _selectedDate;
  int _totalBiaya = 0;

  late int _hargaPerHari;

  @override
  void initState() {
    super.initState();

    _namaCtrl = TextEditingController(text: widget.transaksi['penyewa']);

    _lamaCtrl = TextEditingController(
      text: widget.transaksi['lamaSewa'].toString(),
    );

    try {
      _selectedDate = DateFormat(
        'yyyy-MM-dd',
      ).parse(widget.transaksi['tglSewa']);
    } catch (e) {
      _selectedDate = DateTime.now();
    }

    _totalBiaya = widget.transaksi['totalBiaya'];

    int lamaLama = widget.transaksi['lamaSewa'];
    if (lamaLama > 0) {
      _hargaPerHari = (_totalBiaya / lamaLama).round();
    } else {
      _hargaPerHari = 0;
    }
  }

  void _hitungTotal() {
    if (_lamaCtrl.text.isNotEmpty) {
      int lamaBaru = int.tryParse(_lamaCtrl.text) ?? 0;
      setState(() {
        _totalBiaya = lamaBaru * _hargaPerHari;
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

  void _simpanPerubahan() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> dataBaru = {
        'id': widget.transaksi['id'],
        'carName': widget.transaksi['carName'],
        'penyewa': _namaCtrl.text,
        'lamaSewa': int.parse(_lamaCtrl.text),
        'tglSewa': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'totalBiaya': _totalBiaya,
        'status': 'Aktif',
      };

      await DBHelper.instance.updateTransaction(dataBaru);

      if (mounted) {
        Navigator.pop(context, dataBaru);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Berhasil Diupdate!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Pesanan"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Penyewa",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.indigo),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _lamaCtrl,
                keyboardType: TextInputType.number,
                onChanged: (v) => _hitungTotal(),
                decoration: InputDecoration(
                  labelText: "Lama Sewa (Hari)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.timer, color: Colors.indigo),
                  suffixText: "Hari",
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              InkWell(
                onTap: _pilihTanggal,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Tanggal Mulai",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.indigo,
                    ),
                  ),
                  child: Text(
                    DateFormat('dd MMMM yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const Divider(height: 40),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Baru:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rp $_totalBiaya",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _simpanPerubahan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "SIMPAN PERUBAHAN",
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
