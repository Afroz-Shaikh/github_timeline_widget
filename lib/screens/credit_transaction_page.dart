import 'package:flutter/material.dart';
import 'package:github_timeline/mocktransactions.dart';
import 'package:github_timeline/models/models.dart';
import 'package:github_timeline/screens/widgets/app_bar.dart';
import 'package:github_timeline/screens/widgets/base_time_line_widget.dart';
import 'package:github_timeline/utils/constants.dart';

///
/// The main entry point for the application
///
class CardTransactionsPage extends StatefulWidget {
  /// constructor for hompage
  const CardTransactionsPage({super.key});

  @override
  State<CardTransactionsPage> createState() => _CardTransactionsPageState();
}

class _CardTransactionsPageState extends State<CardTransactionsPage> {
  final GlobalKey _tooltipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: const MainAppBar(),
          body: Stack(
            children: [
              buildMainWidget(),
              buildScrollableSheet(),
            ],
          ),
        );
      },
    );
  }

  DraggableScrollableSheet buildScrollableSheet() {
    return DraggableScrollableSheet(
      snap: true,
      initialChildSize: 0.4,
      snapSizes: const [0.4, 0.6],
      minChildSize: 0.4,
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Color(0xff111111),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverList.list(
                children: [
                  const Divider(
                    color: Colors.white,
                    thickness: 0.2,
                    endIndent: 120,
                    indent: 120,
                  ),
                  ListTile(
                    trailing: Text(
                      mockTransactions
                          .map((e) => e.totalAmount)
                          .reduce((value, element) => value + element)
                          .toStringAsFixed(2),
                    ),
                    title: const Text(
                      'Recent Transactions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...mockTransactions.reversed.map((Transaction transaction) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 54, 54, 54),
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minLeadingWidth: 7,
                        leading: GestureDetector(
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            size: 10,
                          ),
                        ),
                        trailing: Text(
                          transaction.date,
                        ),
                        title: Text(
                          transaction.transactionDetails
                              .map((e) => e.merchant)
                              .join(
                                ', ',
                              ),
                        ),
                        subtitle: Text(
                          transaction.totalAmount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Builder buildMainWidget() {
    return Builder(
      builder: (context) {
        final isHorizontal = MediaQuery.of(context).size.width > 600;
        final children = [
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Text(
                  'Current Billing Cycle Spedings ${kcycleStartDate.difference(DateTime.now()).inDays} days left',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: SingleChildScrollView(
                    scrollDirection:
                        isHorizontal ? Axis.horizontal : Axis.vertical,
                    child: RotatedBox(
                      quarterTurns: isHorizontal ? 3 : 0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth,
                          maxHeight: isHorizontal ? double.maxFinite : 400,
                        ),
                        child: TransactionTimelineWidget(
                          cycleStartDate: kcycleStartDate,
                          transactions: mockTransactions,
                          showLastDaycount: isHorizontal ? 100 : 40,
                          rows: isHorizontal ? 10 : 7,
                          onTapCallback: (index) {
                            final cycleStartDate = kcycleStartDate;
                            final selectedDate =
                                cycleStartDate.add(Duration(days: index));

                            // Find the transaction for the selected date
                            final transaction = mockTransactions.firstWhere(
                              (Transaction t) => _isSameDay(
                                DateTime.parse(t.date),
                                selectedDate,
                              ), // Use _isSameDay to compare dates
                              orElse: () => Transaction(
                                date: selectedDate.toString(),
                                totalAmount: 0,
                                transactionDetails: [],
                              ),
                            );

                            ///
                            ///  the dialog with the  transaction
                            /// details
                            ///
                            showDialog<void>(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: SizedBox(
                                    height: 200,
                                    width: 300,
                                    child: ListView.builder(
                                      itemCount:
                                          transaction.transactionDetails.length,
                                      itemBuilder: (context, i) {
                                        final text = Text(
                                          '\$${transaction.transactionDetails[i].amount.toStringAsFixed(2)}',
                                        );
                                        return ListTile(
                                          title: Text(
                                            transaction
                                                .transactionDetails[i].merchant,
                                          ),
                                          subtitle: Text(
                                            transaction
                                                .transactionDetails[i].category,
                                          ),
                                          trailing: text,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Limit',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            textColor: Colors.grey,
            title: const Text(
              'Statement Summary',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Text('View'),
            ),
            subtitle: const Text('for the month November 2024'),
          ),
        ];
        return SizedBox(
          // color: Colors.red,
          child: Column(
            children: children,
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
