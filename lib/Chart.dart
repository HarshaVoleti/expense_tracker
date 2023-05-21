import 'package:expense_tracker/Transactions.dart';
import 'package:expense_tracker/chartbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transactions> recentTransactions;

  Chart(this.recentTransactions);

  List<Map> get groupedTransactionsvalues {
    return List.generate(7, (index) {
      var weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalsum = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalsum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalsum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsvalues.fold(0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(242, 249, 253, 1),
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedTransactionsvalues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
              data['day'],
              data['amount'],
              totalSpending == 0
                  ? 0
                  : (data["amount"] as double) / totalSpending,
            ),
          );
        }).toList(),
      ),
    );
  }
}
