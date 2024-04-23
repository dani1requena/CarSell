class CarDto {
  final int id;
  final String photo;
  final String brand;
  final int kilometer;
  final int horsepower;

  CarDto({
    required this.id,
    required this.photo,
    required this.brand,
    required this.kilometer,
    required this.horsepower,
  });
  factory CarDto.fromJson(Map<String, dynamic> json) {
    return CarDto(
      id: json['id'],
      photo: json['photo'],
      brand: json['brand'],
      kilometer: json['kilometer'],
      horsepower: json['horsepower'],
    );
  }
}
