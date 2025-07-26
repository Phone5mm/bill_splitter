import 'package:flutter/material.dart';
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
  final Color _accentColor = Colors.teal.shade600;

  void _addExpense() {
    final amount = double.tryParse(_amountController.text);
    if (_selectedName == null || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid name and amount')),
      );
      return;
    }

    setState(() {
      _expenses.add({
        'name': _selectedName,
        'amount': amount,
        'description': _descriptionController.text.trim(),
      });
      _amountController.clear();
      _descriptionController.clear();
      _selectedName = null;
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
    TextEditingController amountCtrl = TextEditingController(
      text: expense['amount'].toString(),
    );
    TextEditingController descCtrl = TextEditingController(
      text: expense['description'] ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
                border: OutlineInputBorder(borderRadius: _borderRadius),
              ),
              items: widget.names
                  .map(
                    (name) => DropdownMenuItem(
                      value: name,
                      child: Text(name, style: GoogleFonts.poppins()),
                    ),
                  )
                  .toList(),
              onChanged: (value) => selectedName = value ?? selectedName,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (\$)',
                border: OutlineInputBorder(borderRadius: _borderRadius),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(
                labelText: 'Description (e.g. 🍕 Lunch)',
                border: OutlineInputBorder(borderRadius: _borderRadius),
              ),
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'Save',
              style: GoogleFonts.poppins(color: _accentColor),
            ),
            onPressed: () {
              final updatedAmount = double.tryParse(amountCtrl.text);
              if (updatedAmount == null || updatedAmount <= 0) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
                return;
              }

              setState(() {
                _expenses[index] = {
                  'name': selectedName,
                  'amount': updatedAmount,
                  'description': descCtrl.text.trim(),
                };
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _goToSummary() {
    if (_expenses.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add at least one expense')));
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/summary',
      arguments: {'names': widget.names, 'expenses': _expenses},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Expenses',
          style: GoogleFonts.poppins(
            color: _accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.teal),
            tooltip: 'Start Over',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/names',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedName,
              decoration: InputDecoration(
                labelText: 'Paid by',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(borderRadius: _borderRadius),
                focusedBorder: OutlineInputBorder(
                  borderRadius: _borderRadius,
                  borderSide: BorderSide(color: _accentColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              items: widget.names
                  .map(
                    (name) => DropdownMenuItem(
                      value: name,
                      child: Text(name, style: GoogleFonts.poppins()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedName = value;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (\$)',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(borderRadius: _borderRadius),
                focusedBorder: OutlineInputBorder(
                  borderRadius: _borderRadius,
                  borderSide: BorderSide(color: _accentColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (e.g. 🍕 Lunch)',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(borderRadius: _borderRadius),
                focusedBorder: OutlineInputBorder(
                  borderRadius: _borderRadius,
                  borderSide: BorderSide(color: _accentColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                'Add Expense',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _expenses.isEmpty
                  ? Center(
                      child: Text(
                        'No expenses added yet.',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _expenses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final exp = _expenses[i];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: _borderRadius,
                          ),
                          elevation: 3,
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              '${exp['name']} paid \$${exp['amount'].toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: exp['description'] != ''
                                ? Text(
                                    exp['description'],
                                    style: GoogleFonts.poppins(),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: _accentColor),
                                  onPressed: () => _editExpense(i),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => _deleteExpense(i),
                                  tooltip: 'Delete',
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
                shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                'See Summary',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
