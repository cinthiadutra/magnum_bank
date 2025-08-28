import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:magnum_bank/presentation/profile/profile_screen.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('exibe os dados do usuário corretamente', (tester) async {
    final mockUser = UserProfile(
      nome: 'Cinthia Dutra',
      idade: 30,
      qntdPost: 5,
      imagem: 'https://via.placeholder.com/150', // para o CircleAvatar
      hobbies: ['Leitura', 'Correr', 'Flutter'], id: '',
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileScreen(userProfile: mockUser),
        ),
      );

      await tester.pumpAndSettle();

      // Verifica o CircleAvatar
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Verifica nome e idade
      expect(find.text('Cinthia Dutra'), findsNWidgets(2)); // appBar + corpo
      expect(find.text('Idade: 30 anos'), findsOneWidget);

      // Verifica quantidade de posts
      expect(find.text('Posts: 5'), findsOneWidget);

      // Verifica os hobbies
      expect(find.text('Leitura'), findsOneWidget);
      expect(find.text('Correr'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
    });
  });
}
