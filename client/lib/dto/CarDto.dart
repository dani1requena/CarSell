class CarDto {
  final String photo;
  final String brand;
  final int kilometer;
  final int horsepower;

  CarDto({
    required this.photo,
    required this.brand,
    required this.kilometer,
    required this.horsepower,
  });
  factory CarDto.fromJson(Map<String, dynamic> json) {
    return CarDto(
      photo: json['photo'],
      brand: json['brand'],
      kilometer: json['kilometer'],
      horsepower: json['horsepower'],
    );
  }
}
