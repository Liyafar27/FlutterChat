import 'package:flutter/material.dart';
import 'dart:io';
import './user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFm, this.isLoading);

  final bool isLoading;
  final void Function(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) submitFm;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Plese pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return null;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFm(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _userImageFile, _isLogin, context);
     
    }
  }

//    AnimationController _controllerAnim;
//    Animation <Size> _heightAnim;
//    @override
//   void initState() {
     
//     super.initState();
//      _controllerAnim = AnimationController(vsync: this, duration: Duration(milliseconds: 1400) );
//      _heightAnim = Tween<Size>(begin: Size(double.infinity,260),end: Size(double.infinity, 320)).animate(CurvedAnimation(parent:_controllerAnim, curve: Curves.linear));
//   _heightAnim.addListener(()=>setState((){}));
//  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
      //  height: _isLogin ?_controllerAnim.value : _controllerAnim.value,
        child: Card(
          elevation: 20,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty || value.length < 3) {
                            return 'Please enter at least 3 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Passwords must be at least 7 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    SizedBox(height: 12),
                    if (widget.isLoading) CircularProgressIndicator(),
                    if (!widget.isLoading)
                      RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                           //_heightAnim.value.width;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create new account'
                            : 'I already have account'),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
