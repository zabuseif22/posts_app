import 'package:flutter/material.dart';

import '../../../domain/entites/post.dart';
import '../../pages/post_details_page.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;
  const PostListWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(posts[index].id.toString()),
            title: Text(
              posts[index].title,
            ),
            subtitle: Text(
              posts[index].body,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PostDetailsPage(
                            post: posts[index],
                          )));
            },
          );
        },
        itemCount: posts.length,
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.grey,
            thickness: 1,
          );
        },
      ),
    );
  }
}
