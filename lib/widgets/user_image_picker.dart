import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
final void Function(File pickedImageFile) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
File _pickedImage;
void _pickImage() async {
  final picker = ImagePicker();
  final pickedImage = await picker.getImage(source: ImageSource.camera,imageQuality: 50, maxWidth: 150);
  final pickedImageFile = File(pickedImage.path);
  setState(() {
    _pickedImage = pickedImageFile;
  });
widget.imagePickFn(pickedImageFile);

}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage!=null ? FileImage(_pickedImage): null,
        ),
        FlatButton.icon(
          label: Text('Загрузить фото'),
          textColor: Theme.of(context).accentColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
        ),
      ],
    );
  }
}
