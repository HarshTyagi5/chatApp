import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return UserImagePickerState();
  }
}

class UserImagePickerState extends State<UserImagePicker> {
  File? userPickedImage;
  var _camera = false;

  void _showOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: ((context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _imagePicker();
                },
                child: Text(
                  'Gallery',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _camera = true;
                  _imagePicker();
                },
                child: Text(
                  'Camera',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          )),
    );
  }

  void _imagePicker() async {
    final pickedImage = await ImagePicker().pickImage(
        source: _camera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 150);

    if (pickedImage == null) return;
    setState(() {
      userPickedImage = File(pickedImage.path);
    });

    widget.onPickImage(userPickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              userPickedImage != null ? FileImage(userPickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _showOptions,
          icon: const Icon(Icons.image),
          label: Text(
            'Pick Image',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
