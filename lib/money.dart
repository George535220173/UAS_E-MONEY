import 'package:intl/intl.dart';
import 'package:uas_emoney/Transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class Money {
  static double totalBalance = 0.0;
  static Function()? onBalanceChange;
  static List<Transaction> transactionHistory = [];

  static void deposit(double amount) async {
    totalBalance += amount;
    await _updateFirestoreBalance(amount, "Deposit Via Debit");
    _notifyBalanceChange();
  }

  static void giftCode(double amount) async {
    totalBalance += amount;
    await _updateFirestoreBalance(amount, "Deposit Via Giftcode");
    _notifyBalanceChange();
  }

  static void transfer(double amount) async {
    totalBalance -= amount;
    await _updateFirestoreBalance(-amount, "Transfer");
    _notifyBalanceChange();
  }

  static void transferToPhoneNumber(String phoneNumber, double amount) async {
    try {
      firestore.QuerySnapshot users = await firestore.FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .get();

      if (users.docs.isNotEmpty) {
        String recipientUserId = users.docs.first.id;

        totalBalance -= amount;
        await _updateFirestoreBalance(-amount, "Transfer to Phone Number");

        await _updateFirestoreBalanceForRecipient(recipientUserId, amount);

        await firestore.FirebaseFirestore.instance
            .collection('transactions')
            .add({
          'sender': FirebaseAuth.instance.currentUser?.uid,
          'recipient': recipientUserId,
          'amount': amount,
          'date': DateTime.now(),
        });

        _notifyBalanceChange();
      } else {
        print('Phone number not found in Firestore.');
        // Handle phone number not found error
      }
    } catch (error) {
      print('Error during phone number transfer: $error');
    }
  }

  static Future<void> _updateFirestoreBalanceForRecipient(String recipientUserId, double amount) async {
    try {
      firestore.DocumentReference recipientDocRef =
          firestore.FirebaseFirestore.instance.collection('users').doc(recipientUserId);

      await firestore.FirebaseFirestore.instance.runTransaction((transaction) async {
        firestore.DocumentSnapshot snapshot = await transaction.get(recipientDocRef);

        double currentBalance = (snapshot.get('balance') ?? 0).toDouble();
        double newBalance = currentBalance + amount;

        transaction.update(recipientDocRef, {'balance': newBalance});
      });
    } catch (error) {
      print('Error updating recipient balance in Firestore: $error');
    }
  }

  static void withdraw(double amount) async {
    totalBalance -= amount;
    await _updateFirestoreBalance(-amount, "Withdraw");
    _notifyBalanceChange();
  }

  static void _notifyBalanceChange() {
    print('Balance changed. New balance: $totalBalance');
    if (onBalanceChange != null) {
      onBalanceChange!();
    }
  }

  static Future<void> _updateFirestoreBalance(double amount, String transactionType) async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      firestore.DocumentReference userDocRef =
          firestore.FirebaseFirestore.instance.collection('users').doc(uid);

      await firestore.FirebaseFirestore.instance.runTransaction((transaction) async {
        firestore.DocumentSnapshot snapshot = await transaction.get(userDocRef);

        double currentBalance = (snapshot.get('balance') ?? 0).toDouble();
        double newBalance = currentBalance + amount;

        transaction.update(userDocRef, {'balance': newBalance});

        firestore.CollectionReference historyCollection = userDocRef.collection('history');
        await historyCollection.add({
          'type': transactionType,
          'amount': amount,
          'date': DateTime.now(),
        });
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

      firestore.DocumentSnapshot snapshot = await userDocRef.get();

      totalBalance = (snapshot.get('balance') ?? 0.0).toDouble();
      _notifyBalanceChange();
    } catch (error) {
      print('Error initializing totalBalance: $error');
    }
  }

  static void redeemGiftCode(String code, double selectedAmount) {
    giftCode(selectedAmount);
  }

  static String formatCurrency(double amount) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return currencyFormatter.format(amount);
  }
}