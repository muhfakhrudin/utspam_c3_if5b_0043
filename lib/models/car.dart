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
    gambar: "assets/images/Toyota Alphard.jpg",
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
  Car(
    nama: "Mitsubishi Pajero",
    tipe: "SUV",
    harga: 800000,
    gambar: "assets/images/Pajero.jpg",
  ),
  Car(
    nama: "Honda Civic",
    tipe: "Sedan",
    harga: 900000,
    gambar: "assets/images/Civic.jpg",
  ), 
  Car(
    nama: "Daihatsu Gran Max PU",
    tipe: "Pickup",
    harga: 250000,
    gambar: "assets/images/granmax.jpg",
  ),
];
