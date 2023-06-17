import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts/post_bloc.dart';
import 'package:posts_app/features/posts/presentation/pages/add_post_page.dart';
import 'package:posts_app/injection_continar.dart' as di;
import '../../domain/entites/post.dart';
import '../widgets/loading_widget.dart';
import '../widgets/post_widget/message_display_widget.dart';
import '../widgets/post_widget/post_list_widget.dart';

class PostsPage extends StatelessWidget {
  PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingBtn(context),
    );
  }

  _buildAppBar() => AppBar(
        title: const Text('Posts'),
      );

  _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (state is LoadingPostsState) {
            return const LoadingWidget();
          } else if (state is LoadedPostState) {
            return RefreshIndicator(
                color: Colors.green,
                child: PostListWidget(posts: state.posts),
                onRefresh: () => _onRefresh(context));
          } else if (state is ErrorPostsState) {
            return MessageDisplayWidget(message: state.message);
          }
          return const LoadingWidget();
        }));
  }

  _buildFloatingBtn(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddPostPage(
                      isUpdate: false,
                    )));
      },
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<PostBloc>(context).add(RefreshPostsEvent());
  }
}
