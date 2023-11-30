import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart';

class PinCodeWidget extends StatefulWidget {
  final VoidCallback onPinVerified;
  final VoidCallback onPinFailed; // Added callback for incorrect PIN

  const PinCodeWidget(
      {Key? key, required this.onPinVerified, required this.onPinFailed})
      : super(key: key);

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  String enteredPin = '';
  String errorText = '';
  bool isPinVisible = false;

  // Function to get the UID of the currently logged-in user
  String? getLoggedInUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<String?> getFirestorePin(String uid) async {
    var snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (snapshot.exists) {
      return snapshot['pin']; // Assuming your PIN field is named 'pin'
    } else {
      return null; // Handle the case when the document doesn't exist
    }
  }

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () async {
          setState(() {
            if (enteredPin.length < 6) {
              enteredPin += number.toString();
              errorText = ''; // Reset error message on button press
            }
          });

          // Check if the entered PIN is correct
          String? uid = getLoggedInUserId();
          if (uid != null) {
            String? firestorePin = await getFirestorePin(uid);

            if (enteredPin.length == 6 && enteredPin == firestorePin) {
              // If correct, call the provided callback function
              enteredPin = '';
              widget.onPinVerified();
            } else if (enteredPin.length == 6 && enteredPin != firestorePin) {
              // Incorrect PIN, handle accordingly
              // Example: Show an error message and reset the entered PIN
              setState(() {
                errorText = 'Invalid Pin';
                enteredPin = '';
                widget.onPinFailed(); // Call the callback for incorrect PIN
              });
            }
          }
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            const Center(
              child: Text(
                'Enter Your Pin',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) {
                  return Container(
                    margin: const EdgeInsets.all(7.0),
                    width: isPinVisible ? 43 : 20,
                    height: isPinVisible ? 43 : 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: index < enteredPin.length
                          ? isPinVisible
                              ? const Color.fromARGB(255, 208, 0, 225)
                              : const Color.fromARGB(255, 208, 0, 255)
                          : const Color.fromARGB(255, 208, 0, 255)
                              .withOpacity(0.1),
                    ),
                    child: isPinVisible && index < enteredPin.length
                        ? Center(
                            child: Text(
                              enteredPin[index],
                              style: const TextStyle(
                                fontSize: 17,
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
              ),
            ),
            SizedBox(height: isPinVisible ? 50.0 : 8.0),
            for (var i = 0; i < 3; i++)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => numButton(1 + 3 * i + index),
                  ).toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextButton(onPressed: null, child: SizedBox()),
                  numButton(0),
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          if (enteredPin.isNotEmpty) {
                            enteredPin =
                                enteredPin.substring(0, enteredPin.length - 1);
                          }
                        },
                      );
                    },
                    child: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  enteredPin = '';
                });
              },
              child: const Text(
                'Reset',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}