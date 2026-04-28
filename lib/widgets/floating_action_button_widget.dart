import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const FloatingActionButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppTheme.primaryColor,
      child: Icon(Icons.add, size: 30),
    );
  }
}
