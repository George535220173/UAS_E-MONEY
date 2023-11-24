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
        backgroundColor: Color.fromARGB(255, 41, 8, 80),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 33, 6, 64),
              Color.fromARGB(255, 86, 38, 84)
            ],
          ),
        ),
        child: ListView(
            // Wrap with ListView
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                .onDrag, // Handle keyboard dismissal
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Box First Name
                    Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 237, 97),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 237, 97)),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 226, 145, 255),
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Box Last Name
                    Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 237, 97),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 237, 97)),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 226, 145, 255),
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ),
                    SizedBox(height: 20),

// Box Phone
                    Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 237, 97),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '(+62)',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 237, 97)),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    11), // Batasan panjang nomor hp
                              ],
                              onChanged: (value) {
                                if (value.startsWith('(+62)')) {
                                  // Jika pengguna memasukkan manual "(08)", hapus agar tidak ada duplikasi
                                  setState(() {
                                    phoneController.text = value.substring(4);
                                  });
                                } else {
                                  setState(() {
                                    // Update nomor hp dalam format yang diinginkan
                                    phoneController.text = value;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Nomor Hp',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15.0),
                                labelStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 237, 97)),
                              ),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 226, 145, 255),
                                  fontFamily: 'PoppinsRegular'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Box Email
                    Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 237, 97),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 237, 97)),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 226, 145, 255),
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Box Password
                    Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 237, 97),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 237, 97)),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 226, 145, 255),
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Box Confirm Password
                    Container(
                      height: 60,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 237, 97),
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
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.0),
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 237, 97)),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 226, 145, 255),
                            fontFamily: 'PoppinsRegular'),
                      ),
                    ),

                    SizedBox(height: 60),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () async {
                        bool isEmailValid =
                            emailController.text.endsWith('@gmail.com');
                        bool isPasswordMatch = passwordController.text ==
                            confirmPasswordController.text;

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
                            UserCredential userCredential = await FirebaseAuth
                                .instance
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
                            print(
                                'FirebaseAuthException during registration: $e');
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
                        backgroundColor: Color.fromARGB(255, 245, 167, 41),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
            ]),
      ),
    );
  }
}
