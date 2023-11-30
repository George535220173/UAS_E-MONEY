import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_emoney/registerlogin/login.dart';

class CreatePINPage extends StatefulWidget {
  final String userId;

  const CreatePINPage({required this.userId, Key? key}) : super(key: key);

  @override
  _CreatePINPageState createState() => _CreatePINPageState();
}

class _CreatePINPageState extends State<CreatePINPage> {
  String pin = '';
  bool isPinVisible = false;

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (pin.length < 6) {
              pin += number.toString();
            }
          });
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 255, 244, 145),
          onPrimary: Color.fromARGB(255, 29, 0, 62),
          minimumSize: Size(60, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void savePINToFirestore(String pin) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'pin': pin});
      // Tampilkan pesan sukses atau navigasi ke halaman berikutnya
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('PIN has been saved successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Kembali ke halaman sebelumnya
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error saving PIN to Firestore: $e');
      // Handle error saving PIN to Firestore
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while saving PIN.'),
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

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to save this PIN?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Save PIN to Firestore
                savePINToFirestore(pin);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 8, 80),
      body: SafeArea(
        child: SingleChildScrollView(
          // Tambahkan SingleChildScrollView di sini
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Create Your PIN',
                  style: TextStyle(
                      fontSize: 36,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'PoppinsBold'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: index < pin.length
                            ? Color.fromARGB(255, 255, 244, 145)
                            : const Color.fromARGB(61, 0, 0, 0),
                      ),
                      child: isPinVisible && index < pin.length
                          ? Center(
                              child: Text(
                                '•',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isPinVisible = !isPinVisible;
                  });
                },
                icon: Icon(
                  isPinVisible ? Icons.visibility_off : Icons.visibility,
                  color: Color.fromARGB(255, 255, 244, 145),
                ),
              ),
              SizedBox(height: 10.0),
              for (var i = 0; i < 3; i++)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) => numButton(1 + 3 * i + index),
                    ).toList(),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextButton(onPressed: null, child: SizedBox()),
                    numButton(0),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            if (pin.isNotEmpty) {
                              pin = pin.substring(0, pin.length - 1);
                            }
                          },
                        );
                      },
                      child: const Icon(
                        Icons.backspace,
                        color: Color.fromARGB(255, 255, 244, 145),
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    // Reset PIN
                    pin = '';
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'PoppinsBold',
                    color: Color.fromARGB(255, 255, 244, 145),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cek apakah PIN sudah sesuai panjang
                  if (pin.length == 6) {
                    // Tampilkan dialog konfirmasi
                    showConfirmationDialog();
                  } else {
                    // Tampilkan pesan jika panjang PIN tidak sesuai
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Please enter a 6-digit PIN.'),
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
                },
                child: Text(
                  'Create PIN',
                  style: TextStyle(
                      fontFamily: 'PoppinsBold',
                      fontSize: 24,
                      color: Color.fromARGB(255, 41, 8, 80)),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 244, 145),
                    minimumSize: Size(100, 50)),
                    
              ),
            ],
          ),
        ),
      ),
    );
  }
}