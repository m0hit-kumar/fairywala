import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitfn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext context) submitfn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  var _userName = '';
  var _userPassword = '';
  var _userEmail = '';
  var _number;
  bool isVendor = false;
  List<String> Categories = [
    'Fruits/Vegetables',
    'Icecream',
    'Folding Niwar Maker',
    'Gas Stove repair',
  ];
  String? selectedCategory = "Icecream";
  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitfn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          isLogin, context);
    }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please Enter a valid Email Address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Username must be at least 4 characters long';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'UserName'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  if (!isLogin)
                    TextFormField(
                      keyboardType: TextInputType.number,
                      key: const ValueKey('Number'),
                      validator: (value) {
                        if (value!.isEmpty || value.toString().length < 11) {
                          return 'Enter a valid number to recive sms';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Number'),
                      onSaved: (value) {
                        _number = value!;
                      },
                    ),
                  if (!isLogin)
                    Checkbox(
                      value: isVendor,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          this.isVendor = true;
                        });
                      },
                    ),
                  if (!isLogin & isVendor)
                    DropdownButton<String>(
                        value: selectedCategory,
                        items:
                            Categories.map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                )).toList(),
                        onChanged: (item) => {
                              setState(() {
                                selectedCategory = item;
                              })
                            }),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          _trySubmit();
                        },
                        child: Text(isLogin ? 'Login' : 'SignUp')),
                  if (!widget.isLoading)
                    TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin
                          ? 'Create New Account'
                          : 'I already have a account'),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
