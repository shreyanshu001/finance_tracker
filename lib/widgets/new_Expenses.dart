import 'package:flutter/material.dart';
import 'package:finance_tracker/models/expense.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

// Define an enum for transaction types

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpensesState();
  }
}

class _NewExpensesState extends State<NewExpenses> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  // this text editing controller manages the text which is to be entered.
  DateTime? _selectedDate;
  Category _selectedCategory = Category.Salary;
  // Add transaction type with default value
  TransactionType _transactionType = TransactionType.Expense;

  void _presentdatepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    // if tryparse('hello)=>null and if tryparse('1.12')=>1.12
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure that correct date, amount, and category is selected'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }

    // Adjust the amount based on transaction type (negative for expense, positive for income)
    final adjustedAmount = _transactionType == TransactionType.Expense
        ? -enteredAmount.abs()
        : enteredAmount.abs();

    widget.onAddExpense(
      Expense(
          amount: adjustedAmount,
          date: _selectedDate!,
          title: _titleController.text,
          category: _selectedCategory,
          type: _transactionType),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // this dispose method deletes the data when not used or widget is closed.
  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    // viewInsects.bottom, what it does is it contains extra information about all the ui operlappings from bottom.
    return LayoutBuilder(builder: (ctx, constraints) {
      // what this layout builder does is that it gives the dimensions of it's parent widget rather than whole screen dimension like mediaQuery.
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardspace + 16),
          child: SingleChildScrollView(
            // SingleChildScrollView widget makes the screen scrollable so that we can view other part of screen if it is hidden by keyboard or other things.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Type Selection (shown at the top of the form)
                const Text('Transaction Type:'),
                const SizedBox(height: 8),
                // Use a wrapper with constraints to prevent overflow
                SizedBox(
                  width: width, // Use full available width
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment<TransactionType>(
                          value: TransactionType.Income,
                          label: Text('Income'),
                          icon: Icon(Icons.arrow_downward),
                        ),
                        ButtonSegment<TransactionType>(
                          value: TransactionType.Expense,
                          label: Text('Expense'),
                          icon: Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: <TransactionType>{_transactionType},
                      onSelectionChanged: (Set<TransactionType> newSelection) {
                        setState(() {
                          _transactionType = newSelection.first;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (values) {
                            if (values == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = values;
                            });
                          }),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'Selected date'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentdatepicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'Selected date'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentdatepicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: Text(_transactionType == TransactionType.Expense
                            ? 'Save Expense'
                            : 'Save Income'),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (values) {
                            if (values == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = values;
                            });
                          }),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: Text(_transactionType == TransactionType.Expense
                            ? 'Save Expense'
                            : 'Save Income'),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
