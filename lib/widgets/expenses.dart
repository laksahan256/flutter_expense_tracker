import 'package:expense_tracker/widgets/add_new_expense.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(title: 'Flutter Course', amount: 6000, date: DateTime.now(), category: Category.work),
    Expense(title: 'Cinema', amount: 800, date: DateTime.now(), category: Category.leisure)
  ];

  void _appendNewExpense(Expense expense) {
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
        content: const Text('Expense deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }
        ),
      )
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (ctx) => AddNewExpense(_appendNewExpense)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay, 
            icon: const Icon(Icons.add)
          )
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          _registeredExpenses.isEmpty 
            ? const Center(
              child: Text('No expenses found. Start adding some!')
            ) 
            : Expanded(
              child: ExpensesList(_registeredExpenses, _removeExpense)
            )
        ],
      ),
    );
  }
}