import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,File image,
      bool isLogin, BuildContext ctx) async {
    AuthResult authResult;
    
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
            final ref = FirebaseStorage.instance.ref().child('user_image').child(authResult.user.uid + 'jpg');            
            await ref.putFile(image).onComplete;           
            final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url' : url,
        });
      }
    } on PlatformException
     catch (err) {
      var message = 'An error occurred, pleae check your credentials';
      if (err.message != null) {
        message = err.message;
        print(message);
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold( 
      backgroundColor: Colors.transparent,     
      body: 
      Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                   Colors.blue[900],
                    Color.fromARGB(255, 25,178,238),
                    Color.fromARGB(255, 25,178,238),
                    Color.fromARGB(255, 21,236,229),
                    Color.fromARGB(255, 21,236,229),
                   Colors.orange[300]
                  ],
                ),
                ),
                
              child:AuthForm(
        _submitAuthForm,
        _isLoading
      ),
      ),
    );
  }
}
