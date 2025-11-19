class Car {
  final String nama;
  final String tipe;
  final int harga;
  final String gambar; // Path asset

  Car({
    required this.nama,
    required this.tipe,
    required this.harga,
    required this.gambar,
  });
}

final List<Car> dummyCars = [
  Car(
    nama: "Toyota Avanza",
    tipe: "MPV",
    harga: 300000,
    gambar: "assets/images/avanza.jpg", //gamabr nantia e lah
  ),
  Car(
    nama: "Honda Brio",
    tipe: "City Car",
    harga: 250000,
    gambar: "assets/images/brio.jpg",
  ),
  Car(
    nama: "Suzuki Ertiga",
    tipe: "MPV",
    harga: 280000,
    gambar: "assets/images/ertiga.jpg",
  ),
];
