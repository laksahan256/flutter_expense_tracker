import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddNewExpense extends StatefulWidget {
  final void Function(Expense) onAddExpense;
  const AddNewExpense(this.onAddExpense, {super.key});

  @override
  State<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text); 
    final isValidAmount = enteredAmount == null || enteredAmount <= 0;
    if (isValidAmount || _titleController.text.trim().isEmpty || _selectedDate == null) {
      showDialog(
        context: context, 
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please make sure a valid title, amount and date was entered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                }, 
                child: const Text('Okay')
              )
            ],
          );
        }
      );
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text, amount: enteredAmount, category: _selectedCategory, date: _selectedDate!));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text('Title')),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  decoration: const InputDecoration(
                    label: Text('Amount'),
                    prefixText: 'Rs. ',
                  ),
                ),
              ),
              const SizedBox(width: 60),
              Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
              IconButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final pickedDate = await showDatePicker(
                    context: context, 
                    initialDate: now, 
                    firstDate: DateTime(now.year - 1, now.month), 
                    lastDate: now
                  );
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }, 
                icon: const Icon(Icons.calendar_month)
              )
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name)
                  );
                }).toList(), 
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text('Cancel')
              ),
              ElevatedButton(
                onPressed: _submitExpenseData, 
                child: const Text('Save Expense')
              )
            ],
          )
        ],
      ),
    );
  }
}