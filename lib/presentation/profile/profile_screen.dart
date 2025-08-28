import 'package:flutter/material.dart';
import 'package:magnum_bank/domain/entities/user.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile? userProfile;

  const ProfileScreen({super.key, this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          userProfile?.nome ?? "",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // Imagem do usuário
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userProfile?.imagem ?? ""),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),

            // Nome
            Text(
              userProfile?.nome ?? "",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),

            // Idade
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cake, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Idade: ${userProfile?.idade} anos',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Quantidade de posts
                  Row(
                    children: [
                      const Icon(Icons.post_add, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Posts: ${userProfile?.qntdPost}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Hobbies / Gostos
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hobbies / Gostos:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: userProfile!.hobbies
                        .map(
                          (hobby) => Chip(
                            label: Text(
                              hobby,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              169,
                              46,
                              59,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
