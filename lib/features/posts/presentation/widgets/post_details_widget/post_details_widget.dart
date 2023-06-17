import 'package:flutter/material.dart';
import 'package:posts_app/features/posts/domain/entites/post.dart';

import '../../../../map/presentation/pages/map_page.dart';

class PostDetailsWidget extends StatelessWidget {
  final Post post;
  PostDetailsWidget({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(post.title),
          const Divider(
            height: 22,
          ),
          Text(post.body),
          const Divider(
            height: 22,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text('Edit'),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: Text('Delete'),
              ),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MapPage()));
                },
                icon: const Icon(Icons.map),
                label: const Text('Map'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
