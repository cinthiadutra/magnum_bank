import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:magnum_bank/presentation/shared_widgets/glass_container.dart';

class PostItemWidget extends StatefulWidget {
  final Post post;
  const PostItemWidget({required this.post});

  @override
  _PostItemWidgetState createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final body = widget.post.body;
    final isLong = body.length > 100;
    final displayText = !_expanded && isLong
        ? '${body.substring(0, 100)}...'
        : body;

    return GlassContainer(
      child: ListTile(
        trailing: Icon(Icons.arrow_circle_right_outlined, color: Colors.red),
        title: Text(
          widget.post.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayText),
            if (isLong)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'Ver menos' : 'Ver mais',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          context.go('/post/${widget.post.id}');
        },
      ),
    );
  }
}
