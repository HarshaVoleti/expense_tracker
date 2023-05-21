import 'package:flutter/material.dart';

class AdaptiveButtons extends StatelessWidget {
  final String text;
  final Function function;
  AdaptiveButtons(this.text, this.function);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      onPressed: () {
        function;
      },
    );
  }
}
