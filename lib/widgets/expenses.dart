// ignore_for_file: non_constant_identifier_names

import 'package:finance_tracker/chart/chart.dart';
import 'package:finance_tracker/models/expense.dart';
import 'package:finance_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:finance_tracker/widgets/new_Expenses.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      amount: 19.99,
      date: DateTime.now(),
      title: 'intern',
      category: Category.Entertainment,
      type: TransactionType.Expense,
    ),
    Expense(
      amount: 15.59,
      date: DateTime.now(),
      title: 'cinema',
      category: Category.Salary,
      type: TransactionType.Expense,
    )
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      // this is for the screen elements not to be there behind the camera, it is for modal to display below camera and not take that camera place
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpenses(
        onAddExpense: _addExpense,
      ),
    );
  }
// this context value which we get here holds information about this expenses widget in the end and its position in the widget tree.
// As you'll also see if you hover over this context value. Now this object which is full of metadata, is required by show modal bottom sheet, which is why you have to pass it.

// And whenever you see an argument called builder it basically always means that you must provide a function as a value.
// And here it's a function that should return a widget and that automatically gets one input value passed into it by Flutter,
// which will call this builder function basically when it then tries to show this modal bottom sheet.

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('expense deleted'),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    MediaQuery.of(context).size.height;
    // this(mediaquery) is for dimensions of the screen
    Widget mainContent = const Center(
      child: Text('no expenses found. try adding some!'),
    );
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to finance tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent)
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(child: mainContent)
              ],
            ),
    );
  }
}
