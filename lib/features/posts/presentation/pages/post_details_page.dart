import 'package:flutter/material.dart';

import '../../domain/entites/post.dart';
import '../widgets/post_details_widget/post_details_widget.dart';

class PostDetailsPage extends StatelessWidget {
  final Post post;
  PostDetailsPage({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text('details page'),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: PostDetailsWidget(
        post: post,
      ),
    );
  }
}
