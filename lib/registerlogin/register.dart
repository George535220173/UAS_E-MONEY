import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uas_emoney/createpin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Box First Name
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Box Last Name
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                ),
              ),
            ),
            SizedBox(height: 20),

              Container(
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Nomor Hp',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                  ),
                ),
              ),
              SizedBox(height: 20),

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

                    String uid = userCredential.user?.uid ?? '';

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .set({
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                      'phone': phoneController.text,
                      'email': emailController.text,
                      'pin': '',
                      'balance': 0,
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePINPage(
                          userId: uid,
                        ),
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
