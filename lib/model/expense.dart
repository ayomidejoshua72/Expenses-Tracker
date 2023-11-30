import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Expense {
  Expense({
    required this.amount,
    required this.title,
    required this.date,
  }) : id = uuid.v4();

  final String title;
  final String id;
  final double amount;
  final DateTime date;
}
