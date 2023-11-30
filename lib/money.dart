import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uas_emoney/Transaction.dart';

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
      String senderPhoneNumber =
          await getPhoneNumber(FirebaseAuth.instance.currentUser?.uid ?? '');

      totalBalance -= amount;
      await _updateFirestoreBalance(-amount, "Transfer to $phoneNumber");

      await _updateFirestoreBalanceForRecipient(recipientUserId, amount, senderPhoneNumber);

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
      
    }
  } catch (error) {
    print('Error during phone number transfer: $error');
  }
}
  

  static Future<void> _updateFirestoreBalanceForRecipient(
      String recipientUserId, double amount, String senderPhoneNumber) async {
    try {
      String senderUid = FirebaseAuth.instance.currentUser?.uid ?? '';
      firestore.DocumentReference senderDocRef = firestore
          .FirebaseFirestore.instance
          .collection('users')
          .doc(senderUid);

      firestore.DocumentReference recipientDocRef = firestore
          .FirebaseFirestore.instance
          .collection('users')
          .doc(recipientUserId);

      await firestore.FirebaseFirestore.instance
          .runTransaction((transaction) async {
        firestore.DocumentSnapshot senderSnapshot =
            await transaction.get(senderDocRef);
        firestore.DocumentSnapshot recipientSnapshot =
            await transaction.get(recipientDocRef);

        double currentSenderBalance =
            (senderSnapshot.get('balance') ?? 0).toDouble();
        double currentRecipientBalance =
            (recipientSnapshot.get('balance') ?? 0).toDouble();

        double newSenderBalance = currentSenderBalance - amount;
        double newRecipientBalance = currentRecipientBalance + amount;

        transaction.update(senderDocRef, {'balance': newSenderBalance});
        transaction.update(recipientDocRef, {'balance': newRecipientBalance});

        firestore.CollectionReference recipientHistoryCollection =
            recipientDocRef.collection('history');
        await recipientHistoryCollection.add({
          'type': "Receive from $senderPhoneNumber",
          'amount': amount,
          'date': DateTime.now(),
          'sender': senderUid,
        });
      });
    } catch (error) {
      print(
          'Error updating recipient balance and sender history in Firestore: $error');
    }
  }

  static void withdraw(double amount) async {
    totalBalance -= amount;
    await _updateFirestoreBalance(-amount, "Withdraw With Atm");
    _notifyBalanceChange();
  }

  static void _notifyBalanceChange() {
    print('Balance changed. New balance: $totalBalance');
    if (onBalanceChange != null) {
      onBalanceChange!();
    }
  }

 static Future<String> getPhoneNumber(String uid) async {
    try {
      firestore.DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

      if (userSnapshot.exists) {

        String phone = userSnapshot.data()?['phone'] ?? '';
        return phone;
      } else {

        return '';
      }
    } catch (error) {
      print('Error getting phone number: $error');
      return ''; 
    }
  }

  static Future<void> _updateFirestoreBalance(
      double amount, String transactionType) async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      firestore.DocumentReference userDocRef =
          firestore.FirebaseFirestore.instance.collection('users').doc(uid);


      await firestore.FirebaseFirestore.instance
          .runTransaction((transaction) async {
        firestore.DocumentSnapshot snapshot = await transaction.get(userDocRef);

        double currentBalance = (snapshot.get('balance') ?? 0).toDouble();
        double newBalance = currentBalance + amount;

        transaction.update(userDocRef, {'balance': newBalance});

        firestore.CollectionReference historyCollection =
            userDocRef.collection('history');
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
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return currencyFormatter.format(amount);
  }
}
