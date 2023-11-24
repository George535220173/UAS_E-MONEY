import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
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
    var jakartaTimeZone = TimeZone(timeZoneOffset.isNegative ? -7 * 60 : 7 * 60,
        'WIB'); // Jakarta timezone

    var jakartaTime = now.toUtc().add(Duration(
        minutes: timeZoneOffset.inMinutes > 0
            ? jakartaTimeZone.offset
            : -jakartaTimeZone.offset));

    if (jakartaTime.hour < 12) {
      greeting = 'Selamat Pagi';
    } else if (jakartaTime.hour < 17) {
      greeting = 'Selamat Siang';
    } else if (jakartaTime.hour < 20) {
      greeting = 'Selamat Sore';
    } else {
      greeting = 'Selamat malam';
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
      backgroundColor: Color.fromARGB(255, 45, 3, 100),
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
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 70, 10, 149),
                            Color.fromARGB(255, 100, 14, 228),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(70),
                          bottomRight: Radius.circular(70),
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
                                        fontSize: 20,
                                        fontFamily: 'PoppinsRegular',
                                        color:
                                            Color.fromARGB(255, 255, 253, 128),
                                      ),
                                    ),
                                    Text(
                                      '$firstName $lastName',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30,
                                        fontFamily: 'PoppinsBold',
                                        color:
                                            Color.fromARGB(255, 255, 253, 128),
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
                        height: 130,
                        width: 320,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 253, 128),
                              Color.fromARGB(255, 255, 212, 196),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(2),
                            bottomRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Balance',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 28,
                                      fontFamily: 'PoppinsBold',
                                      color: Color.fromARGB(255, 77, 234, 164),
                                    ),
                                  ),
                                  IconButton(
                                    icon: isEyeOpen
                                        ? Icon(
                                            Icons.remove_red_eye,
                                            color: Color.fromARGB(
                                                255, 100, 255, 185),
                                          )
                                        : Icon(
                                            Icons.visibility_off,
                                            color: Color.fromARGB(
                                                255, 100, 255, 185),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 20),
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
                      padding: EdgeInsets.only(top: 665),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 70, 10, 149),
                              Color.fromARGB(255, 100, 14, 228),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(top: 690),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildNavigationButton(Icons.arrow_downward,
                              'WITHDRAW', WithdrawalPage()),
                          buildNavigationButton(
                              Icons.arrow_upward, 'DEPOSIT', DepositPage()),
                          buildNavigationButton(
                              Icons.swap_horiz, 'TRANSFER', TransferPage()),
                          buildNavigationButton(Icons.history, 'HISTORY',
                              TransactionHistoryPage()),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 300,
                      top: 21,
                      child: Image.asset(
                        'assets/images/Wizzzzz test icon.png',
                        width: 90,
                        height: 90,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 300),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 200.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 200),
                          viewportFraction: 0.8,
                        ),
                        carouselController: CarouselController(),
                        items: [
                          Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage('assets/ad/sisyphus.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/ad/its official ive gone insane.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/ad/F-s7NEPWkAAVmWa.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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
                fontFamily: 'PoppinsBold',
                color: Color.fromARGB(255, 105, 100, 255),
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
          iconSize: 45,
          color: Color.fromARGB(255, 255, 253, 128),
        ),
        SizedBox(height: 0),
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'PoppinsBold',
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 26, 0, 87)),
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
