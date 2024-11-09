import 'dart:convert';
import 'package:flutter/material.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Visualization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TransactionGridScreen(),
    );
  }
}

// Transaction class for a single transaction
class Transaction {
  final String transactionId;
  final double amount;
  final String type;
  final String merchant;
  final String category;

  Transaction({
    required this.transactionId,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      amount: json['amount'],
      type: json['type'],
      merchant: json['merchant'],
      category: json['category'],
    );
  }
}

// DayTransaction class for a list of transactions for one day
class DayTransaction {
  final String date;
  final List<Transaction> transactions;

  DayTransaction({
    required this.date,
    required this.transactions,
  });

  factory DayTransaction.fromJson(Map<String, dynamic> json) {
    var list = json['transactions'] as List;
    List<Transaction> transactionList =
        list.map((i) => Transaction.fromJson(i)).toList();

    return DayTransaction(
      date: json['date'],
      transactions: transactionList,
    );
  }

  // Calculate total amount spent for the day
  double get totalAmount {
    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }
}

// Response class for API data
class TransactionResponse {
  final String status;
  final String message;
  final List<DayTransaction> data;

  TransactionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<DayTransaction> dayTransactionList =
        list.map((i) => DayTransaction.fromJson(i)).toList();

    return TransactionResponse(
      status: json['status'],
      message: json['message'],
      data: dayTransactionList,
    );
  }
}

// Mock API data response
final mockApiResponse = '''
{
  "status": "success",
  "message": "Transactions fetched successfully",
  "data": [
    {
      "date": "2024-11-09",
      "transactions": [
        {
          "transaction_id": "txn_001",
          "amount": 120.50,
          "type": "debit",
          "merchant": "Amazon",
          "category": "Shopping"
        },
        {
          "transaction_id": "txn_002",
          "amount": 45.75,
          "type": "debit",
          "merchant": "Starbucks",
          "category": "Dining"
        }
      ]
    },
    {
      "date": "2024-11-08",
      "transactions": [
        {
          "transaction_id": "txn_003",
          "amount": 35.00,
          "type": "debit",
          "merchant": "Uber",
          "category": "Transport"
        }
      ]
    },
    {
      "date": "2024-11-07",
      "transactions": [
        {
          "transaction_id": "txn_004",
          "amount": 200.00,
          "type": "credit",
          "merchant": "Refund from Store",
          "category": "Refund"
        },
        {
          "transaction_id": "txn_005",
          "amount": 75.00,
          "type": "debit",
          "merchant": "Walmart",
          "category": "Shopping"
        }
      ]
    },
    {
      "date": "2024-10-31",
      "transactions": [
        {
          "transaction_id": "txn_006",
          "amount": 50.00,
          "type": "debit",
          "merchant": "Netflix",
          "category": "Subscription"
        }
      ]
    },
    {
      "date": "2024-09-15",
      "transactions": [
        {
          "transaction_id": "txn_007",
          "amount": 500.00,
          "type": "debit",
          "merchant": "Apple Store",
          "category": "Electronics"
        }
      ]
    }
  ]
}
''';

class TransactionGridScreen extends StatelessWidget {
  // Simulating a mock API response (you would normally fetch this from an actual API)
  final TransactionResponse transactionResponse = TransactionResponse.fromJson(
      Map<String, dynamic>.from(
          jsonDecode(mockApiResponse) as Map));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Credit Card Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TransactionGrid(transactions: transactionResponse.data),
      ),
    );
  }
}

// Widget that displays the grid of transactions for an entire month
class TransactionGrid extends StatelessWidget {
  final List<DayTransaction> transactions;

  TransactionGrid({required this.transactions});

  // Function to return color based on spending amount
  Color getSpendingColor(double totalAmount) {
    if (totalAmount <= 20) {
      return Colors.green[200]!; // Low spending
    } else if (totalAmount <= 100) {
      return Colors.yellow[700]!; // Moderate spending
    } else if (totalAmount <= 300) {
      return Colors.orange[700]!; // High spending
    } else {
      return Colors.red[700]!; // Very high spending
    }
  }

  // Create a list of all the days for the current month
  List<DayTransaction> getDaysInMonth() {
    List<DayTransaction> allDays = [];
    for (int i = 1; i <= 30; i++) {
      String date = '2024-11-${i.toString().padLeft(2, '0')}';
      var dayTransaction = transactions.firstWhere(
          (transaction) => transaction.date == date,
          orElse: () => DayTransaction(date: date, transactions: []));
      allDays.add(dayTransaction);
    }
    return allDays;
  }

  @override
  Widget build(BuildContext context) {
    List<DayTransaction> monthDays = getDaysInMonth();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // Display 7 days per row (1 week)
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: monthDays.length, // 30 days for the month (can be dynamic)
      itemBuilder: (context, index) {
        DayTransaction dayTransaction = monthDays[index];
        double totalAmount = dayTransaction.totalAmount;

        return GestureDetector(
          onTap: () {
            showTransactionDetails(context, dayTransaction);
          },
          child: Container(
            color: getSpendingColor(totalAmount),
            child: Center(
              child: Text(
                dayTransaction.date.split("-")[2], // Day part of the date
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to display transaction details on tap
  void showTransactionDetails(BuildContext context, DayTransaction dayTransaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transactions for ${dayTransaction.date}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: dayTransaction.transactions.map((transaction) {
              return ListTile(
                title: Text(transaction.merchant),
                subtitle: Text(transaction.category),
                trailing: Text("\$${transaction.amount.toStringAsFixed(2)}"),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
