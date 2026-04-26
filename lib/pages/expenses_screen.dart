import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpensesScreen extends StatefulWidget {
  final List<String> names;

  const ExpensesScreen({super.key, required this.names});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Map<String, dynamic>> _expenses = [];

  String? _selectedName;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final BorderRadius _borderRadius = BorderRadius.circular(15);
  final Color _accentColor = Colors.teal;

  int _amountInCents = 0;

  // 🔥 Handle raw numeric input (cents)
  void _onAmountChanged(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    setState(() {
      _amountInCents = int.tryParse(digitsOnly) ?? 0;
    });
  }

  // 💰 formatted display
  String get _formattedAmount {
    final dollars = _amountInCents / 100;
    return '\$${dollars.toStringAsFixed(2)}';
  }

  void _addExpense() {
    if (_selectedName == null || _amountInCents <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid name and amount')),
      );
      return;
    }

    final amount = _amountInCents / 100;

    setState(() {
      _expenses.add({
        'name': _selectedName,
        'amount': amount,
        'description': _descriptionController.text.trim(),
      });

      _amountController.clear();
      _descriptionController.clear();
      _selectedName = null;
      _amountInCents = 0;
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _editExpense(int index) {
    final expense = _expenses[index];

    String selectedName = expense['name'];

    int editCents =
        ((expense['amount'] as double) * 100).round();

    final amountCtrl =
        TextEditingController(text: editCents.toString());

    final descCtrl =
        TextEditingController(text: expense['description'] ?? '');

    void onEditChanged(String value) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      editCents = int.tryParse(digits) ?? 0;
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(
              'Edit Expense',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedName,
                  decoration: InputDecoration(
                    labelText: 'Paid by',
                    border: OutlineInputBorder(
                      borderRadius: _borderRadius,
                    ),
                  ),
                  items: widget.names
                      .map((name) => DropdownMenuItem(
                            value: name,
                            child: Text(name,
                                style: GoogleFonts.poppins()),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      selectedName = value ?? selectedName,
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (v) {
                    setStateDialog(() {
                      onEditChanged(v);
                    });
                  },
                  decoration: InputDecoration(
                    labelText:
                        'Amount (\$${(editCents / 100).toStringAsFixed(2)})',
                    border: OutlineInputBorder(
                      borderRadius: _borderRadius,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: descCtrl,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: _borderRadius,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  'Save',
                  style: TextStyle(color: _accentColor),
                ),
                onPressed: () {
                  if (editCents <= 0) return;

                  setState(() {
                    _expenses[index] = {
                      'name': selectedName,
                      'amount': editCents / 100,
                      'description': descCtrl.text.trim(),
                    };
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _goToSummary() {
    if (_expenses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one expense')),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/summary',
      arguments: {
        'names': widget.names,
        'expenses': _expenses,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Expenses',
          style: GoogleFonts.poppins(
            color: _accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedName,
              decoration: InputDecoration(
                labelText: 'Paid by',
                border: OutlineInputBorder(
                  borderRadius: _borderRadius,
                ),
              ),
              items: widget.names
                  .map((name) => DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedName = value),
            ),

            const SizedBox(height: 12),

            // 💰 LIVE formatted input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: _onAmountChanged,
              decoration: InputDecoration(
                labelText: 'Amount ($_formattedAmount)',
                border: OutlineInputBorder(
                  borderRadius: _borderRadius,
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: _borderRadius,
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Add Expense',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (_, i) {
                  final exp = _expenses[i];

                  return Card(
                    child: ListTile(
                      title: Text(
                        '${exp['name']} paid \$${exp['amount'].toStringAsFixed(2)}',
                      ),
                      subtitle: Text(exp['description'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editExpense(i),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteExpense(i),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: _goToSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('See Summary'),
            ),
          ],
        ),
      ),
    );
  }
}