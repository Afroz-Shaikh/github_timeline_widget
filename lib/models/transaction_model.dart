import 'package:github_timeline/models/transaction_detail_model.dart';

///
/// Transaction class for each day's transaction
///
class Transaction {
  /// Constructor for the Transaction class
  Transaction({
    required this.date,
    required this.totalAmount,
    required this.transactionDetails,
  });

  ///
  /// Method for  Converting the JSON object to a Transaction object
  ///
  factory Transaction.fromJson(Map<String, dynamic> json) {
    final list = json['transactions'] as List;
    final transactionList = list
        .map((i) => TransactionDetail.fromJson(i as Map<String, dynamic>))
        .toList();
    return Transaction(
      date: json['date'] as String,
      totalAmount: json['totalAmount'] as double,
      transactionDetails: transactionList,
    );
  }

  /// The date of the transaction
  final String date;

  /// The total amount of the transaction
  final double totalAmount;

  /// The list of transaction details
  final List<TransactionDetail> transactionDetails;
}
