class UserModel {
  String id;
  final String name, email;
  final int score;

  UserModel({
    this.id = '',
    required this.name,
    required this.email,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "score": score,
      };
}
