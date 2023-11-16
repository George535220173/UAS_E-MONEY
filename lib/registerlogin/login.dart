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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.network(
                'https://media.istockphoto.com/id/1028818726/id/vektor/topi-wizard-ikon-terkait-halloween-desain-kerangka-terisi-goresan-yang-dapat-diedit.jpg?s=170667a&w=0&k=20&c=AjAMfn6NFTRj6j3aowaVIlppwdN1VrHWYh3IAYAgc54=',
                width: 100,
                height: 100,
              ),
              
              SizedBox(
                height: 30,
              ),

              Text(
                'Sign in to Continue',
                style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 75, 149, 209)),
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
                    suffixIcon: IconButton(
                      icon: Icon(Icons.info),
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
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 30.0), // Sesuaikan dengan kebutuhan Anda
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
                  try {
                    // Lakukan autentikasi login dengan Firebase Authentication
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Jika login berhasil, pindah ke halaman utama
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    } else {
                      print(e.message);
                    }
                  }
                },
                child: Text('Log In'),
              ),

              SizedBox(height: 20),

              // Garis Pemisah
              Divider(thickness: 2, color: Colors.black),

              SizedBox(height: 20),

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
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
