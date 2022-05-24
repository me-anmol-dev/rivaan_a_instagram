import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImageFn(ImageSource source) async {
  final _imagePicker = ImagePicker();
  XFile? _imageFile = await _imagePicker.pickImage(source: source);

  // Came back with no Image
  if (_imageFile != null) {
    return await _imageFile.readAsBytes();
  } else {
    debugPrint('No Image selected');
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}
