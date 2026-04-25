import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppTheme.primaryColor,
      child: Icon(Icons.add, size: 30),
    );
  }
}
