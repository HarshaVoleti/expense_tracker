import 'dart:io';

import 'package:expense_tracker/adaptivebuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addtransaction;

  NewTransaction(this._addtransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleInput = TextEditingController();
  final amountInput = TextEditingController();
  
  DateTime selectedDate = DateTime.now();

  void submitData() {
    final enteredTitle = titleInput.text;
    final enteredAmount = double.parse(amountInput.text);

    if (enteredTitle.isEmpty || enteredAmount == 0 || selectedDate == null) {
      return;
    }

    widget._addtransaction(
      enteredTitle,
      enteredAmount,
      selectedDate,
    );
    Navigator.of(context).pop();
  }

  void presentdatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'title',
                ),
                controller: titleInput,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: '000 000 0000',
                ),
                keyboardType: TextInputType.number,
                controller: amountInput,
                onSubmitted: (_) => submitData(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'No Date Choosen'
                          : 'Date: ${DateFormat.yMEd().format(selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: presentdatePicker,
                    child: Text("choose Date"),
                  ),
                ],
              ),
              TextButton(
                child: Text('Add transaction'),
                onPressed: () {
                  submitData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
