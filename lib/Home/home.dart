import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<home> {
  bool isEyeOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Siang',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Peserta',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 130),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildIconButton(Icons.arrow_downward, 'Withdraw'),
                    buildIconButton(Icons.arrow_upward, 'Deposit'),
                    buildIconButton(Icons.swap_horiz, 'Transfer'),
                    buildIconButton(Icons.history, 'History'),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
            Positioned(
              top: 160,
              child: Container(
                height: 170,
                width: 320,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 46, 122, 88),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: isEyeOpen
                                ? Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                            onPressed: () {
                              setState(() {
                                isEyeOpen = !isEyeOpen;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 40),
                      child: Row(
                        children: [
                          Text(
                            isEyeOpen ? 'Rp 205,957' : 'Rp *****',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            // Implement action for each button
          },
          icon: Icon(icon),
          iconSize: 40,
          color: Colors.green,
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
