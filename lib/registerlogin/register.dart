import 'package:flutter/material.dart';
import 'package:uas_emoney/registerlogin/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Box Email
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Box Password
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: isPasswordVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Box Confirm Password
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: isConfirmPasswordVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Sign Up Button
            ElevatedButton(
              onPressed: () async {
                bool isEmailValid = emailController.text.endsWith('@gmail.com');
                bool isPasswordMatch =
                    passwordController.text == confirmPasswordController.text;

                if (!isEmailValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid email format'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (!isPasswordMatch) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password does not match'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Save additional user data to Firestore (optional)
                    // ...

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    print('FirebaseAuthException during registration: $e');
                    // Handle FirebaseAuthException (weak-password, email-already-in-use, etc.)
                  } catch (e) {
                    print('Error during registration: $e');
                    // Handle other exceptions
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 234, 234, 234),
                onPrimary: Color.fromARGB(255, 149, 53, 173),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
