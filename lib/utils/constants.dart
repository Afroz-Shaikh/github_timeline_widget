///
/// Cycle Start Date is the Starting date of the Credit Card cycle
/// in this Project's context it is the day from where the
///  `CardTransactionsPage`'s Transaction Timeline starts
///
DateTime kcycleStartDate = DateTime.now().subtract(const Duration(days: 35));

///
/// The name of the User, In here set to 'Afroz'
///
const String kuserName = 'Afroz';

const String kRecentTransactions = 'Recent Transactions';

///
/// Method for converting a string to a DateTime object
///
DateTime convertStringToDateTime(String dateString) {
  return DateTime.parse(dateString);
}

///
/// The type of expense
///
enum ExpenseType {
  /// The expense is a credit transaction
  credit,

  /// The expense is a debit transaction
  debit,
}

///
///  Custom function to format DateTime as 'yyyy-MM-dd'
///
String formatDate(DateTime date) {
  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();
  return '$year-$month-$day';
}

