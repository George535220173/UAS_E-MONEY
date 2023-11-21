import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_emoney/Withdraw/withdrawHome.dart';
import 'package:uas_emoney/Deposit/deposit.dart';
import 'package:uas_emoney/Transfer/transfer.dart';
import 'package:uas_emoney/History/history.dart';
import 'package:uas_emoney/money.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEyeOpen = true;
  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  final ValueNotifier<double> totalBalanceNotifier =
      ValueNotifier<double>(Money.totalBalance);

  late String greeting;

  @override
  void initState() {
    super.initState();

    _updateGreeting(); // Set initial greeting
    Timer.periodic(Duration(minutes: 1), (timer) {
      _updateGreeting(); // Update greeting every minute
    });

    Money.initializeTotalBalance().then((_) {
      setState(() {});
    });

    getUserData().then((userData) {
      double balance = (userData['balance'] ?? 0).toDouble();
      totalBalanceNotifier.value = balance;
    });

    Money.onBalanceChange = () {
      getUserData().then((userData) {
        double balance = (userData['balance'] ?? 0).toDouble();
        totalBalanceNotifier.value = balance;
      });
    };
  }

  Future<void> _updateGreeting() async {
    var now = DateTime.now();
    var timeZoneOffset = now.timeZoneOffset;
    var jakartaTimeZone = TimeZone(
        timeZoneOffset.isNegative ? -7 * 60 : 7 * 60, 'WIB'); // Jakarta timezone

    var jakartaTime = now.toUtc().add(Duration(minutes: timeZoneOffset.inMinutes > 0
        ? jakartaTimeZone.offset
        : -jakartaTimeZone.offset));

    if (jakartaTime.hour < 12) {
      greeting = 'Selamat Pagi,';
    } else if (jakartaTime.hour < 17) {
      greeting = 'Selamat Siang,';
    } else if (jakartaTime.hour < 20) {
      greeting = 'Selamat Sore,';
    } else {
      greeting = 'Selamat malam,';
    }

    setState(() {});
  }

  Future<Map<String, dynamic>> getUserData() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return userSnapshot.data() as Map<String, dynamic>;
  }

  @override
  void dispose() {
    Money.onBalanceChange = null;
    super.dispose();
  }

  Future<void> _refreshData() async {
    getUserData().then((userData) {
      double balance = (userData['balance'] ?? 0).toDouble();
      totalBalanceNotifier.value = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 240,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 147, 76, 175),
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
                            child: FutureBuilder(
                              future: getUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (snapshot.hasError) {
                                  return Text('Error loading user data');
                                }

                                String firstName =
                                    snapshot.data?['firstName'] ?? '';
                                String lastName =
                                    snapshot.data?['lastName'] ?? '';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      greeting,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '$firstName $lastName',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 160,
                      child: Container(
                        height: 170,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 95, 42, 118),
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
                                  buildBalanceWidget(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 600),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(138, 194, 194, 194),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(top: 615),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildNavigationButton(
                              Icons.arrow_downward, 'Withdraw', WithdrawalPage()),
                          buildNavigationButton(
                              Icons.arrow_upward, 'Deposit', DepositPage()),
                          buildNavigationButton(
                              Icons.swap_horiz, 'Transfer', TransferPage()),
                          buildNavigationButton(
                              Icons.history, 'History', TransactionHistoryPage()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<Map<String, dynamic>> buildBalanceWidget() {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading user data');
        }

        return ValueListenableBuilder<double>(
          valueListenable: totalBalanceNotifier,
          builder: (context, value, child) {
            return Text(
              isEyeOpen ? currencyFormatter.format(value) : '******',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Colors.white,
              ),
            );
          },
        );
      },
    );
  }

  Widget buildNavigationButton(IconData icon, String label, Widget page) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          icon: Icon(icon),
          iconSize: 40,
          color: Color.fromARGB(255, 168, 78, 224),
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

class TimeZone {
  final int offset;
  final String name;

  TimeZone(this.offset, this.name);
}
