import 'package:flutter/material.dart';
import 'package:utspam_c3_if5b_0043/db/db_helper.dart';
import 'edit_rental_page.dart';


class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> transaksi;
  const TransactionDetailPage({super.key, required this.transaksi});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late Map<String, dynamic> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.transaksi;
  }

  void _batalkanPesanan() async {
    Map<String, dynamic> updatedRow = Map.from(_data);
    updatedRow['status'] = 'Dibatalkan';

    await DBHelper.instance.updateTransaction(updatedRow);

    setState(() {
      _data = updatedRow;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Pesanan Dibatalkan")));
  }

  @override
  Widget build(BuildContext context) {
    bool isAktif = _data['status'] == 'Aktif';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.directions_car,
                size: 40,
                color: Colors.indigo,
              ),
              title: Text(
                _data['carName'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Text("Rp ${_data['totalBiaya']}"),
            ),
            const Divider(),

            _baris("Penyewa", _data['penyewa']),
            _baris("Tanggal", _data['tglSewa']),
            _baris("Lama Sewa", "${_data['lamaSewa']} Hari"),
            _baris("Status", _data['status']),

            const SizedBox(height: 30),

            if (isAktif)
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditRentalPage( transaksi: _data)),
                  );
                  if (result != null) {
                    setState(() => _data = result);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  "EDIT PESANAN",
                  style: TextStyle(color: Colors.white),
                ),
              ),

            const SizedBox(height: 10),

            if (isAktif)
              ElevatedButton(
                onPressed: _batalkanPesanan,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  "BATALKAN PESANAN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
