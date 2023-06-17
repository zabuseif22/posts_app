import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/posts/presentation/bloc/add_or_update_or_delete/add_update_or_delete_bloc.dart';

import '../../../domain/entites/post.dart';

class FormWidget extends StatefulWidget {
  final Post? post;
  final bool isUpdate;

  const FormWidget({this.post, required this.isUpdate, Key? key})
      : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.isUpdate) {
      titleController.text = widget.post!.title;
      bodyController.text = widget.post!.body;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
                validator: (val) =>
                    val!.isEmpty ? ' title cannot be empty' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: bodyController,
                decoration: const InputDecoration(hintText: 'Body'),
                validator: (val) => val!.isEmpty ? ' body cannot be empty' : null,
                maxLines: 6,
                minLines: 6,
              ),
            ),
            ElevatedButton.icon(
                onPressed: validationFormAddUpdate,
                icon: widget.isUpdate
                    ? const Icon(Icons.edit)
                    : const Icon(Icons.add),
                label: Text(widget.isUpdate ? 'Update' : 'Add'))
          ],
        ));
  }

  void validationFormAddUpdate() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final post = Post(
          id: widget.isUpdate ? widget.post!.id : null,
          title: titleController.text,
          body: bodyController.text);
      if (widget.isUpdate) {
        BlocProvider.of<AddUpdateOrDeleteBloc>(context)
            .add(UpdatePostEvent(post: post));
      } else {
        BlocProvider.of<AddUpdateOrDeleteBloc>(context)
            .add(AddPostEvent(post: post));
      }
    }
  }
}
