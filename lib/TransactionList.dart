import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return // transactions
        transactions.isEmpty
            ? LayoutBuilder(builder: (ctx, constraints) {
                return Column(
                  children: [
                    Text(
                      'you have no transactions yet',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                );
              })
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 6,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                        radius: 30,
                      ),
                      title: Text('${transactions[index].title}'),
                      subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_rounded),
                        onPressed: () =>
                            deleteTransaction(transactions[index].id),
                      ),
                    ),
                  );
                },
                itemCount: transactions.length,
              );
  }
}
