import 'dart:io';

import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategories = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(
      now.year - 1,
      now.month,
      now.day,
    );
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDialog() {
    // for IOS devices
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text("Invalid Input!"),
            content: const Text(
                "Please make sure a valid title, amount, date and catergories was entered."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"),
              ),
            ],
          );
        },
      );
      //for Android devices (Platfrom.IsAndroid)
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Invalid Input!"),
            content: const Text(
                "Please make sure a valid title, amount, date and catergories was entered."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"),
              ),
            ],
          );
        },
      );
    }
  }

  void _submitExpenseData() {
    final enterAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enterAmount == null || enterAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // Error pop up
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        amount: enterAmount,
        title: _titleController.text,
        date: _selectedDate!,
        category: _selectedCategories,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (context, contraints) {
      final width = contraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, keyboardSpace + 20),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title section
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Amount input section
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            prefixText: "\$",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  //Title section
                  TextField(
                    controller: _titleController,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      //Category section
                      DropdownButton(
                        value: _selectedCategories,
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
                        onChanged: (value) {
                          value == null
                              ? _selectedCategories
                              : setState(
                                  () {
                                    _selectedCategories = value;
                                  },
                                );
                        },
                      ),
                      const SizedBox(width: 16),
                      //Date picker section
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No date Selected"
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: () {
                                _presentDatePicker();
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      // Amount input section
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            prefixText: "\$",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 60,
                      ),

                      //Date picker section
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No date Selected"
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: () {
                                _presentDatePicker();
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      //Cancel button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),

                      //Save button
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: const Text("Save Expense"),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      //Category section
                      DropdownButton(
                        value: _selectedCategories,
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
                        onChanged: (value) {
                          value == null
                              ? _selectedCategories
                              : setState(
                                  () {
                                    _selectedCategories = value;
                                  },
                                );
                        },
                      ),

                      const Spacer(),
                      //Cancel button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),

                      //Save button
                      ElevatedButton(
                        onPressed: () {
                          _submitExpenseData();
                        },
                        child: const Text("Save Expense"),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
