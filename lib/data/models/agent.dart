import 'package:equatable/equatable.dart';

class Agent extends Equatable {
  const Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.image,
  });

  final String id;
  final String name;
  final String email;
  final String token;
  final String? image;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'token': token,
        'image': image,
      };

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        token: (json['token'] ?? '').toString(),
        image: (json['image'] ?? '').toString().trim().isEmpty
            ? null
            : (json['image'] ?? '').toString(),
      );

  @override
  List<Object?> get props => [id, name, email, token, image];
}
