import 'package:expense_tracker/model/expense.dart';
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

  void _submitExpenseData() {
    final enterAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enterAmount == null || enterAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // Error pop up
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


    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(20, 40, 20, keyboardSpace+  20),
          child: Column(
            children: [
              //Title section
              TextField(
                controller: _titleController,
                maxLength: 20,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
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
  }
}
