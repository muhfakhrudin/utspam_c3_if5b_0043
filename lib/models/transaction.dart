class TransactionModel {
  final int? id;
  final String carName;
  final String penyewa;
  final int lamaSewa;
  final String tglSewa;
  final int totalBiaya;
  final String status;

  TransactionModel({
    this.id,
    required this.carName,
    required this.penyewa,
    required this.lamaSewa,
    required this.tglSewa,
    required this.totalBiaya,
    this.status = 'Aktif',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carName': carName,
      'penyewa': penyewa,
      'lamaSewa': lamaSewa,
      'tglSewa': tglSewa,
      'totalBiaya': totalBiaya,
      'status': status,
    };
  }
}
