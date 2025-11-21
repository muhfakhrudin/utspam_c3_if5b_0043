class Car {
  final String nama;
  final String tipe;
  final int harga;
  final String gambar;

  Car({
    required this.nama,
    required this.tipe,
    required this.harga,
    required this.gambar,
  });
}

final List<Car> dummyCars = [
  Car(
    nama: "Toyota Alphard",
    tipe: "Luxury",
    harga: 2500000,
    gambar: "assets/images/alphard.jpg",
  ),
  Car(
    nama: "Honda Brio",
    tipe: "City Car",
    harga: 250000,
    gambar: "assets/images/brio.jpg",
  ),
  Car(
    nama: "Toyota Innova Reborn",
    tipe: "Premium MPV",
    harga: 700000,
    gambar: "assets/images/ertiga.jpg",
  ),
];
