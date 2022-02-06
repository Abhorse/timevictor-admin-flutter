import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timevictor_admin/constant.dart';
import 'package:timevictor_admin/services/auth.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false;
  bool hidePassword = true;
  String errorMsg = '';

  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      setState(() {
        isLoading = true;
        errorMsg = '';
      });
      var authResult = await AuthServices()
          .singin(_usernameController.text, _passwordController.text);
      print(authResult);
    } catch (e) {
      setState(() {
        errorMsg = 'Invaild username or password';
      });
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleViewPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(195, 20, 50, 1.0),
                Color.fromRGBO(36, 11, 54, 1.0)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox(
                  width: 450,
                  child: Card(
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Welcome to time victor admin panel',
                              style: TextStyle(
                                color: kAppBarColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: errorMsg.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                errorMsg,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'username',
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'enter admin username';
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'password',
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'enter password';
                                      return null;
                                    },
                                    obscureText: hidePassword,
                                  ),
                                ),
                                IconButton(
                                  // icon: Icon(Icons.remove_red_eye),
                                  icon: Icon(
                                    hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),

                                  onPressed: toggleViewPassword,
                                )
                              ],
                            ),
                          ),
                          FlatButton(
                            color: kAppBarColor,
                            shape: kCardShape(20.0),
                            child: Text(
                              'Login',
                              style: kButtonTextStyle,
                            ),
                            onPressed: () {
                              if (_loginFormKey.currentState.validate()) {
                                print('login user');
                                print(_usernameController.text);
                                print(_passwordController.text);
                                loginUser();
                              } else {
                                print('invalid user');
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
