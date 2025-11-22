import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utspam_c3_if5b_0043/db/db_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBHelper.instance.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text(
                    "Belum ada riwayat sewa",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final transaction = data[data.length - 1 - index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transaction['carName'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: transaction['status'] == 'Aktif'
                                  ? Colors.green[50]
                                  : Colors.red[50],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: transaction['status'] == 'Aktif'
                                    ? Colors.green
                                    : Colors.red,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              transaction['status'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: transaction['status'] == 'Aktif'
                                    ? Colors.green[700]
                                    : Colors.red[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            transaction['tglSewa'],
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(width: 15),

                          const Icon(Icons.timer, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            "${transaction['lamaSewa']} Hari",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Biaya",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Rp ${transaction['totalBiaya']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Detail Transaksi (Coming Soon)",
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.indigo),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Lihat Detail",
                              style: TextStyle(color: Colors.indigo),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
