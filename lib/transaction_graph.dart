import 'package:flutter/material.dart';
import 'package:github_timeline/main.dart';
import 'package:github_timeline/temp.dart';
import 'package:flutter/material.dart';

// Custom function to format DateTime as 'yyyy-MM-dd'
String formatDate(DateTime date) {
  String year = date.year.toString();
  String month = date.month < 10 ? '0${date.month}' : date.month.toString();
  String day = date.day < 10 ? '0${date.day}' : date.day.toString();
  return '$year-$month-$day';
}

class TransactionGraph extends StatefulWidget {
  final List<Transaction> transactions;

  TransactionGraph({required this.transactions});

  @override
  _TransactionGraphState createState() => _TransactionGraphState();
}

class _TransactionGraphState extends State<TransactionGraph> {
  late final Map<String, double> _transactionMap;

  @override
  void initState() {
    super.initState();
    _transactionMap = _aggregateTransactions(widget.transactions);
  }

  Map<String, double> _aggregateTransactions(List<Transaction> transactions) {
    final Map<String, double> transactionMap = {};
    for (var transaction in transactions) {
      transactionMap[transaction.date] = transaction.totalAmount;
    }
    return transactionMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yearly Transaction Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildGraph(),
      ),
    );
  }

  Widget _buildGraph() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year - 1, now.month, now.day);
    final blocks = <Widget>[];

    for (int i = 0; i < 365; i++) {
      final currentDate = firstDayOfYear.add(Duration(days: i));
      final dateString = formatDate(currentDate);
      final amountSpent = _transactionMap[dateString] ?? 0.0;
      final colorIntensity = (amountSpent / 100).clamp(0.0, 1.0);
      final color =
          Color.lerp(Colors.orange[100], Colors.orange[900], colorIntensity)!;

      blocks.add(
        GestureDetector(
          onTap: () =>
              _showTransactionsDialog(context, currentDate, amountSpent),
          child: Container(
            margin: const EdgeInsets.all(1.0),
            width: 10,
            height: 10,
            color: color,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: blocks,
    );
  }

  void _showTransactionsDialog(
      BuildContext context, DateTime date, double amountSpent) {
    final dateString = formatDate(date);
    final transactions = widget.transactions
        .where((transaction) => transaction.date == dateString)
        .expand((transaction) => transaction.transactionDetails)
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transactions on $dateString'),
          content: transactions.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: transactions
                      .map((detail) => ListTile(
                            title: Text(detail.merchant),
                            subtitle:
                                Text('\$${detail.amount.toStringAsFixed(2)}'),
                          ))
                      .toList(),
                )
              : Text('No transactions recorded for this day.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
