import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_event.dart';

void main() {
  group('ProfileEvent', () {
    test('FetchUserProfile deve ter userId correto em props', () {
      const event = FetchUserProfile(userId: 'user123');

      expect(event.props, ['user123']);
      expect(event.userId, 'user123');

      // Testa igualdade
      const event2 = FetchUserProfile(userId: 'user123');
      expect(event, event2);

      const event3 = FetchUserProfile(userId: 'user456');
      expect(event == event3, isFalse);
    });
  });
}
