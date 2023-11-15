import 'package:uas_emoney/Transaction.dart';

class Money {
  static double totalBalance = 0.0;
  static Function()? onBalanceChange;
  static List<Transaction> transactionHistory = [];

  static void deposit(double amount) {
    totalBalance += amount;
    _notifyBalanceChange();
  }

  static void transfer(double amount) {
    totalBalance -= amount;
    _notifyBalanceChange();
  }

  static void _notifyBalanceChange() {
    if (onBalanceChange != null) {
      onBalanceChange!();
    }
  }
}
