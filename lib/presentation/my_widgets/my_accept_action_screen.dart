import 'package:flutter/material.dart';

class MyAcceptActionScreen extends StatelessWidget {
  final String text;
  bool isConfirmed = false;

  MyAcceptActionScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Подтверждение'),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            isConfirmed = true;
            Navigator.of(context).pop();
          },
          child: const Text('Подтвердить'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
