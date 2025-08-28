class UserProfile {
  final String id;
  final String nome;
  final String imagem;
  final int idade;
  final List<String> hobbies;
  final int qntdPost;

  UserProfile({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.idade,
    required this.hobbies,
    required this.qntdPost,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json, String id) {
    return UserProfile(
      id: id,
      nome: json['nome'] ?? '',
      imagem: json['imagem'] ?? '',
      idade: json['idade'] ?? 0,
      hobbies: List<String>.from(json['hobbies'] ?? []),
      qntdPost: json['qntdPost'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'imagem': imagem,
      'idade': idade,
      'hobbies': hobbies,
      'qntdPost': qntdPost,
    };
  }
}
