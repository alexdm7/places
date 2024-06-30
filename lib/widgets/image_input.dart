import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;
  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selctedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selctedImage = File(pickedImage.path);
    });
    widget.onPickImage(_selctedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: _takePicture,
        icon: Icon(Icons.camera),
        label: Text('add image'));
    if (_selctedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selctedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        width: 1,
      )),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
