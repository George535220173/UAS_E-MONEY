import 'package:flutter/material.dart';
import 'package:uas_emoney/Home/home.dart';
import 'package:uas_emoney/registerlogin/register.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Wizzzzz test bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/Wizzzzz test.png',
                  width: 380,
                  height: 200,
                ),

                SizedBox(
                  height: 1,
                ),

                Text(
                  'Log in to Continue',
                  style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 209, 109, 255),
                      fontFamily: 'PoppinsBold'),
                ),

                SizedBox(
                  height: 40,
                ),

                // Bagian email
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Color.fromARGB(255, 248, 240, 179),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.info,
                            color: Color.fromARGB(255, 53, 21, 58)),
                        onPressed: () {
                          if (!emailController.text.endsWith('@gmail.com')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid email format'),
                              ),
                            );
                          }
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 53, 21, 58)),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Bagian password
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Color.fromARGB(255, 248, 240, 179),
                      suffixIcon: IconButton(
                        icon: isPasswordVisible
                            ? Icon(Icons.visibility,
                                color: Color.fromARGB(255, 53, 21, 58))
                            : Icon(Icons.visibility_off,
                                color: Color.fromARGB(255, 53, 21, 58)),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 53, 21, 58)),
                    ),
                    obscureText: !isPasswordVisible,
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

// Login Button
                ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      _showErrorDialog('Email and password are required');
                      return;
                    }

                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      // Check if login is successful
                      if (userCredential.user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      } else {
                        _showErrorDialog(
                            'Email or password is incorrect or not registered.');
                      }
                    } on FirebaseAuthException {
                      _showErrorDialog(
                          'Email or password is incorrect or not registered.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(125, 50),
                    backgroundColor: Color.fromARGB(255, 194, 41, 245),
                  ),
                  child: Text(
                    'Log In!',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 104, 44, 114),
                      fontSize: 24,
                      fontFamily: 'PoppinsBold',
                    ),
                  ),
                ),

                SizedBox(height: 70),

                Text(
                  'If you dont have an account',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 248, 255, 173),
                      fontFamily: 'PoppinsRegular'),
                ),

                SizedBox(height: 10),

                // Sign Up Button
                TextButton(
                  onPressed: () {
                    // Pindah ke halaman registrasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(125, 20), // Set the button size here
                    backgroundColor: Color.fromARGB(255, 228, 245, 41),
                  ),
                  child: Text(
                    'Sign Up!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 114, 66, 44),
                      fontSize: 20,
                      fontFamily: 'PoppinsBold',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed to log in'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
