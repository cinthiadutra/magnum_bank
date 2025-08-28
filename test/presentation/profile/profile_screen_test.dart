import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:magnum_bank/presentation/profile/profile_screen.dart';

void main() {
  group('ProfileScreen Widget Test', () {
    final mockUser = UserProfile(
      id: '1',
      nome: 'Leanne Graham',
      imagem: 'https://www.example.com/avatar.jpg',
      idade: 45,
      hobbies: ['dançar', 'comer', 'fumar'],
      qntdPost: 10,
    );

    testWidgets('Deve exibir todos os elementos do perfil corretamente',
        (WidgetTester tester) async {
      // Construir o widget
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileScreen(userProfile: mockUser),
        ),
      );

      // Verificar se o AppBar mostra o nome
      expect(find.text(mockUser.nome), findsWidgets);

      // Verificar se a imagem do CircleAvatar está presente
      final avatarFinder = find.byType(CircleAvatar);
      expect(avatarFinder, findsOneWidget);

      final circleAvatar = tester.widget<CircleAvatar>(avatarFinder);
      expect((circleAvatar.backgroundImage as NetworkImage).url, mockUser.imagem);

      // Verificar idade
      expect(find.text('Idade: ${mockUser.idade} anos'), findsOneWidget);

      // Verificar quantidade de posts
      expect(find.text('Posts: ${mockUser.qntdPost}'), findsOneWidget);

      // Verificar hobbies
      for (var hobby in mockUser.hobbies) {
        expect(find.text(hobby), findsOneWidget);
      }

      // Verificar título "Hobbies / Gostos:"
      expect(find.text('Hobbies / Gostos:'), findsOneWidget);
    });
  });
}
