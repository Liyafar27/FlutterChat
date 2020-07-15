import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
 
  String _url;
  AuthResult authResult;
  File _imageFile;

  Future<Null> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 100, maxWidth: 350);
    final pickedImageFile = File(imageFile.path);
    _imageFile = pickedImageFile;
    Navigator.pop(context);
    _sendPhoto();
  }

  Future<Null> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 100, maxWidth: 350);
    final pickedImageFile = File(imageFile.path);

    _imageFile = pickedImageFile;
    Navigator.pop(context);
    _sendPhoto();
  }

  final TextEditingController _controller = new TextEditingController();
  var _enteredMessage = '';

  Future _sendPhoto() async {
    final String fileName = DateTime.now().toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("user_image/share/$fileName");
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    // await uploadTask.onComplete;
    //print('File Uploaded');
    final uploadedFileURL =
        await (await uploadTask.onComplete).ref.getDownloadURL();

    _url = uploadedFileURL;
   
    //  Navigator.pop(context);
  }

  void clearSelection() {
    setState(() {
      _imageFile = null;
      _url = null;
      _enteredMessage = null;
    });
  }

  void _sendTextAndImage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'imageShare': _url,
      'text': _enteredMessage,
      'createAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url']
    });
    _controller.clear();
    clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(children: <Widget>[
        IconButton(
          icon: Icon(_url != null ? Icons.plus_one : Icons.attach_file),
          color: Colors.orange[500],
          onPressed: () {
            var alert = AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text('Поделиться фото', textAlign: TextAlign.center),
              content: Card(
                elevation: 15,
                child: Container(
                  height: 50,
                  color: Colors.cyan[50],
                  child: (Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.indigo[900],),
                              onPressed: () async =>
                                  await _pickImageFromCamera(),
                            ),
                            IconButton(
                              icon: Icon(Icons.photo_library,color: Colors.indigo[900]),
                              onPressed: () async =>
                                  await _pickImageFromGallery(),
                            ),
                            IconButton(
                              icon: Icon(Icons.close,color: Colors.orange[900]),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                });
          },
        ),
        Expanded(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(
                labelText: 'Send a message...',
                labelStyle: TextStyle(color: Colors.orange[500])),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          ),
        ),
        
        IconButton(
          
            icon: Icon(Icons.send),
            color: Colors.orange[500],
            onPressed: _url != null || _enteredMessage != null
                ? _sendTextAndImage
                : null),
      ]),
    );
  }
}
