import 'package:github_timeline/models/models.dart';
import 'package:github_timeline/utils/constants.dart';

///
/// List of transactions for the user ||  Mocked Data for the transactions
///
final List<Transaction> mockTransactions = [
  // June 2024
  Transaction(
    date: '2024-06-01',
    totalAmount: 12.99,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Amazon',
        amount: 12.99,
        category: 'Shopping',
        type: ExpenseType.credit,
      ),
    ],
  ),
  Transaction(
    date: '2024-06-03',
    totalAmount: 34.50,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Starbucks',
        amount: 34.50,
        category: 'Dining',
        type: ExpenseType.credit,
      ),
    ],
  ),
  Transaction(
    date: '2024-06-07',
    totalAmount: 55.75,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Walmart',
        amount: 55.75,
        category: 'Groceries',
      ),
    ],
  ),
  Transaction(
    date: '2024-06-10',
    totalAmount: 89.99,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Target',
        amount: 89.99,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-06-14',
    totalAmount: 24,
    transactionDetails: [
      TransactionDetail(
        merchant: "McDonald's",
        amount: 24,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-06-18',
    totalAmount: 150,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Best Buy',
        amount: 150,
        category: 'Electronics',
      ),
    ],
  ),
  Transaction(
    date: '2024-06-21',
    totalAmount: 45.99,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Whole Foods',
        amount: 45.99,
        category: 'Groceries',
      ),
    ],
  ),

  // July 2024
  Transaction(
    date: '2024-07-02',
    totalAmount: 75,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Amazon',
        amount: 75,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-07-04',
    totalAmount: 28.50,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Starbucks',
        amount: 28.50,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-07-06',
    totalAmount: 66.30,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Target',
        amount: 66.30,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-07-10',
    totalAmount: 120,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Walmart',
        amount: 120,
        category: 'Groceries',
      ),
    ],
  ),
  Transaction(
    date: '2024-07-14',
    totalAmount: 52.20,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Uber Eats',
        amount: 52.20,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-07-18',
    totalAmount: 33.99,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Best Buy',
        amount: 33.99,
        category: 'Electronics',
      ),
    ],
  ),
  Transaction(
    date: '2024-07-21',
    totalAmount: 40,
    transactionDetails: [
      TransactionDetail(
        merchant: "McDonald's",
        amount: 40,
        category: 'Dining',
      ),
    ],
  ),

  // August 2024
  Transaction(
    date: '2024-08-01',
    totalAmount: 150,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Apple Store',
        amount: 150,
        category: 'Electronics',
      ),
    ],
  ),
  Transaction(
    date: '2024-08-03',
    totalAmount: 60,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Target',
        amount: 60,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-08-06',
    totalAmount: 35,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Starbucks',
        amount: 35,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-08-09',
    totalAmount: 75.50,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Whole Foods',
        amount: 75.50,
        category: 'Groceries',
      ),
    ],
  ),
  Transaction(
    date: '2024-08-12',
    totalAmount: 120,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Walmart',
        amount: 120,
        category: 'Groceries',
      ),
    ],
  ),
  Transaction(
    date: '2024-08-18',
    totalAmount: 88,
    transactionDetails: [
      TransactionDetail(
        merchant: "McDonald's",
        amount: 88,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-08-21',
    totalAmount: 200,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Amazon',
        amount: 200,
        category: 'Shopping',
      ),
    ],
  ),

  // September 2024
  Transaction(
    date: '2024-09-02',
    totalAmount: 55,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Target',
        amount: 55,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-09-04',
    totalAmount: 22,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Starbucks',
        amount: 22,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-09-08',
    totalAmount: 105,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Whole Foods',
        amount: 105,
        category: 'Groceries',
      ),
    ],
  ),
  Transaction(
    date: '2024-09-12',
    totalAmount: 45,
    transactionDetails: [
      TransactionDetail(
        merchant: "McDonald's",
        amount: 45,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-09-15',
    totalAmount: 150,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Best Buy',
        amount: 150,
        category: 'Electronics',
      ),
    ],
  ),
  Transaction(
    date: '2024-09-18',
    totalAmount: 62.50,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Uber Eats',
        amount: 62.50,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-09-22',
    totalAmount: 44,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Target',
        amount: 44,
        category: 'Shopping',
      ),
    ],
  ),

  // October 2024
  Transaction(
    date: '2024-10-02',
    totalAmount: 30,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Whole Foods',
        amount: 30,
        category: 'Groceries',
      ),
    ],
  ),
  Transaction(
    date: '2024-10-05',
    totalAmount: 80,
    transactionDetails: [
      TransactionDetail(
        merchant: "McDonald's",
        amount: 80,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-10-08',
    totalAmount: 50,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Amazon',
        amount: 50,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-10-12',
    totalAmount: 150,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Best Buy',
        amount: 150,
        category: 'Electronics',
      ),
    ],
  ),
  Transaction(
    date: '2024-10-15',
    totalAmount: 100,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Apple Store',
        amount: 100,
        category: 'Electronics',
      ),
    ],
  ),
  Transaction(
    date: '2024-10-20',
    totalAmount: 45.99,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Target',
        amount: 45.99,
        category: 'Shopping',
      ),
    ],
  ),

  // November 2024
  Transaction(
    date: '2024-11-01',
    totalAmount: 15.50,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Amazon',
        amount: 15.50,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-11-03',
    totalAmount: 45.75,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Starbucks',
        amount: 45.75,
        category: 'Dining',
      ),
    ],
  ),
  Transaction(
    date: '2024-11-05',
    totalAmount: 110,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Walmart',
        amount: 110,
        category: 'Groceries',
      ),
    ],
  ),
  Transaction(
    date: '2024-11-07',
    totalAmount: 20,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Target',
        amount: 20,
        category: 'Shopping',
      ),
    ],
  ),
  Transaction(
    date: '2024-11-09',
    totalAmount: 75,
    transactionDetails: [
      TransactionDetail(
        merchant: 'Uber Eats',
        amount: 40,
        category: 'Dining',
        type: ExpenseType.credit,
      ),
      TransactionDetail(
        merchant: 'Spotify',
        amount: 35,
        category: 'Entertainment',
      ),
    ],
  ),
  Transaction(
    date: '2024-11-10',
    totalAmount: 5.50,
    transactionDetails: [
      TransactionDetail(
        merchant: "McDonald's",
        amount: 5.50,
        category: 'Dining',
      ),
    ],
  ),
];
