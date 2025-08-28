import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_event.dart';

void main() {
  group('PostDetailEvent', () {
    test('FetchPostDetail deve ter postId correto em props', () {
      const event = FetchPostDetail(postId: 42);

      expect(event.props, [42]);
      expect(event.postId, 42);

      // Testa igualdade
      const event2 = FetchPostDetail(postId: 42);
      expect(event, event2);

      const event3 = FetchPostDetail(postId: 7);
      expect(event == event3, isFalse);
    });
  });
}
