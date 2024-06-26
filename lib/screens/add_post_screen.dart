import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivaan_a_instagram/providers/provider_list.dart';

import 'package:rivaan_a_instagram/providers/user_provider.dart';
import 'package:rivaan_a_instagram/resources/firestore_methods.dart';
import 'package:rivaan_a_instagram/utilities/color.dart';
import 'package:rivaan_a_instagram/utilities/utilities.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  bool _isLoading = false;
  Uint8List? _file;
  final _descriptionController = TextEditingController();

  _selectImage(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImageFn(ImageSource.camera);
                  setState(() => _file = file);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImageFn(ImageSource.gallery);
                  setState(() => _file = file);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() => _isLoading = true);
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);

      if (res == 'success') {
        setState(() => _isLoading = false);
        showSnackBar('Posted!', context);
        clearImage();
      } else {
        setState(() => _isLoading = false);
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() => setState(() => _file = null);

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).getUser;
    final user = ref.watch(userProvider).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(CupertinoIcons.arrow_left),
                onPressed: clearImage,
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.photoUrl),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
