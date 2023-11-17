import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uas_emoney/Home/home.dart';
import 'PinStorage.dart'; // Import the PinStorage file

class createWidget extends StatefulWidget {
  const createWidget({Key? key}) : super(key: key);

  @override
  State<createWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<createWidget> {
  bool isPinVisible = false;

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (PinStorage.pin.length < 6) {
              PinStorage.pin += number.toString();
            }
            // Check if the entered PIN is correct
            if (PinStorage.pin == '123456') {
              // If correct, navigate to the home page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            }
          });
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
                'Create Your PIN',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 50),

            /// bulet2 setelah masukin code
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) {
                  return Container(
                    margin: const EdgeInsets.all(7.0),
                    width: isPinVisible ? 43 : 20, //buat besar kecilin bulet2
                    height: isPinVisible ? 43 : 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: index < PinStorage.pin.length
                          ? isPinVisible
                              ? const Color.fromARGB(255, 208, 0, 225)
                              : const Color.fromARGB(255, 208, 0, 255)
                          : const Color.fromARGB(255, 208, 0, 255).withOpacity(0.1),
                    ),
                    child: isPinVisible && index < PinStorage.pin.length
                        ? Center(
                            child: Text(
                              PinStorage.pin[index],
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

            /// mata mata indah
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

            /// 123456789
            for (var i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => numButton(1 + 3 * i + index),
                  ).toList(),
                ),
              ),

            /// tombol remove
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
                          if (PinStorage.pin.isNotEmpty) {
                            PinStorage.pin = PinStorage.pin.substring(0, PinStorage.pin.length - 1);
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

            /// tombol reset
            TextButton(
              onPressed: () {
                setState(() {
                  PinStorage.pin = '';
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