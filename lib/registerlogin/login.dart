import 'package:flutter/material.dart';
import 'package:uas_emoney/Home/home.dart';
import 'package:uas_emoney/registerlogin/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

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
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.network(
                'https://e7.pngegg.com/pngimages/700/675/png-clipart-hat-shaman-wizard-top-hat-hatpin-thumbnail.png', // Ganti dengan path logo topi wizard
                width: 100,
                height: 100,
              ),

              SizedBox(height: 20),

              // Email Input
              TextField(
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
                ),
              ),

              SizedBox(height: 10),

              // Password Input
              TextField(
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
                ),
                obscureText: !isPasswordVisible,
              ),

              SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Lakukan autentikasi login (biasanya akan memeriksa di database)
                  // Anda bisa menambahkan logika login di sini

                  // Pindah ke halaman utama setelah login
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
                child: Text('Log In'),
              ),

              SizedBox(height: 20),

              // Garis Pemisah
              Divider(),

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
