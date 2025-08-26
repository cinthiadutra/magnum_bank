
class UserProfile {
  final String name;
  final String email;
  final int age;
  final List<String> hobbies;
  final int postCount;

  UserProfile({
    required this.name,
    required this.email,
    required this.age,
    required this.hobbies,
    required this.postCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'hobbies': hobbies,
      'postCount': postCount,
    };
  }
}