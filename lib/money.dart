import 'package:uas_emoney/Transaction.dart';
import 'package:uas_emoney/Deposit/giftcode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_emoney/Home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;


class Money {
  static double totalBalance = 0.0;
  static Function()? onBalanceChange;
  static List<Transaction> transactionHistory = [];

  static void deposit(double amount) async {
    totalBalance += amount;
    await _updateFirestoreBalance(amount);
    _notifyBalanceChange();
  }

  static void transfer(double amount) async {
    totalBalance -= amount;
    await _updateFirestoreBalance(-amount);
    _notifyBalanceChange();
  }

  static void withdraw(double amount) async {
    totalBalance -= amount;
    await _updateFirestoreBalance(-amount);
    _notifyBalanceChange();
  }

static void _notifyBalanceChange() {
  print('Balance changed. New balance: $totalBalance');
  if (onBalanceChange != null) {
    onBalanceChange!();
  }
}

static Future<void> _updateFirestoreBalance(double amount) async {
  try {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    firestore.DocumentReference userDocRef =
        firestore.FirebaseFirestore.instance.collection('users').doc(uid);

    await firestore.FirebaseFirestore.instance.runTransaction((transaction) async {
      firestore.DocumentSnapshot snapshot = await transaction.get(userDocRef);

      double currentBalance = (snapshot.get('balance') ?? 0).toDouble();
      double newBalance = currentBalance + amount;

      transaction.update(userDocRef, {'balance': newBalance});
    });
  } catch (error) {
    print('Error updating Firestore balance: $error');
  }
}

  static Future<void> initializeTotalBalance() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      firestore.DocumentReference userDocRef =
          firestore.FirebaseFirestore.instance.collection('users').doc(uid);

      firestore.DocumentSnapshot snapshot =
          await userDocRef.get(); // Get data from Firestore

      // Set totalBalance based on the value in Firestore
      totalBalance = (snapshot.get('balance') ?? 0.0).toDouble();
      _notifyBalanceChange();
    } catch (error) {
      print('Error initializing totalBalance: $error');
    }
  }

  static void redeemGiftCode(String code, double selectedAmount) {
    // You can use the selected amount here
    deposit(selectedAmount);
  }
}