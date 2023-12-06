import 'package:expense_tracker/widget/chart/chart.dart';
import 'package:expense_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:flutter/material.dart';

class Expeneses extends StatefulWidget {
  const Expeneses({super.key});

  @override
  State<Expeneses> createState() => _ExpenesesState();
}

class _ExpenesesState extends State<Expeneses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      amount: 20,
      title: "Flutter Course",
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      amount: 15,
      title: "Cinema",
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
      isScrollControlled: true,
    );
  }

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
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // to determine the width and height of the the device
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    Widget mainContent = const Center(
      child: Text("No expenses found, Start adding some!"),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
