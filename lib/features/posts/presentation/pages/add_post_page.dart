import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/core/util/snakbar.dart';
import 'package:posts_app/features/posts/presentation/bloc/add_or_update_or_delete/add_update_or_delete_bloc.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts/post_bloc.dart';
import 'package:posts_app/features/posts/presentation/pages/posts_page.dart';
import 'package:posts_app/features/posts/presentation/widgets/loading_widget.dart';

import '../../domain/entites/post.dart';
import '../widgets/add_update_widget/form_widget.dart';

class AddPostPage extends StatelessWidget {
  final Post? post;
  final bool isUpdate;
  AddPostPage({this.post, required this.isUpdate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(isUpdate ? 'Edit Post' : 'Add Post'),
    );
  }

  _buildBody() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocConsumer<AddUpdateOrDeleteBloc, AddUpdateOrDeleteState>(
              listener: (context, state) {
                if (state is MessageAddDeleteUpdateState) {

                  SnakBar().showSnakBar(state.message, context);

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => PostsPage()),
                      (route) => false);

                } else if (state is ErrorAddDeleteUpdateState) {
                  SnakBar().showErrorSnakBar(state.message, context);
                }
              },
              builder: (context, state) {

                if (state is LoadingAddDeleteUpdateState) {
                  return const LoadingWidget();
                }

                return FormWidget(
                    isUpdate: isUpdate, post: isUpdate ? post : null);
              },
            )));
  }


}
