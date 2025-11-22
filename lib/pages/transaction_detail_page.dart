import 'package:flutter/material.dart';
import 'package:utspam_c3_if5b_0043/db/db_helper.dart';
import 'package:utspam_c3_if5b_0043/models/car.dart';
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
    // try to find car image from dummy list
    String? imagePath;
    try {
      imagePath = dummyCars
          .firstWhere((c) => c.nama == _data['carName'])
          .gambar;
    } catch (e) {
      imagePath = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (imagePath != null)
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.directions_car,
                              size: 60,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 140,
                      color: Colors.indigo.shade50,
                      child: const Center(
                        child: Icon(
                          Icons.directions_car,
                          size: 60,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _data['carName'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _data['penyewa'],
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(_data['status']),
                                    backgroundColor: _data['status'] == 'Aktif'
                                        ? Colors.green.shade50
                                        : Colors.grey.shade200,
                                    avatar: Icon(
                                      _data['status'] == 'Aktif'
                                          ? Icons.check_circle
                                          : Icons.info,
                                      color: _data['status'] == 'Aktif'
                                          ? Colors.green
                                          : Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _formatCurrency(_data['totalBiaya']),
                                    style: const TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _detailRow("Penyewa", _data['penyewa']),
                  const Divider(),
                  _detailRow("Tanggal Sewa", _data['tglSewa']),
                  const Divider(),
                  _detailRow("Lama Sewa", "${_data['lamaSewa']} Hari"),
                  const Divider(),
                  _detailRow(
                    "Harga / Hari",
                    _formatCurrency(
                      _data['totalBiaya'] ~/
                          (_data['lamaSewa'] == 0 ? 1 : _data['lamaSewa']),
                    ),
                  ),
                  const Divider(),
                  _detailRow(
                    "Total Biaya",
                    _formatCurrency(_data['totalBiaya']),
                    isBold: true,
                  ),
                  const Divider(),
                  _detailRow(
                    "Status",
                    _data['status'],
                    valueColor: _data['status'] == 'Aktif'
                        ? Colors.green
                        : Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      // Edit
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditRentalPage(transaksi: _data),
                        ),
                      );
                      if (result != null) {
                        setState(() => _data = result);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.indigo.shade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Ubah Pesanan",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAktif ? _batalkanPesanan : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Batalkan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return "Rp 0";
    int v = 0;
    if (value is int)
      v = value;
    else if (value is String)
      v = int.tryParse(value) ?? 0;

    final s = v.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+\b)'),
      (Match m) => '${m[1]}.',
    );
    return 'Rp $s';
  }
}
