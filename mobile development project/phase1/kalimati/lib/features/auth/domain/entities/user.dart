import 'package:floor/floor.dart';
import 'package:class_manager/features/auth/domain/enums/user_role.dart';

@Entity(
  tableName: 'users',
  indices: [
    Index(value: ['email'], unique: true),
  ],
)
class User {
  @primaryKey
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final UserRole role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final id =
        json['id'] as String? ??
        DateTime.now().millisecondsSinceEpoch.toString();

    UserRole role;
    final roleString = (json['role'] as String? ?? '').toLowerCase();
    if (roleString == 'teacher') {
      role = UserRole.teacher;
    } else if (roleString == 'student') {
      role = UserRole.student;
    } else {
      role = UserRole.student;
    }

    return User(
      id: id,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
