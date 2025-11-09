/// User entity representing app user
class User {
  final String id;
  final String email;
  final bool emailVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.createdAt,
  });
}