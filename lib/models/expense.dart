import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { Groceries, Rent, Salary, Entertainment }

enum TransactionType { Income, Expense }

const categoryIcons = {
  Category.Groceries: Icons.restaurant_menu_sharp,
  Category.Salary: Icons.money_sharp,
  Category.Rent: Icons.real_estate_agent,
  Category.Entertainment: Icons.movie
};

const transactionmethod = {
  TransactionType.Income: 'income',
  TransactionType.Expense: 'expense'
};

class Expense {
  Expense({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    required this.type,
  }) : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final TransactionType type;

  String get formattedDate {
    return formatter.format(date);
  }
}

class Expensebucket {
  Expensebucket({required this.category, required this.expenses});
  Expensebucket.forCategory(List<Expense> allexpenses, this.category)
      : expenses = allexpenses
            .where((expense) => expense.category == category)
            .toList();
  final Category category;
  final List<Expense> expenses;
  double get totalexpense {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
