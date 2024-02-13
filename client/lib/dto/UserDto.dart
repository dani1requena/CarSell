class UserDto {
  final String username;
  final String password;
  final String email;

  UserDto({
    required this.username,
    required this.password,
    required this.email,
  });
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      username: json['username'],
      password: json['password'],
      email: json['email'],
    );
  }
}
