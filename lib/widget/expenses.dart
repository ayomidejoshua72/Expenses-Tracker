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
      builder: (ctx) =>  NewExpense(onAddExpense: _addExpense),
      isScrollControlled: true,
    );
  }

  void _addExpense(Expense expenses) {
    setState(() {
      _registeredExpenses.add(expenses);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          const Text("The Chart"),
          Expanded(
            child: ExpensesList(expenses: _registeredExpenses),
          )
        ],
      ),
    );
  }
}
